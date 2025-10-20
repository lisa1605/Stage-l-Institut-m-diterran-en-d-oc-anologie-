from src.forcingfunctions import sites
from src.simulations import run_model_for_sites
from src.visualisations import plot_phyto_zoo_and_chlorophyll_with_obs
import pandas as pd

# Données
observation = pd.read_csv("data/observation.csv")
chla_jour_moy = pd.read_csv("data/chla_jour_moy.csv")

# Simulation
results = run_model_for_sites(sites)

# Visualisation
plot_phyto_zoo_and_chlorophyll_with_obs(results, observation, chla_jour_moy)
