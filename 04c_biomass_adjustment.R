###############################################################
# Script 04c : Ajustement des biomasses eucaryotes à partir du FLR
# Auteur : Lisa Tardivel
###############################################################

library(dplyr)
library(tidyr)

load("../outputs/tables/flr_chla_estimated.RData")
load("../outputs/tables/biomasse.RData")

### 1. Ratio FLR/Biomasse basé sur Synechococcus ###
coef_SYN <- biomasse %>%
  filter(GROUPE == "SYNC") %>%
  select(DATE, site, BIOMASS_TOTALE_MMN) %>%
  left_join(flrdata %>% select(DATE, site, FLR_total_SYN), by = c("DATE", "site")) %>%
  mutate(ratio_FLR_BIOMASS = BIOMASS_TOTALE_MMN / FLR_total_SYN)

coef_par_site <- coef_SYN %>%
  group_by(site) %>%
  summarise(coef_FLR_BIOMASS = mean(ratio_FLR_BIOMASS, na.rm = TRUE))

### 2. Application du ratio pour ajuster les eucaryotes ###
flr_totaux <- flrdata %>%
  select(DATE, site, FLR_total_PICOE, FLR_total_NANOE)

biomasse <- biomasse %>%
  left_join(flr_totaux, by = c("DATE", "site")) %>%
  left_join(coef_par_site, by = "site") %>%
  mutate(
    Biomass_PICOE_ajustee = FLR_total_PICOE * coef_FLR_BIOMASS,
    Biomass_NANOE_ajustee = FLR_total_NANOE * coef_FLR_BIOMASS,
    Eucaryotes = Biomass_PICOE_ajustee + Biomass_NANOE_ajustee
  )

save(biomasse, coef_par_site, file = "../outputs/tables/biomass_adjusted.RData")
