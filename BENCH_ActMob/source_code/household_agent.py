# -*- coding: utf-8 -*-
"""
Created on Wed Jan 29 11:53:30 2025

@author: hartvig
"""
from mesa import Agent

# Create agent class
class HouseholdAgent(Agent):
    def __init__(self, unique_id, model, **kwargs):
        super().__init__(model)
        
        self.h_id = unique_id
        self.action = 0
        
        for attr,value in kwargs.items():
            try:
                value = int(value)
            except:
                pass
            setattr(self, attr, value)
            