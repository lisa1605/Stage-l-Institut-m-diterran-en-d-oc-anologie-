###############################################################
# Script 04a : Nettoyage et calculs FLR
# Auteur : Lisa Tardivel
# Description :
#   - Extraction des colonnes FLR
#   - Suppression des valeurs extrêmes (outliers)
#   - Moyenne FLR par site et calcul des FLR totaux
###############################################################

library(dplyr)
library(tidyr)
library(lubridate)

load("../outputs/tables/data_fusion.RData")

### 1. Extraction FLR et variables associées ###
flrdata <- data_fusion %>%
  select(matches("FLR$"), DATE, site, CHLA, annee, mois,
         PROC, SYNC, CRYC, PICOEC, NANOEC)

### 2. Fonction de nettoyage des valeurs extrêmes ### 
replace_outliers <- function(df, var) {
  Q1 <- quantile(df[[var]], 0.25, na.rm = TRUE)
  Q3 <- quantile(df[[var]], 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  lower <- Q1 - 2 * IQR
  upper <- Q3 + 2 * IQR
  df %>% mutate(!!sym(var) :=
                  ifelse(.data[[var]] < lower | .data[[var]] > upper, NA, .data[[var]]))
}

# Application uniquement à CHLA
flrdata <- flrdata %>%
  mutate(across(CHLA, ~ replace_outliers(flrdata, cur_column())[[cur_column()]]))

### 3. Moyennes FLR par site ###
flr_moyens <- flrdata %>%
  group_by(site) %>%
  summarise(across(ends_with("FLR"), ~ mean(.x, na.rm = TRUE), .names = "FLR_moy_{col}"))

### 4. Calcul FLR totaux ###
flrdata <- flrdata %>%
  left_join(flr_moyens, by = "site") %>%
  mutate(
    FLR_total_CRY   = FLR_moy_CRYFLR   * CRYC   * 1000,
    FLR_total_SYN   = FLR_moy_SYNFLR   * SYNC   * 1000,
    FLR_total_PRO   = FLR_moy_PROFLR   * PROC   * 1000,
    FLR_total_PICOE = FLR_moy_PICOEFLR * PICOEC * 1000,
    FLR_total_NANOE = FLR_moy_NANOEFLR * NANOEC * 1000,
    FLR_total_L     = rowSums(across(starts_with("FLR_total_")), na.rm = TRUE)
  )

save(flrdata, file = "../outputs/tables/flr_cleaned.RData")
