###############################################################
# Script 07b : Calcul des biomasses PHYTOBS
# Auteur : Lisa Tardivel
# Description :
#   - Somme des abondances par date et mois
#   - Conversion vers biomasses (pgC/L puis mmolN/m³)
###############################################################

library(tidyverse)
library(lubridate)
load("../outputs/tables/phyto_clean.RData")

### 1. Moyennes mensuelles ###
compute_monthly_avg <- function(df) {
  df %>%
    group_by(site, Année, Mois, Date) %>%
    summarise(Total_Count = sum(count_result_cell_parlitre, na.rm = TRUE), .groups = "drop") %>%
    group_by(site, Année, Mois) %>%
    summarise(Mean_Abundance = mean(Total_Count, na.rm = TRUE), .groups = "drop") %>%
    arrange(site, Mois)
}

Banyuls_monthly <- Banyuls %>% compute_monthly_avg()
Villefranche_monthly <- Villefranche %>%
  filter(Année >= 2016 & Année <= 2022) %>%
  compute_monthly_avg()
Marseille_monthly <- Marseille %>%
  filter(Année >= 2016 & Année <= 2022, Mean_Abundance < 2e6) %>%
  compute_monthly_avg()

### 2. Fusion ###
month_levels <- c("janv", "févr", "mars", "avr", "mai", "juin", "juil", "août", "sept", "oct", "nov", "déc")

prepare_plot_df <- function(df, site_name) {
  df %>% mutate(Mois_num = as.numeric(factor(Mois, levels = month_levels)), Site = site_name)
}

merged_plot_df <- bind_rows(
  prepare_plot_df(Banyuls_monthly, "Banyuls"),
  prepare_plot_df(Villefranche_monthly, "Villefranche"),
  prepare_plot_df(Marseille_monthly, "Marseille")
)

### 3. Conversion vers biomasse ###
carbone_per_cell <- 92.65  # pgC/cell (Chaetoceros)
convert_pgC_to_mmolN <- function(pgC_L) pgC_L * 1e-12 / 12 / 6.625 * 1e6

merged_plot_df <- merged_plot_df %>%
  mutate(
    Biomass_pgC_L = Mean_Abundance * carbone_per_cell,
    Biomass_mmolN_m3 = convert_pgC_to_mmolN(Biomass_pgC_L)
  )

save(merged_plot_df, file = "../outputs/tables/phyto_biomass.RData")
