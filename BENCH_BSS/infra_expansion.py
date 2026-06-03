import geopandas as gpd
from shapely.geometry import Point
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
import pandas as pd

# Set Matplotlib backend to 'Agg'
plt.switch_backend('Agg')

# Load bike stations, public transport stops, and Vienna boundary data
bike_stations = gpd.read_file("station_locations.geojson")
pt_stops = gpd.read_file("pt_stops.geojson")
vienna_boundary = gpd.read_file("vienna_boundary.json")  # Adjust the filename if needed

# Ensure all datasets use the same CRS and reproject to a projected CRS for buffering
projected_crs = "EPSG:32633"  # UTM zone 33N, suitable for Vienna

bike_stations = bike_stations.to_crs(projected_crs)
pt_stops = pt_stops.to_crs(projected_crs)
vienna_boundary = vienna_boundary.to_crs(projected_crs)

# Count the number of bicycle stations
num_bike_stations = len(bike_stations)
print(f"Number of bicycle stations: {num_bike_stations}")

# Filter public transport stops to only those within the Vienna boundary
pt_stops_vienna = gpd.sjoin(pt_stops, vienna_boundary, predicate='within')

# Create a buffer of 500 meters around each bike station
bike_station_buffers = bike_stations.geometry.buffer(500)

# Find which public transport stops are within 500 meters of any bike station
covered_pt_stops = pt_stops_vienna[pt_stops_vienna.geometry.apply(lambda x: any(bike_station_buffers.contains(x)))]

# Find the public transport stops that are not covered
uncovered_pt_stops = pt_stops_vienna[~pt_stops_vienna.index.isin(covered_pt_stops.index)]

# Number of new bike stations needed
num_new_bike_stations = len(uncovered_pt_stops)
print(f"Number of new bike stations needed: {num_new_bike_stations}")

# Optionally, save the uncovered public transport stops to a file for further analysis
if num_new_bike_stations > 0:
    uncovered_pt_stops.to_file("uncovered_pt_stops_vienna.geojson", driver="GeoJSON")  # Save in the current directory

# Define the number of new bike stations to add
num_new_bike_stations_to_add = 200

# Extract the coordinates of the uncovered PT stops
uncovered_pt_stops_coords = uncovered_pt_stops.geometry.apply(lambda x: (x.x, x.y)).tolist()

# Apply KMeans clustering to find optimal locations for new bike stations
kmeans = KMeans(n_clusters=num_new_bike_stations_to_add, random_state=0).fit(uncovered_pt_stops_coords)

# Get the coordinates of the cluster centers (new bike station locations)
new_bike_stations_coords = kmeans.cluster_centers_

# Convert the cluster centers to a GeoDataFrame
new_bike_stations = gpd.GeoDataFrame(
    geometry=[Point(x, y) for x, y in new_bike_stations_coords],
    crs=projected_crs
)

# Calculate coverage for each new bike station
def calculate_coverage(station, pt_stops, buffer_distance=500):
    buffer = station.buffer(buffer_distance)
    return pt_stops[pt_stops.geometry.within(buffer)].shape[0]

coverage_list = []
for idx, station in new_bike_stations.iterrows():
    coverage = calculate_coverage(station.geometry, uncovered_pt_stops)
    coverage_list.append((station.geometry, coverage))

# Create a DataFrame to rank the new bike stations by coverage
coverage_df = pd.DataFrame(coverage_list, columns=['geometry', 'coverage'])
coverage_df = coverage_df.sort_values(by='coverage', ascending=False).reset_index(drop=True)

# Convert the DataFrame back to a GeoDataFrame
ranked_new_bike_stations = gpd.GeoDataFrame(coverage_df, geometry='geometry', crs=projected_crs)

# Save the ranked new bike stations to a file
ranked_new_bike_stations.to_file("ranked_new_bike_stations.geojson", driver="GeoJSON")

# Visualization of the ranked new bike stations
fig, ax = plt.subplots(figsize=(10, 10))

# Plot Vienna boundary
vienna_boundary.plot(ax=ax, color='none', edgecolor='black', linewidth=1, label='Vienna Boundary')

# Plot covered public transport stops
if not covered_pt_stops.empty:
    covered_pt_stops.plot(ax=ax, color='orange', markersize=5, label='Covered PT Stops')

# Plot uncovered public transport stops
if not uncovered_pt_stops.empty:
    uncovered_pt_stops.plot(ax=ax, color='orange', markersize=5, label='Uncovered PT Stops')

# Plot existing bike stations
bike_stations.plot(ax=ax, color='red', marker='s', markersize=10, label='Existing Bike Stations')

# Plot new bike stations (with a color gradient based on rank)
ranked_new_bike_stations.plot(ax=ax, color ='blue', marker='s', markersize=10, legend=True, label='New Bike Stations')


# Set plot title and labels
plt.xlabel('Longitude')
plt.ylabel('Latitude')
plt.legend()

# Save the plot
plt.savefig('vienna_ranked_optimized_bike_stations_coverage.png')  # Save in the current directory
print(ranked_new_bike_stations.head())