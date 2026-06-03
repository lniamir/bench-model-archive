# -*- coding: utf-8 -*-
"""
Created on Wed Nov 19 10:06:18 2025

@author: hartvig
"""
import numpy as np
import pandas as pd

def info_campaign(agents, campaign_cluster):
    for agent in agents:
        # Check if agent is in the age target group
        if agent.cluster in campaign_cluster:
            # Increase knowledge and social norms
            agent.kn_aw_ch += min(1, 5 - agent.kn_aw) 
            agent.sn_ch += min(1, 5 - agent.sn) 





