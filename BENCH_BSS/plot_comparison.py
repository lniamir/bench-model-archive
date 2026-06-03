import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import matplotlib

matplotlib.use('Agg')

# Load data
csv_adoption = 'adoption_rate_combined.csv'
csv_emissions = 'emissions_savings_combined.csv'

df_adoption = pd.read_csv(csv_adoption)
df_emissions = pd.read_csv(csv_emissions)

# # Remove duplicate rows and keep only the latest entry for each Label and Quarters
df_adoption = df_adoption.groupby(['Label', 'Quarters']).last().reset_index()
df_emissions = df_emissions.groupby(['Label', 'Quarters']).last().reset_index()

# Define selected scenarios
selected_labels = [
    'No-learning, No-expansion, Not-Implemented',
    'No-learning, Gradual, Not-Implemented',
    'Informative-all, No-expansion, Not-Implemented',
    'No-learning, No-expansion, Implemented',
    'No-learning, No-expansion, Not-implemented, MVP'
]
# Custom labels for the plots
custom_labels = [
    'Baseline',
    'Infrastructure',
    'Social',
    'Regulatory',
    'Service'
]

# Filter data based on selected scenarios
df_adoption_filtered = df_adoption[df_adoption['Label'].isin(selected_labels)]
df_emissions_filtered = df_emissions[df_emissions['Label'].isin(selected_labels)]

# Calculate the number of years and set ticks
num_quarters = df_adoption_filtered['Quarters'].max()
years = np.arange(2024, 2024 + num_quarters // 4)
yearly_ticks = np.arange(0, num_quarters, 4)

# Function to plot adoption rate
def plot_adoption_rate():
    plt.figure(figsize=(12, 8))
    for label, custom_label in zip(selected_labels, custom_labels):
        adoption_data = df_adoption_filtered[df_adoption_filtered['Label'] == label]
        if not adoption_data.empty:
            plt.plot(adoption_data['Quarters'], adoption_data['AvgAdoptionRate'], label=custom_label)
            plt.fill_between(adoption_data['Quarters'],
                             adoption_data['AvgAdoptionRate'] - adoption_data['StdAdoptionRate'],
                             adoption_data['AvgAdoptionRate'] + adoption_data['StdAdoptionRate'],
                             alpha=0.2)
    plt.xticks(ticks=yearly_ticks, labels=years)
    plt.xlabel('Years')
    plt.ylabel('Adoption Rate')
    # plt.title('Adoption Rate Over Time - Comparison')
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.savefig('adoption_rate_comparison_infra.png')
    plt.show()

# Function to plot emissions savings
def plot_emissions_savings():
    plt.figure(figsize=(12, 8))
    for label, custom_label in zip(selected_labels, custom_labels):
        emissions_data = df_emissions_filtered[df_emissions_filtered['Label'] == label]
        if not emissions_data.empty:
            plt.plot(emissions_data['Quarters'], emissions_data['AvgEmissionsSavings'], label=custom_label)
            plt.fill_between(emissions_data['Quarters'],
                             emissions_data['AvgEmissionsSavings'] - emissions_data['StdEmissionsSavings'],
                             emissions_data['AvgEmissionsSavings'] + emissions_data['StdEmissionsSavings'],
                             alpha=0.2)
    plt.xticks(ticks=yearly_ticks, labels=years)
    plt.xlabel('Years')
    plt.ylabel('Emissions Savings (kg)')
    plt.title('Emissions Savings Over Time - Comparison')
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.savefig('emissions_savings_comparison_comb.png')
    plt.show()

# Function to plot scaled emissions savings for Vienna
def plot_scaled_emissions_savings():
    vienna_population = 1.9e6
    model_population = 500
    scaling_factor = vienna_population / model_population

    plt.figure(figsize=(12, 8))
    for label, custom_label in zip(selected_labels, custom_labels):
        emissions_data = df_emissions_filtered[df_emissions_filtered['Label'] == label]
        if not emissions_data.empty:
            scaled_emissions = emissions_data['AvgEmissionsSavings'] * scaling_factor
            plt.plot(emissions_data['Quarters'], scaled_emissions, label=custom_label)
            plt.fill_between(emissions_data['Quarters'],
                             (emissions_data['AvgEmissionsSavings'] - emissions_data['StdEmissionsSavings']) * scaling_factor,
                             (emissions_data['AvgEmissionsSavings'] + emissions_data['StdEmissionsSavings']) * scaling_factor,
                             alpha=0.2)
    plt.xticks(ticks=yearly_ticks, labels=years)
    plt.xlabel('Years')
    plt.ylabel('Emissions Savings (kg) - Scaled')
    plt.title('Scaled Emissions Savings Over Time - Comparison')
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.savefig('scaled_emissions_savings_comparison_infra.png')
    plt.show()

# Function to plot cumulative CO2 saved by 2050
def plot_cumulative_co2_saved():
    final_quarter = df_adoption_filtered['Quarters'].max()
    emissions_2050 = df_emissions_filtered[df_emissions_filtered['Quarters'] == final_quarter]
    cumulative_emissions = emissions_2050.groupby('Label')['AvgEmissionsSavings'].sum().reindex(selected_labels)

    # Ensure lengths match
    if len(cumulative_emissions) == len(custom_labels):
        plt.figure(figsize=(10, 6))
        plt.bar(custom_labels, cumulative_emissions, color='skyblue')
        plt.xlabel('Scenarios')
        plt.ylabel('Cumulative CO2 Saved (kg)')
        plt.title('Cumulative CO2 Saved by 2050')
        plt.grid(axis='y')
        plt.tight_layout()
        plt.savefig('cumulative_co2_saved_2050_infra.png')
        plt.show()
    else:
        print("Error: Length mismatch between labels and data. Check your selected scenarios.")


def lineplot_cumulative_co2_saved():
    plt.figure(figsize=(12, 8))

    # Scaling factor to adjust for Vienna's population
    vienna_population = 1.9e6
    model_population = 500
    scaling_factor = vienna_population / model_population

    for label, custom_label in zip(selected_labels, custom_labels):
        emissions_data = df_emissions_filtered[df_emissions_filtered['Label'] == label]
        if not emissions_data.empty:
            # Calculate cumulative sum, apply the scaling factor, and convert to tons
            cumulative_emissions = emissions_data['AvgEmissionsSavings'].cumsum() * scaling_factor / 100000  # Now in tCO2
            cumulative_std = emissions_data['StdEmissionsSavings'].cumsum() * scaling_factor / 100000  # Now in tCO2

            plt.plot(emissions_data['Quarters'], cumulative_emissions, label=custom_label)
            plt.fill_between(emissions_data['Quarters'],
                             cumulative_emissions - cumulative_std,
                             cumulative_emissions + cumulative_std,
                             alpha=0.2)

    plt.xticks(ticks=yearly_ticks, labels=years)
    plt.xlabel('Years')
    plt.ylabel('Cumulative CO2 Saved (tCO2)')
    #plt.title('Cumulative CO2 Saved Over Time - Comparison (Scaled in tCO2)')
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.savefig('cumulative_co2_saved_line_plot_scaled_tco2.png')
    plt.show()

# Function to plot adoption rate by 2050
def plot_adoption_rate_2050():
    final_quarter = df_adoption_filtered['Quarters'].max()
    adoption_2050 = df_adoption_filtered[df_adoption_filtered['Quarters'] == final_quarter]
    final_adoption_rate = adoption_2050.groupby('Label')['AvgAdoptionRate'].mean().reindex(selected_labels)

    # Ensure lengths match
    if len(final_adoption_rate) == len(custom_labels):
        plt.figure(figsize=(10, 6))
        plt.bar(custom_labels, final_adoption_rate, color='lightgreen')
        plt.xlabel('Scenarios')
        plt.ylabel('Adoption Rate in 2050')
        plt.title('Adoption Rate by 2050')
        plt.grid(axis='y')
        plt.tight_layout()
        plt.savefig('adoption_rate_2050_infra.png')
        plt.show()
    else:
        print("Error: Length mismatch between labels and data. Check your selected scenarios.")

# Execute the plots
plot_adoption_rate()
plot_scaled_emissions_savings()
plot_cumulative_co2_saved()
plot_adoption_rate_2050()
lineplot_cumulative_co2_saved()