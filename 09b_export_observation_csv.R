###############################################################
# Script 09b : Export du dataframe "observation" pour Python
# Auteur : Lisa Tardivel
# Description :
#   - Fusion des biomasses microbiennes, phyto et zoo
#   - Ajout des variables environnementales (azote total, T°)
#   - Export final vers CSV pour utilisation dans le modèle 0D Python
###############################################################

library(tidyverse)
library(lubridate)

load("../outputs/tables/zoo_biomass.RData")
load("../outputs/tables/chla_moy.RData")

### 1. Construction du dataframe observation mensuel ###
observation <- biomasse %>%
  filter(GROUPE %in% c("HNABACC", "LNABACC", "SYNC")) %>%
  mutate(GROUPE = recode(GROUPE,
                         "HNABACC" = "HNA",
                         "LNABACC" = "LNA",
                         "SYNC" = "cyanobactéries")) %>%
  group_by(site, mois, annee, GROUPE) %>%
  summarise(BIOMASSE = mean(BIOMASS_TOTALE_MMN, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = GROUPE, values_from = BIOMASSE) %>%
  left_join(
    biomasse %>%
      group_by(site, mois, annee) %>%
      summarise(Eucaryotes = mean(Eucaryotes, na.rm = TRUE), .groups = "drop"),
    by = c("site", "mois", "annee")
  ) %>%
  left_join(
    biomasse %>%
      select(site, mois, annee, NO3, NO2, NH4, TEMPERATURE) %>%
      distinct() %>%
      mutate(azote_total = NO3 + NO2 + NH4) %>%
      select(site, mois, annee, azote_total, TEMPERATURE),
    by = c("site", "mois", "annee")
  ) %>%
  left_join(
    cycle_saisonniertot %>%
      rename(mois = Mois, annee = Année, Zoo = Biomasse_Moyennezoo_N) %>%
      mutate(mois = as.numeric(mois), annee = as.numeric(annee), site = "Marseille"),
    by = c("site", "mois", "annee")
  ) %>%
  left_join(
    merged_plot_df %>%
      filter(site != "Marseille") %>%
      rename(mois = Mois, annee = Année, µphyto = Biomass_mmolN_m3) %>%
      mutate(mois = as.numeric(mois), annee = as.numeric(annee)) %>%
      select(site, mois, annee, µphyto),
    by = c("site", "mois", "annee")
  ) %>%
  left_join(
    biomasse %>%
      group_by(site, mois, annee) %>%
      summarise(CHLA = mean(CHLA, na.rm = TRUE), .groups = "drop"),
    by = c("site", "mois", "annee")
  )

write.csv(observation, "../outputs/tables/observation_monthly.csv", row.names = FALSE)

### 2. Construction du dataframe observation journalier ###
observation2 <- biomasse %>%
  filter(GROUPE %in% c("HNABACC", "LNABACC", "SYNC")) %>%
  mutate(GROUPE = recode(GROUPE,
                         "HNABACC" = "HNA",
                         "LNABACC" = "LNA",
                         "SYNC" = "cyanobactéries")) %>%
  group_by(site, jour_annee, GROUPE) %>%
  summarise(BIOMASSE = mean(BIOMASS_TOTALE_MMN, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = GROUPE, values_from = BIOMASSE) %>%
  left_join(
    biomasse %>%
      group_by(site, jour_annee) %>%
      summarise(Eucaryotes = mean(Eucaryotes, na.rm = TRUE), .groups = "drop"),
    by = c("site", "jour_annee")
  ) %>%
  left_join(
    biomasse %>%
      select(site, jour_annee, NO3, NO2, NH4, TEMPERATURE) %>%
      distinct() %>%
      mutate(azote_total = NO3 + NO2 + NH4) %>%
      select(site, jour_annee, azote_total, TEMPERATURE),
    by = c("site", "jour_annee")
  )

write.csv(observation2, "../outputs/tables/observation_daily.csv", row.names = FALSE)
save(observation, observation2, file = "../outputs/tables/observation.RData")
