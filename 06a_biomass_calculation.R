###############################################################
# Script 06a : Calculs de biomasse (Carbone, Azote)
# Auteur : Lisa Tardivel
# Description :
#   - Définition des volumes cellulaires moyens par groupe
#   - Conversion en biomasse carbone et azote
#   - Filtrage des valeurs aberrantes
###############################################################

library(dplyr)
library(tidyr)

load("../outputs/tables/data_fusion.RData")

### 1. Volumes moyens (µm³/cellule) ###
volumes <- data.frame(
  GROUPE = c("PROC", "SYNC", "PICOEC", "NANOEC", "CRYC", "LNABACC", "HNABACC"),
  VOLUME_CELL = c(0.12, 0.24, 2.14, 100, 523, 0.05, 0.06)
)

### 2. Calculs de biomasse ###
biomasse <- data_fusion %>%
  select(-matches("FLR$|FLO$|FLV$")) %>%
  pivot_longer(
    cols = any_of(c("PROC", "SYNC", "PICOEC", "NANOEC", "CRYC", "LNABACC", "HNABACC")),
    names_to = "GROUPE", values_to = "ABONDANCE"
  ) %>%
  left_join(volumes, by = "GROUPE") %>%
  mutate(
    BIOMASS_CARBONE = case_when(
      GROUPE == "SYNC" ~ 0.12,  # valeur fixe Synechococcus
      grepl("BACC", GROUPE) ~ 0.12 * VOLUME_CELL^0.72,
      TRUE ~ 0.35 * VOLUME_CELL^0.90
    ),
    BIOMASS_TOTALE = BIOMASS_CARBONE * ABONDANCE,
    BIOMASS_TOTALE_UMOL = BIOMASS_TOTALE * 8.333e-5,  # pgC → µmolC
    BIOMASS_TOTALE_MMN = case_when(
      GROUPE %in% c("HNABACC", "LNABACC") ~ BIOMASS_TOTALE * 1.515e-5,  # C:N bactéries = 5.5
      TRUE ~ BIOMASS_TOTALE * 1.258e-5  # C:N phyto = 6.625
    )
  ) %>%
  filter(!(GROUPE == "NANOEC" & BIOMASS_TOTALE > 175000))

save(biomasse, file = "../outputs/tables/biomass_carbon_nitrogen.RData")
