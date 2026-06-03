# -*- coding: utf-8 -*-
"""
Created on Wed Jan 29 11:53:30 2025

@author: hartvig
"""
import pandas as pd
import numpy as np
import os
import random
import pandas as pd
from mesa import Agent, Model
from mesa.space import MultiGrid
# from mesa.time import RandomActivation
import argparse


# class Barbarian():
#     def __init__(self,**kwargs):
#         super(Barbarian, self).__init__()
#         self.name = 'Barbarian'
#         for attr,value in kwargs.items():
#             setattr(self,attr,value)

# b = Barbarian(**barbs['9'])
# barbs = {'9': {'fav_target': 'any', 'damage_type': 'single', 'targets': 'ground', 'space': 1, 'speed': 16, 
#         'dps': 38, 'hp': 230, 'type': 'ground', 'attack_rate': 1}}

# os.chdir('C://Users//hartvig//OneDrive - IIASA//Aron_IIASA//BENCH-X//BENCH-py')

# setup_vars = pd.read_csv('input//agent_setup.csv', index_col = 0)
# setup_vars = setup_vars.to_dict()

# class HouseholdAgent(Agent):
#     def __init__(self, unique_id, model, **kwargs):
#         super().__init__(unique_id, model)
        
#         self.h_id = unique_id
        
#         for attr,value in kwargs.items():
#             setattr(self, attr, value)
            
# agent = HouseholdAgent(1, self, **setup_vars)

            