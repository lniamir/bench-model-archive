# -*- coding: utf-8 -*-
"""
Created on Wed Nov 19 10:04:48 2025

@author: hartvig
"""


import pandas as pd
import numpy as np
import geopandas as gpd



def update_map(year, agents):

    print('Update map')
    fn = 'input//vienna_houses//vienna_social_houses_distances_' + str(year) + '.shp'
    # New housing map
    vienna_housing_map = gpd.read_file(fn)
    distance_cols = ['bike_dist', 'green_dist', 'hike_dist', 'resid_dist', 'slow_dist']
    facility_cols = ['bike_bool', 'green_bool', 'hike_bool', 'resid_bool', 'slow_bool']
    housing_distances = vienna_housing_map[distance_cols]
    housing_facilities = vienna_housing_map[facility_cols]
    # Update agents
    for agent in agents:
        # New facilities
        facilities = housing_facilities.loc[agent.house_id].to_dict(orient = 'list')
        # Increase motivation if facility is not available near the agent
        # print(facilities['green_bool'][0],agent.facilities['green_bool'][0]) 
        # print((facilities['green_bool'][0] > 0))
        # print((agent.facilities['green_bool'][0] < 1))
        if (facilities['bike_bool'][0] > 0) and (agent.facilities['bike_bool'][0] < 1):
            if agent.pn < 4.5:
                agent.pn_ch += 0.7
                agent.pn += agent.pn_ch
            if agent.pbc < 4.5:
                agent.pbc_ch += 0.7
                agent.pbc += agent.pbc_ch
        if (facilities['hike_bool'][0] > 0) and (agent.facilities['hike_bool'][0] < 1):
            if agent.kn_aw < 4.5:
                agent.kn_aw_ch += 0.7
                agent.kn_aw += agent.kn_aw_ch
        if (facilities['resid_bool'][0] > 0) and (agent.facilities['resid_bool'][0] < 1):
            if agent.pn < 4:
                agent.pn_ch += 0.9
                agent.pn += agent.pn_ch
            if agent.pbc < 4.5:
                agent.pbc_ch += 0.7
                agent.pbc += agent.pbc_ch
        if (facilities['green_bool'][0] > 0) and (agent.facilities['green_bool'][0] < 1):
            if agent.kn_aw < 4.5:
                agent.kn_aw_ch += 0.5
                agent.kn_aw += agent.kn_aw_ch
            if agent.pbc < 4.5:
                agent.pbc_ch += 0.7
                agent.pbc += agent.pbc_ch
                
        # Update houseing characteristics to agent (distances from facilities)
        distances = housing_distances.loc[agent.house_id].to_dict(orient = 'list').copy()
        facilities = facilities.copy()
    
    return distances, facilities
    # # Load new map in 2035
    # if self.year == 2035:
    #      # Housing map in 2035
    #     vienna_housing_map = gpd.read_file('input//vienna_houses//vienna_social_houses_distances_2035_3_4_5_10_bezirk.shp')
    #     distances = ['bike_dist', 'green_dist', 'hike_dist', 'resid_dist', 'slow_dist']
    #     facilities = ['bike_bool', 'green_bool', 'hike_bool', 'resid_bool', 'slow_bool']
    #     housing_distances = vienna_housing_map[distances]
    #     housing_facilities = vienna_housing_map[facilities]
    #     # Update agents
    #     for agent in self.agents:
    #         # New facilities
    #         facilities = housing_facilities.loc[agent.house_id].to_dict(orient = 'list')
    #         # Increase perceived behaviour if facility is not available near the agent
    #         if agent.pbc < 4.6 and agent.facilities['bike_bool'][0] == 0 and facilities['bike_bool'][0] == 1:
    #             agent.pbc += agent.pbc * 0.1
    #         if agent.pbc < 4.6 and agent.facilities['green_bool'][0] == 0 and facilities['green_bool'][0] == 1:
    #             agent.pbc += agent.pbc * 0.1
    #         if agent.pbc < 4.6 and agent.facilities['slow_bool'][0] == 0 and facilities['slow_bool'][0] == 1:
    #             agent.pbc += agent.pbc * 0.1
    #         if agent.pbc < 4.6 and agent.facilities['hike_bool'][0] == 0 and facilities['hike_bool'][0] == 1:
    #             agent.pbc += agent.pbc * 0.1
    #         if agent.pbc < 4.6 and agent.facilities['resid_bool'][0] == 0 and facilities['resid_bool'][0] == 1:
    #             agent.pbc += agent.pbc * 0.1
    #         # Update houseing characteristics to agent (distances from facilities)
    #         agent.distances = housing_distances.loc[agent.house_id].to_dict(orient = 'list')
    #         agent.facilities = facilities


    # print("Housing information updated.")