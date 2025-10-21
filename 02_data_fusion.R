###############################################################
# Script 02 : Fusion des données PICONANO & HYDRO
# Auteur : Lisa Tardivel
# Description :
#   - Jointure sur les colonnes communes
#   - Nettoyage des doublons et renommage des variables clés
###############################################################

library(dplyr)
library(tidyr)
library(naniar)

# ---- Chargement des données nettoyées ----
load("../outputs/tables/data_clean.RData")

# ---- Fusion par ID_SITE, DATE et HEURE ----
data_fusion <- left_join(piconano, hydrosurf, by = c("ID_SITE", "DATE", "HEURE"))

# ---- Suppression des colonnes inutiles ----
data_fusion <- data_fusion %>%
  select(-c(COEF_MAREE.x, COEF_MAREE.y, MAREE.x, MAREE.y,
            PROF_TEXT.y, 'nomSite*.y', 'gpsLat*.y', 'gpsLong*.y',
            'gpsLat*.x', 'gpsLong*.x', PROF_NUM.x, PROF_NUM.y)) %>%
  select(-matches("^q"))

# ---- Renommage pour cohérence ----
data_fusion <- data_fusion %>%
  rename(
    TEMPERATURE = "TRUE",
    SALINITE = "S",
    OXYGENE = "O"
  )

# ---- Sauvegarde ----
save(data_fusion, file = "../outputs/tables/data_fusion.RData")
