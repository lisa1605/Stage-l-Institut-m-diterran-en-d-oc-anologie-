###############################################################
# Script 08c : Visualisations des biomasses zooplanctoniques
# Auteur : Lisa Tardivel
# Description :
#   - Cycle saisonnier total du zooplancton
#   - Distribution par classes de taille
###############################################################

library(tidyverse)
load("../outputs/tables/zoo_biomass.RData")

### 1. Cycle saisonnier total ###
ggplot(cycle_saisonniertot, aes(x = Mois, y = Biomasse_Moyennezoo_N, group = 1)) +
  geom_point(size = 2, alpha = 0.5) +
  geom_smooth(method = "loess", span = 0.5, se = TRUE, color = "lightgreen", size = 1.2) +
  labs(
    title = "Cycle saisonnier de la biomasse totale du zooplancton à Marseille (mmol N/m³)",
    x = "Mois", y = "Biomasse moyenne (mmol N/m³)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

### 2. Par classes de taille ###
ggplot(cycle_saisonnier_taille, aes(x = Mois, y = Biomasse_Moyenne, color = Classe_Taille)) +
  geom_point(size = 1.5, alpha = 0.6) +
  geom_smooth(method = "loess", span = 0.5, se = TRUE, size = 1.2) +
  facet_wrap(~Classe_Taille, scales = "free_y") +
  labs(
    title = "Cycle saisonnier de la biomasse du zooplancton par classe de taille (Marseille)",
    x = "Mois", y = "Biomasse moyenne (mg DW/m³)", color = "Classe de taille"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "top")
