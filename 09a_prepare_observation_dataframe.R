###############################################################
# Script 09a : Création du dataframe "observation" pour le modèle Python
# Auteur : Lisa Tardivel
# Description :
#   - Conversion des mois en valeurs numériques
#   - Calcul des moyennes mensuelles et journalières de la CHLA
#   - Fusion des données SOMLIT, PHYTOBS et ZOOScan
###############################################################

library(tidyverse)
library(lubridate)

### 1. Conversion du mois en numérique
mois_noms <- c("janv" = 1, "févr" = 2, "mars" = 3, "avr" = 4, "mai" = 5, "juin" = 6,
               "juil" = 7, "août" = 8, "sept" = 9, "oct" = 10, "nov" = 11, "déc" = 12)

biomasse <- biomasse %>%
  mutate(
    mois = mois_noms[mois],
    annee = as.numeric(annee)
  )

### 2. CHLA moyenne mensuelle
chla_mesuree_moyenne <- flrdata %>%
  group_by(mois, DATE, annee, site) %>%
  summarise(CHLA_moy_mesuree = mean(CHLA, na.rm = TRUE), .groups = "drop") %>%
  mutate(
    mois = mois_noms[mois],
    annee = as.numeric(annee)
  )

### 3. CHLA moyenne journalière
chla_jour_moy <- flrdata %>%
  group_by(site, jour_annee) %>%
  summarise(CHLA_moy_jour = mean(CHLA, na.rm = TRUE), .groups = "drop")

save(chla_mesuree_moyenne, chla_jour_moy, file = "../outputs/tables/chla_moy.RData")
