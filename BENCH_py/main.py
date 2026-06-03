# -*- coding: utf-8 -*-
"""
Created on Wed Jan 29 11:42:53 2025

@author: hartvig
"""

import random
import pandas as pd
from mesa import Agent, Model
from mesa.space import MultiGrid
from mesa.time import RandomActivation
import argparse

from source_code.model_class import CommunityModel

args = parse_args()
model = CommunityModel(
    N=args.num_agents,
    case_study=args.case_study,
    scenario=args.scenario,
    data=args.data,
    learning=args.learning,
    i1_cost=args.i1_cost,
    i2_cost=args.i2_cost,
    i3_cost=args.i3_cost,
    seed=args.seed
)
for _ in range(20):  # Simulate 10 years
    model.go()

if __name__ == "__main__":
    main()
