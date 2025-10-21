###############################################################
# Script 07c : Visualisation des biomasses PHYTOBS
# Auteur : Lisa Tardivel
# Description :
#   - Graphiques des abondances et biomasses moyennes
#   - Lissage LOESS + intervalles de confiance
###############################################################

library(tidyverse)
load("../outputs/tables/phyto_biomass.RData")

month_levels <- c("janv", "févr", "mars", "avr", "mai", "juin",
                  "juil", "août", "sept", "oct", "nov", "déc")

### 1. Graphique de biomasse ###
ggplot(merged_plot_df, aes(x = Mois_num, y = Biomass_mmolN_m3, color = Site)) +
  geom_point() +
  geom_smooth(method = "loess", se = TRUE) +
  scale_x_continuous(breaks = 1:12, labels = month_levels) +
  labs(
    title = "Cycle saisonnier moyen des biomasses phytoplanctoniques (mmol N/m³)",
    x = "Mois", y = "Biomasse moyenne (mmol N/m³)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

### 2. Lissage manuel avec IC ###
smooth_data <- merged_plot_df %>%
  group_by(Site) %>%
  do({
    mod <- loess(Biomass_mmolN_m3 ~ Mois_num, data = ., span = 0.75)
    pred <- predict(mod, se = TRUE)
    tibble(
      Mois_num = .$Mois_num, Site = .$Site,
      fit = pmax(pred$fit, 0),
      ymin = pmax(pred$fit - 1.96 * pred$se.fit, 0),
      ymax = pmax(pred$fit + 1.96 * pred$se.fit, 0)
    )
  })

ggplot() +
  geom_point(data = merged_plot_df, aes(x = Mois_num, y = Biomass_mmolN_m3, color = Site)) +
  geom_ribbon(data = smooth_data, aes(x = Mois_num, ymin = ymin, ymax = ymax, fill = Site), alpha = 0.2) +
  geom_line(data = smooth_data, aes(x = Mois_num, y = fit, color = Site)) +
  scale_x_continuous(breaks = 1:12, labels = month_levels) +
  labs(
    title = "Cycle saisonnier moyen des biomasses phytoplanctoniques (mmol N/m³)",
    x = "Mois", y = "Biomasse moyenne (mmol N/m³)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
