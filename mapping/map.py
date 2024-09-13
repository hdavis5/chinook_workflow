import pandas as pd 
import geopandas as gpd
import matplotlib.pyplot as plt
from shapely.geometry import LineString
from adjustText import adjust_text

data = pd.read_csv('locals.csv')

# Create a GeoDataFrame from the provided locations
gdf = gpd.GeoDataFrame(
    data, geometry=gpd.points_from_xy(data.Long, data.Lat))

# Load the world map with natural earth data
world = gpd.read_file('ne_110m_admin_1_states_provinces/ne_110m_admin_1_states_provinces.shp')
rivers = gpd.read_file('ne_50m_rivers_lake_centerlines/ne_50m_rivers_lake_centerlines.shp')

# Plot the map
fig, ax = plt.subplots(figsize=(15, 10))
world.plot(ax=ax, color='lightgrey')
rivers.plot(ax=ax, color='blue', linewidth=1, label='Rivers')
gdf.plot(ax=ax, color='red', markersize=50, label='Localities')

ax.set_xlim([-125, -117])
ax.set_ylim([43.5, 49.0])

# Add labels and legend
texts = []
for x, y, label in zip(gdf.geometry.x, gdf.geometry.y, gdf['Location']):
    texts.append(plt.text(x, y, label, fontsize=8))

# Adjust text to avoid overlap
adjust_text(texts, arrowprops=dict(arrowstyle='->', color='black'))

plt.title('Localities and Rivers')
plt.legend()
plt.xlabel('Longitude')
plt.ylabel('Latitude')
plt.savefig("WA_Chinookz_map.png", dpi=300)
plt.show()