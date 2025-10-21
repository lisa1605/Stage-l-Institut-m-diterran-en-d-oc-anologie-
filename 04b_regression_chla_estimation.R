###############################################################
# Script 04b : Régression FLR–CHLA et conversion en mmolN/m³
# Auteur : Lisa Tardivel
###############################################################

library(dplyr)
library(tidyr)
library(purrr)

load("../outputs/tables/flr_cleaned.RData")

### 1. Corrélation et régression par site ###
correlation_by_site <- flrdata %>%
  group_by(site) %>%
  summarise(Correlation = cor(FLR_total_L, CHLA, use = "pairwise.complete.obs", method = "spearman"))

print(correlation_by_site)

reg_par_site <- flrdata %>%
  group_by(site) %>%
  summarise(a = coef(lm(CHLA ~ 0 + FLR_total_L))[1], .groups = "drop")

### 2. Estimation CHLA par groupe ###
flrdata <- flrdata %>%
  left_join(reg_par_site, by = "site") %>%
  mutate(
    CHLA_CRY = a * FLR_total_CRY,
    CHLA_SYN = a * FLR_total_SYN,
    CHLA_PRO = a * FLR_total_PRO,
    CHLA_PICOE = a * FLR_total_PICOE,
    CHLA_NANOE = a * FLR_total_NANOE,
    CHLA_total_estimee = CHLA_CRY + CHLA_SYN + CHLA_PRO + CHLA_PICOE + CHLA_NANOE
  )

### 3. Conversion µg/L → mmolN/m³ ###
ratio_chlC <- 0.03
CN_ratio <- 6.6

flrdata <- flrdata %>%
  mutate(CHLA_mmolN_m3 = (CHLA_total_estimee / ratio_chlC) / 12 / CN_ratio)

save(flrdata, file = "../outputs/tables/flr_chla_estimated.RData")
