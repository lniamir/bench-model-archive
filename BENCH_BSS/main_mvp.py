import random
import numpy as np
import geopandas as gpd
import pandas as pd
from scipy.stats import truncnorm
from shapely.geometry import Polygon
from shapely.ops import nearest_points, unary_union
import matplotlib.pyplot as plt
from sklearn.neighbors import KDTree
from mesa import Agent, Model
from mesa.time import RandomActivation
import argparse
import matplotlib.dates as mdates
import matplotlib
import os

matplotlib.use('Agg')

# Load bike stations and social housing data
bike_stations = gpd.read_file("station_locations.geojson")
vienna_cycleways = gpd.read_file("vienna_cycleways.geojson")
social_housing = gpd.read_file("social_housing.json")
ranked_new_bike_stations = gpd.read_file("ranked_new_bike_stations.geojson")
bus_stops = gpd.read_file("pt_stops.geojson")
districts = gpd.read_file("districts.geojson")

coefficients = {
    # Coefficients for Shared Docked (E-)Bike Usage
    "constant_bike": -1.84,
    "age_bike": -0.01,
    "female_bike": -0.51,
    "drivers_license_bike": 0.22,
    "access_to_car_bike": -0.31,
    "education_bike": 0.04,
    "employment_bike": 0.17,
    "pt_card_bike": 0.39,  # PT season ticket (country)
    "pt_access_bike": 0.16,  # PT season ticket (local)
    "env_bike": -0.04,  # Travel priority: environment
    "time_bike": 0.00,  # Travel priority: time
    "flexibility_bike": -0.03,  # Travel priority: flexibility
    "income_bike": 0.02,
    "children_bike": -0.31,
    "adults_bike": -0.09,
    "cars_bike": -0.08,
    "bikes_bike": 0.10,
    "station_access_bike": 0.76,  # Bike-share at home
    "pt_access_bike": 0.40,  # PT access at work
    "awareness": 0.16,

    # Coefficients for Shared Dockless E-Bike Usage
    "constant_ebike": -3.98,
    "age_ebike": 0.00,
    "female_ebike": -0.72,
    "drivers_license_ebike": 0.23,
    "access_to_car_ebike": -0.05,
    "education_ebike": 0.02,
    "employment_ebike": 0.25,
    "pt_card_ebike": 0.33,  # PT season ticket (country)
    "pt_access_ebike": 0.08,  # PT season ticket (local)
    "env_ebike": -0.07,  # Travel priority: environment
    "time_ebike": -0.01,  # Travel priority: time
    "flexibility_ebike": 0.22,  # Travel priority: flexibility
    "income_ebike": 0.02,
    "children_ebike": -0.10,
    "adults_ebike": 0.10,
    "cars_ebike": 0.10,
    "bikes_ebike": -0.01,
    "station_access_ebike": 0.77,  # Bike-share at home
    "pt_access_ebike": 0.21,  # PT access at work
    "awareness_ebike": 0.08
}

empirical_probabilities = {
    "female": 51.10,
    "drivers_license": 62.00,
    "access_to_car": 42.00,
    "education": 28.50,
    "employment": 53.90,
    "pt_card": 53.40,
    "awareness": 90.50,
    "children": 0.295,
    "adults": 1.745,
    "cars": 0.77,
    "bikes": 1.8
}

generate_age = lambda: random.choices(
    population=[19, 25, 35, 45, 55, 63],
    weights=[2, 16, 28, 25, 21, 8, ],
    k=1
)[0]

# Generate environment value
generate_environment_value = lambda: random.choices(
    population=[0, 1, 2, 3, 4],
    weights=[21, 16, 24, 22, 7],
    k=1
)[0]

# Generate time value
generate_time_value = lambda: random.choices(
    population=[0, 1, 2, 3, 4],
    weights=[10, 7, 12, 37, 27],
    k=1
)[0]

# Generate flexibility value
generate_flexibility_value = lambda: random.choices(
    population=[0, 1, 2, 3, 4],
    weights=[10, 9, 22, 25, 20],
    k=1
)[0]

# Generate income value
generate_income = lambda: random.choices(
    population=[0, 1, 2, 3, 4],
    weights=[18, 21, 22, 26, 14],
    k=1
)[0]

generate_children = lambda: random.choices(
    population=[0, 1, 2],
    weights=[74, 12, 15],
    k=1
)[0]

generate_adults = lambda: random.choices(
    population=[1, 2, 3],
    weights=[27, 60, 13],
    k=1
)[0]

generate_bikes = lambda: random.choices(
    population=[0, 1, 2],
    weights=[17, 20, 63],
    k=1
)[0]

class HouseholdAgent(Agent):
    def __init__(self, unique_id, model, position):
        super().__init__(unique_id, model)
        self.h_id = unique_id
        self.position = position
        self.age = 0
        self.female = 0
        self.drivers_license = 0
        self.access_to_car = 0
        self.education = 0
        self.employment = 0
        self.pt_card = 0
        self.awareness = 0
        self.env = 0
        self.time = 0
        self.flexibility = 0
        self.income = 0
        self.children = 0
        self.adults = 0
        self.cars = 0
        self.bikes = 0
        self.station_access = 0
        self.pt_access = 0
        self.sn = 0
        self.U = 0
        self.adopted = False
        self.c_st = "L"
        self.m_st = "L"
        self.quarters_since_adoption = 0  # Add this line
        self.user_status = "non_user"  # Can be "non_user", "user", or "frequent_user"
        self.transitions = 0  # Track transitions
        self.satisfaction = 0
        self.adopt_bike = False
        self.adopt_ebike = False


class CommunityModel(Model):
    def __init__(self, N, learning="No-learning", infrastructure="No-expansion", policy="Not-implemented", seed=None):
        super().__init__()
        self.num_agents = N
        self.schedule = RandomActivation(self)
        self.learning = learning
        self.infrastructure = infrastructure
        self.policy = policy
        self.quarters = []
        self.adopters_per_quarter = []
        self.non_users_per_quarter = []
        self.users_per_quarter = []
        self.frequent_users_per_quarter = []
        self.adoption_rate_per_quarter = []
        self.year = 2024
        self.quarter = 1
        self.debugfiles = True
        self.first_district_polygon = None
        self.districts = gpd.read_file("districts.geojson")
        self.cumulative_emissions_savings = 0
        if self.districts.crs and self.districts.crs.is_geographic:
            self.districts = self.districts.to_crs("EPSG:32633")
        if seed is not None:
            random.seed(seed)
        self.setup_agents()
        self.setup_infrastructure()

    def setup_agents(self):
        housing_locations = social_housing.geometry
        bike_station_locations = bike_stations.geometry
        bus_stop_locations = bus_stops.geometry

        # Reproject CRS to EPSG:32633 if needed
        if housing_locations.crs and housing_locations.crs.is_geographic:
            housing_locations = housing_locations.to_crs("EPSG:32633")
        if bike_station_locations.crs and bike_station_locations.crs.is_geographic:
            bike_station_locations = bike_station_locations.to_crs("EPSG:32633")
        if bus_stop_locations.crs and bus_stop_locations.crs.is_geographic:
            bus_stop_locations = bus_stop_locations.to_crs("EPSG:32633")

        if vienna_cycleways.crs and vienna_cycleways.crs.is_geographic:
            self.vienna_cycleways = vienna_cycleways.to_crs("EPSG:32633")
        else:
            self.vienna_cycleways = vienna_cycleways

        bike_station_union = bike_station_locations.unary_union
        bus_stop_union = bus_stop_locations.unary_union

        housing_centroids = [
            polygon.centroid if isinstance(polygon, Polygon) else max(polygon.geoms, key=lambda p: p.area).centroid for
            polygon in housing_locations]

        random.shuffle(housing_centroids)

        agent_positions = []

        first_district = self.districts[self.districts['BEZNR'] == 1]
        if first_district.empty:
            print("First district not found in the dataset.")
        else:
            print("First district found in the dataset.")
            self.first_district_polygon = unary_union(first_district.geometry)

        # Calculate the number of initial users (6% of total agents)
        num_initial_users = int(0.06 * self.num_agents)
        initial_user_indices = set(random.sample(range(self.num_agents), num_initial_users))

        # Calculate the number of agents to place in the first district (1% of total agents)
        num_first_district_agents = int(0.01 * self.num_agents)

        for i in range(self.num_agents):
            if i < num_first_district_agents and not first_district.empty:
                position = self.first_district_polygon.representative_point()
            else:
                position = random.choice(housing_centroids)

            agent = HouseholdAgent(i, self, position)
            self.schedule.add(agent)
            agent_positions.append(position)

            nearest_station = nearest_points(position, bike_station_union)[1]
            distance = position.distance(nearest_station)
            agent.station_access = 1 if distance < 500 else 0

            nearest_bus_stop = nearest_points(position, bus_stop_union)[1]
            bus_stop_distance = position.distance(nearest_bus_stop)
            agent.pt_access = 1 if bus_stop_distance < 300 else 0

            agent.age = generate_age()
            agent.female = 1 if random.uniform(0, 100) < empirical_probabilities["female"] else 0
            agent.drivers_license = 1 if random.uniform(0, 100) < empirical_probabilities["drivers_license"] else 0
            agent.access_to_car = 1 if random.uniform(0, 100) < empirical_probabilities["access_to_car"] else 0
            agent.education = 1 if random.uniform(0, 100) < empirical_probabilities["education"] else 0
            agent.employment = 1 if random.uniform(0, 100) < empirical_probabilities["employment"] else 0
            agent.pt_card = 1 if random.uniform(0, 100) < empirical_probabilities["pt_card"] else 0
            agent.env = generate_environment_value()  # personal attitude
            agent.time = generate_time_value()  # personal attitude
            agent.flexibility = generate_flexibility_value()  # personal attitude
            agent.income = generate_income()
            agent.children = generate_children()
            agent.adults = generate_adults()
            agent.cars = 1 if random.uniform(0, 100) < empirical_probabilities["cars"] else 0
            agent.bikes = 1 if random.uniform(0, 100) < empirical_probabilities["bikes"] else 0
            agent.mob_aware = 1 if random.uniform(0, 100) < empirical_probabilities["awareness"] else 0
            agent.env_aware = truncnorm((1 - 4.21) / 0.82, (5 - 4.21) / 0.82, loc=4.21,
                                        scale=0.82).rvs()  # (Wallen Warner, 2021) - importance of environmental issues
            agent.sn = truncnorm((1 - 3.86) / 1.82, (7 - 3.86) / 1.82, loc=3.86,
                                 scale=1.82).rvs()  # (Wallen Warner, 2021) - subjective norm
            agent.att = truncnorm((1 - 5.14) / 2.28, (7 - 5.14) / 2.28, loc=5.14,
                                  scale=2.28).rvs()  # (Wallen Warner, 2021) - attitude

            print(
                f"Agent {agent.h_id}: Age={agent.age}, Female={agent.female}, Driver's License={agent.drivers_license}, "
                f"Access to Car={agent.access_to_car}, Education={agent.education}, Employment={agent.employment}, "
                f"PT Card={agent.pt_card}, Awareness={agent.mob_aware}, Env Awareness={agent.env}, "
                f"Travel Time={agent.time}, Flexibility={agent.flexibility}, Income={agent.income}, "
                f"Children={agent.children}, Adults={agent.adults}, Cars={agent.cars}, Bikes={agent.bikes}, "
                f"Station Access={agent.station_access}, PT Access={agent.pt_access}, Utility={agent.U}"
            )

        self.agent_positions = agent_positions
        self.bike_station_locations = bike_station_locations
        self.tree = KDTree([(p.x, p.y) for p in agent_positions])

        for agent in self.schedule.agents:
            if agent.h_id in initial_user_indices:
                agent.guilt = "H"
                agent.m_st = "H"
                agent.c_st = "H"
                agent.adopted = True
                agent.user_status = "user"

            # Ensure agents in the first district are set as frequent users when policy is implemented
            if self.policy == "Implemented" and self.first_district_polygon.contains(agent.position):
                agent.m_st = "H"
                agent.c_st = "H"
                agent.adopted = True
                agent.user_status = "frequent_user"

    def setup_infrastructure(self):
        if self.infrastructure in ["Gradual", "Dramatic"]:
            self.new_bike_stations = ranked_new_bike_stations.geometry[:200].tolist()
        else:
            self.new_bike_stations = []

    def debug(self):
        if self.debugfiles:
            with open("debug.csv", "a") as file:
                for agent in self.schedule.agents:
                    file.write(
                        f"{self.year}Q{self.quarter},{agent.h_id},{agent.age},{agent.female},{agent.drivers_license},{agent.access_to_car},"
                        f"{agent.education},{agent.employment},{agent.pt_access},{agent.pt_card},{agent.env},"
                        f"{agent.time},{agent.flexibility},{agent.income},{agent.children},{agent.adults},{agent.cars},{agent.bikes},"
                        f"{agent.station_access},{agent.pt_access},{agent.U},{agent.user_status}\n"
                    )

            print("Debug information written to file.")

    def calculate_satisfaction(self, agent):
        income_coefficients = {2: 0.344, 3: 0.596}
        station_access_coefficient = 0.248
        awareness_coefficient = 0.542
        satisfaction_fees_coefficient = 0.471
        saving_travel_cost_coefficient = 0.354
        flexibility_coefficient = 0.349
        pt_access_coefficient = 0.374
        check_in_coefficient = 0.36
        check_out_coefficient = 0.242

        # Mean xwvalue for check in/out
        check_mean = 0.381

        # Calculate satisfaction components
        income_score = income_coefficients.get(agent.income, 0)  # Default to 0 if income not in 2 or 3
        station_access_score = station_access_coefficient * agent.station_access
        awareness_score = awareness_coefficient * agent.awareness
        satisfaction_fees_score = satisfaction_fees_coefficient  # Assume 1 as per the table
        saving_travel_cost_score = saving_travel_cost_coefficient  # Assume 1 as per the table
        flexibility_score = flexibility_coefficient * (agent.flexibility / 4)  # Assuming flexibility is from 1 to 4
        pt_access_score = pt_access_coefficient * agent.pt_access
        check_in_score = check_in_coefficient * check_mean
        check_out_score = check_out_coefficient * check_mean

        # Sum all the components to get the total satisfaction score
        total_satisfaction = (income_score + station_access_score + awareness_score + satisfaction_fees_score +
                              saving_travel_cost_score + flexibility_score + pt_access_score +
                              check_in_score + check_out_score)
        # Return the calculated satisfaction score
        return total_satisfaction

    def knowledge(self):
        for agent in self.schedule.agents:
            if agent.adopted == True:
                agent.guilt = "H"
            # agent.guilt = "L" if (agent.env_aware < 4.04 or agent.mob_aware == 0) else "H"
            agent.guilt = "L" if (agent.env_aware < 3.84 or agent.mob_aware == 0) else "H"
        print("Knowledge updated.")

    def motivation(self):
        for agent in self.schedule.agents:
            if agent.adopted == True:
                agent.m_st = "H"
            # agent.m_st = "L" if (agent.sn < 4.29 or agent.att < 5.75) else "H"
            agent.m_st = "L" if (agent.sn < 3.69 or agent.att < 5.15) else "H"
        print("Motivation updated.")

    def consideration(self):
        for agent in self.schedule.agents:
            if agent.m_st == "H" and not agent.adopted:
                # Calculate the latent utilities for each mobility scheme (shared bikes and e-bikes)
                U_bike = (
                        coefficients["constant_bike"] +
                        coefficients["age_bike"] * agent.age +
                        coefficients["female_bike"] * agent.female +
                        coefficients["drivers_license_bike"] * agent.drivers_license +
                        coefficients["access_to_car_bike"] * agent.access_to_car +
                        coefficients["education_bike"] * agent.education +
                        coefficients["employment_bike"] * agent.employment +
                        coefficients["pt_card_bike"] * agent.pt_card +
                        coefficients["awareness"] * agent.mob_aware +
                        coefficients["env_bike"] * agent.env +
                        coefficients["time_bike"] * agent.time +
                        coefficients["flexibility_bike"] * agent.flexibility +
                        coefficients["income_bike"] * agent.income +
                        coefficients["children_bike"] * agent.children +
                        coefficients["adults_bike"] * agent.adults +
                        coefficients["cars_bike"] * agent.cars +
                        coefficients["bikes_bike"] * agent.bikes +
                        coefficients["station_access_bike"] * agent.station_access +
                        coefficients["pt_access_bike"] * agent.pt_access
                )

                U_ebike = (
                        coefficients["constant_ebike"] +
                        coefficients["age_ebike"] * agent.age +
                        coefficients["female_ebike"] * agent.female +
                        coefficients["drivers_license_ebike"] * agent.drivers_license +
                        coefficients["access_to_car_ebike"] * agent.access_to_car +
                        coefficients["education_ebike"] * agent.education +
                        coefficients["employment_ebike"] * agent.employment +
                        coefficients["pt_card_ebike"] * agent.pt_card +
                        coefficients["awareness_ebike"] * agent.mob_aware +
                        coefficients["env_ebike"] * agent.env +
                        coefficients["time_ebike"] * agent.time +
                        coefficients["flexibility_ebike"] * agent.flexibility +
                        coefficients["income_ebike"] * agent.income +
                        coefficients["children_ebike"] * agent.children +
                        coefficients["adults_ebike"] * agent.adults +
                        coefficients["cars_ebike"] * agent.cars +
                        coefficients["bikes_ebike"] * agent.bikes +
                        coefficients["station_access_ebike"] * agent.station_access +
                        coefficients["pt_access_ebike"] * agent.pt_access
                )

                # Simulate correlated error terms
                correlation_matrix = np.array([
                    [1, 0.5],  # Correlation between bike and e-bike
                    [0.5, 1]
                ])

                mean_vector = [0, 0]
                errors = np.random.multivariate_normal(mean_vector, correlation_matrix)

                U_bike += errors[0]
                U_ebike += errors[1]

                # Make adoption decisions
                agent.adopt_bike = U_bike > 0
                agent.adopt_ebike = U_ebike > 0

                # Determine overall adoption status
                agent.adopted = agent.adopt_bike or agent.adopt_ebike

        print("Consideration updated using multivariate probit model.")

    def go(self):
        if self.quarter == 1 and self.infrastructure in ["Gradual", "Dramatic"]:
            self.expand_infrastructure()

        print(f"Simulation step for year {self.year} quarter {self.quarter} started.")
        self.schedule.step()
        #self.debug()
        self.update_info()

        self.load_agent_state()

        self.knowledge()
        self.motivation()
        self.consideration()
        self.action()
        self.learn()
        if self.learning == "Informative-all":
            self.update_social_norms_population_based()

        num_adopters = sum([agent.adopted for agent in self.schedule.agents])
        num_non_users = sum([agent.user_status == "non_user" for agent in self.schedule.agents])
        num_users = sum([agent.user_status == "user" for agent in self.schedule.agents])
        num_frequent_users = sum([agent.user_status == "frequent_user" for agent in self.schedule.agents])
        adoption_rate = num_adopters / self.num_agents
        self.adoption_rate_per_quarter.append(adoption_rate)

        self.adopters_per_quarter.append(num_adopters)
        self.non_users_per_quarter.append(num_non_users)
        self.users_per_quarter.append(num_users)
        self.frequent_users_per_quarter.append(num_frequent_users)
        self.calculate_emissions()

        self.quarters.append(f"{self.year} Q{self.quarter}")
        # if self.quarter == 1:
        #     self.plot_grid()
        #     self.plot_neighborhood_grid()
        self.print_summary()

        self.quarter += 1
        if self.quarter > 4:
            self.quarter = 1
            self.year += 1

    def action(self):
        for agent in self.schedule.agents:
            if agent.adopted:
                agent.quarters_since_adoption += 1  # Increment the counter
                if agent.user_status == "frequent_user":
                    continue
                if agent.quarters_since_adoption == 2:
                    agent.satisfaction = self.calculate_satisfaction(agent)
                    if agent.satisfaction > 1.826:
                        agent.user_status = "frequent_user"
                        agent.act = True
                    elif agent.satisfaction < 1.426:
                        agent.user_status = "non_user"
                        agent.adopted = False
                        agent.quarters_since_adoption = 0
                        agent.c_st = "L"
                        agent.U = 0
                        agent.act = True
                    else:
                        agent.act = False
                continue

            elif agent.c_st == "H":
                agent.act = True
                agent.adopted = True
                agent.user_status = "user"
                agent.quarters_since_adoption = 0

            else:
                agent.act = False

        print("Actions determined for agents.")

    def learn(self):
        if self.year >= 2024:
            for agent in self.schedule.agents:
                if self.learning == "No-learning":
                    continue
                if self.learning == "Informative":
                    self.informative_learning(agent)

                if self.learning == "Informative-peer" or "Informative-all":
                    self.informative_peers(agent)

        print("Learning process updated.")

    def update_neighbors(self, agent, neighbors, multiplier=1):
        ngb_env_aware, ngb_att, ngb_sn = self.calculate_neighbor_means(neighbors)
        for n in neighbors:
            if n.env_aware < ngb_env_aware and n.env_aware < 5:
                n.env_aware += n.env_aware * 0.1 * multiplier
            if n.att < ngb_att and n.att < 7:
                n.att += n.att * 0.1 * multiplier
            if n.sn < ngb_sn and n.sn < 7:
                n.sn += n.sn * 0.1 * multiplier

    def informative_learning(self, agent):
        if agent.act:
            neighbors = self.get_neighbors(agent, 8)
            if agent.satisfaction <= 1.426 and agent.satisfaction != 0:
                # Decrease environmental awareness, attitude, and social norms
                if agent.env_aware <= 5:
                    agent.env_aware -= agent.env_aware * 0.1
                if agent.att <= 7:
                    agent.att -= agent.att * 0.1
                if agent.sn <= 7:
                    agent.sn -= agent.sn * 0.1
                self.update_neighbors(agent, neighbors, multiplier=-1)
            else:
                if agent.env_aware <= 5:
                    agent.env_aware += agent.env_aware * 0.05
                if agent.att <= 7:
                    agent.att += agent.att * 0.05
                if agent.sn <= 7:
                    agent.sn += agent.sn * 0.05
                self.update_neighbors(agent, neighbors, multiplier=1)

    def is_demographically_similar(self, agent, neighbor):
    # Check if the neighbor is sociodemographically similar (same age and gender)
        return agent.age == neighbor.age and agent.gender == neighbor.gender

    def learn(self):
        if self.year >= 2024:
            for agent in self.schedule.agents:
                if self.learning == "No-learning":
                    continue
                elif self.learning == "Informative":
                    self.informative_learning(agent)
                elif self.learning in ["Informative-peer", "Informative-all"]:

        print("Learning process updated.")

    def update_neighbors(self, agent, neighbors, multiplier=1):
        ngb_env_aware, ngb_att, ngb_sn = self.calculate_neighbor_means(neighbors)
        for n in neighbors:
            if n.env_aware < ngb_env_aware and n.env_aware < 5:
                n.env_aware += n.env_aware * 0.1 * multiplier
            if n.att < ngb_att and n.att < 7:
                n.att += n.att * 0.1 * multiplier
            if n.sn < ngb_sn and n.sn < 7:
                n.sn += n.sn * 0.1 * multiplier

    def informative_learning(self, agent):
        if agent.act:
            neighbors = self.get_neighbors(agent, 8)
            if agent.satisfaction <= 1.426 and agent.satisfaction != 0:
                # Decrease environmental awareness, attitude, and social norms
                if agent.env_aware <= 5:
                    agent.env_aware -= agent.env_aware * 0.1
                if agent.att <= 7:
                    agent.att -= agent.att * 0.1
                if agent.sn <= 7:
                    agent.sn -= agent.sn * 0.1
                self.update_neighbors(agent, neighbors, multiplier=-1)
            else:
                if agent.env_aware <= 5:
                    agent.env_aware += agent.env_aware * 0.1
                if agent.att <= 7:
                    agent.att += agent.att * 0.1
                if agent.sn <= 7:
                    agent.sn += agent.sn * 0.1
                self.update_neighbors(agent, neighbors, multiplier=0.8)

    def informative_peers(self, agent):
        if agent.act:
            neighbors = self.get_neighbors(agent, 8)
            if agent.satisfaction == 1.426 and agent.satisfaction != 0:
                # Decrease environmental awareness, attitude, and social norms
                if agent.env_aware <= 5:
                    agent.env_aware -= agent.env_aware * 0.05
                if agent.att <= 7:
                    agent.att -= agent.att * 0.05
                if agent.sn <= 7:
                    agent.sn -= agent.sn * 0.05
                for neighbor in neighbors:
                    multiplier = 2 if self.is_demographically_similar(agent, neighbor) else -1
                    self.update_neighbors(agent, [neighbor], multiplier=multiplier)
            else:
                if agent.env_aware <= 5:
                    agent.env_aware += agent.env_aware * 0.05
                if agent.att <= 7:
                    agent.att += agent.att * 0.05
                if agent.sn <= 7:
                    agent.sn += agent.sn * 0.05
                for neighbor in neighbors:
                    multiplier = 2 if self.is_demographically_similar(agent, neighbor) else 1
                    self.update_neighbors(agent, [neighbor], multiplier=multiplier)

    def calculate_neighbor_means(self, neighbors):
        ngb_aware_mean = sum([n.env_aware for n in neighbors]) / len(neighbors)
        ngb_aware_median = sorted([n.env_aware for n in neighbors])[len(neighbors) // 2]
        ngb_aware = max(ngb_aware_mean, ngb_aware_median)

        ngb_att_mean = sum([n.att for n in neighbors]) / len(neighbors)
        ngb_att_median = sorted([n.att for n in neighbors])[len(neighbors) // 2]
        ngb_att = max(ngb_att_mean, ngb_att_median)

        ngb_sn_mean = sum([n.sn for n in neighbors]) / len(neighbors)
        ngb_sn_median = sorted([n.sn for n in neighbors])[len(neighbors) // 2]
        ngb_sn = max(ngb_sn_mean, ngb_sn_median)

        return ngb_aware, ngb_att, ngb_sn

    def calculate_emissions(self):
        # Emission savings per year per user type (in kg/year)
        emissions_savings = {
            "frequent_user_bike": 24.01,  # kg/year
            "user_bike": 9.61,  # kg/year
            "frequent_user_ebike": 11.94,  # kg/year
            "user_ebike": 4.77,  # kg/year
            "non_user": 0  # kg/year
        }

        # Calculate emissions savings for the current quarter
        total_emissions_savings = {
            "frequent_user_bike": self.frequent_users_per_quarter[-1] * emissions_savings["frequent_user_bike"] / 4,
            "user_bike": self.users_per_quarter[-1] * emissions_savings["user_bike"] / 4,
            "frequent_user_ebike": self.frequent_users_per_quarter[-1] * emissions_savings["frequent_user_ebike"] / 4,
            "user_ebike": self.users_per_quarter[-1] * emissions_savings["user_ebike"] / 4,
            "non_user": self.non_users_per_quarter[-1] * emissions_savings["non_user"] / 4
        }

        # Total emissions savings for the current quarter
        total_savings = sum(total_emissions_savings.values())

        # Update the cumulative emissions savings
        self.cumulative_emissions_savings += total_savings

        # Print the cumulative emissions savings
        print(
            f"Cumulative Emissions Savings up to Year {self.year} Quarter {self.quarter}: {self.cumulative_emissions_savings:.2f} kg")
        print(
            f"Frequent Users Savings: {total_emissions_savings['frequent_user_bike'] + total_emissions_savings['frequent_user_ebike']:.2f} kg")
        print(
            f"Normal Users Savings: {total_emissions_savings['user_bike'] + total_emissions_savings['user_ebike']:.2f} kg")
        print(f"Non-Users Savings: {total_emissions_savings['non_user']:.2f} kg")

        # Save the emissions savings data for plotting
        if hasattr(self, 'emissions_savings'):
            self.emissions_savings.append(total_savings)
        else:
            self.emissions_savings = [total_savings]

    def update_info(self):
        for agent in self.schedule.agents:
            agent.act = False
        print("Agent info updated.")

    def get_neighbors(self, agent, num_neighbors=4):
        point = agent.position
        distances, indices = self.tree.query([[point.x, point.y]], k=num_neighbors)
        neighbors = [self.schedule.agents[i] for i in indices[0] if self.schedule.agents[i] != agent]
        return neighbors

    def plot_grid(self):
        fig, ax = plt.subplots(figsize=(10, 10))

        # Define fixed boundaries for consistency across all plots
        min_x, min_y, max_x, max_y = 590000, 5332500, 610000, 5350000
        ax.set_xlim(min_x, max_x)
        ax.set_ylim(min_y, max_y)

        # Plot cycleways
        self.vienna_cycleways.plot(ax=ax, color='grey', linewidth=1, label='Cycleways')

        # Plot existing bike stations
        if not self.bike_station_locations.empty:
            self.bike_station_locations.plot(ax=ax, color='red', markersize=50, label='Existing Bike Stations',
                                             marker='s', alpha=0.7)
        else:
            print("No existing bike stations data to plot.")

        # Plot new bike stations if in expansion mode
        if self.infrastructure in ["Gradual", "Dramatic"]:
            if self.new_bike_stations:
                new_station_count = min((self.year - 2024) * 20, len(self.new_bike_stations))
                new_stations_to_plot = self.new_bike_stations[:new_station_count]
                gpd.GeoSeries(new_stations_to_plot).plot(ax=ax, color='red', markersize=50, label='New Bike Stations',
                                                         marker='s', alpha=0.3)
            else:
                print("No new bike stations data to plot.")
        else:
            print("Not in Expansion mode; no new bike stations will be plotted.")

        # Plot first district if policy is implemented
        if self.policy == "Implemented":
            first_district = self.districts[self.districts['BEZNR'] == 1]
            if not first_district.empty:
                first_district.plot(ax=ax, color='yellow', alpha=0.5, label='First District')
            else:
                print("First district not found in the dataset.")

        # Plot agents based on their status
        agent_colors = {'non_user': 'black', 'user': 'blue', 'frequent_user': 'green'}
        agent_labels = {'non_user': 'Non-users', 'user': 'Users', 'frequent_user': 'Frequent Users'}
        plotted_labels = set()  # To track which labels have been added to the legend

        for agent in self.schedule.agents:
            label = agent_labels[agent.user_status]
            color = agent_colors[agent.user_status]
            if label not in plotted_labels:
                ax.scatter(agent.position.x, agent.position.y, color=color, s=20, label=label)
                plotted_labels.add(label)
            else:
                ax.scatter(agent.position.x, agent.position.y, color=color, s=20)

        # Manually build the legend from the ordered items
        handles, labels = ax.get_legend_handles_labels()
        by_label = dict(zip(labels, handles))

        # Ordered labels to ensure correct legend display
        ordered_labels = ['Cycleways', 'Existing Bike Stations', 'Non-users', 'Users', 'Frequent Users']
        if self.infrastructure in ["Gradual", "Dramatic"]:
            ordered_labels.append('New Bike Stations')  # Add this label if in expansion mode
        if self.policy == "Implemented":
            ordered_labels.append('First District')  # Ensure the first district is included in the legend

        # Ensure to include all required handles based on labels
        ordered_handles = [by_label[label] for label in ordered_labels if label in by_label]

        # Add labels and title
        plt.xlabel('Easting (meters)')
        plt.ylabel('Northing (meters)')
        plt.title(f'Year {self.year}')
        ax.legend(ordered_handles, ordered_labels, loc='upper right')
        plt.savefig(f'grid_{self.year}.png')
        plt.close()
        print(f'Grid plot saved as grid_{self.year}.png')

    def plot_neighborhood_grid(self):
        fig, ax = plt.subplots(figsize=(10, 10))

        # Define fixed boundaries for the neighborhood
        min_x, min_y = 598200, 5336500
        max_x, max_y = 600500, 5338800

        ax.set_xlim(min_x, max_x)
        ax.set_ylim(min_y, max_y)

        # Plot cycleways and stations with consistent labels
        self.vienna_cycleways.plot(ax=ax, color='grey', linewidth=1, label='Cycleways')
        self.bike_station_locations.plot(ax=ax, color='red', markersize=50, label='Existing Bike Stations', marker='s',
                                         alpha=0.7)

        # Plot new bike stations if in expansion mode
        if self.infrastructure in ["Gradual", "Dramatic"]:
            new_station_count = min((self.year - 2024) * 20, len(self.new_bike_stations))
            new_stations_to_plot = self.new_bike_stations[:new_station_count]
            gpd.GeoSeries(new_stations_to_plot).plot(ax=ax, color='red', markersize=50, label='New Bike Stations',
                                                     marker='s', alpha=0.3)

        # Plot agents ensuring each type is labeled once
        agent_colors = {'non_user': 'black', 'user': 'blue', 'frequent_user': 'green'}
        agent_labels = {'non_user': 'Non-users', 'user': 'Users', 'frequent_user': 'Frequent Users'}
        plotted_labels = set()  # To track which labels have been added to the legend

        for agent in self.schedule.agents:
            if min_x <= agent.position.x <= max_x and min_y <= agent.position.y <= max_y:
                label = agent_labels[agent.user_status]
                if label not in plotted_labels:
                    ax.scatter(agent.position.x, agent.position.y, color=agent_colors[agent.user_status], s=20,
                               label=label)
                    plotted_labels.add(label)
                else:
                    ax.scatter(agent.position.x, agent.position.y, color=agent_colors[agent.user_status], s=20)

        # Manually build the legend from the ordered items
        handles, labels = ax.get_legend_handles_labels()
        by_label = dict(zip(labels, handles))

        # Ordered labels to ensure correct legend display
        ordered_labels = ['Cycleways', 'Existing Bike Stations', 'Non-users', 'Users', 'Frequent Users']
        if self.infrastructure in ["Gradual", "Dramatic"]:
            ordered_labels.append('New Bike Stations')  # Add this label if in expansion mode
        if self.policy == "Implemented":
            ordered_labels.append('First District')  # Ensure the first district is included in the legend

        # Ensure to include all required handles based on labels
        ordered_handles = [by_label[label] for label in ordered_labels if label in by_label]

        # Add labels and title
        plt.xlabel('Easting (meters)')
        plt.ylabel('Northing (meters)')
        plt.title(f'Year {self.year} Quarter {self.quarter} - Neighborhood View')
        ax.legend(ordered_handles, ordered_labels, loc='upper right')
        plt.savefig(f'neighborhood_grid_{self.year}.png')
        plt.close()

    def plot_emissions(self):
        if not hasattr(self, 'emissions_savings'):
            print("No emissions savings data to plot.")
            return

        plt.figure(figsize=(10, 6))
        plt.plot(self.quarters, self.emissions_savings, marker='o', linestyle='-', color='b',
                 label='Total Emissions Savings')
        years = range(2024, 2051)
        yearly_ticks = list(range(0, len(self.quarters), 4))
        plt.xticks(ticks=yearly_ticks, labels=[years[i] for i in range(len(yearly_ticks))])
        plt.xlabel('Year')
        plt.ylabel('Total Emissions Savings (kg)')
        plt.title('Total Emissions Savings Over Time')
        plt.legend()
        plt.grid(True)
        plt.tight_layout()
        plt.savefig('emissions_savings.png')
        plt.close()

    def plot_adoption_rate(self):
        plt.figure(figsize=(10, 6))
        plt.plot(self.quarters, self.adoption_rate_per_quarter, marker='o', linestyle='-', color='b',
                 label='Adoption Rate')
        years = range(2024, 2051)
        yearly_ticks = list(range(0, len(self.quarters), 4))
        plt.xticks(ticks=yearly_ticks, labels=[years[i] for i in range(len(yearly_ticks))])
        plt.xlabel('Year')
        plt.ylabel('Adoption Rate')
        plt.title('Adoption Rate Over Time')
        plt.legend()
        plt.grid(True)
        plt.xticks(rotation=45)
        plt.tight_layout()
        plt.savefig('adoption_rate_over_time.png')
        plt.close()
        print("Adoption rate plot saved as 'adoption_rate_over_time.png'.")

    def plot_stages(self):
        # Initialize counters for each stage
        knowledge_count = sum(agent.guilt == "L" for agent in self.schedule.agents)
        motivation_count = sum(agent.m_st == "L" and agent.guilt == "H" for agent in self.schedule.agents)
        consideration_count = sum(agent.c_st == "L" and agent.m_st == "H" for agent in self.schedule.agents)
        action_count = sum(agent.adopted for agent in self.schedule.agents)
        habit_count = sum(agent.user_status == "frequent_user" for agent in self.schedule.agents)

        # Labels for the stages
        stages = ['Knowledge', 'Motivation', 'Consideration', 'Action', 'Habit']
        counts = [knowledge_count, motivation_count, consideration_count, action_count, habit_count]

        # Plotting the stages
        plt.figure(figsize=(10, 6))
        plt.bar(stages, counts, color=['blue', 'orange', 'green', 'red', 'purple'])
        plt.xlabel('Stages')
        plt.ylabel('Number of Agents')
        plt.title('Number of Agents in Each Stage')
        plt.grid(True)
        plt.tight_layout()
        plt.savefig('stages_distribution.png')
        plt.close()
        print("Stages distribution plot saved as 'stages_distribution.png'.")

    def expand_infrastructure(self):
        if self.infrastructure == "Gradual":
            if self.year - 2024 <= 9:
                new_stations_this_year = self.new_bike_stations[(self.year - 2024) * 20: (self.year - 2024 + 1) * 20]
                new_stations_gdf = gpd.GeoDataFrame({'geometry': new_stations_this_year},
                                                    crs=self.bike_station_locations.crs)

                print(f"Year {self.year}: Adding {len(new_stations_gdf)} new bike stations.")

                self.bike_station_locations = pd.concat([self.bike_station_locations, new_stations_gdf]).reset_index(
                    drop=True)

                print(f"Total number of bike stations after addition: {len(self.bike_station_locations)}")

                self.update_station_access()

        elif self.infrastructure == "Dramatic":
            if self.year == 2025 and self.quarter == 1:
                new_stations_gdf = gpd.GeoDataFrame({'geometry': self.new_bike_stations[:200]},
                                                    crs=self.bike_station_locations.crs)

                print(f"Year {self.year} Quarter {self.quarter}: Adding 200 new bike stations.")

                self.bike_station_locations = pd.concat([self.bike_station_locations, new_stations_gdf]).reset_index(
                    drop=True)

                print(f"Total number of bike stations after addition: {len(self.bike_station_locations)}")

                self.update_station_access()

    def update_station_access(self):
        all_stations_union = self.bike_station_locations.unary_union
        num_agents_with_access_before = sum(agent.station_access for agent in self.schedule.agents)

        for agent in self.schedule.agents:
            nearest_station = nearest_points(agent.position, all_stations_union)[1]
            distance = agent.position.distance(nearest_station)
            agent.station_access = 1 if distance < 300 else 0

        num_agents_with_access_after = sum(agent.station_access for agent in self.schedule.agents)
        # Debug: print the change in number of agents with access
        print(
            f"Updated station access for agents. Number of agents with access before: {num_agents_with_access_before}, after: {num_agents_with_access_after}")

    def update_social_norms_population_based(self):
        # Calculate the overall adoption rate of the population
        num_adopters = sum(agent.adopted for agent in self.schedule.agents)
        adoption_rate = num_adopters / self.num_agents

        # Define the threshold and the maximum SN increment
        threshold = 0.2
        max_increment = 0.7

        for agent in self.schedule.agents:
            if adoption_rate > threshold:
                # Increase SN based on the excess adoption rate
                increment = max_increment * (adoption_rate - threshold) / (1 - threshold)
                agent.sn += increment
                # Cap SN at the maximum value of 7
                agent.sn = min(agent.sn, 7)

        print("Social norms updated based on overall population adoption rate.")

    def print_summary(self):
        num_agents_act = sum(agent.act for agent in self.schedule.agents)
        avg_aware = sum(agent.env_aware for agent in self.schedule.agents) / self.num_agents
        num_guilt = sum(agent.guilt == "H" for agent in self.schedule.agents)
        num_c_st_H = sum(agent.c_st == "H" for agent in self.schedule.agents)
        num_m_st_H = sum(agent.m_st == "H" for agent in self.schedule.agents)
        num_station_access = sum(agent.station_access for agent in self.schedule.agents)
        avg_utility = sum(agent.U for agent in self.schedule.agents) / self.num_agents

        print(f"Year: {self.year} Quarter: {self.quarter}")
        print(f"Number of agents taking action: {num_agents_act}")
        print(f"Average environment awareness: {avg_aware}")
        print(f"Number of agents with guilt: {num_guilt}")
        print(f"Number of agents with m_st='H': {num_m_st_H}")
        print(f"Number of agents with c_st='H': {num_c_st_H}")
        print(f"Number of agents with station access: {num_station_access}")

    def calculate_average_attributes(self):
        # Initialize sums and counters
        bike_user_age_sum = 0
        bike_user_income_sum = 0
        bike_user_female_sum = 0
        bike_user_count = 0

        ebike_user_age_sum = 0
        ebike_user_income_sum = 0
        ebike_user_female_sum = 0
        ebike_user_count = 0

        # Iterate over all agents and categorize them
        for agent in self.schedule.agents:
            is_bike_user, is_ebike_user = self.check_agent_user_status(agent)

            if is_bike_user:
                bike_user_age_sum += agent.age
                bike_user_income_sum += agent.income
                bike_user_female_sum += agent.female  # Add female count (1 for female, 0 for male)
                bike_user_count += 1

            if is_ebike_user:
                ebike_user_age_sum += agent.age
                ebike_user_income_sum += agent.income
                ebike_user_female_sum += agent.female  # Add female count (1 for female, 0 for male)
                ebike_user_count += 1

        # Calculate averages
        avg_age_bike_users = bike_user_age_sum / bike_user_count if bike_user_count > 0 else 0
        avg_income_bike_users = bike_user_income_sum / bike_user_count if bike_user_count > 0 else 0
        avg_female_bike_users = bike_user_female_sum / bike_user_count if bike_user_count > 0 else 0

        avg_age_ebike_users = ebike_user_age_sum / ebike_user_count if ebike_user_count > 0 else 0
        avg_income_ebike_users = ebike_user_income_sum / ebike_user_count if ebike_user_count > 0 else 0
        avg_female_ebike_users = ebike_user_female_sum / ebike_user_count if ebike_user_count > 0 else 0

        # Prepare data for CSV
        data = {
            "User Type": ["Bike Users", "E-Bike Users"],
            "Average Age": [avg_age_bike_users, avg_age_ebike_users],
            "Average Income": [avg_income_bike_users, avg_income_ebike_users],
            "Average Female Proportion": [avg_female_bike_users, avg_female_ebike_users]
        }

        # Convert to DataFrame
        df = pd.DataFrame(data)

        # Save to CSV
        df.to_csv("average_attributes_bike_vs_ebike.csv", index=False)

        # Print results
        print(df)

    def end_of_simulation(self):
        self.plot_adoption_rate()
        self.plot_user_status()
        self.plot_emissions()
        self.plot_social_network()
        self.plot_stages()  # Add this line

    def plot_user_status(self):
        plt.figure(figsize=(10, 6))
        plt.plot(self.quarters, self.non_users_per_quarter, marker='o', linestyle='-', color='k', label='Non-users')
        plt.plot(self.quarters, self.users_per_quarter, marker='o', linestyle='-', color='b', label='Users')
        plt.plot(self.quarters, self.frequent_users_per_quarter, marker='o', linestyle='-', color='g',
                 label='Frequent Users')
        years = range(2024, 2051)
        yearly_ticks = list(range(0, len(self.quarters), 4))
        plt.xticks(ticks=yearly_ticks, labels=[years[i] for i in range(len(yearly_ticks))])
        plt.xlabel('Year')
        plt.ylabel('Number of Agents')
        plt.title('User Status Over Time')
        plt.legend()
        plt.grid(True)
        plt.gca().xaxis.set_major_locator(mdates.YearLocator())
        plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%Y'))
        plt.gca().xaxis.set_major_locator(mdates.YearLocator())
        plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%Y'))
        plt.xticks(rotation=45)
        plt.tight_layout()
        plt.savefig('user_status_over_time.png')
        plt.close()
        print("User status plot saved as 'user_status_over_time.png'.")

    def save_user_attributes(self):
        # Prepare lists to store the user attributes
        bike_user_data = []
        ebike_user_data = []

        # Iterate over agents to collect data based on adoption status
        for agent in self.schedule.agents:
            if agent.adopt_bike:
                bike_user_data.append({
                    "ID": agent.h_id,
                    "Age": agent.age,
                    "Income": agent.income,
                    "Female": agent.female,
                    "Education": agent.education,
                    "Employment": agent.employment,
                    "Children": agent.children,
                    "Adults": agent.adults,
                    "Cars": agent.cars,
                    "Bikes": agent.bikes,
                    "Station Access": agent.station_access,
                    "PT Access": agent.pt_access,
                    "User Type": "Bike"
                })
            if agent.adopt_ebike:
                ebike_user_data.append({
                    "ID": agent.h_id,
                    "Age": agent.age,
                    "Income": agent.income,
                    "Female": agent.female,
                    "Education": agent.education,
                    "Employment": agent.employment,
                    "Children": agent.children,
                    "Adults": agent.adults,
                    "Cars": agent.cars,
                    "Bikes": agent.bikes,
                    "Station Access": agent.station_access,
                    "PT Access": agent.pt_access,
                    "User Type": "E-Bike"
                })

        # Convert lists to DataFrames
        bike_user_df = pd.DataFrame(bike_user_data)
        ebike_user_df = pd.DataFrame(ebike_user_data)

        # Combine both dataframes into one
        combined_df = pd.concat([bike_user_df, ebike_user_df], ignore_index=True)

        # Check if the file already exists, and append if it does
        file_path = "bike_ebike_users_attributes.csv"
        if not os.path.isfile(file_path):
            combined_df.to_csv(file_path, index=False, mode='w', header=True)
        else:
            combined_df.to_csv(file_path, index=False, mode='a', header=False)

        print(f"User attributes saved and appended to '{file_path}'.")

    def save_agent_states(self):
        self.saved_agent_states = []
        for agent in self.schedule.agents:
            agent_state = {
                "U": agent.U,
                "satisfaction": agent.satisfaction,
                "user_status": agent.user_status
            }
            self.saved_agent_states.append(agent_state)

    def load_agent_state(self):
        if hasattr(self, 'saved_agent_states'):
            for agent, saved_state in zip(self.schedule.agents, self.saved_agent_states):
                agent.U = saved_state["U"]
                agent.satisfaction = saved_state["satisfaction"]
                agent.user_status = saved_state["user_status"]
            print("Agent states loaded.")

    def plot_social_network(self):
        fig, ax = plt.subplots(figsize=(10, 10))

        # Define fixed boundaries for consistency across all plots
        min_x, min_y, max_x, max_y = 590000, 5332500, 610000, 5350000
        ax.set_xlim(min_x, max_x)
        ax.set_ylim(min_y, max_y)

        # Plot cycleways
        self.vienna_cycleways.plot(ax=ax, color='grey', linewidth=1, label='Cycleways')

        # Select 10 random agents
        random_agents = random.sample(self.schedule.agents, 1)

        # Collect positions of agents and their neighbors
        agent_positions = []
        neighbor_positions = []
        connections = []

        for agent in random_agents:
            agent_positions.append((agent.position.x, agent.position.y))
            neighbors = self.get_neighbors(agent, num_neighbors=8)
            for neighbor in neighbors:
                neighbor_positions.append((neighbor.position.x, neighbor.position.y))
                connections.append(((agent.position.x, agent.position.y), (neighbor.position.x, neighbor.position.y)))

        # Plot agents
        if agent_positions:
            ax.scatter(*zip(*agent_positions), color='blue', s=50, label='Agents')

        # Plot neighbors
        if neighbor_positions:
            ax.scatter(*zip(*neighbor_positions), color='green', s=20, label='Neighbors')

        # Plot KDTree connections
        for connection in connections:
            ax.plot([connection[0][0], connection[1][0]], [connection[0][1], connection[1][1]], color='red',
                    linewidth=0.5)

        plt.xlabel('Easting (meters)')
        plt.ylabel('Northing (meters)')
        plt.title('Social Network of 10 Random Agents and Their Neighbors')
        ax.legend(loc='upper right')
        plt.savefig(f'social_network_{self.year}_Q{self.quarter}.png')
        plt.close()
        print(f'Social network plot saved as social_network_{self.year}_Q{self.quarter}.png')

    def calculate_adopters_per_district(self):
        district_adoption = []
        for district in self.districts['BEZNR'].unique():
            district_agents = [agent for agent in self.schedule.agents if
                               self.districts[self.districts['BEZNR'] == district].geometry.iloc[0].contains(
                                   agent.position)]
            total_agents = len(district_agents)
            adopters = sum(agent.adopted for agent in district_agents)
            adoption_rate = adopters / total_agents if total_agents > 0 else 0
            district_adoption.append([district, total_agents, adopters, adoption_rate])

        df_adoption = pd.DataFrame(district_adoption, columns=['District', 'Total Agents', 'Adopters', 'Adoption Rate'])
        return df_adoption

def main():
    args = parse_args()

    settings = [
        {"learning": "No-learning", "infrastructure": "No-expansion", "policy": "Not-Implemented"},
        {"learning": "No-learning", "infrastructure": "No-expansion", "policy": "Implemented"},
        {"learning": "Informative-all", "infrastructure": "No-expansion", "policy": "Not-Implemented"}
    ]

    num_runs = 100
    num_quarters = 108  # Simulate 27 years (108 quarters)
    default_seed = 0

    for setting in settings:
        # Dynamically create the label by combining learning, infrastructure, and policy settings
        add_label = "MVP"
        label = f"{setting['learning']}, {setting['infrastructure']}, {setting['policy']}, {add_label}"
        setting["label"] = label  # Assign the label to the setting

        # Initialize empty lists to collect DataFrame rows for each run
        adoption_rate_rows = []
        emissions_savings_rows = []
        user_status_rows = []
        stage_rows = []
        district_adoption_rows = []

        all_adoption_rates = np.zeros((num_runs, num_quarters))
        all_emissions_savings = np.zeros((num_runs, num_quarters))

        for run in range(num_runs):
            seed = (args.seed if args.seed is not None else default_seed) + run
            model = CommunityModel(
                N=args.num_agents,
                learning=setting["learning"],
                infrastructure=setting["infrastructure"],
                policy=setting["policy"],
                seed=seed
            )

            for quarter in range(num_quarters):
                model.go()
                all_adoption_rates[run, quarter] = model.adoption_rate_per_quarter[-1]
                all_emissions_savings[run, quarter] = model.emissions_savings[-1]

                # Collect user status counts
                num_non_users = sum(agent.user_status == "non_user" for agent in model.schedule.agents)
                num_users = sum(agent.user_status == "user" for agent in model.schedule.agents)
                num_frequent_users = sum(agent.user_status == "frequent_user" for agent in model.schedule.agents)

                user_status_rows.append({
                    'Quarters': quarter + 1,
                    'NonUsers': num_non_users,
                    'Users': num_users,
                    'FrequentUsers': num_frequent_users,
                    'Label': setting['label']
                })

                # Collect stage counts
                knowledge_count = sum(agent.guilt == "L" for agent in model.schedule.agents)
                motivation_count = sum(agent.m_st == "L" and agent.guilt == "H" for agent in model.schedule.agents)
                consideration_count = sum(agent.c_st == "L" and agent.m_st == "H" for agent in model.schedule.agents)
                action_count = sum(agent.adopted for agent in model.schedule.agents)
                habit_count = sum(agent.user_status == "frequent_user" for agent in model.schedule.agents)

                stage_rows.append({
                    'Quarters': quarter + 1,
                    'Knowledge': knowledge_count,
                    'Motivation': motivation_count,
                    'Consideration': consideration_count,
                    'Action': action_count,
                    'Habit': habit_count,
                    'Label': setting['label']
                })

            num_bike_users = sum(agent.adopt_bike for agent in model.schedule.agents)
            num_ebike_users = sum(agent.adopt_ebike for agent in model.schedule.agents)
            print(f"Number of Bike users in run {run + 1}: {num_bike_users}")
            print(f"Number of E-Bike users in run {run + 1}: {num_ebike_users}")
            model.save_user_attributes()
            print(f"Completed run {run + 1}/{num_runs} for setting: {setting['label']}")

        avg_adoption_rate = np.mean(all_adoption_rates, axis=0)
        std_adoption_rate = np.std(all_adoption_rates, axis=0)

        avg_emissions_savings = np.mean(all_emissions_savings, axis=0)
        std_emissions_savings = np.std(all_emissions_savings, axis=0)

        # Create rows to append to the DataFrame for adoption rate
        for quarter in range(num_quarters):
            adoption_rate_rows.append({
                'Quarters': quarter + 1,
                'AvgAdoptionRate': avg_adoption_rate[quarter],
                'StdAdoptionRate': std_adoption_rate[quarter],
                'Label': setting['label']
            })

        # Create rows to append to the DataFrame for emissions savings
        for quarter in range(num_quarters):
            emissions_savings_rows.append({
                'Quarters': quarter + 1,
                'AvgEmissionsSavings': avg_emissions_savings[quarter],
                'StdEmissionsSavings': std_emissions_savings[quarter],
                'Label': setting['label']
            })

        # Convert lists to DataFrames
        adoption_rate_df = pd.DataFrame(adoption_rate_rows)
        emissions_savings_df = pd.DataFrame(emissions_savings_rows)
        user_status_df = pd.DataFrame(user_status_rows)
        stage_df = pd.DataFrame(stage_rows)
        district_adoption_df = pd.DataFrame(district_adoption_rows)  # Convert district adoption data to DataFrame

        # Append to existing files or create new ones if they don't exist
        append_or_create_csv(adoption_rate_df, 'adoption_rate_combined_mvp.csv')
        append_or_create_csv(emissions_savings_df, 'emissions_savings_combined_mvp.csv')
        append_or_create_csv(user_status_df, 'user_status_combined_mvp.csv')
        append_or_create_csv(stage_df, 'stage_combined_mvp.csv')
        append_or_create_csv(district_adoption_df, 'district_adoption_combined_mvp.csv')  # Save district adoption data

    print("Simulation and data saving complete for all scenarios.")

def append_or_create_csv(df, filepath):
    if not os.path.isfile(filepath):
        df.to_csv(filepath, index=False, mode='w', header=True)
    else:
        df.to_csv(filepath, index=False, mode='a', header=False)

def parse_args():
    parser = argparse.ArgumentParser(description="Community Simulation Model")
    parser.add_argument("--num_agents", type=int, default=500, help="Number of agents")
    parser.add_argument("--learning", type=str, default="No-learning", help="Learning type")
    parser.add_argument("--infrastructure", type=str, default="No-Expansion", help="Infrastructure expansion scenario")
    parser.add_argument("--policy", type=str, default="Not-implemented", help="Car free first district scenario")
    parser.add_argument("--seed", type=int, default=None, help="Seed for random number generator")
    return parser.parse_args()

main()
