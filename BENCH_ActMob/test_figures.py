# -*- coding: utf-8 -*-
"""
Created on Tue Dec  2 14:23:30 2025

@author: hartvig
"""
import os
import pandas as pd
import matplotlib.pyplot as plt
from adjustText import adjust_text
import seaborn as sns
import pickle
from source_code.support.result_processing import load_pickles

load_scenarios = True

plt.rcParams['font.family'] = 'Cambria'

only_selected = False
selected_scens = ['None & None & None', 'None & 2060 & None', 'Peers & None & None', 'Peers & 2060 & None', 'Peers & 2060 & Zoning', 'Peers & Early 2060 & None', 'Peers & Early 2060 & Zoning']
selected_colors = ['#7F7F7F', '#FBBB40', '#A0DDD9', '#EE696B', '#EE696B', '#207E6E', '#207E6E']
selected_color_map = {}
for i, scen in enumerate(selected_scens):
    selected_color_map[scen] = selected_colors[i]

social_order = ['None', 'Peers', 'Neighbour']
infra_order = ['None', '2060', 'Early 2060', '2050']

if load_scenarios:
                
    model_shares_2040, model_shares_2040_min, model_shares_2040_max, \
        active_mob_shares, active_mob_shares_min, active_mob_shares_max, agent_pbc = load_pickles('v1')
    
col_order = ['None & None & None', 'None & None & Zoning', 'None & 2060 & None',
            'None & 2060 & Zoning', 'None & Early 2060 & None', 'None & Early 2060 & Zoning', 
            'None & 2050 & None', 'None & 2050 & Zoning', 'Neighbour & None & None',
            'Neighbour & None & Zoning', 'Neighbour & 2060 & None', 'Neighbour & 2060 & Zoning',
            'Neighbour & Early 2060 & None', 'Neighbour & Early 2060 & Zoning',
            'Neighbour & 2050 & None', 'Neighbour & 2050 & Zoning', 'Peers & None & None',
            'Peers & None & Zoning', 'Peers & 2060 & None', 'Peers & 2060 & Zoning',
            'Peers & Early 2060 & None', 'Peers & Early 2060 & Zoning',
            'Peers & 2050 & None', 'Peers & 2050 & Zoning']


########################################################################################
# PLOT
########################################################################################



# --- 0. Create labels according to your rules ---
def transform_label(idx):
    parts = idx.split("_")
    parts = parts  # drop last part

    first, second, third = parts[0], parts[1], parts[2]

    # Replace baseline -> BAU
    if first == "baseline":
        first = "None"

    # Remove only the substring 'innerestadt', keep the rest
    if "innerestadt" in first:
        first = first.replace("innerestadt", "")
    if "early" in first:
        first = first.replace("early", "Early ")
    if "No" in second:
        second = second.replace("No", "None")
    if "Zoning" in third:
        third = third.replace("Zoning", "Zoning")
    if "No" in third:
        third = third.replace("No", "None")
    if "Neighbour" in second:
        second = second.replace("Neighbour", "Neighbour")
    if "Peers" in second:
        second = second.replace("Peers", "Peers")
    # Clean cases like "early2055" or "2045"
    first = first.strip("_")

    return f"{second} & {first} & {third}"
    

def run_plots(model_shares_2040, model_shares_2040_min, model_shares_2040_max, \
    active_mob_shares, active_mob_shares_min, active_mob_shares_max, agent_pbc):



    df1 = model_shares_2040.copy()
    df1[['Cycling', 'Walking', 'Public tr.', 'Car']] = df1[['Cycling', 'Walking', 'Public tr.', 'Car']] * 100
    # --- 3. Compute Active mobility ---
    df1["active_mobility"] = df1["Cycling"] + df1["Walking"]
    
    df1["label"] = df1.index.map(transform_label)
    df1 = df1.set_index('label')
    if only_selected:
        df1 = df1.loc[selected_scens]
    
    # --- 1. Extract first and second parts for plotting purposes ---
    def extract_parts(idx):
        parts = idx.split(" & ")  # drop last part
        first, second, third = parts[0], parts[1], parts[2]
        return first, second, third
    
    df1["first_part"], df1["second_part"], df1["third_part"] = zip(*df1.index.map(extract_parts))
    
    # --- 2. Define colors and markers ---
    first_part_unique = df1["first_part"].unique()
    first_part_unique = [item for item in social_order if item in first_part_unique]
    second_part_unique = df1["second_part"].unique()
    second_part_unique = [item for item in infra_order if item in second_part_unique]
    third_part_unique = df1["third_part"].unique()
    
    # Map first parts to colors
    colors = plt.cm.tab10(range(len(first_part_unique)))  # pick a colormap
    color_map = {fp: col for fp, col in zip(first_part_unique, colors)}
    # Map second parts to marker styles
    markers = ['^', 'X', 'P', '*', ',']  # extend if needed
    marker_map = {sp: mk for sp, mk in zip(second_part_unique, markers)}
    
    # Map second parts to marker edges
    marker_edge_colors = plt.cm.tab10(range(len(third_part_unique)))  # pick a colormap
    marker_edge_map = {sp: mk for sp, mk in zip(third_part_unique, marker_edge_colors)}
    marker_edge_map = {
        'None': 'none',       # no outline
        'Zoning': 'black'   # black outline
    }
    
    
    
    
    # --- 3. Plot ---
    ax = plt.figure(figsize=(9, 6))
    
    texts = []
    
    for i, row in df1.iterrows():
        plt.scatter(
            row["Walking"],
            row["Cycling"],
            color=[selected_color_map[row.name] if only_selected else color_map[row['first_part']]][0],
            marker=marker_map[row["second_part"]],
            edgecolor=marker_edge_map[row["third_part"]],
            linewidth=1.5,
            # linestyle='--',       # dashed
            s=300
        )
        
        # txt = plt.text(
        #     row["Walking"], row["Cycling"], row["label"],
        #     fontsize=11,
        #     ha='left', va='bottom'
        # )
        # texts.append(txt)
    
    plt.ylabel("Cycling Share", fontsize=11)
    plt.xlabel("Walking Share", fontsize=11)
    plt.title("Cycling Share vs Walking Share", fontsize=14)
    plt.grid(True, alpha=0.3)
    plt.xticks(fontsize=11)
    plt.yticks(fontsize=11)
    plt.xticks([30, 31, 32, 33, 34, 35])
    
    adjust_text(texts, expand=(1.1, 2), arrowprops=dict(arrowstyle='->', color='gray', lw=0.8))
    
    # 1) Legend for marker SHAPES (first_part)
    shape_handles = [
        plt.Line2D(
            [0], [0], marker=marker_map[first], color='black',
            markerfacecolor='white', markersize=10, label=first
        )
        for first in second_part_unique
    ]
    
    shape_legend = plt.legend(
        handles=shape_handles,
        title="Infrastructure Intv.",
        loc="upper left",
        bbox_to_anchor=(1, 1),
        fontsize=10,
        title_fontsize=11
    )
    plt.gca().add_artist(shape_legend)
    
    # 2) Legend for EDGE COLORS (third_part)
    edge_handles = [
        plt.Line2D(
            [0], [0], marker='o', color='none',
            markerfacecolor='white',
            markeredgecolor=marker_edge_map[third],
            markeredgewidth=2,
            markersize=10,
            linestyle='--',       # dashed
            label=third
        )
        for third in marker_edge_map.keys()
    ]
    
    edge_legend = plt.legend(
        handles=edge_handles,
        title="Policy Intervention",
        loc="upper left",
        bbox_to_anchor=(1, 0.75),
        fontsize=10,
        title_fontsize=11
    )
    
    plt.gca().add_artist(edge_legend)

    
    if not only_selected:
        # 3) Legend for marker FACE COLORS (second_part)
        color_handles = [
            plt.Line2D(
                [0], [0], marker='o', color='none',
                markerfacecolor=color_map[sec], markersize=10, label=sec
            )
            for sec in first_part_unique
        ]
        
        color_legend = plt.legend(
            handles=color_handles,
            title="Social Intervention",
            loc="upper left",
            bbox_to_anchor=(1, 0.575),
            fontsize=10,
            title_fontsize=11
        )
        plt.gca().add_artist(color_legend)  # keep it when adding more legends
    
    
    
    
    plt.tight_layout(rect=[0, 0, 0.7, 1])
    plt.show()
    if only_selected:
        ax.savefig('figures/walking_vs_cycling_selected.jpg', dpi = 300)
    else:
        ax.savefig('figures/walking_vs_cycling.jpg', dpi = 300)
    
    
    
    
    
    
    
    
    
    
    #############################################################
    # active mobility vs cars
    
    
    # --- 2. Remove rows containing 'Zoning' ---
    df = model_shares_2040.copy()
    df[['Cycling', 'Walking', 'Public tr.', 'Car']] = df[['Cycling', 'Walking', 'Public tr.', 'Car']] * 100
    # --- 3. Compute Active mobility ---
    df["Active Mobility"] = df["Cycling"] + df["Walking"]
    
    df["label"] = df.index.map(transform_label)
    df = df.set_index('label')
    
    if only_selected:
        df = df.loc[selected_scens]
    
    # --- 1. Extract first and second parts for plotting purposes ---
    def extract_parts(idx):
        parts = idx.split(" & ")  # drop last part
        first, second, third = parts[0], parts[1], parts[2]
        return first, second, third
    
    df["first_part"], df["second_part"], df["third_part"] = zip(*df.index.map(extract_parts))
    
    # --- 2. Define colors and markers ---
    first_part_unique = df1["first_part"].unique()
    first_part_unique = [item for item in social_order if item in first_part_unique]
    second_part_unique = df1["second_part"].unique()
    second_part_unique = [item for item in infra_order if item in second_part_unique]
    third_part_unique = df1["third_part"].unique()
    
    # Map first parts to colors
    colors = plt.cm.tab10(range(len(first_part_unique)))  # pick a colormap
    color_map = {fp: col for fp, col in zip(first_part_unique, colors)}
    # Map second parts to marker styles
    markers = ['^', 'X', 'P', '*', ',']  # extend if needed
    marker_map = {sp: mk for sp, mk in zip(second_part_unique, markers)}
    # Map second parts to marker edges
    marker_edge_colors = plt.cm.tab10(range(len(third_part_unique)))  # pick a colormap
    marker_edge_map = {sp: mk for sp, mk in zip(third_part_unique, marker_edge_colors)}
    marker_edge_map = {
        'None': 'none',       # no outline
        'Zoning': 'black'   # black outline
    }
    
    
    
    
    # --- 3. Plot ---
    ax = plt.figure(figsize=(9, 6))
    
    texts = []
    
    for i, row in df.iterrows():
        plt.scatter(
            row["Car"],
            row["Active Mobility"],
            color=[selected_color_map[row.name] if only_selected else color_map[row['first_part']]][0],
            marker=marker_map[row["second_part"]],
            edgecolor=marker_edge_map[row["third_part"]],
            linewidth=1.5,
            # linestyle='--',       # dashed
            s=300
        )
        
        # txt = plt.text(
        #     row["Walking"], row["Cycling"], row["label"],
        #     fontsize=11,
        #     ha='left', va='bottom'
        # )
        # texts.append(txt)
    
    plt.ylabel("Active Mobility Share", fontsize=11)
    plt.xlabel("Car Share", fontsize=11)
    plt.title("Active Mobility Share vs Car Share", fontsize=14)
    plt.grid(True, alpha=0.3)
    plt.xticks(fontsize=11)
    plt.yticks(fontsize=11)
    adjust_text(texts, expand=(1.1, 2), arrowprops=dict(arrowstyle='->', color='gray', lw=0.8))
    
    
    # 1) Legend for marker SHAPES (first_part)
    shape_handles = [
        plt.Line2D(
            [0], [0], marker=marker_map[first], color='black',
            markerfacecolor='white', markersize=10, label=first
        )
        for first in second_part_unique
    ]
    
    shape_legend = plt.legend(
        handles=shape_handles,
        title="Infrastructure Intv.",
        loc="upper left",
        bbox_to_anchor=(1, 1),
        fontsize=10,
        title_fontsize=11
    )
    plt.gca().add_artist(shape_legend)
    
    # 2) Legend for EDGE COLORS (third_part)
    edge_handles = [
        plt.Line2D(
            [0], [0], marker='o', color='none',
            markerfacecolor='white',
            markeredgecolor=marker_edge_map[third],
            markeredgewidth=2,
            markersize=10,
            linestyle='--',       # dashed
            label=third
        )
        for third in marker_edge_map.keys()
    ]
    
    edge_legend = plt.legend(
        handles=edge_handles,
        title="Policy Intervention",
        loc="upper left",
        bbox_to_anchor=(1, 0.75),
        fontsize=10,
        title_fontsize=11
    )
    
    plt.gca().add_artist(edge_legend)
    
    
    
    if not only_selected:
        # 3) Legend for marker FACE COLORS (second_part)
        color_handles = [
            plt.Line2D(
                [0], [0], marker='o', color='none',
                markerfacecolor=color_map[sec], markersize=10, label=sec
            )
            for sec in first_part_unique
        ]
        
        color_legend = plt.legend(
            handles=color_handles,
            title="Social Intervention",
            loc="upper left",
            bbox_to_anchor=(1, 0.575),
            fontsize=10,
            title_fontsize=11
        )
        plt.gca().add_artist(color_legend)  # keep it when adding more legends
    
    
    plt.tight_layout(rect=[0, 0, 0.7, 1])
    plt.show()
    if only_selected:
        ax.savefig('figures/active_vs_car_selected.jpg', dpi = 500)
    else:
        ax.savefig('figures/active_vs_car.jpg', dpi = 500)
    
    
    
    
    
    #############################################################
    # PBC
    # df2 = agent_pbc[~agent_pbc.index.str.contains("Zoning")]
    df2 = agent_pbc.copy()
    df2["label"] = df2.index.map(transform_label)
    df2 = df2.set_index('label')
    df2 = df2.loc[selected_scens]
    df_long = df2.reset_index().melt(id_vars="label", var_name="Scenario", value_name="PBC")
    
    def assign_group(rowname):
        if "Neighbour" in rowname:
            return "Neighbour"
        if "Peers" in rowname:
            return "Peers"
        if "None" in rowname[:6]:
            return "None"
        return "Other"
    
    df_long["Social Interaction"] = df_long["label"].apply(assign_group)
    # --- 3. Plot -----------------------------------------------------------------
    
    ax = plt.figure(figsize=(9, 6))
    
    sns.violinplot(
        data=df_long,
        x="label",
        y="PBC",
        inner="quartile",
        hue="label",                         # <-- colour by Neighbour / Peers / No
        palette=selected_color_map,
        cut=0,
        width=0.9, 
        linewidth=1,
        order=[
            'None & None & None',
            'None & 2060 & None', 
            'Peers & None & None',
            # 'Peers & None & Zoning',
            'Peers & Early 2060 & Zoning'
        ]
    )
    
    plt.xticks(rotation=20, fontsize=10)
    plt.yticks(fontsize=11)
    plt.xlabel("Scenario", fontsize=14)
    plt.ylabel("PBC Distribution", fontsize=11)
    plt.title("Violin Plot of PBC", fontsize=14)
    
    plt.tight_layout()
    plt.show()
    ax.savefig('figures/violin_PBC.jpg', dpi = 300)
    
    
    
    ########################################################
    
    active_mob_shares = active_mob_shares.set_index(active_mob_shares.index.map(transform_label))
    
    plt.figure(figsize=(9, 6))   # set figure size
    
    for row_name, row_values in active_mob_shares.iterrows():
        plt.plot(active_mob_shares.columns.astype(int),   # years on x-axis
                 row_values.values,                       # values on y-axis
                 label=row_name)
    
    # --- Chart formatting ---
    plt.xlabel("Year", fontsize=14)
    plt.ylabel("Active Mobility Share", fontsize=14)
    plt.title("Active Mobility Shares Over Time", fontsize=16)
    plt.grid(True, alpha=0.3)
    
    plt.legend(bbox_to_anchor=(1.05, 1), loc="upper left")  # move legend outside
    plt.tight_layout()
    
    # --- Save the figure ---
    plt.savefig("active_mob_shares_linechart.png", dpi=300)
    
    # Show the chart
    plt.show()




run_plots(model_shares_2040, model_shares_2040_min, model_shares_2040_max, \
    active_mob_shares, active_mob_shares_min, active_mob_shares_max, agent_pbc)



#############################################################################
############################### Sensitivities ###############################
#############################################################################

# load_sens_scenarios = True

# plt.rcParams['font.family'] = 'Cambria'

# only_selected = False
# selected_scens = ['Peers & 2060 & None', 'Peers & 2060 & Zoning']
# selected_colors = ['#7F7F7F', '#FBBB40', '#A0DDD9', '#EE696B', '#EE696B', '#207E6E', '#207E6E']
# selected_color_map = {}
# for i, scen in enumerate(selected_scens):
#     selected_color_map[scen] = selected_colors[i]

# social_order = ['None', 'Peers', 'Neighbour']
# infra_order = ['None', '2060', 'Early 2060', '2050']

# if load_sens_scenarios:
                
#     p2_model_shares_2040, p2_model_shares_2040_min, p2_model_shares_2040_max, \
#         p2_active_mob_shares, p2_active_mob_shares_min, p2_active_mob_shares_max, p2_agent_pbc = load_pickles('peernr2')
#     p6_model_shares_2040, p6_model_shares_2040_min, p6_model_shares_2040_max, \
#         p6_active_mob_shares, p6_active_mob_shares_min, p6_active_mob_shares_max, p6_agent_pbc = load_pickles('peernr6')
#     a6_model_shares_2040, a6_model_shares_2040_min, a6_model_shares_2040_max, \
#         a6_active_mob_shares, a6_active_mob_shares_min, a6_active_mob_shares_max, a6_agent_pbc = load_pickles('active6')
#     a8_model_shares_2040, a8_model_shares_2040_min, a8_model_shares_2040_max, \
#         a8_active_mob_shares, a8_active_mob_shares_min, a8_active_mob_shares_max, a8_agent_pbc = load_pickles('active6')
        
#     model_shares_2040["label"] = model_shares_2040.index.map(transform_label)
#     model_shares_2040 = model_shares_2040.set_index('label')
#     model_shares_2040 *= 100
#     m_model_shares_2040 = model_shares_2040.loc[selected_scens]

#     p2_model_shares_2040["label"] = p2_model_shares_2040.index.map(transform_label)
#     p2_model_shares_2040 = p2_model_shares_2040.set_index('label')
#     p2_model_shares_2040 *= 100
#     p6_model_shares_2040["label"] = p6_model_shares_2040.index.map(transform_label)
#     p6_model_shares_2040 = p6_model_shares_2040.set_index('label')
#     p6_model_shares_2040 *= 100

#     a6_model_shares_2040["label"] = a6_model_shares_2040.index.map(transform_label)
#     a6_model_shares_2040 = a6_model_shares_2040.set_index('label')
#     a6_model_shares_2040 *= 100
#     a8_model_shares_2040["label"] = a8_model_shares_2040.index.map(transform_label)
#     a8_model_shares_2040 = a8_model_shares_2040.set_index('label')
#     a8_model_shares_2040 *= 100
    
# col_order = ['None & None & None', 'None & None & Zoning', 'None & 2060 & None',
#             'None & 2060 & Zoning', 'None & Early 2060 & None', 'None & Early 2060 & Zoning', 
#             'None & 2050 & None', 'None & 2050 & Zoning', 'Neighbour & None & None',
#             'Neighbour & None & Zoning', 'Neighbour & 2060 & None', 'Neighbour & 2060 & Zoning',
#             'Neighbour & Early 2060 & None', 'Neighbour & Early 2060 & Zoning',
#             'Neighbour & 2050 & None', 'Neighbour & 2050 & Zoning', 'Peers & None & None',
#             'Peers & None & Zoning', 'Peers & 2060 & None', 'Peers & 2060 & Zoning',
#             'Peers & Early 2060 & None', 'Peers & Early 2060 & Zoning',
#             'Peers & 2050 & None', 'Peers & 2050 & Zoning']




