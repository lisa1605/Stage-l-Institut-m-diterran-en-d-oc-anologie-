###############################################################
# Script 08b : Conversion des biomasses ZOOScan
# Auteur : Lisa Tardivel
# Description :
#   - Calculs saisonniers moyens de la biomasse totale
#   - Conversion mg DW → mmol N/m³
#   - Agrégation par classes de taille
###############################################################

library(tidyverse)
library(lubridate)

load("../outputs/tables/zoo_clean.RData")

### 1. Ordre chronologique des mois ###
mois_ordre <- c("janvier", "février", "mars", "avril", "mai", "juin",
                "juillet", "août", "septembre", "octobre", "novembre", "décembre")

df$Biomasse_totale_zoo <- as.numeric(df$Biomasse_totale_zoo)

### 2. Moyenne mensuelle de la biomasse totale ###
cycle_saisonniertot <- df %>%
  group_by(Mois, Année) %>%
  summarise(Biomasse_Moyenne_zoo = mean(Biomasse_totale_zoo, na.rm = TRUE), .groups = "drop") %>%
  mutate(Mois = factor(Mois, levels = mois_ordre)) %>%
  arrange(Mois)

### 3. Conversion mg DW → mmol N/m³ ###
f_C <- 0.45       # Fraction de carbone dans la biomasse sèche
molar_mass_C <- 12
CN_ratio <- 5     # Ratio C:N zooplancton

cycle_saisonniertot <- cycle_saisonniertot %>%
  mutate(Biomasse_Moyennezoo_N = Biomasse_Moyenne_zoo * f_C / (molar_mass_C * CN_ratio),
         site = "Marseille") %>%
  select(site, Mois, Année, Biomasse_Moyennezoo_N)

### 4. Par classes de taille ###
cols_biomass <- c("biomass fraction gt 2000 um", "biomass fraction 1000-2000 um",
                  "biomass fraction 500-1000 um", "biomass fraction 300-500 um",
                  "biomass fraction 200-300 um", "biomass fraction 80-200 um")

df[cols_biomass] <- lapply(df[cols_biomass], as.numeric)

df_long <- df %>%
  pivot_longer(cols = all_of(cols_biomass), names_to = "Classe_Taille", values_to = "Biomasse") %>%
  mutate(Classe_Taille = recode(Classe_Taille,
    "biomass fraction gt 2000 um" = "> 2000 µm",
    "biomass fraction 1000-2000 um" = "1000-2000 µm",
    "biomass fraction 500-1000 um" = "500-1000 µm",
    "biomass fraction 300-500 um" = "300-500 µm",
    "biomass fraction 200-300 um" = "200-300 µm",
    "biomass fraction 80-200 um" = "80-200 µm"
  ))

cycle_saisonnier_taille <- df_long %>%
  group_by(Mois, Année, Classe_Taille) %>%
  summarise(Biomasse_Moyenne = mean(Biomasse, na.rm = TRUE), .groups = "drop") %>%
  mutate(Mois = factor(Mois, levels = mois_ordre)) %>%
  arrange(Mois)

save(cycle_saisonniertot, cycle_saisonnier_taille, file = "../outputs/tables/zoo_biomass.RData")
