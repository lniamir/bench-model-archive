# -*- coding: utf-8 -*-
"""
Created on Wed Jan 29 14:46:58 2025

@author: hartvig
"""
import os
from pathlib import Path
import random
import pandas as pd
import numpy as np
from mesa import Agent, Model
from mesa.space import MultiGrid
from mesa.visualization import SolaraViz, make_plot_component, make_space_component
# from mesa.time import RandomActivation
import configparser


class HouseholdAgent(Agent):
    def __init__(self, unique_id, model, **kwargs):
        super().__init__(model)
        
        self.h_id = unique_id
        
        for attr,value in kwargs.items():
            try:
                value = int(value)
            except:
                pass
            setattr(self, attr, value)
            

class CommunityModel(Model):
    def __init__(self, start_year, N, case_study="NL", scenario="Ref.SSP2", data="Empirical-survey", learning="Informative", i1_cost=3000, i2_cost=4000, i3_cost=300, seed=None):
        super().__init__()
        self.num_agents = N
        # self.schedule = RandomActivation(self)
        self.learning = learning
        self.grid = MultiGrid(10, 10, True)  # Assuming a 10x10 grid for simplicity
        self.case_study = case_study
        self.scenario = scenario
        self.data = data
        self.year = start_year
        self.debugfiles = True
        self.awareness_levels = {'Low': [], 'Medium': [], 'High': []}
        self.motivation_levels = {'PN1': [], 'PN2': [], 'PN3': [], 'SN1': [], 'SN2': [], 'SN3': []}
        self.behavioral_changes = {'Investment': [], 'Conservation': [], 'Switching': []}
        self.investment_changes = {'I1': [], 'I2': [], 'I3': []}
        self.conservation_changes = {'C1': [], 'C2': [], 'C3': []}
        self.switching_changes = {'S1': [], 'S2': [], 'S3': []}
        self.energy_savings = {'Electricity': [], 'Gas': []}
        self.save_gas_com = 0
        self.invs1_com = 0
        self.a1_com = 0
        self.I1_cost = i1_cost
        self.I2_cost = i2_cost
        self.I3_cost = i3_cost
        if seed is not None:
            random.seed(seed)
        self.load_data()
        self.setup_agents()

    def load_data(self):
        try:
            if self.case_study == "ES" and self.scenario == "Ref.SSP2":
                self.cge_es_ssp2_h = pd.read_csv("input//cge-es-ssp2-h.csv")
            elif self.case_study == "NL" and self.scenario == "Ref.SSP2":
                self.cge_nl_ssp2_h = pd.read_csv("input//cge-nl-ssp2-h.csv")
            print(f"Data loaded successfully for case study {self.case_study} and scenario {self.scenario}.")
        except FileNotFoundError as e:
            print(f"File not found: {e.filename}")

    def setup_agents(self):
        if self.case_study == "NL" and self.data == "Empirical-survey":
            setup_vars = pd.read_csv('input//agent_setup.csv', index_col = 0)
            setup_vars = setup_vars.to_dict()
            for i in range(self.num_agents):
                agent = HouseholdAgent(i, self, **setup_vars['Value'])
                # self.agent.add(agent)
                x = random.randrange(self.grid.width)
                y = random.randrange(self.grid.height)
                self.grid.place_agent(agent, (x, y))

                agent.elec = random.randint(1000, 5000)
                agent.gas = random.randint(0, 5000)
                agent.income = random.randint(800, 100000)
                agent.know = random.uniform(1, 7)

                rn = random.uniform(0, 100)
                if rn < 5.5:
                    self.assign_group(agent, 1)
                elif 5.5 <= rn < 40.19:
                    self.assign_group(agent, 2)
                elif 40.19 <= rn < 78.17:
                    self.assign_group(agent, 3)
                elif 78.17 <= rn < 91.69:
                    self.assign_group(agent, 4)
                elif 91.69 <= rn < 97.39:
                    self.assign_group(agent, 5)
                elif 97.39 <= rn < 98.36:
                    self.assign_group(agent, 6)
                elif 98.36 <= rn <= 100:
                    self.assign_group(agent, 7)
                    
                agent.aware = (agent.know + agent.cee_aw + agent.ed_aw) / 3

                print(
                    f"Agent {agent.h_id}: Income={agent.income}, Gas={agent.gas}, Awareness={agent.aware}, Group={agent.h_group}")

    def assign_group(self, agent, group):
        agent_ranges = pd.read_csv('input//agent_ranges.csv', index_col = 0)
        group_ranges = agent_ranges.loc[group, :].set_index('Variables').to_dict()['Value']
        agent.h_group = group
        for attr, value in group_ranges.items():
            range_min = float(value.split(', ')[0])
            range_max = float(value.split(', ')[1])
            if attr in ['income, gas']:
                setattr(agent , attr, random.uniform(int(range_min), int(range_max)))
            else:
                setattr(agent , attr, random.uniform(range_min, range_max))

        group_probs = pd.read_csv('input//agent_survey_probs.csv', index_col = 0).loc[group, :].set_index('Variables')
        group_probs = group_probs.T.to_dict()
        for attr, value in group_probs.items():
            probs = list(value.values())
            probs = [float(i) for i in probs]
            setattr(agent, attr, np.random.choice(5, 1, p = probs)[0] + 1)

        print(f"Agent {agent.h_id} assigned to group {group}.")


    def recall_memory(self):
        group_limits = {'ES': {1: 2.3, 2: 1.7, 3: 2.9, 4: 3, 5: 2.5, 6: 2.5, 7: 2.5},
                        'NL': {1: 1.8, 2: 1.4, 3: 1.5, 4: 3.6, 5: 1.2, 6: 1.2, 7: 1.2}}

        if self.year == 2016:
            for agent in self.agents:
                if self.case_study == "ES":
                    if random.uniform(0, 100) <= group_limits[self.case_study][agent.h_group]:
                        agent.act1 = True
                        agent.invest1 = True
                        agent.h_sta = "insulated"
                    else:
                        agent.act1 = False
                        agent.invest1 = False                    

            print(f"Memory recalled for year {self.year}.")

    def debug(self):
        if self.debugfiles:
            with open("output/debug.csv", "a") as file:
                for agent in self.agents:
                    file.write(
                        f"{self.year},{agent.h_id},{agent.sdgroup},{agent.h_sta},{agent.invest1},{agent.invest2},{agent.ene_prov},{agent.income},{agent.gen},{agent.edu},{agent.ecom},{agent.age},{agent.dw_st},{agent.dw_elab},{agent.dw_type},{agent.dw_age},{agent.dw_size},{agent.elec},{agent.gas},{agent.ene_pat1},{agent.ene_pat2},{agent.ene_pat3},{agent.know},{agent.cee_aw},{agent.ed_aw},{agent.guilt},{agent.aware},{agent.pn1},{agent.pn2},{agent.pn3},{agent.sn1},{agent.sn2},{agent.sn3},{agent.m1_st},{agent.m2_st},{agent.m3_st},{agent.pbcI1},{agent.pbcI2},{agent.pbcI3},{agent.pbcC1},{agent.pbcC2},{agent.pbcC3},{agent.pbcS1},{agent.pbcS2},{agent.pbcS3},{agent.cI1_st},{agent.cI2_st},{agent.cI3_st},{agent.cC1_st},{agent.cC2_st},{agent.cC3_st},{agent.cS1_st},{agent.cS2_st},{agent.cS3_st},{agent.U1},{agent.act1},{agent.U2},{agent.act2},{agent.U3},{agent.act3}\n")
            print("Debug information written to file.")

    def knowledge(self):
        for agent in self.agents:
            agent.aware = (agent.know + agent.cee_aw + agent.ed_aw) / 3
            if self.case_study == "NL":
                agent.guilt = "L" if agent.aware < 4.6 else "H"
            elif self.case_study == "ES":
                agent.guilt = "L" if agent.aware < 5.2 else "H"
            if agent.guilt == "H":
                agent.k = agent.aware / 7
        print("Knowledge updated.")

    def motivation(self):
        for agent in self.agents:
            if agent.guilt == "H":
                if self.case_study == "NL":
                    agent.m1_st = "L" if (agent.pn1 < 4.7 or agent.sn1 < 3.5) else "H"
                    agent.m2_st = "L" if (agent.pn2 < 4.8 or agent.sn2 < 3.6) else "H"
                    agent.m3_st = "L" if (agent.pn3 < 4.8 or agent.sn3 < 3.7) else "H"
                elif self.case_study == "ES":
                    agent.m1_st = "L" if (agent.pn1 < 5.67 or agent.sn1 < 4.77) else "H"
                    agent.m2_st = "L" if (agent.pn2 < 5.40 or agent.sn2 < 4.45) else "H"
                    agent.m3_st = "L" if (agent.pn3 < 5.78 or agent.sn3 < 5.05) else "H"
        print("Motivation updated.")

    def consideration(self):
        for agent in self.agents:
            if self.case_study == "NL":
                if agent.m1_st == "H":
                    agent.cI1_st = "L" if (agent.pbcI1 < 1 or agent.dw_st == 2) else "H"
                    agent.cI2_st = "L" if (agent.pbcI2 < 1 or agent.dw_st == 2) else "H"
                    agent.cI3_st = "L" if agent.pbcI3 < 1 else "H"
                if agent.m2_st == "H":
                    agent.cC1_st = "L" if (agent.pbcC1 < 1 or agent.ene_pat1 == 3) else "H"
                    agent.cC2_st = "L" if (agent.pbcC2 < 1 or agent.ene_pat2 == 3) else "H"
                    agent.cC3_st = "L" if (agent.pbcC3 < 1 or agent.ene_pat3 == 3) else "H"
                if agent.m3_st == "H":
                    if agent.ene_prov == 1:
                        agent.cS1_st = "L" if agent.pbcS1 < 1 else "H"
                    elif agent.ene_prov == 2:
                        agent.cS2_st = "L" if agent.pbcS2 < 1 else "H"
                    else:
                        agent.cS3_st = "L" if agent.pbcS3 < 1 else "H"

            elif self.case_study == "ES":
                if agent.m1_st == "H":
                    agent.cI1_st = "L" if (agent.pbcI1 < 2.2 or agent.dw_st == 2) else "H"
                    agent.cI2_st = "L" if (agent.pbcI2 < 2.2 or agent.dw_st == 2) else "H"
                    agent.cI3_st = "L" if agent.pbcI3 < 2.2 else "H"
                if agent.m2_st == "H":
                    agent.cC1_st = "L" if (agent.pbcC1 < 1 or agent.ene_pat1 == 3) else "H"
                    agent.cC2_st = "L" if (agent.pbcC2 < 1 or agent.ene_pat2 == 3) else "H"
                    agent.cC3_st = "L" if (agent.pbcC3 < 1 or agent.ene_pat3 == 3) else "H"
                if agent.m3_st == "H":
                    if agent.ene_prov == 1:
                        agent.cS1_st = "L" if agent.pbcS1 < 3.5 else "H"
                    elif agent.ene_prov == 2:
                        agent.cS2_st = "L" if agent.pbcS2 < 3.5 else "H"
                    else:
                        agent.cS3_st = "L" if agent.pbcS3 < 3.5 else "H"
        print("Consideration updated.")

    def utility(self):
        for agent in self.agents:
            if agent.cI1_st == "L":
                agent.U1 = 0
            else:
                agent.U1 = (agent.edu * 0.0563284 + agent.age * 0.0008106 +
                            agent.dw_elab * -0.0769971 + agent.dw_type * 0.4265 +
                            agent.dw_age * 0.0883428 + agent.dw_size * 0.0857047 +
                            agent.gas * 0.0000488 + agent.pn1 * 0.052849 + agent.erI1)
        print("Utility calculated.")

    def go(self):
        self.year += 1
        print(f"Simulation step for year {self.year} started.")
        # self.schedule.step()
        self.agents.shuffle_do("step")
        self.recall_memory()
        self.debug()
        self.update_info()
        self.update_dwelling()

        if self.scenario == "Ref.SSP2":
            self.knowledge()
            self.motivation()
            self.consideration()
            self.utility()
            self.action()
            self.save_energy()
            self.invest()
            self.learn()
            self.update_income()
            self.update_energy()
            self.update_memory()

        self.print_summary()

    def action(self):
        for agent in self.agents:
            if agent.U1 <= 0 or agent.invest1 or agent.h_sta == "insulated":
                agent.act1 = False
            elif agent.U1 > 0 and not agent.invest1 and agent.dw_elab > 1:
                agent.act1 = True
                agent.invest1 = True

        no_action = len([agent for agent in self.agents if not agent.act1])
        a1 = len([agent for agent in self.agents if agent.act1])
        self.a1_com += a1

        self.number_dwage1 = len([a for a in self.agents if a.dw_age == 1])
        self.number_dwage2 = len([a for a in self.agents if a.dw_age == 2])
        self.number_dwage3 = len([a for a in self.agents if a.dw_age == 3])

        self.number_elab1 = len([a for a in self.agents if a.dw_elab == 1])
        self.number_elab2 = len([a for a in self.agents if a.dw_elab == 2])
        self.number_elab3 = len([a for a in self.agents if a.dw_elab == 3])
        self.number_elab4 = len([a for a in self.agents if a.dw_elab == 4])
        self.number_elab5 = len([a for a in self.agents if a.dw_elab == 5])

        self.n_hh_eff = len([a for a in self.agents if a.h_sta == "Efficient"])
        print("Actions determined for agents.")

    def save_energy(self):
        gas_total = sum([agent.gas for agent in self.agents])

        if self.year >= 2017:
            for agent in self.agents:
                if agent.act1:
                    agent.save_a1 = agent.gas * 0.2
                    agent.gas -= agent.save_a1
                else:
                    agent.save_a1 = 0

        save_gas = sum([agent.save_a1 for agent in self.agents])
        self.save_gas_com += save_gas
        print(f"Energy savings calculated for year {self.year}.")

    def invest(self):
        if self.year >= 2017:
            for agent in self.agents:
                if agent.act1:
                    agent.invs_a1 = self.I1_cost
                else:
                    agent.invs_a1 = 0

        self.invs1_com += sum([agent.invs_a1 for agent in self.agents])
        print(f"Investments calculated for year {self.year}.")

    def learn(self):
        if self.year >= 2017:
            for agent in self.agents:
                if self.learning == "No learning":
                    continue
                if self.learning in ["Slow dynamics", "Fast dynamics"]:
                    if agent.act1 or agent.invest1:
                        if agent.pbcI1 < 6.6:
                            agent.pbcI1 += agent.pbcI1 * 0.05

                        neighbors = self.grid.get_neighbors(agent.pos, moore=True, include_center=False)
                        ngb_k_mean = sum([n.know for n in neighbors]) / len(neighbors)
                        ngb_k_median = sorted([n.know for n in neighbors])[len(neighbors) // 2]
                        ngb_k = max(ngb_k_mean, ngb_k_median)

                        ngb_ca_mean = sum([n.cee_aw for n in neighbors]) / len(neighbors)
                        ngb_ca_median = sorted([n.cee_aw for n in neighbors])[len(neighbors) // 2]
                        ngb_ca = max(ngb_ca_mean, ngb_ca_median)

                        ngb_ea_mean = sum([n.ed_aw for n in neighbors]) / len(neighbors)
                        ngb_ea_median = sorted([n.ed_aw for n in neighbors])[len(neighbors) // 2]
                        ngb_ed = max(ngb_ea_mean, ngb_ea_median)

                        ngb_pn1_mean = sum([n.pn1 for n in neighbors]) / len(neighbors)
                        ngb_pn1_median = sorted([n.pn1 for n in neighbors])[len(neighbors) // 2]
                        ngb_pn1 = max(ngb_pn1_mean, ngb_pn1_median)

                        ngb_sn1_mean = sum([n.sn1 for n in neighbors]) / len(neighbors)
                        ngb_sn1_median = sorted([n.sn1 for n in neighbors])[len(neighbors) // 2]
                        ngb_sn1 = max(ngb_sn1_mean, ngb_sn1_median)

                        ngb_pbcI1_mean = sum([n.pbcI1 for n in neighbors]) / len(neighbors)
                        ngb_pbcI1_median = sorted([n.pbcI1 for n in neighbors])[len(neighbors) // 2]
                        ngb_pbcI1 = max(ngb_pbcI1_mean, ngb_pbcI1_median)

                        if len(neighbors) > 4:
                            for n in neighbors:
                                if n.know < ngb_k and n.know < 6.6:
                                    n.know += n.know * 0.05
                                if n.cee_aw < ngb_ca and n.cee_aw < 6.6:
                                    n.cee_aw += n.cee_aw * 0.05
                                if n.ed_aw < ngb_ed and n.ed_aw < 6.6:
                                    n.ed_aw += n.ed_aw * 0.05
                                if n.pn1 < ngb_pn1 and n.pn1 < 6.6:
                                    n.pn1 += n.pn1 * 0.05
                                if n.sn1 < ngb_sn1 and n.sn1 < 6.6:
                                    n.sn1 += n.sn1 * 0.05
                                if n.pbcI1 < 6.5 and n.pbcI1 < ngb_pbcI1:
                                    n.pbcI1 += n.pbcI1 * 0.05

                if self.learning == "Informative":
                    if agent.know <= 6.6:
                        agent.know += agent.know * 0.05
                    if agent.cee_aw <= 6.6:
                        agent.cee_aw += agent.cee_aw * 0.05
                    if agent.ed_aw <= 6.6:
                        agent.ed_aw += agent.ed_aw * 0.05
                    if agent.act1 or agent.invest1:
                        if agent.pbcI1 < 6.6:
                            agent.pbcI1 += agent.pbcI1 * 0.05

                        neighbors = self.grid.get_neighbors(agent.pos, moore=True, include_center=False)
                        ngb_k_mean = sum([n.know for n in neighbors]) / len(neighbors)
                        ngb_k_median = sorted([n.know for n in neighbors])[len(neighbors) // 2]
                        ngb_k = max(ngb_k_mean, ngb_k_median)

                        ngb_ca_mean = sum([n.cee_aw for n in neighbors]) / len(neighbors)
                        ngb_ca_median = sorted([n.cee_aw for n in neighbors])[len(neighbors) // 2]
                        ngb_ca = max(ngb_ca_mean, ngb_ca_median)

                        ngb_ea_mean = sum([n.ed_aw for n in neighbors]) / len(neighbors)
                        ngb_ea_median = sorted([n.ed_aw for n in neighbors])[len(neighbors) // 2]
                        ngb_ed = max(ngb_ea_mean, ngb_ea_median)

                        ngb_pn1_mean = sum([n.pn1 for n in neighbors]) / len(neighbors)
                        ngb_pn1_median = sorted([n.pn1 for n in neighbors])[len(neighbors) // 2]
                        ngb_pn1 = max(ngb_pn1_mean, ngb_pn1_median)

                        ngb_sn1_mean = sum([n.sn1 for n in neighbors]) / len(neighbors)
                        ngb_sn1_median = sorted([n.sn1 for n in neighbors])[len(neighbors) // 2]
                        ngb_sn1 = max(ngb_sn1_mean, ngb_sn1_median)

                        ngb_pbcI1_mean = sum([n.pbcI1 for n in neighbors]) / len(neighbors)
                        ngb_pbcI1_median = sorted([n.pbcI1 for n in neighbors])[len(neighbors) // 2]
                        ngb_pbcI1 = max(ngb_pbcI1_mean, ngb_pbcI1_median)

                        for n in neighbors:
                            if n.know < ngb_k and n.know < 6.6:
                                n.know += n.know * 0.05
                            if n.cee_aw < ngb_ca and n.cee_aw < 6.6:
                                n.cee_aw += n.cee_aw * 0.05
                            if n.ed_aw < ngb_ed and n.ed_aw < 6.6:
                                n.ed_aw += n.ed_aw * 0.05
                            if n.pn1 < ngb_pn1 and n.pn1 < 6.6:
                                n.pn1 += n.pn1 * 0.05
                            if n.sn1 < ngb_sn1 and n.sn1 < 6.6:
                                n.sn1 += n.sn1 * 0.05
                            if n.pbcI1 < 6.5 and n.pbcI1 < ngb_pbcI1:
                                n.pbcI1 += n.pbcI1 * 0.05

                if self.learning == "Informative-Soft":
                    if agent.know <= 6.6:
                        agent.know += agent.know * 0.05
                    if agent.cee_aw <= 6.6:
                        agent.cee_aw += agent.cee_aw * 0.05
                    if agent.ed_aw <= 6.6:
                        agent.ed_aw += agent.ed_aw * 0.05

                if self.learning == "Promoting":
                    if agent.know <= 6.6:
                        agent.know += agent.know * 0.05
                    if agent.cee_aw <= 6.6:
                        agent.cee_aw += agent.cee_aw * 0.05
                    if agent.ed_aw <= 6.6:
                        agent.ed_aw += agent.ed_aw * 0.05
        print("Learning process updated.")

    def update_income(self):
        for agent in self.agents:
            rn = random.uniform(0, 100)
            if self.case_study == "ES" and self.scenario == "Ref.SSP2":
                cge_data = self.cge_es_ssp2_h
            elif self.case_study == "NL" and self.scenario == "Ref.SSP2":
                cge_data = self.cge_nl_ssp2_h
            else:
                continue
        print("Income updated.")

    def update_energy(self):
        if self.year >= 2017:
            for agent in self.agents:
                if agent.act1 and agent.dw_elab >= 2:
                    agent.dw_elab -= 1
                elif agent.act1 and agent.dw_elab == 1:
                    agent.h_sta = "Efficient"
        print("Energy status updated.")

    def update_memory(self):
        for agent in self.agents:
            if agent.invest1:
                agent.act1_year = getattr(agent, "act1_year", 0) + 1
            if getattr(agent, "act1_year", 0) >= 15 and agent.dw_age == 1:
                agent.invest1 = False
                agent.act1_year = 0
            elif getattr(agent, "act1_year", 0) >= 7 and agent.dw_age == 2:
                agent.invest1 = False
                agent.act1_year = 0
            elif getattr(agent, "act1_year", 0) >= 2 and agent.dw_age >= 3:
                agent.invest1 = False
                agent.act1_year = 0
        print("Memory updated.")

    def update_dwelling(self):
        # Define age limits for each period
        # Dictionary keys (numbers) refer to the time intervals place in chronological order
        age_groups = {'ES': {1: [49, 80], 2: [49, 84], 3: [49, 84], 4: [49, 84], 5: [57, 84]},
                      'NL': {1: [51, 83], 2: [51, 83], 3: [53, 83], 4: [55, 84], 5: [57, 84]}}
        # Create a list with year interval limits
        year_limits = np.array([2025, 2030, 2035, 2040, 2045, 2050])
        # Calculate diff from actual year
        year_diff = list(year_limits - self.year)
        # Find the smallest positive number --> index will be the actual time intervals number
        age_group_idx = year_diff.index(min(n for n in year_diff  if n>0))
        # Update dwellings if year is greater than the lowest interval limit
        if age_group_idx > 0:
            for agent in self.agents:            
                year_lims = age_groups[self.case_study][age_group_idx]
                dag = random.uniform(0, 100)
                if dag < year_lims[0]:
                    agent.dw_age = 1
                elif year_lims[0] <= dag < year_lims[1]:
                    agent.dw_age = 2
                else:
                    agent.dw_age = 3

        print("Dwelling information updated.")

    def update_info(self):
        for agent in self.agents:
            agent.act1 = False
        print("Agent info updated.")

    def print_summary(self):
        # Print summary statistics for the current year
        num_agents_act1 = sum(agent.act1 for agent in self.agents)
        avg_income = sum(agent.income for agent in self.agents) / self.num_agents
        avg_gas = sum(agent.gas for agent in self.agents) / self.num_agents
        avg_aware = sum(agent.aware for agent in self.agents) / self.num_agents

        print(f"Year: {self.year}")
        print(f"Number of agents taking action: {num_agents_act1}")
        print(f"Average income: {avg_income}")
        print(f"Average gas consumption: {avg_gas}")
        print(f"Average awareness: {avg_aware}")

def agent_portrayal(agent):
    return {
        "color": "tab:blue",
        "size": 50,
    }

def main():
    config = configparser.ConfigParser()
    config.read(r'settings.ini')
    # args = parse_args()
    start_year = config.getint('default', 'start_year')
    end_year = config.getint('default', 'end_year')
    timeline = list(range(end_year - start_year))
    model = CommunityModel(
        start_year = start_year,
        N = config.getint('default', 'num_agents'),
        case_study = config.get('default', 'case_study'),
        scenario = config.get('default', 'scenario'),
        data = config.get('default', 'data'),
        learning = config.get('default', 'learning'),
        i1_cost = config.getint('default', 'i1_cost'),
        i2_cost = config.getint('default', 'i2_cost'),
        i3_cost = config.getint('default', 'i3_cost'),
        seed = config.get('default', 'seed')
    )
    

    for _ in timeline:  # Simulate 10 years
        model.go()

if __name__ == "__main__":
    path = Path(__file__)
    os.chdir(path.parent.parent.absolute())
    main()
    
    