# -*- coding: utf-8 -*-
"""
Created on Mon Aug  4 09:09:24 2025

@author: hartvig
"""

# -*- coding: utf-8 -*-
'''
Created on Wed Jul  2 13:26:24 2025

@author: hartv
'''


import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import statsmodels.api as sm
import statsmodels.formula.api as smf
import os
import time
import datetime
from scipy.stats import lognorm

# 1. Load the dataset
df = pd.read_excel('../../input/survey_encoded_reviewed.xlsx', index_col = 0)
# df.index = pd.to_datetime(df.index, format = "%d/%m/%Y %H:%M:%S.%f")
street_index = pd.read_excel('../../data/streets_facilities.xlsx', index_col = 0)
district_infra = pd.read_csv('../../data/vienna_district_densities.csv')
district_infra['pedestz_density'] = district_infra['pedestz_density'] + district_infra['residz_density']
district_infra = district_infra.rename(columns = {'lane_density_km_per_km2': 'bikelane',
                                                  'pedestz_density': 'pedestz',
                                                  'park_density': 'park'})



list(set(df.index) & set(street_index.index))
# 2. Filter on Vienna and remove responses with bad quality
df = df.loc[df.city == 1, :]
df = df.loc[df.quality_tag >= 0, :]

# 3. Assess used trip moes by destination
# Create columns showing whether te main modes are used or not by the respondent
# Assess work, services and leisure separately

cars = ['ice', 'ev', 'taxi', 'carsh', 'motor']
bikes = ['bike', 'ebike', 'bikesh']
scooters = ['scooter', 'scootersh']
duration_cols = {}
duration_cols['work'] = [col for col in df.columns if 'duration_work' in col]
duration_cols['services'] = [col for col in df.columns if 'duration_services' in col]
duration_cols['leisure'] = [col for col in df.columns if 'duration_leisure' in col]
cars = ['ice', 'ev', 'taxi', 'carsh', 'motor']
bikes = ['bike', 'ebike', 'bikesh']
scooters = ['scooter', 'scootersh']

# Clean work, services and leisure separately
for d in ['work', 'services', 'leisure']:
    cars_cols = ['duration_' + d + '_' + c for c in cars]
    df[d + '_car'] = df[cars_cols].sum(axis = 1).div((df[cars_cols] > 0).sum(axis = 1)).fillna(0)
    df[d + '_car_use'] = (df[d + '_car'] > 0).astype(int)
    bikes_cols = ['duration_' + d + '_' + c for c in bikes]
    df[d + '_bike'] = df[bikes_cols].sum(axis = 1).div((df[bikes_cols] > 0).sum(axis = 1)).fillna(0)
    df[d + '_bike_use'] = (df[d + '_bike'] > 0).astype(int)

    scooters_cols = ['duration_' + d + '_' + c for c in scooters]
    df[d + '_scooters'] = df[scooters_cols].sum(axis = 1).div((df[scooters_cols] > 0).sum(axis = 1)).fillna(0)
    df[d + '_scooter_use'] = (df[d + '_scooters'] > 0).astype(int)

    df[d + '_pt'] = df['duration_' + d + '_pt']
    df[d + '_pt_use'] = (df[d + '_pt'] > 0).astype(int)

    df[d + '_walk'] = df['duration_' + d + '_walk']
    df[d + '_walk_use'] = (df[d + '_walk'] > 0).astype(int)
    
    avg_cols = [d + '_car', d + '_bike', d + '_walk', d + '_pt', d + '_scooters']
    df[d + '_total_trip'] = (df[avg_cols].sum(axis = 1))
    # Remove where total work trip is longer than 70 minutes
    # df = df.loc[df['tot_work_trip'] < 71, :]
    
    # Limit frequency to 5
    df.loc[df['freq_work'] > 5, 'freq_work'] = 5
    df['tot_work_per_day'] = (df['freq_work'] * df[avg_cols].sum(axis = 1)) / 7 * 2


    # Active mobility
    df[d + '_walk_total'] = (df['freq_' + d] * df[d + '_walk'])
    df[d + '_bike_total'] = (df['freq_' + d] * df[d + '_bike'])
    df[d + '_active_total'] = (df[d + '_walk_total'] + df[d + '_bike_total'])
    

# Match street index with response
df = df.join(street_index, rsuffix = '_')
district_infra = district_infra.rename(columns = {'BEZNR': 'vienna_district'})
district_infra = district_infra.fillna(0)

df = df.merge(district_infra, on="vienna_district", how="left")

# Add attitude averages

attitude = ['kn_env_climate', 'kn_env_action', 'kn_subj_car', 'kn_actm_air', 
    'kn_actm_health', 'aw_env_climate', 'aw_env_future', 'aw_subj_ecotrans', 
    'aw_subj_transmode', 'kn_subj_exercise', 'kn_health_air', 'kn_health_warnings', 
    'pn_eco_climate', 'pn_eco_nature', 'pn_eco_protect', 'pn_health_activity', 
    'pn_health_lifestlye', 'pn_health_wellbeing', 'pn_general_social', 'pn_general_urbanenv', 
    'sn_peers', 'sn_community', 'sn_friends', 'sn_colleagues', 
    'sn_neighbors', 'sn_city', 'pn_time_traffic', 'pbc_shared', 
    'pbc_info', 'pbc_safety', 'pbc_affordable', 'pbc_prioritization', 
    'pbc_community', 'pbc_green', 'pbc_air']

####### Knowledge
kn = ["kn_env_climate", "kn_env_action", "kn_subj_car", "kn_actm_air",
 "kn_actm_health", "kn_subj_exercise", "kn_health_air", "kn_health_warnings"]
df['kn'] = (df[kn] / len(kn)).sum(axis = 1)
####### Awareness
aw = ["aw_env_climate", "aw_env_future", "aw_subj_ecotrans", "aw_subj_transmode"]
df['aw'] = (df[aw] / len(aw)).sum(axis = 1)
####### Personal norm
pn = ["pn_eco_climate", "pn_eco_nature", "pn_eco_protect", "pn_health_activity",
 "pn_health_lifestlye", "pn_health_wellbeing", "pn_general_social", "pn_general_urbanenv",
 "pn_time_traffic"]
df['pn'] = (df[pn] / len(pn)).sum(axis = 1)
####### Social norm
sn = ["sn_peers", "sn_community", "sn_friends",
 "sn_colleagues", "sn_neighbors", "sn_city"]
df['sn'] = (df[sn] / len(sn)).sum(axis = 1)
####### PBC
pbc = ["pbc_shared", "pbc_info", "pbc_safety", "pbc_affordable",
 "pbc_prioritization", "pbc_community", "pbc_green", "pbc_air"]
df['pbc'] = (df[pbc] / len(pbc)).sum(axis = 1)



######################################################
######## Build lin. reg. models for attitudes ########
######################################################

# Frequency to go to work
for d in ['work', 'services', 'leisure']:
    y = df['freq_' + d]  # Convert to numeric codes
    # X = df[['gender', 'age', 'income', 'bike_dist', 'green_dist', 'slow_dist']].dropna()
    X = df[['gender', 'age', 'income']].dropna()

    y = y.loc[X.index]
    
    X = sm.add_constant(X)
    
    # Fit model
    model = sm.OLS(y, X)
    results = model.fit()
    
    # Get the coefficient table as DataFrame
    coeff_table = results.summary2().tables[1]
    coeff_table['Resid.Std.']= (sum(results.resid ** 2) / results.df_resid) ** 0.5
    
    # Summary
    print(results.summary())
    print('Std. of residuals: {}'.format(round((sum(results.resid ** 2) / results.df_resid) ** 0.5, 3)))
    coeff_table['Avg.']= y.mean()
    
    # Export to CSV
    coeff_table.to_csv("../../output/coefficients/freq_" + d + "__coefficients.csv")



# Knowledge and awareness
df['kn_aw'] = (df['kn'] + df['aw']) / 2
y = df['kn_aw']  # Convert to numeric codes
X = df[['gender', 'age', 'income']].dropna()
# X = df[['gender', 'age', 'income', 'bike_bool', 'green_bool', 'hike_bool', 'resid_bool',
#        'slow_bool']].dropna()
y = y.loc[X.index]

X = sm.add_constant(X)

# Fit model
model = sm.OLS(y, X)
results = model.fit()

# Get the coefficient table as DataFrame
coeff_table = results.summary2().tables[1]
coeff_table['Resid.Std.']= (sum(results.resid ** 2) / results.df_resid) ** 0.5

# Summary
print('-------------------------------------------------')
print('Knowledge and awareness')
print(results.summary())
print('Std. of residuals: {}'.format(round((sum(results.resid ** 2) / results.df_resid) ** 0.5, 3)))
coeff_table['Avg.']= y.mean()

# Export to CSV
coeff_table.to_csv("../../output/coefficients/kn_aw__coefficients.csv")


# Social norm
y = df['sn']  # Convert to numeric codes
# X = df[['gender', 'income', 'bike_bool', 'green_bool', 'hike_bool', 'resid_bool',
#        'slow_bool']].dropna()
X = df[['gender', 'income']].dropna()
y = y.loc[X.index]

X = sm.add_constant(X)

# Fit model
model = sm.OLS(y, X)
results = model.fit()

# Get the coefficient table as DataFrame
coeff_table = results.summary2().tables[1]
coeff_table['Resid.Std.']= (sum(results.resid ** 2) / results.df_resid) ** 0.5
coeff_table['Avg.']= y.mean()

# Summary
print('-------------------------------------------------')
print('Social norm')
print(results.summary())
print('Std. of residuals: {}'.format(round((sum(results.resid ** 2) / results.df_resid) ** 0.5, 3)))
# Export to CSV
coeff_table.to_csv("../../output/coefficients/sn__coefficients.csv")


# Personal norm
y = df['pn']  # Convert to numeric codes
# X = df[['kn_aw', 'sn', 'bike_bool', 'green_bool', 'hike_bool', 'resid_bool',
#        'slow_bool']].dropna()
X = df[['kn_aw', 'sn']].dropna()
y = y.loc[X.index]

X = sm.add_constant(X)

# Fit model
model = sm.OLS(y, X)
results = model.fit()

# Get the coefficient table as DataFrame
coeff_table = results.summary2().tables[1]
coeff_table['Resid.Std.']= (sum(results.resid ** 2) / results.df_resid) ** 0.5
coeff_table['Avg.']= y.mean()

# Summary
print('-------------------------------------------------')
print('Personal norm')
print(results.summary())
print('Std. of residuals: {}'.format(round((sum(results.resid ** 2) / results.df_resid) ** 0.5, 3)))

# Export to CSV
coeff_table.to_csv("../../output/coefficients/pn__coefficients.csv")


# PBC
y = df['pbc']  # Convert to numeric codes

# X = df[['pn', 'bike_bool', 'green_bool', 'hike_bool', 'resid_bool',
#        'slow_bool']].dropna()
X = df[['pn']].dropna()
y = y.loc[X.index]


X = sm.add_constant(X)

# Fit model
model = sm.OLS(y, X)
results = model.fit()

# Get the coefficient table as DataFrame
coeff_table = results.summary2().tables[1]
coeff_table['Resid.Std.']= (sum(results.resid ** 2) / results.df_resid) ** 0.5
coeff_table['Avg.']= y.mean()

# Summary
print('-------------------------------------------------')
print('PBC')
print(results.summary())
print('Std. of residuals: {}'.format(round((sum(results.resid ** 2) / results.df_resid) ** 0.5, 3)))

# Export to CSV
coeff_table.to_csv("../../output/coefficients/pbc__coefficients.csv")



##############################################
######## Build logit models for modes ########
##############################################

# Calculate priori probability fro survey
for mode in ['car', 'bike', 'walk', 'pt']:    
    
    dest_cols = [d + '_' + mode + '_use' for d in ['work', 'services', 'leisure']]
    
    print(df[dest_cols].mean())


for d in ['work', 'services', 'leisure']:
    print('##############################################')
    print('##############################################')
    print( '########## {} ##########'.format(d))
    print('##############################################')
    print('##############################################')


    # Cars
    print('----------------------------')
    print('Cars')
    print('----------------------------')

    # Define independent variables and add constant
    # x_vars = ['pbc', 'gender', 'age', 'income', 'freq_' + d]
    x_vars = ['pbc', 'gender', 'age', 'income', 'freq_' + d]

    # x_vars = ['pbc', 'gender', 'age', 'income', 'freq_' + d, 'bike_bool', 'green_bool', 'hike_bool', 'slow_bool']
    X = df[x_vars].dropna()
    # dummies = pd.get_dummies(df['household'], prefix='household', drop_first=True).astype(float)
    # X = pd.concat([X, dummies], axis=1)
    # dummies = pd.get_dummies(df['employment'], prefix='employment', drop_first=True).astype(float)
    # X = pd.concat([X, dummies], axis=1).dropna()
    # dummies = pd.get_dummies(df['education'], prefix='education', drop_first=True).astype(float)
    # X = pd.concat([X, dummies], axis=1).dropna()
    X = sm.add_constant(X)  # adds the intercept
    
    # Weight observations so car use matches city wide data (25%)
    p_target = 0.25  # true share in population
    p_sample = df[d + '_car_use'].mean()  # observed share in your sample
    
    # Weighting to match target
    df['weight'] = df[d + '_car_use'].apply(lambda x: p_target / p_sample if x == 1 else (1 - p_target) / (1 - p_sample))
    
    y_var = d + '_car_use'
    y = df.loc[X.index, y_var]
    weights = df.loc[X.index,'weight']
    
    
    # Fit logit model
    model = sm.Logit(y, X)
    result = model.fit(weights=weights,
                       cov_type="cluster",
                       cov_kwds={"groups": X.index})
    

    # Get the coefficient table as DataFrame
    coeff_table = result.summary2().tables[1]
    # coeff_table['Resid.Std.']= (sum(result.resid ** 2) / result.df_resid) ** 0.5
    # coeff_table['Avg.']= y.mean()
    # Set coefficients where p value > 0.2 to 0
    coeff_table.loc[(coeff_table['P>|z|'] > 0.2) & (coeff_table.index != 'const'), 'Coef.'] = 0
    # Summary
    print(result.summary())
    # Export to CSV
    coeff_table.to_csv("../../output/coefficients/car_" + d + "__coefficients.csv")
    
    print('----------------------------')
    print('Bikes')
    print('----------------------------')

    # Bike
    # Define independent variables and add constant
    X = df[x_vars].dropna()
    # dummies = pd.get_dummies(df['household'], prefix='household', drop_first=True).astype(float)
    # X = pd.concat([X, dummies], axis=1)
    # dummies = pd.get_dummies(df['employment'], prefix='employment', drop_first=True).astype(float)
    # X = pd.concat([X, dummies], axis=1).dropna()
    # dummies = pd.get_dummies(df['education'], prefix='education', drop_first=True).astype(float)
    # X = pd.concat([X, dummies], axis=1).dropna()
    X = sm.add_constant(X)  # adds the intercept
    
    # Weight observations so bike use matches city wide data (10%)
    p_target = 0.11  # true share in population
    p_sample = df[d + '_bike_use'].mean()  # observed share in your sample
    
    # Weighting to match target
    df['weight'] = df[d + '_bike_use'].apply(lambda x: p_target / p_sample if x == 1 else (1 - p_target) / (1 - p_sample))
    
    y = df.loc[X.index, d + '_bike_use']
    weights = df.loc[X.index,'weight']
    
    # Fit logit model
    model = sm.Logit(y, X)
    result = model.fit(weights=weights,
                       cov_type="cluster",
                       cov_kwds={"groups": X.index})    

    # Get the coefficient table as DataFrame
    coeff_table = result.summary2().tables[1]
    # coeff_table['Resid.Std.']= (sum(result.resid ** 2) / result.df_resid) ** 0.5
    # coeff_table['Avg.']= y.mean()
    # Set coefficients where p value > 0.2 to 0
    coeff_table.loc[(coeff_table['P>|z|'] > 0.2) & (coeff_table.index != 'const'), 'Coef.'] = 0
    # Summary
    print(result.summary())
    # Export to CSV
    coeff_table.to_csv("../../output/coefficients/bike_" + d + "__coefficients.csv")
    
    
    print('----------------------------')
    print('Walk')
    print('----------------------------')

    # Walk
    # Define independent variables and add constant
    X = df[x_vars].dropna()
    # dummies = pd.get_dummies(df['household'], prefix='household', drop_first=True).astype(float)
    # X = pd.concat([X, dummies], axis=1)
    # dummies = pd.get_dummies(df['employment'], prefix='employment', drop_first=True).astype(float)
    # X = pd.concat([X, dummies], axis=1).dropna()
    # dummies = pd.get_dummies(df['education'], prefix='education', drop_first=True).astype(float)
    # X = pd.concat([X, dummies], axis=1).dropna()
    X = sm.add_constant(X)  # adds the intercept
    # Weight observations so walk use matches city wide data (30%)
    p_target = 0.3  # true share in population
    p_sample = df[d + '_walk_use'].mean()  # observed share in your sample
    
    # Weighting to match target
    df['weight'] = df[d + '_walk_use'].apply(lambda x: p_target / p_sample if x == 1 else (1 - p_target) / (1 - p_sample))
    
    y = df.loc[X.index, d + '_walk_use']
    weights = df.loc[X.index,'weight']
    
    # Fit logit model
    model = sm.Logit(y, X)
    result = model.fit(weights=weights,
                       cov_type="cluster",
                       cov_kwds={"groups": X.index})    

    # Get the coefficient table as DataFrame
    coeff_table = result.summary2().tables[1]
    # coeff_table['Resid.Std.']= (sum(result.resid ** 2) / result.df_resid) ** 0.5
    # coeff_table['Avg.']= y.mean()
    # Set coefficients where p value > 0.2 to 0
    coeff_table.loc[(coeff_table['P>|z|'] > 0.2) & (coeff_table.index != 'const'), 'Coef.'] = 0
    # Summary
    print(result.summary())
    # Export to CSV
    coeff_table.to_csv("../../output/coefficients/walk_" + d + "__coefficients.csv")
    
    print('----------------------------')
    print('Public transport')
    print('----------------------------')

    # Public transport
    # Define independent variables and add constant
    X = df[x_vars].dropna()
    # dummies = pd.get_dummies(df['household'], prefix='household', drop_first=True).astype(float)
    # X = pd.concat([X, dummies], axis=1)
    # dummies = pd.get_dummies(df['employment'], prefix='employment', drop_first=True).astype(float)
    # X = pd.concat([X, dummies], axis=1).dropna()
    # dummies = pd.get_dummies(df['education'], prefix='education', drop_first=True).astype(float)
    # X = pd.concat([X, dummies], axis=1).dropna()
    X = sm.add_constant(X)  # adds the intercept
    
    p_target = 0.34  # true share in population
    p_sample = df[d + '_pt_use'].mean()  # observed share in your sample
    
    # Weighting to match target
    df['weight'] = df[d + '_pt_use'].apply(lambda x: p_target / p_sample if x == 1 else (1 - p_target) / (1 - p_sample))
    
    y = df.loc[X.index, d + '_pt_use']
    weights = df.loc[X.index,'weight']
    
    # Fit logit model
    model = sm.Logit(y, X)
    result = model.fit(weights=weights,
                       cov_type="cluster",
                       cov_kwds={"groups": X.index})    

    # Get the coefficient table as DataFrame
    coeff_table = result.summary2().tables[1]
    # coeff_table['Resid.Std.']= (sum(result.resid ** 2) / result.df_resid) ** 0.5
    # coeff_table['Avg.']= y.mean()
    # Set coefficients where p value > 0.2 to 0
    coeff_table.loc[(coeff_table['P>|z|'] > 0.25) & (coeff_table.index != 'const'), 'Coef.'] = 0
    # Summary
    print(result.summary())
    # Export to CSV
    coeff_table.to_csv("../../output/coefficients/pt_" + d + "__coefficients.csv")

##################################################
######## Get distribution of trip lengths ########
##################################################

from scipy.stats import gaussian_kde

# Compute the KDE manually
for mode in ['car', 'bike', 'walk', 'pt']:
    for d in ['work', 'services', 'leisure']:

        data = df[d + '_' + mode].dropna()  # Drop NaNs for KDE
        # Drop values greater than 40 for walking
        # if mode == 'walk':
        #     data = data[data <= 40]
        kde = gaussian_kde(data, bw_method=1)  # bw_adjust=1.5 equivalent
        
        # Create an x-axis range matching the KDE plot
        # if mode == 'walk':
        #     x_vals = np.linspace(data.min(), data.max(), 41)
        # else:
        #     x_vals = np.linspace(data.min(), data.max(), 71)
        x_vals = np.linspace(data.min(), data.max(), 71)
        y_vals = kde(x_vals)  # These are the KDE density values
        
        # Optional: plot to confirm match
        sns.histplot(data, bins=30, color='gray', alpha=0.3, stat='density')
        plt.plot(x_vals, y_vals, color='blue', linewidth=2)
        plt.title('Histogram and KDE of {0} trips for {1}'.format(mode, d))
        plt.show()
        kde_df = pd.DataFrame({'x': x_vals, 'kde_density': y_vals})
        kde_df.to_csv('../../output/coefficients/duration_' + mode + '_' + d + '__kde.csv', index=False)

df['bike_dummy_work'] = np.where(df["duration_work_bike"] > 0, 1, 0)
df['bike_dummy_services'] = np.where(df["duration_services_bike"] > 0, 1, 0)
df['bike_dummy_leisure'] = np.where(df["duration_leisure_bike"] > 0, 1, 0)
df['bike_dummy'] = np.where(df["bike_dummy_work"] + df["bike_dummy_services"] + df["duration_leisure_bike"] > 0, 1, 0)


df.groupby('bike_dummy_work')[['pbc', 'pn', 'sn', 'kn_aw']].mean()
df.groupby('bike_dummy_services')[['pbc', 'pn', 'sn', 'kn_aw']].mean()
df.groupby('bike_dummy_leisure')[['pbc', 'pn', 'sn', 'kn_aw']].mean()
df.groupby('bike_dummy')[['pbc', 'pn', 'sn', 'kn_aw']].mean()
