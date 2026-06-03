# -*- coding: utf-8 -*-
"""
Created on Wed Nov 19 09:56:48 2025

@author: hartvig
"""

# BENCH-Mobility for Vienna

# Import packages
import os
import sys
from pathlib import Path
import random
import pandas as pd
import numpy as np
from mesa import Agent, Model
from mesa.space import MultiGrid
from mesa import DataCollector
from mesa.visualization import SolaraViz, make_plot_component, make_space_component
import configparser
import geopandas as gpd
import networkx as nx
import matplotlib.pyplot as plt
import matplotlib as mpl
import pickle

from source_code.model_class import ModelSetup

# Main function

def main(iters):
    # random.seed(123)
    population = pd.read_csv('input//simulated_population.csv')
    vienna_housing_map = gpd.read_file('input//vienna_houses//vienna_social_houses_distances.shp')
    config = configparser.ConfigParser()
    config.read(r'settings.ini')
    # args = parse_args()
    start_year = config.getint('default', 'start_year')
    end_year = config.getint('default', 'end_year')
    seed = config.get('default', 'seed')
    # Adjust year with -1 since in every step year is first
    # increased by 1
    timeline = list(range(end_year - (start_year - 1)))
    scenario = config.get('default', 'scenario')
    learning = config.get('default', 'learning') 
    district_infra_fn = config.get('default', 'infra_scenario') 
    district_infra = pd.read_csv('input//vienna_district_infra__{}.csv'.format(district_infra_fn))
    policy = config.get('default', 'policy')
    if policy == 'Zoning':
        zoning_plan = pd.read_csv('input//vienna_zoning.csv')
    else:
        zoning_plan = 'No'
    if policy == 'Campaign':
        campaign_cluster = [int(cl) for cl in config.get('default', 'campaign_cluster').replace(" ", "").split(',')]
        campaign_years = [int(age) for age in config.get('default', 'campaign_years').replace(" ", "").split(',')]
    else:
        campaign_cluster = [-1]
        campaign_years = [0]
    # Import coefficients
    coef_fn = os.listdir('output/coefficients')
    coefs = {}
    for fn in coef_fn:
        var = fn.split('__')
        if 'coefficients' in var[1]:
            c = pd.read_csv('input/coefficients/' + fn, index_col = 0)
            c = c['Coef.']
            if 'car' in var[0]:
                if c['bikelane'] > 0:
                    c['bikelane'] = 0
                if c['pedestz'] > 0:
                    c['pedestz'] = 0
                # if c['park'] > 0:
                #     c['park'] = 0
            if 'bike' in var[0]:
                if c['bikelane'] <= 0.6:
                    c['bikelane'] = 0.6
                if c['pedestz'] < 0:
                    c['pedestz'] = 0
                # if c['park'] < 0:
                #     c['park'] = 0
            if 'walk' in var[0]:
                if c['bikelane'] < 0:
                    c['bikelane'] = 0
                if c['pedestz'] < 0:
                    c['pedestz'] = 0
                # if c['park'] < 0:
                #     c['park'] = 0
            # if 'pt' in var[0]:
            #     if c['bikelane'] < 0:
            #         c['bikelane'] = 0
            #     if c['pedestz'] < 0:
            #         c['pedestz'] = 0
            #     if c['park'] < 0:
            #         c['park'] = 0
            coefs[var[0]] = c
            
    # coef_df = pd.DataFrame(coefs)
    # cols = ['bike_leisure',
    #   'bike_services',
    #   'bike_work',
    #   'car_leisure',
    #   'car_services',
    #   'car_work',
    #   'pt_leisure',
    #   'pt_services',
    #   'pt_work',
    #   'walk_leisure',
    #   'walk_services',
    #   'walk_work']
    # coef_df = coef_df[cols]
    
    print("-----------------------------------------")
    print("Initiate BENCH-Mobility model run")
        
    for district_infra_fn in ['innerestadt2060']:
    # for district_infra_fn in ['baseline', 'innerestadt2060', 'innerestadtearly2060', 'innerestadt2050']:
        district_infra = pd.read_csv('input//vienna_district_infra__{}.csv'.format(district_infra_fn))
        for learning in ['Peers']:
        # for learning in ['No', 'Neighbour', 'Peers']:
            # for policy in ['No']:
            for policy in ['No']:

                scen = district_infra_fn + '_' + learning + '_' + policy

                
                print('--------------------------------------')
                print('')
                print('{0} infrastructure, {1} learning, {2} policy'.format(district_infra_fn, learning, policy))
                print('')
                print('--------------------------------------')
        
                if policy == 'Zoning':
                    zoning_plan = pd.read_csv('input//vienna_zoning.csv')
                else:
                    zoning_plan = 'No'
                if policy == 'Campaign':
                    campaign_cluster = [int(cl) for cl in config.get('default', 'campaign_cluster').replace(" ", "").split(',')]
                    campaign_years = [int(age) for age in config.get('default', 'campaign_years').replace(" ", "").split(',')]
                else:
                    campaign_cluster = [-1]
                    campaign_years = [0]
        
                if learning == 'No':
                    scenario_name = scenario + '_wo_l'
                if learning == 'Neighbour':
                    scenario_name = scenario + '_w_nl'
                if learning == 'Peers':
                    scenario_name = scenario + '_w_pl'
                    
                    
                results = {}

                for i in range(iters):
                    print('------------')
                    print("Model iteration: {0} / {1}".format(i + 1, iters))
                        
                    model = ModelSetup(
                        population,
                        vienna_housing_map,
                        coefs = coefs,
                        district_infra = district_infra,
                        start_year = start_year,
                        simulation_start = config.getint('default', 'simulation_start'),
                        num_agents = config.getint('default', 'num_agents'),
                        num_peers = config.getint('default', 'num_peers'),
                        case_study = config.get('default', 'case_study'),
                        scenario = scenario_name,
                        data = config.get('default', 'data'),
                        learning = learning,
                        map_update = config.get('default', 'map_update'),
                        policy = policy,
                        campaign_cluster = campaign_cluster,
                        campaign_years = campaign_years,
                        zoning_plan = zoning_plan,
                        seed = seed,
                        iteration = i
                    )
                    

                    for _ in timeline:  # Simulate
                        model.step()
            
                    results[i] = model.agent_dict
                
                with open('output/results_peers4_{}.pickle'.format(scen), 'wb') as handle:
                    pickle.dump(results, handle)
                print('Model results are saved to a pickle file.')

    return results


# Run
if __name__ == "__main__":
    results = main(10)
    
# results = {}
# for file in os.listdir('output'):
#     if ('pickle' in file) and ('v1' in file):
#         scenario = file.replace('results_v2_', '').split('.')[0]
#         if scenario not in results.keys():
#             print(scenario)
#             with open(os.path.join('output', file), 'rb') as handle:
#                 results[scenario] = pickle.load(handle)


# for scen, model in results.items():
#     if 'Peers' in scen:
#         model = model[2040]
#         for c, c_agents in model.cluster_dict.items():
            
#             if c == 0:
#                 active_share_dict = {i: model.agents[j].mode_shares['bike'] + model.agents[j].mode_shares['walk'] for i, j in enumerate(model.cluster_dict[c])}
#                 income_dict = {i: model.agents[j].income for i, j in enumerate( model.cluster_dict[c])}
#                 consider_dict = {i: (1 if model.agents[j].cons == 'H' else 0) for i, j in enumerate( model.cluster_dict[c])}
#                 pbc_dict = {i: model.agents[j].pbc for i, j in enumerate( model.cluster_dict[c])}
#                 sn_dict = {i: model.agents[j].sn for i, j in enumerate( model.cluster_dict[c])}
    
#                 G = model.network[c]
                
#                 nx.set_node_attributes(G, active_share_dict, "active_share")
#                 nx.set_node_attributes(G, consider_dict, "consideration")
#                 nx.set_node_attributes(G, income_dict, "income")
#                 nx.set_node_attributes(G, pbc_dict, "pbc")
#                 nx.set_node_attributes(G, sn_dict, "sn")
    
#                 pos = nx.spring_layout(G, seed=1, k = 1/np.sqrt(len(active_share_dict)))
#                 # pos = nx.circular_layout(G)
            
#                 active_share = [G.nodes[n]['active_share'] for n in G.nodes()]
#                 consideration = [G.nodes[n]['consideration'] for n in G.nodes()]
#                 pbc = [G.nodes[n]['pbc'] for n in G.nodes()]
#                 sn = [G.nodes[n]['sn'] for n in G.nodes()]
    
#                 color = active_share
#                 # sizes = [0.005 * G.nodes[n]['income'] + 10 for n in G.nodes()]
            
                
#                 fig, ax = plt.subplots(figsize=(18, 10))
                
#                 # Draw on the explicit axis
#                 nodes = nx.draw(
#                     G, pos,
#                     node_size=100,
#                     node_color=color,
#                     cmap='viridis',
#                     edge_color='gray',
#                     width=0.3,
#                     alpha=0.8,
#                     ax=ax
#                 )
                
#                 # Create a ScalarMappable with a fixed vmin=1
#                 norm = mpl.colors.Normalize(vmin=2, vmax=5)  # vmax can be max of your data
#                 sm = plt.cm.ScalarMappable(cmap='viridis', norm=norm)
#                 sm.set_array([])  # required for colorbar
                
#                 # Add colorbar
#                 cbar = fig.colorbar(sm, ax=ax)
#                 cbar.set_label("Share of trips using active mobility", fontsize=16)
#                 cbar.ax.tick_params(labelsize=14)

                
#                 ax.set_title("Active Mobility Share in Cluster {0} in scenario {1}".format(c, scen),
#                               fontsize=20,
#                               pad=20)
#                 ax.set_axis_off()
                
#                 plt.show()

