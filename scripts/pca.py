import pandas as pd
import matplotlib.pyplot as plt

# Get the eigenvec file from the command-line argument
eigenvec_file = "/Users/haydendavis/Desktop/salmon/Chinook_workflow/data/pca_results_labeled.eigenvec"

# Load the PCA eigenvector file
pca_data = pd.read_csv(eigenvec_file, delim_whitespace=True, header=None)

# Columns 1 and 2 are individual IDs, PCs start from column 3
pca_data.columns = ['Name', 'Year'] + [f'PC{i}' for i in range(1, 21)]

# Create a color map for the different years
year_color = {1992: 'red', 2005: 'blue', 2020: 'green'}
colors = pca_data['Year'].map(year_color)

# Plotting PC1 vs PC2 with colors based on Year
plt.figure(figsize=(10, 6))
plt.scatter(pca_data['PC1'], pca_data['PC3'], c=colors, alpha=0.8)
plt.xlabel('PC1')
plt.ylabel('PC2')
plt.grid(True)

# Create a legend
handles = [plt.Line2D([0], [0], marker='o', color='w', label=year,
                      markerfacecolor=color, markersize=10)
           for year, color in year_color.items()]
plt.legend(handles=handles, title='Year')

plt.savefig("pc1_pc3.jpg", dpi=300)  # Save the plot
plt.show()