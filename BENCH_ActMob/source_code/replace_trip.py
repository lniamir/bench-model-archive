# -*- coding: utf-8 -*-
"""
Created on Wed Nov 19 11:17:07 2025

@author: hartvig
"""

import numpy as np

def replace_trip(agent, d, tr_modes, dests):
    
    if agent.prob['bike'][d] > 0.3 and not agent.prob['walk'][d] > 0.35:
        # Replaceable trips
        replace_bike = 0
        # Find trips where not bike is used
        if agent.modes[d] != 'bike':
            # Assess length by mode
            if agent.modes[d] == 'car':
                if agent.length[d] < 40:
                    replace_bike += agent.trips[d]
            if agent.modes[d] == 'pt':
                if agent.length[d] < 50:
                    replace_bike += agent.trips[d]
            # if agent.modes[d] == 'walk':
            #     if agent.length[d] < 40:
            #         replace_bike += agent.trips[d]

        # Probability of replacing 1 trip
        # Generate random numbers to see how many trips are replaced
        random_nr = np.random.uniform(size = int(replace_bike), low = 0, high = 1)  
        replaced_nr = sum(random_nr < agent.prob['bike'][d])
        if replaced_nr > replace_bike / 2:
            # If agent would choose bike in most cases it replaces all its trips to a destination 
            agent.modes[d] = 'bike'
            agent.shift_mode = 1
            agent.shift_dest = agent.shift_dest + [d]
            agent.shift_to = agent.shift_to + ['bike']
    elif agent.prob['walk'][d] > 0.35 and not agent.prob['bike'][d] > 0.3:
        # Replaceable trips
        replace_walk = 0
        # Find trips where not bike is used
        if agent.modes[d] != 'walk':
            # Assess length by mode
            if agent.modes[d] == 'car':
                if agent.length[d] < 20:
                    replace_walk += agent.trips[d]
            if agent.modes[d] == 'pt':
                if agent.length[d] < 25:
                    replace_walk += agent.trips[d]
            # if agent.modes[d] == 'bike':
            #     if agent.length[d] < 20:
            #         replace_walk += agent.trips[d]

        # Probability of replacing 1 trip
        # Generate random numbers to see how many trips are replaced
        random_nr = np.random.uniform(size = int(replace_walk), low = 0, high = 1)  
        replaced_nr = sum(random_nr < agent.prob['walk'][d])
        if replaced_nr > replace_walk / 2:
            # If agent would choice bike in most cases it replaces all its trips to a destination 
            agent.modes[d] = 'walk'
            agent.shift_mode = 1
            agent.shift_dest = agent.shift_dest + [d]
            agent.shift_to = agent.shift_to + ['walk']
    elif agent.prob['walk'][d] > 0.35 and agent.prob['bike'][d] > 0.3:
        # Replaceable trips
        # Assess walking
        replace_walk = 0
        # Find trips where not bike is used
        if (agent.modes[d] != 'walk') & (agent.modes[d] != 'bike'):
            # Assess length by mode
            if agent.modes[d] == 'car':
                if agent.length[d] < 15:
                    replace_walk += agent.trips[d]
            if agent.modes[d] == 'pt':
                if agent.length[d] < 20:
                    replace_walk += agent.trips[d]                    
        # Probability of replacing 1 trip
        # Generate random numbers to see how many trips are replaced
        random_nr_walk = np.random.uniform(size = int(replace_walk), low = 0, high = 1)  
        replaced_nr_walk = sum(random_nr_walk < agent.prob['walk'][d])

        # Assess cycling
        replace_bike = 0
        # Find trips where not bike is used
        if agent.modes[d] != 'bike':
            # Assess length by mode
            if agent.modes[d] == 'car':
                if agent.length[d] < 30:
                    replace_bike += agent.trips[d]
            if agent.modes[d] == 'pt':
                if agent.length[d] < 40:
                    replace_bike += agent.trips[d]
        # Probability of replacing 1 trip
        # Generate random numbers to see how many trips are replaced
        random_nr_bike = np.random.uniform(size = int(replace_bike), low = 0, high = 1)  
        replaced_nr_bike = sum(random_nr_bike < agent.prob['bike'][d])

        random_walk_or_bike = np.random.uniform(size = 1, low = 0, high = 1)
        # Decide randomly between walking and cycling if both are preferred in most trips
        # Weight probabilities based on agent probs
        walk_vs_bike = agent.prob['walk'][d] / (agent.prob['walk'][d] + agent.prob['bike'][d])
        if (replaced_nr_walk > replace_walk / 2) & (replaced_nr_bike > replace_bike / 2):
            if (random_walk_or_bike < walk_vs_bike):
                agent.modes[d] = 'walk'
                agent.shift_mode = 1
                agent.shift_dest = agent.shift_dest + [d]
                agent.shift_to = agent.shift_to + ['walk']
            else:
                agent.modes[d] = 'bike'
                agent.shift_mode = 1
                agent.shift_dest = agent.shift_dest + [d]
                agent.shift_to = agent.shift_to + ['bike']
        # If only walking is preferred set to walking
        elif (replaced_nr_walk > replace_walk / 2):
            # If agent would choose bike in most cases it replaces all its trips to a destination 
            agent.modes[d] = 'walk'
            agent.shift_mode = 1
            agent.shift_dest = agent.shift_dest + [d]
            agent.shift_to = agent.shift_to + ['walk']
        # If only cycling is preferred set to cycling
        elif (replaced_nr_bike > replace_bike / 2):
            # If agent would choose bike in most cases it replaces all its trips to a destination 
            agent.modes[d] = 'bike'
            agent.shift_mode = 1
            agent.shift_dest = agent.shift_dest + [d]
            agent.shift_to = agent.shift_to + ['bike']

        # if agent.shift_mode == 1:
        #     # Recalculate mode shares
        #     agent.mode_trips = {m: 0 for m in tr_modes}
        #     for mode in tr_modes:
        #         for dest in dests:
        #             if agent.modes[dest] == mode:
        #                 agent.mode_trips[mode] += agent.trips[dest]
        #     if agent.total_trips > 0:
        #         agent.mode_shares = {k: v / agent.total_trips for k, v in agent.mode_trips.items()}
        #     else:
        #         agent.mode_shares = {k: 0 for k, v in agent.mode_trips.items()}  
        

def reconsider(agent, d, new_mode, original_mode, tr_modes, dests):
    
        # Create mode dictionary for new and previous mode
        prob_old_mode = agent.prob[original_mode][d]
        prob_new_mode = agent.prob[new_mode][d]
        replace_trips = agent.trips[d]

        # Probability of replacing 1 trip
        # Generate random numbers to see how many trips are replaced
        random_nr = np.random.uniform(size = int(replace_trips), low = 0, high = prob_old_mode + prob_new_mode)  
        replaced_nr = sum(random_nr < prob_new_mode)
        # If agent does not choose new most most frequently
        if replaced_nr <= replace_trips / 2:
            agent.modes[d] = original_mode
            # Calculate which trips are replaced
            agent.shift_year = 0

            # # Recalculate mode shares
            # agent.mode_trips = {m: 0 for m in tr_modes}
            # for mode in tr_modes:
            #     for dest in dests:
            #         if agent.modes[dest] == mode:
            #             agent.mode_trips[mode] += agent.trips[dest]
            # if agent.total_trips > 0:
            #     agent.mode_shares = {k: v / agent.total_trips for k, v in agent.mode_trips.items()}
            # else:
            #     agent.mode_shares = {k: 0 for k, v in agent.mode_trips.items()}  