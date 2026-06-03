# -*- coding: utf-8 -*-
"""
Created on Mon Aug  4 14:39:42 2025

@author: hartvig
"""

import pandas as pd
import numpy as np
import os
import random 


main_folder = os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))

os.chdir(main_folder)

# 1. Load the dataset and converters
# Converters
conv = pd.read_excel('utilities/converters.xlsx', sheet_name = None, index_col = 0)

# Age-gender-income table
age_gender_income = pd.read_csv('data/Equivalised net household income of persons in private households in Austria in 2024 by age and sex (table).csv', 
                                index_col = 0, sep = ";")
age_gender_income.loc['Men 0 to 17 years'] = age_gender_income.loc['0 to 17 years']
age_gender_income.loc['Women 0 to 17 years'] = age_gender_income.loc['0 to 17 years']
age_gender_income = age_gender_income.drop(age_gender_income.columns[0], axis = 1)
age_gender_income = age_gender_income.drop(['Total', '0 to 17 years', '18 to 34 years', '35 to 49 years',
       '50 to 64 years', '65 years +', 'Men (from 18 years)', 'Women (from 18 years)'], axis = 0)

age_gender_income.columns = [col[:4] for col in age_gender_income.columns]
age_gender_income['gender'] = age_gender_income.index.to_series().apply(lambda x: 'female' if 'Women' in x else 'male')
age_gender_income['age'] = age_gender_income.index.str.replace(r'Men |Women | years', '', regex=True)
age_gender_income = age_gender_income.reset_index(drop = True).set_index(['age', 'gender'])
# Household type-income table
household_income =  pd.read_csv('data/Equivalised net household income of persons in private households in Austria in 2024 by household type (table).csv', 
                                index_col = 0, sep = ";")

# Household type-age table
household_age =  pd.read_excel('data/table_2025-08-04_15-14-45.xlsx', 
                                index_col = 0, skiprows = 13, nrows = 9,  usecols= 'C:Q')
household_age = household_age.drop('Household type (Level +1)')
household_age = household_age.drop(['Under 15 years', '15 to 19 years'], axis = 1)
household_age = household_age.replace('-', 0)
household_age = household_age / household_age.sum().sum()
# Household type-age table
age_gender =  pd.read_excel('data/table_2025-08-04_15-29-50.xlsx', 
                                index_col = 0, skiprows = 13, nrows = 4,  usecols= 'C:Q')
age_gender = age_gender.drop('Sex')
age_gender = age_gender.drop(['Up to 14 years old', '15 to 19 years old'], axis = 1)
male_ratio = age_gender.loc['male'].sum() / age_gender.sum().sum()
age_gender = (age_gender.T / age_gender.sum(axis = 1))
age_gender = pd.merge(age_gender, conv['age']['Survey'], left_index=True, right_index=True)
age_gender = age_gender.groupby('Survey').sum()

# Use only the age-gender-income data for simplicity
# Define poulation size
n = 30000
pop = pd.DataFrame(0, columns = ['gender', 'gender_cat', 'age', 'age_cat', 'income'], index = range(n))
# Create the same dataframe populated with random numbers so characteristics will be assigned randomly
pop_rand = pd.DataFrame(np.random.rand(n, 3), columns = ['gender', 'age', 'income'], index = range(n))
# Assign gender
pop['gender_cat'] = pop['gender_cat'].astype('string')
pop.loc[pop_rand['gender'] < male_ratio, 'gender_cat'] = 'male'
pop.loc[pop_rand['gender'] >= male_ratio, 'gender_cat'] = 'female'
pop['gender'] = pop.gender_cat.apply(lambda x: 1 if x == 'male' else 0)
# Assign age
age_gender_cdf = age_gender.cumsum()
# Define a function to assign age based on the random value
def assign_age(r, series):
    age_range = series[series >= r].dropna().index[0]
    if age_range == '71 and above':
        age_limits = [71, 80]
    else:
        age_limits = [int(age) for age in age_range.split('-')]
    return random.randint(age_limits[0], age_limits[1])
    
pop.loc[pop.gender_cat == 'male', 'age'] = pop_rand.loc[pop.gender_cat == 'male', 'age'].apply(assign_age, args=(age_gender_cdf['male'],))
pop.loc[pop.gender_cat == 'female', 'age'] = pop_rand.loc[pop.gender_cat == 'female', 'age'].apply(assign_age, args=(age_gender_cdf['female'],))

def assign_age_category(r, series):
    return series[series >= r].dropna().index[0]

pop['age_cat'] = pop['age_cat'].astype('string')
pop.loc[pop.gender_cat == 'male', 'age_cat'] = pop_rand.loc[pop.gender_cat == 'male', 'age'].apply(assign_age_category, args=(age_gender_cdf['male'],))
pop.loc[pop.gender_cat == 'female', 'age_cat'] = pop_rand.loc[pop.gender_cat == 'female', 'age'].apply(assign_age_category, args=(age_gender_cdf['female'],))

# Assign income
bin_centre1 = {'0 to 17': 17,
               '18 to 34': 26, 
               '35 to 49': 42, 
               '50 to 64': 57,
               '65 +': 70}
bin_centre2 = {'18-24': 21,
               '25-34': 29.5, 
               '35-44': 39.5, 
               '45-54': 49.5, 
               '55-64': 59.5, 
               '65-70': 67.5, 
               '71 and above': 75}


age_gender_income_reclass = {}
for g, df in age_gender_income.groupby('gender'):
    age_gender_income_reclass[g] = pd.DataFrame(0, index = bin_centre2.keys(), columns = age_gender_income.columns)
    df = df.reset_index()
    df = df.drop('gender', axis = 1)
    df['age'] = df['age'].map(bin_centre1)   
    df = df.set_index('age').sort_values(by = 'age')
    for a in pop.age_cat.unique():
        age = bin_centre2[a]
        if age > 70:
            age_gender_income_reclass[g].loc['71 and above'] = df.loc[70]
        else:    
            upper_idx = df.loc[df.index >= age].index[0]
            lower_idx = df.loc[df.index <= age].index[-1]
            upper_dist = 1 - (upper_idx - age) / (upper_idx - lower_idx)
            lower_dist = 1 - (age - lower_idx) / (upper_idx - lower_idx)
            age_gender_income_reclass[g].loc[a] = df.loc[upper_idx] * upper_dist + df.loc[lower_idx] * lower_dist
            
# Define income based on probabilities and new mapping df
def assign_income(r, series):
    upper_limit = series[series >= r].dropna().index[0]
    lower_limit = series[series <= r].dropna().index[-1]
    return random.uniform(lower_limit, upper_limit) / 12

pop['income'] = pop['income'].astype(float)

for a in pop.age_cat.unique():
    for g in ['male', 'female']:
        income_series = age_gender_income_reclass[g].loc[a].copy()
        income_series.name = 'income'
        income_series['0 %'] = 10000.0
        income_series['100 %'] = 70000.0
        income_series = income_series.reset_index()
        income_series['index'] = income_series['index'].str.replace(' %', '').astype(float) / 100
        income_series = income_series.set_index('income').sort_values(by = 'income')

        row_idx = (pop.gender_cat == g) & (pop.age_cat == a)
        pop.loc[row_idx, 'income'] = pop_rand.loc[row_idx, 'income'].apply(assign_income, args=(income_series,))

# Add knowledge, awareness, social norm, personal norm and PBC to agents based on regressions
# Import coefficients
coef_fn = os.listdir('output/coefficients')
coefs = {}
for fn in coef_fn:
    var = fn.split('__')[0]
    coefs[var] = pd.read_csv('output/coefficients/' + fn, index_col = 0)

for var in ['kn_aw', 'sn', 'pn', 'pbc']:
    x = coefs[var].index[1:]
    coef = coefs[var]['Coef.'][1:]
    p_values = coefs[var]['P>|t|'][1:]
    coef[p_values > 0.2] = 0
    c = coefs[var].loc['const', 'Coef.']
    std = coefs[var]['Resid.Std.'].values[0]
    if var == 'kn_aw':
        std = std / 2
    estim = c + (pop[x] * coef).sum(axis = 1)
    avg = coefs[var]['Avg.']['const']
    diff_avg = avg - estim.mean()
    estim_adj = estim + diff_avg
    estim_w_rand = estim + np.random.normal(loc = 0, scale = std, size = n)
    estim_w_rand[estim_w_rand > 5] = 5
    estim_w_rand[estim_w_rand < 1] = 1
    pop[var] = estim_w_rand


for var in ['freq_work', 'freq_leisure', 'freq_services']:
    x = coefs[var].index[1:]
    coef = coefs[var]['Coef.'][1:]
    p_values = coefs[var]['P>|t|'][1:]
    coef[p_values > 0.2] = 0
    c = coefs[var].loc['const', 'Coef.']
    std = coefs[var]['Resid.Std.'].values[0]
    estim = c + (pop[x] * coef).sum(axis = 1)
    estim_w_rand = estim + np.random.normal(loc = 0, scale = std, size = n)
    norm_estim = (estim_w_rand - min(estim_w_rand)) / (max(estim_w_rand) - min(estim_w_rand)) * 5
    pop[var] = round(norm_estim, 0)
    
##############################################################

# Assign transportation mode by destination
# while considering Vienna's overall modal shares
# Mode shares in survey 
usage = pd.DataFrame({
    'car': {
        'work': 0.159574,
        'services': 0.239362,
        'leisure': 0.372340
    },
    'bike': {
        'work': 0.542553,
        'services': 0.537234,
        'leisure': 0.632979
    },
    'walk': {
        'work': 0.728723,
        'services': 0.968085,
        'leisure': 0.914894
    },
    'pt': {
        'work': 0.803191,
        'services': 0.760638,
        'leisure': 0.930851
    }
})
# For each mode, get the fraction of that mode that comes from each trip type
mode_trip_shares = usage.div(usage.sum(axis=0), axis=1)
# source for modal split: https://presse.wien.gv.at/presse/2025/03/16/modal-split-2024-weitere-zunahme-bei-oeffis-und-radfahren-zu-fuss-gehen-nach-wie-vor-auf-rekordniveau
target = pd.Series([0.25, 0.11, 0.3, 0.34], index = mode_trip_shares.columns)
# car, bike, walk, public tr.
# Allocate total modal share by trip type (mode × trip type)
modal_targets_by_trip = mode_trip_shares.multiply(target, axis=1)
    
for dest in ['work', 'leisure', 'services']:
    for mode in ['car', 'bike', 'walk', 'pt']:
        var = mode + '_' + dest
        x = coefs[var].index[1:]
        coef = coefs[var]['Coef.'][1:]
        p_values = coefs[var]['P>|z|'][1:]
        coef[p_values > 0.2] = 0
        c = coefs[var].loc['const', 'Coef.']
        # std = coefs[var]['Resid.Std.'].values[0]
        logit = c + (pop[x] * coef).sum(axis = 1)
        odds = np.exp(logit)
        prob = odds / (1 + odds)
        prob_w_rand = prob + np.random.normal(loc = 0, scale = 0.1, size = n)
        pop[var + '_prob'] = prob_w_rand
    # Normalize probabilities
    dest_modes = [mode + '_' + dest + '_prob' for mode in ['car', 'bike', 'walk', 'pt']]
    pop[dest_modes] = ((pop[dest_modes] - pop[dest_modes].min().min()) / (pop[dest_modes].max().max() - pop[dest_modes].min().min()))
    pop[dest_modes] = pop[dest_modes].div(pop[dest_modes].sum(axis = 1), axis = 0)
    # Reweight probabilities to meet Vienna modal shares
    # Assume probs_df is your N x 4 DataFrame of probabilities
    # and target_shares is a dict or Series
    dest_target = modal_targets_by_trip.loc[dest]
    dest_target.index = [i + '_' + dest + '_prob' for i in dest_target.index]
    # Normalize
    dest_target = dest_target / dest_target.sum()
    
    # Initial adjustment factors
    factors = dest_target / pop[dest_modes].mean()
    
    # Apply the weights
    adjusted_probs = pop[dest_modes] * factors
    
    # Normalize each row to sum to 1 again
    adjusted_probs = adjusted_probs.div(adjusted_probs.sum(axis=1), axis=0)
    pop[dest_modes] = adjusted_probs
    
    # Create a random dataframe to assign transport mode
    mode_rand = pd.DataFrame(np.random.rand(n, 1), columns = ['mode_' + dest], index = range(n))
    cum_prob = pop[dest_modes].cumsum(axis = 1)
    cum_prob.columns = cum_prob.columns.str.replace(dest, '').str.replace('prob', '').str.replace('_', '')

    # Compare each value in cum_prob with corresponding random value
    comparison = cum_prob.gt(mode_rand.values, axis=0)  # .gt = greater than
    
    # Get first column where cumulative prob > random value
    pop['mode_' + dest] = comparison.idxmax(axis=1)
  
# Assign trip length
def assign_trip_length(r, series):
    return series[series >= r].dropna().index[0]

for dest in ['work', 'leisure', 'services']:
    mode_var = 'mode_' + dest
    dest_rand = pd.Series(np.random.rand(n), index = range(n))
    duration_var = 'duration_' + dest
    pop[duration_var] = 0

    for mode in ['car', 'bike', 'walk', 'pt']:
        var = 'duration_' + mode + '_' + dest
        length_dist = coefs[var].copy()
        length_dist = length_dist[length_dist.index >= 5] / length_dist[length_dist.index >= 5].sum()
        length_cdf = length_dist.cumsum()
        mask = pop[mode_var] == mode
        pop.loc[mask, duration_var] = dest_rand[mask].apply(assign_trip_length, args=(length_cdf,))


# Adjust pbc and pn based on travel mode
bike_dummy = ((pop['mode_work'] == 'bike') | (pop['mode_services'] == 'bike') | (pop['mode_leisure'] == 'bike'))

pop['bike_dummy'] = np.where(bike_dummy, 1, 0)
cyclist_means = pop.groupby('bike_dummy')[['pbc', 'pn', 'sn', 'kn_aw']].mean()
# Get sample averages for cyclists vs. non-cyclists
# PBC 3.35 vs. 2.98
pop.loc[pop['bike_dummy'] == 1, 'pbc'] += 3.35 - cyclist_means.loc[1, 'pbc']
pop.loc[pop['bike_dummy'] == 1, 'pbc'] = np.minimum(pop.loc[pop['bike_dummy'] == 1, 'pbc'], 5)
pop.loc[pop['bike_dummy'] == 0, 'pbc'] += 2.98 - cyclist_means.loc[0, 'pbc']
pop.loc[pop['bike_dummy'] == 0, 'pbc'] = np.maximum(pop.loc[pop['bike_dummy'] == 0, 'pbc'], 1)
# pn 4.16 vs. 3.78
pop.loc[pop['bike_dummy'] == 1, 'pn'] += 4.16 - cyclist_means.loc[1, 'pn']
pop.loc[pop['bike_dummy'] == 1, 'pn'] = np.minimum(pop.loc[pop['bike_dummy'] == 1, 'pn'], 5)
pop.loc[pop['bike_dummy'] == 0, 'pn'] += 3.78 - cyclist_means.loc[0, 'pn']
pop.loc[pop['bike_dummy'] == 0, 'pn'] = np.maximum(pop.loc[pop['bike_dummy'] == 0, 'pn'], 1)
# sn 2.73 vs. 2.63
pop.loc[pop['bike_dummy'] == 1, 'sn'] += 2.73 - cyclist_means.loc[1, 'sn']
pop.loc[pop['bike_dummy'] == 1, 'sn'] = np.minimum(pop.loc[pop['bike_dummy'] == 1, 'sn'], 5)
pop.loc[pop['bike_dummy'] == 0, 'sn'] += 2.63 - cyclist_means.loc[0, 'sn']
pop.loc[pop['bike_dummy'] == 0, 'sn'] = np.maximum(pop.loc[pop['bike_dummy'] == 0, 'sn'], 1)
# kn_aw 4.26 vs. 4.06
pop.loc[pop['bike_dummy'] == 1, 'kn_aw'] += 4.26 - cyclist_means.loc[1, 'kn_aw']
pop.loc[pop['bike_dummy'] == 1, 'kn_aw'] = np.minimum(pop.loc[pop['bike_dummy'] == 1, 'kn_aw'], 5)
pop.loc[pop['bike_dummy'] == 0, 'kn_aw'] += 4.06 - cyclist_means.loc[0, 'kn_aw']
pop.loc[pop['bike_dummy'] == 0, 'kn_aw'] = np.maximum(pop.loc[pop['bike_dummy'] == 0, 'kn_aw'], 1)
cyclist_means = pop.groupby('bike_dummy')[['pbc', 'pn', 'sn', 'kn_aw']].mean()

##############################################################

# Cluster based on sociodemographics
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()

# Calculate inertia (sum of squared distances) for different k
X = pop[['gender', 'age', 'income']].copy()
X_scaled = scaler.fit_transform(X)


inertia = []
K = range(1, 10)

for k in K:
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(X_scaled)
    inertia.append(kmeans.inertia_)

# Plot the elbow curve
plt.figure(figsize=(8, 6))
plt.plot(K, inertia, 'bo-', markersize=8)
plt.xlabel('Number of clusters (k)')
plt.ylabel('Inertia (Within-cluster SS)')
plt.title('Elbow Method for Optimal k')
plt.show()

kmeans = KMeans(n_clusters=6, random_state=0, n_init="auto").fit(X_scaled)
kmeans.labels_
pop['cluster'] = kmeans.predict(X_scaled)
centroids = pd.DataFrame(kmeans.cluster_centers_, columns=X.columns)
print(centroids)

##############################################################
# Assign to districts based on income and cycling patterns

# Income table
district_income = pd.read_csv('data/district_income.csv', index_col = 0)
districts = pd.read_csv('data/vienna_district_densities.csv', index_col = 0)
districts["cycling_norm"] = districts["daily_cyclists_est"] / districts["daily_cyclists_est"].sum()
districts["cycle_st"] = (districts["daily_cyclists_est"] -  districts["daily_cyclists_est"].mean()) / districts["daily_cyclists_est"].std()
districts["income_norm"] = district_income / district_income.sum()
districts["income_st"] = (district_income -  district_income.mean()) / district_income.std()


# Combine into one weight per district
alpha, beta = 0.5, 0.5   # relative importance of cycling vs. income
districts["weight"] = alpha * districts["cycling_norm"] + beta * districts["income_norm"]

# Get number of cycle trips 
work_cycle = np.where(pop['mode_work'] == 'bike', pop['freq_work'], 0) * 2
services_cycle = np.where(pop['mode_services'] == 'bike', pop['freq_services'], 0) * 2
leisure_cycle = np.where(pop['mode_leisure'] == 'bike', pop['freq_leisure'], 0) * 2
total_cycle = work_cycle + services_cycle + leisure_cycle
pop['bike_trips'] = total_cycle
pop["bike_trips_st"] = (pop['bike_trips'] -  pop['bike_trips'].mean()) / pop['bike_trips'].std()
pop["income_st"] = (pop['income'] -  pop['income'].mean()) / pop['income'].std()

max_trips = max(total_cycle)
max_income = max(pop['income'])
min_income = min(pop['income'])
rng = np.random.default_rng(123)
assigned_districts = []

for i, agent in pop.iterrows():
    # # Compute similarity (inverse distance) to district income
    # dist_inc = np.abs(districts["income_st"].values - agent["income_st"])  # absolute difference
    # weights_inc = 1 / (dist_inc + 1e-6)  # avoid division by zero
    # weights_inc = weights_inc / weights_inc.sum()  # normalize to sum=1
    
    # # Compute similarity (inverse distance) to district cycling
    # dist_bike = np.abs(districts["cycle_st"].values - agent["bike_trips_st"])  # absolute difference
    # weights_bike = 1 / (dist_bike + 1e-6)  # avoid division by zero
    # weights_bike = weights_bike / weights_bike.sum()  # normalize to sum=1 
    
    # alpha = 0.5
    # weights = alpha * weights_inc + (1 - alpha) * weights_bike
    
    # 2D Euclidian distance
    dist = (0.5 * (districts["income_st"].values - agent["income_st"]) ** 2 + 0.5 * (districts["cycle_st"].values - agent["bike_trips_st"]) ** 2) ** 0.5
    weights = 1 / (dist + 1e-6)
    weights = weights / weights.sum()
    # Sample a district
    choice = rng.choice(districts.index, p=weights)
    assigned_districts.append(choice)
# Assign districts
pop["district"] = assigned_districts

# Add district attributes
district_infra = pd.read_csv('data/vienna_district_densities.csv')
district_infra = district_infra.rename(columns = {'BEZNR': 'district'})
district_infra = district_infra.fillna(0)
district_infra = district_infra.rename(columns = {'lane_density_km_per_km2': 'bikelane',
                                                  'pedestz_density': 'pedestz',
                                                  'park_density': 'park'})
district_infra = district_infra[['district', 'bikelane', 'pedestz', 'park']]
pop = pop.merge(district_infra, on="district", how="left")

# Make sure that simulated population follows the population distribution of the districts
district_pop = pd.read_csv('data/district_population.csv', index_col = 0)
district_pop_shares = district_pop / district_pop.sum()
distr_target_n = (district_pop_shares * 10000).round().astype(int)

# -------------------
# Sample agents
# -------------------
sampled_list = []

rng = np.random.default_rng(42)

for d in distr_target_n.index:
    target_n = distr_target_n.loc[d].values[0]
    candidates = pop[pop["district"] == d]
    
    # Sample from this district
    if (target_n > 0) & (len(candidates) > 0):
        chosen = rng.choice(candidates.index, size=min(target_n, len(candidates)), replace=False)
        sampled_list.append(pop.loc[chosen])


# Concatenate into final sample
sampled_agents = pd.concat(sampled_list, ignore_index=True)

sampled_agents.to_csv('simulated_population.csv', index = False)


# Plot correlation matrix
import seaborn as sns
import matplotlib.pyplot as plt
df_numeric = pop.select_dtypes(include='number')
corr_matrix = df_numeric.corr()
plt.figure(figsize=(8, 6))
sns.heatmap(corr_matrix[['gender', 'age', 'income', 'kn_aw', 'sn', 'pn', 'pbc']], 
            annot=True, cmap='coolwarm', fmt=".2f",
            annot_kws={"size": 6},  # annotation text size
            cbar_kws={"shrink": 0.8})  # optional: shrink colorbar

plt.xticks(fontsize=12)
plt.yticks(fontsize=12)
plt.title('Correlation Matrix', fontsize=14)

plt.show()

# Check summary statistics
print(pop.groupby(by = ['age_cat', 'mode_work'])[['kn_aw', 'sn', 'pn', 'pbc']].mean())
print(pop.groupby(by = ['gender', 'age_cat'])[['income']].mean())

# Print modal shares
modes = {}
modes['total'] = 0
for mode in ['bike', 'walk', 'car', 'pt']:
    work_ = np.where(pop['mode_work'] == mode, pop['freq_work'], 0) * 2
    services_ = np.where(pop['mode_services'] == mode, pop['freq_services'], 0) * 2
    leisure_ = np.where(pop['mode_leisure'] == mode, pop['freq_leisure'], 0) * 2
    modes[mode] = (work_ + services_ + leisure_).sum()
    modes['total'] += modes[mode]

for mode in ['bike', 'walk', 'car', 'pt']:
    print(mode, ' modal share: ',round(modes[mode] / modes['total'] * 100, 1))