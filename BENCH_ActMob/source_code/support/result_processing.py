# -*- coding: utf-8 -*-
"""
Created on Wed Dec 10 15:26:48 2025

@author: hartvig
"""
import os
import pandas as pd
import matplotlib.pyplot as plt
from adjustText import adjust_text
import seaborn as sns
import pickle

def load_pickles(version):
    
    scenarios = []
    for file in os.listdir('output'):
        if ('pickle' in file) and (version in file):
            scenario = file.replace('results_{}_'.format(version), '').split('.')[0]
            scenarios = scenarios + [scenario]
    
    model_shares_2040 = pd.DataFrame(0.0, columns = ['Cycling', 'Walking', 'Public tr.', 'Car'], index = scenarios)
    model_shares_2040_min = pd.DataFrame(0.0, columns = ['Cycling', 'Walking', 'Public tr.', 'Car'], index = scenarios)
    model_shares_2040_max = pd.DataFrame(0.0, columns = ['Cycling', 'Walking', 'Public tr.', 'Car'], index = scenarios)
    agent_pbc = pd.DataFrame(0.0, columns = list(range(2300*10)), index = scenarios)
    active_mob_shares = pd.DataFrame(0.0, columns = range(2025, 2041), index = scenarios)
    active_mob_shares_min = pd.DataFrame(0.0, columns = range(2025, 2041), index = scenarios)
    active_mob_shares_max = pd.DataFrame(0.0, columns = range(2025, 2041), index = scenarios)
    
    for file in os.listdir('output'):
        if ('pickle' in file) and (version in file):
            scenario = file.replace('results_{}_'.format(version), '').split('.')[0]
            print(scenario)
            with open(os.path.join('output', file), 'rb') as handle:
                results = pickle.load(handle)
    
            iterations1 = pd.DataFrame(0.0, columns = ['Cycling', 'Walking', 'Public tr.', 'Car'], index = list(range(10)))
            iterations2 = pd.DataFrame(0.0, columns = ['Cycling', 'Walking', 'Public tr.', 'Car'], index = list(range(10)))
    
            for key, i in results.items():
                num_agents_bike = sum(i[2040]['mode_trips']['bike'])
                num_agents_walk = sum(i[2040]['mode_trips']['walk'])
                num_agents_car = sum(i[2040]['mode_trips']['car'])
                num_agents_pt = sum(i[2040]['mode_trips']['pt'])
                total = sum(i[2040]['total_trips'])
                modal_shares = [num_agents_bike / total, num_agents_walk / total, num_agents_pt / total, num_agents_car / total]
                out_df_total = pd.Series(modal_shares, index = ['Cycling', 'Walking', 'Public tr.', 'Car'])
                iterations1.loc[key] = out_df_total
                
                pbc_idx_start = key * 2300
                pbc_idx_end = (key + 1) * 2300 - 1
                agent_pbc.loc[scenario, pbc_idx_start:pbc_idx_end] = i[2040]['pbc']
                
                for year in range(2024, 2041):
                    num_agents_bike = sum(i[year]['mode_trips']['bike'])
                    num_agents_walk = sum(i[year]['mode_trips']['walk'])
                    num_agents_car = sum(i[year]['mode_trips']['car'])
                    num_agents_pt = sum(i[year]['mode_trips']['pt'])
                    total = sum(i[year]['total_trips'])
                    active_mob_share = num_agents_bike / total + num_agents_walk / total
                    iterations2.loc[key, year] = active_mob_share
                
            model_shares_2040.loc[scenario] = iterations1.mean()
            model_shares_2040_min.loc[scenario] = iterations1.min()
            model_shares_2040_max.loc[scenario] = iterations1.max()
            active_mob_shares.loc[scenario] = iterations2.mean()
            active_mob_shares_min.loc[scenario] = iterations2.min()
            active_mob_shares_max.loc[scenario] = iterations2.max()
            
    return model_shares_2040, model_shares_2040_min, model_shares_2040_max, \
        active_mob_shares, active_mob_shares_min, active_mob_shares_max, agent_pbc
        
        
scenarios = []
for file in os.listdir('output'):
    if ('pickle' in file) and ('v2' in file):
        if 'Peers' in file:
            scenario = file.replace('results_v2_', '').split('.')[0]
            scenarios = scenarios + [scenario]

model_shares_2040 = pd.DataFrame(0.0, columns = ['Cycling', 'Walking', 'Public tr.', 'Car'], index = scenarios)
model_shares_2040_min = pd.DataFrame(0.0, columns = ['Cycling', 'Walking', 'Public tr.', 'Car'], index = scenarios)
model_shares_2040_max = pd.DataFrame(0.0, columns = ['Cycling', 'Walking', 'Public tr.', 'Car'], index = scenarios)
agent_pbc = pd.DataFrame(0.0, columns = list(range(2300*10)), index = scenarios)
active_mob_shares = pd.DataFrame(0.0, columns = range(2025, 2041), index = scenarios)
active_mob_shares_min = pd.DataFrame(0.0, columns = range(2025, 2041), index = scenarios)
active_mob_shares_max = pd.DataFrame(0.0, columns = range(2025, 2041), index = scenarios)
scens = {}

for file in os.listdir('output'):
    if ('pickle' in file) and ('v1' in file):
        if 'Peers' in file:
    
            scenario = file.replace('results_v1_', '').split('.')[0]
            print(scenario)
            with open(os.path.join('output', file), 'rb') as handle:
                results = pickle.load(handle)
    
            iterations1 = pd.DataFrame(0.0, columns = ['Cycling', 'Walking', 'Public tr.', 'Car'], index = list(range(10)))
            iterations2 = pd.DataFrame(0.0, columns = ['Cycling', 'Walking', 'Public tr.', 'Car'], index = list(range(10)))
    
            for key, i in results.items():
                num_agents_bike = sum(i[2040]['mode_trips']['bike'])
                num_agents_walk = sum(i[2040]['mode_trips']['walk'])
                num_agents_car = sum(i[2040]['mode_trips']['car'])
                num_agents_pt = sum(i[2040]['mode_trips']['pt'])
                total = sum(i[2040]['total_trips'])
                modal_shares = [num_agents_bike / total, num_agents_walk / total, num_agents_pt / total, num_agents_car / total]
                out_df_total = pd.Series(modal_shares, index = ['Cycling', 'Walking', 'Public tr.', 'Car'])
                iterations1.loc[key] = out_df_total
                
                pbc_idx_start = key * 2300
                pbc_idx_end = (key + 1) * 2300 - 1
                agent_pbc.loc[scenario, pbc_idx_start:pbc_idx_end] = i[2040]['pbc']
                
                for year in range(2024, 2041):
                    num_agents_bike = sum(i[year]['mode_trips']['bike'])
                    num_agents_walk = sum(i[year]['mode_trips']['walk'])
                    num_agents_car = sum(i[year]['mode_trips']['car'])
                    num_agents_pt = sum(i[year]['mode_trips']['pt'])
                    total = sum(i[year]['total_trips'])
                    active_mob_share = num_agents_bike / total + num_agents_walk / total
                    iterations2.loc[key, year] = active_mob_share
            scens[scenario] = iterations1
            model_shares_2040.loc[scenario] = iterations1.mean()
            model_shares_2040_min.loc[scenario] = iterations1.min()
            model_shares_2040_max.loc[scenario] = iterations1.max()
            active_mob_shares.loc[scenario] = iterations2.mean()
            active_mob_shares_min.loc[scenario] = iterations2.min()
            active_mob_shares_max.loc[scenario] = iterations2.max()
