# -*- coding: utf-8 -*-
"""
Created on Thu Feb 20 11:28:47 2025

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
df = pd.read_csv("input//Active Mobility in Cities (Responses) - Form responses 1.csv", index_col = 0)
df.columns = df.columns.str.strip()
df.columns = df.columns.str.replace('  [', ' [')
act_mob_freq = 'How often do you choose to engage in active mobility (walking or cycling)?'
df[act_mob_freq] = df[act_mob_freq].str.replace('Very frequently (5-6 times per week)', 'Often (5-6 times per week)')

df_values = pd.DataFrame(np.nan, index = df.index, columns = s_meta.short.unique())

for s in s_meta.short.unique():
    cat = s_meta.loc[s_meta.short == s]
    cols = s_meta.loc[s_meta.short == s].index
    for c in cols:
        if not np.any(pd.isna(cat['answer_categories'])):
            answers = cat_dict[s_meta.loc[c, 'answer_categories']].set_index('Categories')
            if 'Value' in answers.columns:
                responses_coded = df[c].map(answers.Value.to_dict())
            elif 'Lower_value' in answers.columns:
                responses_low = df[c].map(answers.Lower_value.to_dict())
                responses_upper = df[c].map(answers.Upper_value.to_dict())

                responses_coded = (responses_low.astype(float) + responses_upper.astype(float)) / 2

            df_values[s] = df_values[s].fillna(responses_coded)
    
# Export processed survey responses
df_values.to_csv('input//survey_encoded.csv')
