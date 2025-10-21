###############################################################
# Script 05 : Visualisations FLR, CHLA et biomasse
# Auteur : Lisa Tardivel
# Description :
#   - Visualisation LOESS de FLR et CHLA
#   - Graphiques saisonniers et jour de l’année
#   - Comparaison chlorophylle mesurée vs estimée
###############################################################

library(ggplot2)
library(dplyr)
library(lubridate)
library(purrr)
library(tidyr)

load("../outputs/tables/flrdata_processed.RData")
load("../outputs/tables/data_fusion.RData")
# load("../outputs/tables/biomasse.RData")

#############################
# 1. FLR total moyen par mois et site
#############################

flr_total_moyenne <- flrdata %>%
  group_by(mois, annee, site) %>%
  summarise(FLR_moy = mean(FLR_total_L, na.rm = TRUE), .groups = "drop")

flr_total_moyenne$mois <- factor(flr_total_moyenne$mois,
                                 levels = c("janv","févr","mars","avr","mai","juin",
                                            "juil","août","sept","oct","nov","déc"))

ggplot(flr_total_moyenne, aes(x = mois, y = FLR_moy, color = site)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess", se = TRUE, span = 0.4) +
  theme_minimal() +
  labs(title = "Fluorescence rouge moyenne par mois et par site",
       y = "FLR moyenne", x = "Mois") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#############################
# 2. Chlorophylle estimée vs mesurée
#############################

flr_chla_mesuree <- flrdata %>%
  group_by(mois, annee, site) %>%
  summarise(
    CHLA_moy_mesuree = mean(CHLA, na.rm = TRUE),
    CHLA_moy_estimee = mean(CHLA_total_estimee, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(flr_chla_mesuree, aes(x = mois, color = site)) +
  geom_point(aes(y = CHLA_moy_mesuree), shape = 16, alpha = 0.5) +
  geom_point(aes(y = CHLA_moy_estimee), shape = 1, size = 2) +
  geom_smooth(aes(y = CHLA_moy_mesuree), method = "loess", se = TRUE, span = 0.5) +
  geom_smooth(aes(y = CHLA_moy_estimee), method = "loess", se = TRUE, span = 0.5, linetype = "dashed") +
  facet_wrap(~ site, scales = "free_y") +
  labs(title = "Comparaison CHLA mesurée vs estimée par site",
       y = "Chlorophylle-a (µg/L)", x = "Mois",
       color = "Site") +
  theme_minimal(base_size = 14) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#############################
# 3. Biomasse ajustée des eucaryotes voir script sur les biomasses 
#############################

# (si la table biomasse est chargée)
# euca_long <- biomasse %>%
#   select(annee, mois, DATE, site, Biomass_PICOE_ajustee, Biomass_NANOE_ajustee, Eucaryotes) %>%
#   pivot_longer(cols = c(Biomass_PICOE_ajustee, Biomass_NANOE_ajustee, Eucaryotes),
#                names_to = "GROUPE", values_to = "BIOMASSE") %>%
#   mutate(GROUPE = recode(GROUPE,
#                          "Biomass_PICOE_ajustee" = "Picoeucaryotes",
#                          "Biomass_NANOE_ajustee" = "Nanoeucaryotes",
#                          "Eucaryotes" = "Total eucaryotes"))

# ggplot(euca_long, aes(x = mois, y = BIOMASSE, color = site)) +
#   geom_point(alpha = 0.4) +
#   geom_smooth(method = "loess", se = TRUE, span = 0.3) +
#   facet_wrap(~ GROUPE, scales = "free_y") +
#   labs(title = "Biomasse ajustée des eucaryotes par site",
#        y = "Biomasse ajustée (mmolN/m³)", x = "Mois") +
#   theme_minimal(base_size = 14) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1))
