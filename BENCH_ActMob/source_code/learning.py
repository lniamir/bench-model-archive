# -*- coding: utf-8 -*-
"""
Created on Wed Nov 19 10:06:18 2025

@author: hartvig
"""


def learn(learning, agents, grid):
    for agent in agents:
        if learning == "No":
            continue
        # if self.learning in ["Slow dynamics", "Fast dynamics"]:
        #     if agent.act1 or agent.invest1:
        #         if agent.pbc < 4.6:
        #             agent.pbc += agent.pbc * 0.05

        #         neighbors = self.grid.get_neighbors(agent.pos, moore=True, include_center=False)
        #         if len(neighbors) > 0:
        #             ngb_k_mean = sum([n.kn_aw for n in neighbors]) / len(neighbors)
        #             ngb_k_median = sorted([n.kn_aw for n in neighbors])[len(neighbors) // 2]
        #             ngb_k = max(ngb_k_mean, ngb_k_median)

        #             ngb_pn_mean = sum([n.pn for n in neighbors]) / len(neighbors)
        #             ngb_pn_median = sorted([n.pn for n in neighbors])[len(neighbors) // 2]
        #             ngb_pn = max(ngb_pn_mean, ngb_pn_median)

        #             ngb_sn_mean = sum([n.sn for n in neighbors]) / len(neighbors)
        #             ngb_sn_median = sorted([n.sn for n in neighbors])[len(neighbors) // 2]
        #             ngb_sn = max(ngb_sn_mean, ngb_sn_median)

        #             ngb_pbc_mean = sum([n.pbc for n in neighbors]) / len(neighbors)
        #             ngb_pbc_median = sorted([n.pbc for n in neighbors])[len(neighbors) // 2]
        #             ngb_pbc = max(ngb_pbc_mean, ngb_pbc_median)

        #         if len(neighbors) > 4:
        #             for n in neighbors:
        #                 if n.kn_aw < ngb_k and n.kn_aw < 4.6:
        #                     n.kn_aw_ch = n.kn_aw * 0.05
        #                     n.kn_aw += n.kn_aw_ch
        #                 if n.pn < ngb_pn and n.pn < 4.6:
        #                     n.pn_ch = n.pn * 0.05
        #                     n.pn += n.pn_ch
        #                 if n.sn < ngb_sn and n.sn < 4.6:
        #                     n.sn_ch = n.sn * 0.05
        #                     n.sn += n.sn_ch
        #                 if n.pbc < 4.5 and n.pbc < 4.6:
        #                     n.pbc_ch = n.pbc * 0.05
        #                     n.pbc += n.pbc_ch

        if learning == "Neighbour":
            

            # if agent.mode_trips['bike'] < 4 or agent.mode_trips['walk'] < 4:
            # Learning from neighbors  
            active_neighbours = [n for n in agent.neighbours if n.mode_trips['bike'] + n.mode_trips['walk'] > 7]
            active_n_nr = len(active_neighbours)
            if active_n_nr > 0:
            
                ngb_k_mean = sum([n.kn_aw for n in active_neighbours]) / active_n_nr
                ngb_k_median = sorted([n.kn_aw for n in active_neighbours])[active_n_nr // 2]
                ngb_k = max(ngb_k_mean, ngb_k_median)

                ngb_pn_mean = sum([n.pn for n in active_neighbours]) / active_n_nr
                ngb_pn_median = sorted([n.pn for n in active_neighbours])[active_n_nr // 2]
                ngb_pn = max(ngb_pn_mean, ngb_pn_median)

                ngb_sn_mean = sum([n.sn for n in active_neighbours]) / active_n_nr
                ngb_sn_median = sorted([n.sn for n in active_neighbours])[active_n_nr // 2]
                ngb_sn = max(ngb_sn_mean, ngb_sn_median)

                ngb_pbc_mean = sum([n.pbc for n in active_neighbours]) / active_n_nr
                ngb_pbc_median = sorted([n.pbc for n in active_neighbours])[active_n_nr // 2]
                ngb_pbc = max(ngb_pbc_mean, ngb_pbc_median)

                if agent.kn_aw < ngb_k and agent.kn_aw < 5:
                    agent.kn_aw_ch += min(agent.kn_aw * 0.05, 5 - agent.kn_aw) 
                    # agent.kn_aw += agent.kn_aw_ch
                if agent.guilt == 'H' and agent.pn < ngb_pn and agent.pn < 5:
                    agent.pn_ch += min(agent.pn * 0.05, 5 - agent.pn) 
                    # agent.pn += agent.pn_ch 
                if agent.guilt == 'H' and agent.sn < ngb_sn and agent.sn < 5:
                    agent.sn_ch += min(agent.sn * 0.05, 5 - agent.sn) 
                    # agent.sn += agent.sn_ch
                if agent.mot == 'H' and agent.pbc < ngb_pbc and agent.pbc < 5:
                    agent.pbc_ch += min(agent.pbc * 0.05, 5 - agent.pbc)
                    # agent.pbc += agent.pbc_ch

        if learning == "Peers":
            
            # if agent.mode_trips['bike'] < 4 or agent.mode_trips['walk'] < 4:
            # Learning from neighbors  
            peers = agent.peers
            active_peers = [agents[n] for n in peers if agents[n].mode_trips['bike'] + agents[n].mode_trips['walk'] > 7]
            active_p_nr = len(active_peers)
            if active_p_nr > 0:
            
                ngb_k_mean = sum([n.kn_aw for n in active_peers]) / active_p_nr
                ngb_k_median = sorted([n.kn_aw for n in active_peers])[active_p_nr // 2]
                ngb_k = max(ngb_k_mean, ngb_k_median)

                ngb_pn_mean = sum([n.pn for n in active_peers]) / active_p_nr
                ngb_pn_median = sorted([n.pn for n in active_peers])[active_p_nr // 2]
                ngb_pn = max(ngb_pn_mean, ngb_pn_median)

                ngb_sn_mean = sum([n.sn for n in active_peers]) / active_p_nr
                ngb_sn_median = sorted([n.sn for n in active_peers])[active_p_nr // 2]
                ngb_sn = max(ngb_sn_mean, ngb_sn_median)

                ngb_pbc_mean = sum([n.pbc for n in active_peers]) / active_p_nr
                ngb_pbc_median = sorted([n.pbc for n in active_peers])[active_p_nr // 2]
                ngb_pbc = max(ngb_pbc_mean, ngb_pbc_median)

                if agent.kn_aw < ngb_k and agent.kn_aw < 5:
                    agent.kn_aw_ch += min(agent.kn_aw * 0.05, 5 - agent.kn_aw) 
                if agent.guilt == 'H' and agent.pn < ngb_pn and agent.pn < 5:
                    agent.pn_ch += min(agent.pn * 0.05, 5 - agent.pn) 
                if agent.guilt == 'H' and agent.sn < ngb_sn and agent.sn < 5:
                    agent.sn_ch += min(agent.sn * 0.05, 5 - agent.sn) 
                if agent.mot == 'H' and agent.pbc < ngb_pbc and agent.pbc < 5:
                    agent.pbc_ch += min(agent.pbc * 0.05, 5 - agent.pbc) 

    # print("Learning process updated.")
