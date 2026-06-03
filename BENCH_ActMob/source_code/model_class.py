# -*- coding: utf-8 -*-
"""
Created on Wed Nov 19 09:56:48 2025

@author: hartvig
"""

# BENCH-Mobility for Vienna

# Import packages
import random
import pandas as pd
import numpy as np
from mesa import Model
from mesa.space import MultiGrid
from mesa import DataCollector
import networkx as nx

# Import local functions
from source_code.household_agent import HouseholdAgent
from source_code.infrastructure_map import update_map
from source_code.learning import learn
from source_code.summary import print_summary
from source_code.replace_trip import replace_trip
from source_code.replace_trip import reconsider
from source_code.policy import info_campaign


# Create model class
class ModelSetup(Model):
    def __init__(self, population, vienna_housing_map, coefs, district_infra, start_year = 2018, simulation_start = 2025, num_agents = 100, num_peers = 5, case_study="Vienna", scenario="BA", 
                 data="Empirical-survey", learning="Neighbour", map_update="No", policy="No", campaign_cluster = [-1], campaign_years = [0], zoning_plan = "No", seed = 123, iteration = 0):
        super().__init__()
        self.num_agents = num_agents
        self.num_peers = num_peers
        # self.schedule = RandomActivation(self)
        self.learning = learning
        self.tr_modes = ['car', 'bike', 'walk', 'pt']
        self.dests = ['work', 'services', 'leisure']
        self.grid = MultiGrid(3500, 2500, True)  # Assuming a 3500x2500 grid to represent Vienna
        self.case_study = case_study
        #self.scenario = scenario
        self.scenario_name = scenario
        # Adjust year with -1 since in every step year is first
        # increased by 1
        self.start_year = start_year - 1
        self.simulation_start = simulation_start
        self.data = data
        self.map_update = map_update
        self.district_infra = district_infra
        self.policy = policy
        self.campaign_cluster = campaign_cluster
        self.campaign_years = campaign_years
        self.zoning_plan = zoning_plan
        self.population = population
        self.vienna_housing_map = vienna_housing_map
        self.year = start_year - 1
        self.iter = iteration
        self.debugfiles = True
        self.awareness_levels = {'Low': [], 'Medium': [], 'High': []}
        self.motivation_levels = {'PN': [], 'SN': []}
        self.behavioral_changes = {'Car': [], 'Public_tr': [], 'Motor': [], 'Bicycle': [], 'Walk': []}
        self.mode_changes = {'I_bicycle': [], 'I_walk': []}
        self.energy_savings = {'Fuel': []}
        self.invs1_com = 0
        self.a1_com = 0
        self.coefs = coefs
        self.seed = int(seed) + iteration
        self.agent_dict = {}
        
        if seed is not None:
            random.seed(int(self.seed))
            np.random.seed(int(self.seed))
        
        # self.I_bicycle_cost = i1_cost
        # self.I_walk_cost = i2_cost
        # self.load_data()
        self.setup_agents()
        # self.datacollector = DataCollector(
        #     model_reporters={"Bicycle": lambda m: sum(agent.mode_trips['bike'] for agent in m.agents) / sum(agent.total_trips for agent in m.agents),
        #                      "Walk": lambda m: sum(agent.mode_trips['walk'] for agent in m.agents) / sum(agent.total_trips for agent in m.agents),
        #                      # "Bicycle": lambda m: {d: sum(agent.mode_trips['bike'] for agent in m.agents if agent.district == d) for d in range(1, 24)},
        #                      # "Walk": lambda m: {d: sum(agent.mode_trips['walk'] for agent in m.agents if agent.district == d) for d in range(1, 24)},
        #                      # "Utility Bicycle": lambda m: np.mean([agent.U_bike for agent in m.agents]),
        #                      # "Utility Walk": lambda m: np.mean([agent.U_walk for agent in m.agents]),
        #                      "Awareness": lambda m: np.mean([agent.kn_aw for agent in m.agents]),
        #                      "PersonalNorm": lambda m: np.mean([agent.pn for agent in m.agents]),
        #                      "PerceivedBehaviourControl": lambda m: np.mean([agent.pbc for agent in m.agents])}
        # )
        self.running = True
        # self.datacollector.collect(self)


    # def load_data(self):
    #     try:
    #         self.survey = pd.read_csv('input//survey_encoded.csv', index_col = 0)
    #         print(f"Data loaded successfully for case study {self.case_study} and scenario {self.scenario}.")
    #     except FileNotFoundError as e:
    #         print(f"File not found: {e.filename}")

    def setup_agents(self):
        if self.case_study == "Vienna" and self.data == "Empirical-survey":
            # Import data
            setup_vars = pd.read_csv('input//agent_setup.csv', index_col = 0)
            setup_vars_dict = setup_vars.to_dict()
            # Housing map
            distances = ['bike_dist', 'green_dist', 'hike_dist', 'resid_dist', 'slow_dist']
            facilities = ['bike_bool', 'green_bool', 'hike_bool', 'resid_bool', 'slow_bool']
            # Distances between houses and facilities
            housing_distances = self.vienna_housing_map[distances]
            housing_facilities = self.vienna_housing_map[facilities]
            # Subdistricts
            housing_subdistrict = self.vienna_housing_map['ZBEZ'].astype(int)
            # House coordinates by district
            coordinates = {}
            idxs = {}
            probs = {}
            distr_houses = {}
            for distr, houses in self.vienna_housing_map.groupby('BEZIRK'):
                distr_houses[distr] = houses
                idxs[distr] = houses.index
                distr_coords = houses.get_coordinates()
                coordinates[distr] = distr_coords[~distr_coords.index.duplicated(keep='first')]
                coordinates[distr].index = houses.index
                probs[distr] = houses.WOHNUNGSAN.fillna(0) / sum(houses.WOHNUNGSAN.fillna(0))
            # Collect the indices of the agents in the different clusters
            cluster_dict  = {cluster: list() for cluster in self.population.cluster.unique()}
            
            # Create agents
            for i in range(self.num_agents):
                agent = HouseholdAgent(i, self, **setup_vars_dict['Value'])
                # Assign attributes based on simulated population
                self.assign_attributes(agent, self.population, setup_vars)
                district = agent.district
                # Randomly allocate agents to a social house
                idx = np.random.choice(idxs[district], 1, p = probs[district])
                coords = list(zip(coordinates[district].x, coordinates[district].y))
                agent.district = int(district)
                agent.subdistrict = housing_subdistrict.loc[idx].values[0]
                agent.house_id = idx
                # Adjust coordinates to match the multigrid
                list_idx = idxs[district].get_loc(idx[0])
                x = np.round((coords[list_idx][0] - 16.2) * 10000, 0)
                y = np.round((coords[list_idx][1] - 48.1) * 10000, 0)
                self.grid.place_agent(agent, (int(x), int(y)))
                # Add houseing characteristics to agent (distances from facilities)
                agent.distances = housing_distances.loc[idx].to_dict(orient = 'list')
                agent.facilities = housing_facilities.loc[idx].to_dict(orient = 'list')
                # Add to corresponding cluster
                cluster_dict[agent.cluster] = cluster_dict[agent.cluster] + [i]
                # Randomly select when the agent shifted mode the last time
                agent.shift_year = random.randint(0, 3)
                agent.shift_dest = []
                agent.shift_to = []
                # Assess trips
                agent.modes = {'work': agent.mode_work, 'services': agent.mode_services, 'leisure': agent.mode_leisure}
                agent.modes0 = {'work': agent.mode_work, 'services': agent.mode_services, 'leisure': agent.mode_leisure}
                agent.trips = {'work': agent.freq_work * 2, 'services': agent.freq_services * 2, 'leisure': agent.freq_leisure * 2}
                agent.length = {'work': agent.duration_work, 'services': agent.duration_services, 'leisure': agent.duration_leisure}
                agent.mode_trips = {m: 0 for m in self.tr_modes}
                for mode in self.tr_modes:
                    for dest in self.dests:
                        if agent.modes[dest] == mode:
                            agent.mode_trips[mode] += agent.trips[dest]
                agent.total_trips = sum(agent.trips.values())
                if agent.total_trips > 0:
                    agent.mode_shares = {k: v / agent.total_trips for k, v in agent.mode_trips.items()}
                else:
                    agent.mode_shares = {k: 0 for k, v in agent.mode_trips.items()}
                # Store original number of bike/walk trips
                agent.bike0 = agent.mode_trips['bike']
                agent.walk0 = agent.mode_trips['walk']
                # Create holders for utilities, probabilities
                agent.U = {mode: {'work': 0, 'services': 0, 'leisure': 0}
                                  for mode in self.tr_modes}
                agent.raw_prob = {mode: {'work': 0, 'services': 0, 'leisure': 0}
                                  for mode in self.tr_modes}
                agent.prob = {mode: {'work': 0, 'services': 0, 'leisure': 0}
                                  for mode in self.tr_modes}
            self.cluster_dict = cluster_dict
            if self.learning == 'Peers':
                # Create network by cluster
                peer_list = {}
                network = {}
                for c, c_agents in cluster_dict.items():
                    
                    # base network
                    N = len(c_agents)
                    G = nx.watts_strogatz_graph(N, self.num_peers, p = 0.9, seed = 1)
                    
                    # deg_seq = [d for _, d in G.degree()]
                    # print('Peer network in cluster {} created'.format(c))
                    # print("min deg:", min(deg_seq), "max deg:", max(deg_seq), "mean deg:", sum(deg_seq)/len(deg_seq))
                    network[c] = G
                    self.network = network
                    # Convert to agent list
                    peer_list.update({cluster_dict[c][i]: list(G.neighbors(i)) for i in G.nodes()})
                self.network = network
                # Assign peers
                i = 0
                for agent in self.agents:
                    # Assign peers
                    agent.peers = peer_list[i]
                    i += 1
                
            if self.learning == 'Neighbour':
                for agent in self.agents:
                    agent.neighbours = self.grid.get_neighbors(agent.pos, moore=True, include_center=False, radius = 25)

                
            # print(f"Agent {agent.h_id}: Income={agent.income}, Gas={agent.gas}, Awareness={agent.aware}, Group={agent.h_group}")

    def assign_attributes(self, agent, population, setup_vars):
        # Allocate a simulated response to agent
        rn = np.random.choice(population.index)
        agent_attr = population.loc[rn]
        for attr in setup_vars.index:
            if attr in agent_attr.index:
                var = agent_attr[attr]
                setattr(agent, attr, var)

    def step(self):
        self.year += 1

        # print('-------------------------------------')
        # print(self.year)
        # print(f"Simulation step for year {self.year} started.")
        self.agent_dict
        self.agents.shuffle_do("step")
        if self.map_update == "Yes":
            # Load new map in given years
            if self.year in [2025, 2030, 2035]:
                self.distances, self.facilities = update_map(self.year, self.agents)
        
        if self.policy == 'Campaign':
            # Increase knowledge of agents targeted by information campaign
            if self.year in self.campaign_years:
                info_campaign(self.agents, self.campaign_cluster)
                
        if self.year >= self.simulation_start: 
            learn(self.learning, self.agents, self.grid)
            
        self.infrastructure_change()
        
        for agent in self.agents:
            self.update_income(agent)
            self.consideration(agent) 
            self.motivation(agent)
            self.knowledge(agent)
            self.utility(agent)
            self.action(agent)
            if (self.policy == 'Zoning') & (len(self.ban_subdistricts) > 0):
                self.zoning(agent)
            self.recalculate_modal_shares(agent)
            self.update_memory(agent)
            self.update_info(agent)
                

        # if self.year == 2025:
        self.modal_shares, self.model_shares_d, self.agent_dict[self.year] = print_summary(self.agents, self.scenario_name, self.year, self.iter)
        # if self.year >= self.start_year + 3:
        #     self.datacollector.collect(self)


            # print(f"Memory recalled for year {self.year}.")


    def knowledge(self, agent):
        agent.kn_aw += agent.kn_aw_ch
        agent.guilt = "L" if agent.kn_aw < 4 else "H"
        # if agent.guilt == "H":
        #     agent.know = agent.aware / 7
        # print("Knowledge updated.")

    def motivation(self, agent):
        if agent.guilt == "H":
            agent.pn_ch += 0.678 * agent.kn_aw_ch + 0.229 * agent.sn_ch
            # Restrict change so pn cannot be higher than 5
            agent.pn_ch = agent.pn_ch - np.maximum(0, agent.pn + agent.pn_ch - 5)
            agent.pn += agent.pn_ch
            
            agent.mot = "L" if (agent.pn < 3.6) else "H"
        else:
            agent.mot = "L"
        # print("Motivation updated.")

    def consideration(self, agent):
        if agent.mot == "H":
            agent.pbc_ch += 0.641 * agent.pn_ch
            # Restrict change so pbc cannot be higher than 5
            agent.pbc_ch = agent.pbc_ch - np.maximum(0, agent.pbc + agent.pbc_ch - 5)
            agent.pbc += agent.pbc_ch
            agent.cons = "L" if (agent.pbc < 3.6) else "H"
        else:
            agent.cons = "L"
        # print("Consideration updated.")


    def infrastructure_change(self):
        # Get the infrastructure developments for the given year
        # Get previous year
        distr_infr_y_2025 = self.district_infra[['BEZNR', 'Infrastructure', '2025']].set_index(['BEZNR', 'Infrastructure']).copy()
        # get this year
        distr_infr_y = self.district_infra[['BEZNR', 'Infrastructure', str(self.year)]].set_index(['BEZNR', 'Infrastructure']).copy()
        # Difference (therefore development)
        self.distr_infr_diff = distr_infr_y[str(self.year)] - distr_infr_y_2025['2025']
        # print('Infrastructure development vs. 2025')
        # print(distr_infr_diff.groupby('Infrastructure').mean())
        # Calculate utility also for agents where subdistrict ban happens
        if self.policy == 'Zoning':
            self.ban_subdistricts = self.zoning_plan.loc[self.zoning_plan.ban_year == self.year, 'subdistrict'].values
        else:
            self.ban_subdistricts = []

    def utility(self, agent):
        # Check if agent considers changing tr. mode or in a car-free district
        if (agent.cons == "H") or (agent.subdistrict in self.ban_subdistricts):
            # Calculate utility and probability for all destinations
            for dest in self.dests: 
                for mode in self.tr_modes: 
                    # Create key
                    key = mode + "_" + dest
                    # Get coefficients 
                    c = self.coefs[key]
                    # Gather data
                    s = pd.Series(0.0, index = c.index)
                    for var in s.index:
                        if var == 'const':
                            s[var] = 1.0
                        elif var in ['bikelane', 'pedestz', 'park']:
                            distr = agent.district
                            s[var] = self.distr_infr_diff.loc[(distr, var)]
                        else:
                            s[var] = getattr(agent, var)
                    # Calculate logit
                    u = (c * s).sum()
                    # print(c)
                    # print(s)
                    # Set attribute
                    agent.U[mode][dest] = u
                    # Calculate probability
                    raw_p = np.exp(u) / (1 + np.exp(u))
                    # Set attribute
                    agent.raw_prob[mode][dest] = raw_p
                # Once all raw probabilities are calculated, normalise them to 1
                prob_sum = (agent.raw_prob['bike'][dest] + agent.raw_prob['walk'][dest] + 
                            agent.raw_prob['car'][dest] + agent.raw_prob['pt'][dest])
                agent.prob['bike'][dest] = agent.raw_prob['bike'][dest] / prob_sum
                agent.prob['walk'][dest] = agent.raw_prob['walk'][dest] / prob_sum
                agent.prob['car'][dest] = agent.raw_prob['car'][dest] / prob_sum
                agent.prob['pt'][dest] = agent.raw_prob['pt'][dest] / prob_sum

        # print("Utility calculated.")


    def action(self, agent):
        # Consider car, public transport, or motor trips
        # which can be replaced by 20-minute walk/biking
        if agent.cons == "H":
            if agent.shift_mode == 0:
                for d in self.dests:
                    replace_trip(agent, d, self.tr_modes, self.dests)
         
            if (agent.shift_mode == 1) & (agent.shift_year == 1):
                for i, d in enumerate(agent.shift_dest):
                    new_mode = agent.shift_to[i]
                    original_mode = agent.modes0[d]
                    reconsider(agent, d, new_mode, original_mode, self.tr_modes, self.dests)
        # print("Actions determined for agents.")


    def zoning(self, agent):
        # Find subdistricts that are turned into car-free zones
        # If there is a subdistrict then replace car trips in the district that are shorter than 10 minutes
        # Check if agent is in subdistrict
        if agent.subdistrict in self.ban_subdistricts:
            agent.kn_aw_ch += min(1, 5 - agent.kn_aw) 
            # Check if it uses car at all
            if 'car' in [mode for d, mode in agent.modes.items()]:
                # Check all destinations
                for d in self.dests:
                    # Find car trips
                    if agent.modes[d] == 'car':
                        # If car trip is longer than 10 minutes replace
                        if agent.length[d] < 15:
                            # Replace trip based on probability
                            prob_bike = agent.prob['bike'][d]
                            prob_walk = agent.prob['walk'][d]
                            prob_pt = agent.prob['pt'][d]
                            prob_car = agent.prob['car'][d]
                            
                            
                            # Generate random number to see how car is replaced
                            random_nr = np.random.uniform(size = 1, low = 0, high = 1 - prob_car)  
                            # See how many trips are replaced by bike, walk, or publis transport based on probabilities
                            if random_nr <= prob_bike:
                                agent.modes[d] = 'bike'
                            if (random_nr > prob_bike) and (random_nr <= prob_bike + prob_walk):
                                agent.modes[d] = 'walk'
                            if (random_nr > prob_bike + prob_walk):
                                agent.modes[d] = 'pt'
                            
                            agent.shift_mode = 1
 
    def recalculate_modal_shares(self, agent):
        # Recalculate mode shares
        # Check if agent changed mode
        if agent.shift_mode == 1:
            # Clear mode_trips dictionary
            agent.mode_trips = {m: 0 for m in self.tr_modes}
            # Loop over modes and destinations
            for mode in self.tr_modes:
                for dest in self.dests:
                    if agent.modes[dest] == mode:
                        agent.mode_trips[mode] += agent.trips[dest]
            # Calculate modal shares
            if agent.total_trips > 0:
                agent.mode_shares = {k: v / agent.total_trips for k, v in agent.mode_trips.items()}
            else:
                agent.mode_shares = {k: 0 for k, v in agent.mode_trips.items()}  

        
    # def save_energy(self):
    #     gas_total = sum([agent.gas for agent in self.agents])
    
    #     if self.year >= 2017:
    #         for agent in self.agents:
    #             if agent.act1:
    #                 agent.save_a1 = agent.gas * 0.2
    #                 agent.gas -= agent.save_a1
    #             else:
    #                 agent.save_a1 = 0
    
    #     save_gas = sum([agent.save_a1 for agent in self.agents])
    #     # self.save_gas_com += save_gas
    #     print(f"Energy savings calculated for year {self.year}.")


    def update_income(self, agent):
        rn = random.uniform(0, 100)
        if rn >= 50:
            agent.income = agent.income * 1.02
        # print("Income updated.")

    def update_memory(self, agent):
        if agent.shift_mode == 1:
            agent.shift_year += 1
        if agent.shift_year >= 2:
            agent.shift_mode = 0
            agent.shift_year = 0
            agent.shift_dest = []
            agent.shift_to = []
        # print("Memory updated.")



    def update_info(self, agent):
        agent.kn_aw_ch = 0
        agent.pn_ch = 0
        agent.sn_ch = 0
        agent.pbc_ch = 0





