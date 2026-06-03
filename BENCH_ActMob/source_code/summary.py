# -*- coding: utf-8 -*-
"""
Created on Wed Nov 19 10:07:17 2025

@author: hartvig
"""
import numpy as np
import pandas as pd


def print_summary(agents, scenario, year, iter_nr):
    # Print summary statistics for the current year
    num_agents_bike = sum(agent.mode_trips['bike'] for agent in agents)
    num_agents_walk = sum(agent.mode_trips['walk'] for agent in agents)
    num_agents_car = sum(agent.mode_trips['car'] for agent in agents)
    num_agents_pt = sum(agent.mode_trips['pt'] for agent in agents)
    total = sum(agent.total_trips for agent in agents)

    guilt = sum(1 for agent in agents if agent.guilt == 'H')
    mot = sum(1 for agent in agents if agent.mot == 'H')
    cons = sum(1 for agent in agents if agent.cons == 'H')

    kn_aw = np.average([agent.kn_aw for agent in agents])
    pn = np.average([agent.pn for agent in agents])
    pbc = np.average([agent.pbc for agent in agents])
    u_bike = np.average([agent.U['bike']['work'] for agent in agents])
    u_walk = np.average([agent.U['walk']['work'] for agent in agents])

    # if self.year == 2040:
    
    dists = set()
    dists = [agent.district for agent in agents if agent.district not in dists and (dists.add(agent.district) or True)]
    district = {"Bicycle": {d: sum(agent.mode_trips['bike'] for agent in agents if agent.district == d) / 
                            sum(1 for agent in agents if agent.district == d)
                                            for d in dists},
                "Walk": {d: sum(agent.mode_trips['walk'] for agent in agents if agent.district == d) / 
                            sum(1 for agent in agents if agent.district == d)
                                            for d in dists},
                "Car": {d: sum(agent.mode_trips['car'] for agent in agents if agent.district == d) / 
                            sum(1 for agent in agents if agent.district == d)
                                            for d in dists},
                "PT": {d: sum(agent.mode_trips['pt'] for agent in agents if agent.district == d) / 
                            sum(1 for agent in agents if agent.district == d)
                                            for d in dists},
                "PBC": {d: sum(agent.pbc for agent in agents if agent.district == d) / 
                            sum(1 for agent in agents if agent.district == d)
                                            for d in dists},
                "PN": {d: sum(agent.pn for agent in agents if agent.district == d) / 
                            sum(1 for agent in agents if agent.district == d)
                                            for d in dists},
                "KN": {d: sum(agent.kn_aw for agent in agents if agent.district == d) / 
                            sum(1 for agent in agents if agent.district == d)
                                            for d in dists},
                "guilt": {d: sum(1 for agent in agents if (agent.guilt == 'H') & (agent.district == d)) / 
                            sum(1 for agent in agents if agent.district == d)
                                            for d in dists},
                "mot": {d: sum(1 for agent in agents if (agent.mot == 'H') & (agent.district == d)) / 
                            sum(1 for agent in agents if agent.district == d)
                                            for d in dists},
                "cons": {d: sum(1 for agent in agents if (agent.cons == 'H') & (agent.district == d)) / 
                            sum(1 for agent in agents if agent.district == d)
                                            for d in dists},
                "district_pop": {d: sum(1 for agent in agents if agent.district == d)
                                            for d in dists},
                "total_trips": {d: sum(agent.total_trips for agent in agents if agent.district == d)
                                            for d in dists}}
    # print(district)
    # bike_district = pd.DataFrame.from_dict(district["Bicycle"], 
    #                                        orient='index', columns=['bike_trips']
    #                                       ).reset_index().rename(columns={'index': 'district'}).sort_values('district')
    # bike_fn = "output/results/fig_" + str(self.iter) + "_" + self.scenario + "_bike_" + str(self.year) + ".csv"
    # bike_district.to_csv(bike_fn, index = False)

    # walk_district = pd.DataFrame.from_dict(district["Walk"], 
    #                                        orient='index', columns=['bike_trips']
    #                                       ).reset_index().rename(columns={'index': 'district'}).sort_values('district')
    # walk_fn = "output/results/fig_" + str(self.iter) + "_" + self.scenario + "_walk_" + str(self.year) + ".csv"
    # walk_district.to_csv(walk_fn, index = False)

    out_df_district = pd.DataFrame(district)
    out_df_district = out_df_district.reset_index().rename(columns={'index': 'district'}).sort_values('district')
    # ou_fn = "output/results/" + scenario + "_iter" + str(iter_nr) + "_" + str(year) + ".csv"
    # out_df_district.to_csv(ou_fn, index = False)
    
    modal_shares = [num_agents_bike / total, num_agents_walk / total, num_agents_pt / total, num_agents_car / total]
    out_df_total = pd.Series(modal_shares, index = ['Cycling', 'Walking', 'Public tr.', 'Car'])
    
    agent_dict = {}
    agent_dict['gender'] = [agent.gender for agent in agents]
    agent_dict['income'] = [agent.income for agent in agents]
    agent_dict['age'] = [agent.age for agent in agents]

    agent_dict['pbc'] = [agent.pbc for agent in agents]
    agent_dict['pn'] = [agent.pn for agent in agents]
    agent_dict['sn'] = [agent.sn for agent in agents]
    agent_dict['kn_aw'] = [agent.kn_aw for agent in agents]
    agent_dict['total_trips'] = [agent.total_trips for agent in agents]
    agent_dict['district'] = [agent.district for agent in agents]
    agent_dict['subdistrict'] = [agent.subdistrict for agent in agents]

    agent_dict['peers'] = [agent.peers for agent in agents]
    agent_dict['neighbour'] = [agent.neighbour for agent in agents]
    agent_dict['prob'] = {}
    agent_dict['U'] = {}
    agent_dict['modes'] = {}
    agent_dict['modes0'] = {}
    agent_dict['trips'] = {}
    agent_dict['length'] = {}
    agent_dict['U'] = {}
    agent_dict['mode_trips'] = {}


    for tr_mode in ['car', 'bike', 'walk', 'pt']:
        agent_dict['prob'][tr_mode] = {}
        agent_dict['U'][tr_mode] = {}
        agent_dict['mode_trips'][tr_mode] = [agent.mode_trips[tr_mode] for agent in agents]
        for d in ['work', 'services', 'leisure']:
            agent_dict['modes'][d] = [agent.modes[d] for agent in agents]
            agent_dict['modes0'][d] = [agent.modes0[d] for agent in agents]
            agent_dict['trips'][d] = [agent.trips[d] for agent in agents]
            agent_dict['length'][d] = [agent.length[d] for agent in agents]
            agent_dict['prob'][tr_mode][d] = [agent.prob[tr_mode][d] for agent in agents]
            agent_dict['U'][tr_mode][d] = [agent.U[tr_mode][d] for agent in agents]

    if year == 2040:
        print("------------")
        print(f"Year: {year}")
        # print(f"Number of cycling trips: {round(num_agents_bike, 0)}")
        print(f"Share of cycling trips: {round(num_agents_bike / total, 3)}")
        # print(f"Number of walking trips: {round(num_agents_walk, 0)}")
        print(f"Share of walking trips: {round(num_agents_walk / total, 3)}")
        print(f"Share of public tr. trips: {round(num_agents_pt / total, 3)}")
        print(f"Share of car trips: {round(num_agents_car / total, 3)}")

    # print(f"Knowledge & Awareness: {round(kn_aw, 3)}")
    # print(f"Personal norm: {round(pn, 3)}")
    # print(f"PBC: {round(pbc, 3)}")
    # print(f"Guilt: {guilt}")
    # print(f"Motivation: {mot}")
    # print(f"Consideration: {cons}")
    # print(f"Utility bicycle: {round(u_bike, 3)}")
    # print(f"Utility walking: {round(u_walk, 3)}")
    return out_df_total, out_df_district, agent_dict
