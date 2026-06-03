# -*- coding: utf-8 -*-
"""
Created on Thu Feb 20 09:44:12 2025

@author: hartvig
"""

import pandas as pd
import numpy as np
import os
from pathlib import Path
import sys

main_folder = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))

os.chdir(main_folder)

# Read metadata
s_meta = pd.read_csv("utilities//survey_metadata.csv", skiprows = 0, index_col = 0)
cat_dict = pd.read_excel("utilities//categories_dict.xlsx", sheet_name = None)


# Read data
df = pd.DataFrame(index = range(1, 3001), columns = s_meta.index)

df.columns = df.columns.str.strip()
pop_district = pd.read_csv("input//population.csv", skiprows = 3, index_col = 0)

# Populate variables with given distribution
dist_probs = pop_district.population / sum(pop_district.population)
df = df.astype({'What district do you live in?': 'str'})
df.loc[:, 'What district do you live in?'] = np.random.choice(dist_probs.index, df.shape[0], p = dist_probs)

# Loop over questions
# No branch
no_branch = s_meta.loc[s_meta.branch == 'no'].drop('branch', axis = 1)
for q, cat in no_branch.iterrows():
    if not pd.isna(cat.answer_categories):
        answers = cat_dict[cat.answer_categories]['Categories'].values
        option_nr = answers.shape[0]
        probs = [1 / option_nr] * option_nr
        df = df.astype({q: 'str'})
        df.loc[:, q] = np.random.choice(answers, df.shape[0], p = probs)

# Never branch
no_branch = s_meta.loc[s_meta.branch == 'never'].drop('branch', axis = 1)
never_rows = df['How often do you choose to engage in active transport (walking or cycling)?'].isin(['Never (0 times per week)', 'Rarely (1-2 times per week)'])
never_branch = s_meta.loc[s_meta.branch == 'never'].drop('branch', axis = 1)

for q, cat in never_branch.iterrows():
    if not pd.isna(cat.answer_categories):
        answers = cat_dict[cat.answer_categories]['Categories'].values
        option_nr = answers.shape[0]
        probs = [1 / option_nr] * option_nr
        df = df.astype({q: 'str'})
        df.loc[never_rows, q] = np.random.choice(answers, sum(never_rows), p = probs)

# Always branch
always_rows = never_rows == False
always_branch = s_meta.loc[s_meta.branch == 'always'].drop('branch', axis = 1)

for q, cat in always_branch.iterrows():
    if not pd.isna(cat.answer_categories):
        answers = cat_dict[cat.answer_categories]['Categories'].values
        option_nr = answers.shape[0]
        probs = [1 / option_nr] * option_nr
        df = df.astype({q: 'str'})
        df.loc[always_rows, q] = np.random.choice(answers, sum(always_rows), p = probs)


# Norms
low_norms_rows = never_rows
norms_branch = s_meta.loc[s_meta.branch == 'norms'].drop('branch', axis = 1)

for q, cat in norms_branch.iterrows():
    if not pd.isna(cat.answer_categories):
        answers = cat_dict[cat.answer_categories]['Categories'].values
        option_nr = answers.shape[0]
        probs = [0.1, 0.45, 0.3, 0.1, 0.05]
        df = df.astype({q: 'str'})
        df.loc[low_norms_rows, q] = np.random.choice(answers, sum(low_norms_rows), p = probs)

high_norms_rows = always_rows
norms_branch = s_meta.loc[s_meta.branch == 'norms'].drop('branch', axis = 1)

for q, cat in norms_branch.iterrows():
    if not pd.isna(cat.answer_categories):
        answers = cat_dict[cat.answer_categories]['Categories'].values
        option_nr = answers.shape[0]
        probs = [0.05, 0.1, 0.45, 0.3, 0.1]
        df = df.astype({q: 'str'})
        df.loc[high_norms_rows, q] = np.random.choice(answers, sum(high_norms_rows), p = probs)

# Export simulated survey responses
df.to_csv('input//survey_simulation.csv')
