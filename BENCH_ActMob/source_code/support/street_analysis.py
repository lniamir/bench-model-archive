# -*- coding: utf-8 -*-
"""
Created on Thu Jul 10 15:48:52 2025

@author: hartvig
"""
import plotly.express as px
import pandas as pd
import os
import plotly.io as pio
import geopandas as gpd
import shapely
import osmnx as ox
import os

os.getcwd()

# # Set place name
# place_name = "Vienna, Austria"

# # Download street network (e.g., driveable roads)
# G = ox.graph_from_place(place_name, network_type="drive")

# # Convert to GeoDataFrame (only edges are usually needed for street segments)
# edges = ox.graph_to_gdfs(G, nodes=False)

# # Save to a Shapefile
# edges.to_file("vienna_streets.shp")

vienna_base_map = gpd.read_file('vienna_streets//vienna_streets.shp')

vienna_base_map.plot()


