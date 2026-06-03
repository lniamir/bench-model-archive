# -*- coding: utf-8 -*-
"""
Created on Wed Jul 30 13:09:21 2025

@author: hartvig
"""


import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import statsmodels.api as sm
import statsmodels.formula.api as smf
import os
import time
import datetime
# 1. Load the dataset
df = pd.read_csv('input/survey_encoded.csv', index_col = 0)
df.index = pd.to_datetime(df.index, format = "%d/%m/%Y %H:%M:%S")

# 2. Drop unrealistic observations with eyeballing
df = df.drop(['2025-06-27 16:46:16',
              '2025-06-04 10:49:31',
              '2025-06-04 21:38:28',
              '2025-06-04 17:38:44',
              '2025-06-13 22:12:50',
              '2025-07-14 10:48:32',
              '2025-07-10 15:32:55',
              '2025-07-10 14:55:37'], axis = 0)

# Filter on Vienna
df = df.loc[df.city == 1, :]

# 3. Correct trip modes
# Many respondents seemingly answered to the trip questions by listing all
# transportation modes that they might use to the given destination
# This is the most obvious in the leisure related questions
# Therefore, responses are cleaned as such if the respondents use any type of car
# then the length for bicycle and scooter is set to 0 and walking is limited to 10 minutes
cars = ['ice', 'ev', 'taxi', 'carsh', 'motor']
bikes = ['bike', 'ebike', 'bikesh']
scooters = ['scooter', 'scootersh']
duration_cols = {}
duration_cols['work'] = [col for col in df.columns if 'duration_work' in col]
duration_cols['services'] = [col for col in df.columns if 'duration_services' in col]
duration_cols['leisure'] = [col for col in df.columns if 'duration_leisure' in col]

# Clean work, services and leisure separately
clean_dict = {}
for d in ['work', 'services', 'leisure']:
    df_dest = df.copy()
    cars_cols = ['duration_' + d + '_' + c for c in cars]
    df_dest['cars_avg'] = df_dest[cars_cols].sum(axis = 1).div((df_dest[cars_cols] > 0).sum(axis = 1)).fillna(0)
    bikes_cols = ['duration_' + d + '_' + c for c in bikes]
    df_dest['bike_avg'] = df_dest[bikes_cols].sum(axis = 1).div((df_dest[bikes_cols] > 0).sum(axis = 1)).fillna(0)
    df_dest.loc[df_dest['cars_avg'] > 0, 'bike_avg'] = 0
    scooters_cols = ['duration_' + d + '_' + c for c in scooters]
    df_dest['scooters_avg'] = df_dest[scooters_cols].sum(axis = 1).div((df_dest[scooters_cols] > 0).sum(axis = 1)).fillna(0)
    df_dest.loc[df_dest['cars_avg'] > 0, 'scooters_avg'] = 0
    df_dest.loc[df_dest['cars_avg'] > 0, 'bike_avg'] = 0
    df_dest['pt'] = df_dest['duration_' + d + '_pt']
    df_dest.loc[df_dest['cars_avg'] > 0, 'pt'] = 0
    df_dest['walk'] = df_dest['duration_' + d + '_walk']
    df_dest.loc[df_dest['cars_avg'] > 0, 'walk'] = 0
    # Remove cases where respondent walk, cycle, or scooter more than an hour
    df_dest = df_dest.loc[df_dest['walk'] < 60, :]
    df_dest = df_dest.loc[df_dest['bike_avg'] < 60, :]
    df_dest = df_dest.loc[df_dest['scooters_avg'] < 60, :]
    
    avg_cols = ['cars_avg', 'bike_avg', 'walk', 'pt', 'scooters_avg']
    df_dest['tot_work_trip'] = (df_dest[avg_cols].sum(axis = 1))
    # Remove where total work trip is longer than 70 minutes
    df_dest = df_dest.loc[df_dest['tot_work_trip'] < 71, :]
    
    # Limit frequency to 5
    df_dest.loc[df['freq_work'] > 5, 'freq_work'] = 5
    df_dest['tot_work_per_day'] = (df_dest['freq_work'] * df_dest[avg_cols].sum(axis = 1)) / 7 * 2

    clean_dict[d] = df_dest
    