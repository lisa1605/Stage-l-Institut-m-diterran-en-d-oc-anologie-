###############################################################
# Script 06c : Visualisations des biomasses
# Auteur : Lisa Tardivel
# Description :
#   - Barplots annuels par groupe et site
#   - Séries temporelles (jour de l’année)
###############################################################

library(ggplot2)
library(dplyr)
library(lubridate)

load("../outputs/tables/biomass_carbon_nitrogen.RData")
load("../outputs/tables/biomass_stats.RData")

### 1. Barplot annuel ###
ggplot(moyenne_finale, aes(x = GROUPE, y = moyenne_annuelle, fill = site)) +
  geom_col(position = position_dodge(width = 0.9)) +
  geom_errorbar(aes(ymin = moyenne_annuelle - sd_annuelle,
                    ymax = moyenne_annuelle + sd_annuelle),
                position = position_dodge(width = 0.9),
                width = 0.2) +
  labs(
    x = "Groupe microbien",
    y = "Biomasse annuelle moyenne (mmol N/m³)",
    title = "Biomasse moyenne annuelle ± écart-type par site et par groupe"
  ) +
  theme_minimal()

### 2. Séries journalières ###
biomasse <- biomasse %>%
  mutate(jour_annee = yday(DATE))

biomasse_plot <- biomasse %>%
  filter(!GROUPE %in% c("PICOEC", "NANOEC", "PROC", "CRYC"))

ggplot(biomasse_plot, aes(x = jour_annee, y = BIOMASS_TOTALE_MMN, color = site)) +
  geom_point(alpha = 0.3, size = 1) +
  geom_smooth(method = "loess", span = 0.2, se = TRUE, size = 1) +
  facet_wrap(~ GROUPE, scales = "free_y") +
  scale_x_continuous(breaks = seq(0, 360, by = 30)) +
  coord_cartesian(ylim = c(0, NA)) +
  labs(
    title = "Dynamique saisonnière moyenne de la biomasse (mmolN/m³)",
    x = "Jour de l'année", y = "Biomasse totale (mmolN/m³)", color = "Site"
  ) +
  theme_minimal() +
  theme(legend.position = "top")
