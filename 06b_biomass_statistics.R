###############################################################
# Script 06b : Statistiques des biomasses
# Auteur : Lisa Tardivel
# Description :
#   - Moyennes et écarts-types mensuels et annuels
#   - Comparaison entre groupes et sites
###############################################################

library(dplyr)

load("../outputs/tables/biomass_carbon_nitrogen.RData")
load("../outputs/tables/flr_chla_estimated.RData")  # pour Eucaryotes ajustés

### 1. Ajustement des eucaryotes à partir de la Fluorescence rouge FLR###
biomasse <- biomasse %>%
  left_join(flr_totaux, by = c("DATE", "site")) %>%
  left_join(coef_par_site, by = "site") %>%
  mutate(
    Biomass_PICOE_ajustee = FLR_total_PICOE * coef_FLR_BIOMASS,
    Biomass_NANOE_ajustee = FLR_total_NANOE * coef_FLR_BIOMASS,
    Eucaryotes = Biomass_PICOE_ajustee + Biomass_NANOE_ajustee
  )

### 2. Moyennes mensuelles ###
moy_mensuelle <- biomasse %>%
  filter(GROUPE %in% c("HNABACC", "LNABACC", "SYNC")) %>%
  group_by(site, GROUPE, mois) %>%
  summarise(biom_moy = mean(BIOMASS_TOTALE_MMN, na.rm = TRUE), .groups = "drop")

### 3. Moyennes et SD annuelles ###
moy_annee_groupes <- moy_mensuelle %>%
  group_by(site, GROUPE) %>%
  summarise(
    moyenne_annuelle = mean(biom_moy, na.rm = TRUE),
    sd_annuelle = sd(biom_moy, na.rm = TRUE),
    .groups = "drop"
  )

### 4. Cas des eucaryotes ###
moy_euca_mensuelle <- biomasse %>%
  group_by(site, mois) %>%
  summarise(biom_moy = mean(Eucaryotes, na.rm = TRUE), .groups = "drop")

moy_annee_euca <- moy_euca_mensuelle %>%
  group_by(site) %>%
  summarise(
    GROUPE = "Eucaryotes",
    moyenne_annuelle = mean(biom_moy, na.rm = TRUE),
    sd_annuelle = sd(biom_moy, na.rm = TRUE),
    .groups = "drop"
  )

### 5. Assemblage final ###
moyenne_finale <- bind_rows(moy_annee_groupes, moy_annee_euca)
save(moyenne_finale, file = "../outputs/tables/biomass_stats.RData")
