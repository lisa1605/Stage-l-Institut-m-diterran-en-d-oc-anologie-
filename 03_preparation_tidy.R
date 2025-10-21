###############################################################
# Script 03 : Préparation des jeux tidy (nutriments, abondances, diffusion)
# Auteur : Lisa Tardivel
# Description :
#   - Passage au format long pour les variables
#   - Ajout des colonnes temporelles et catégorielles
###############################################################

library(dplyr)
library(tidyr)
library(lubridate)

# ---- Chargement ----
load("../outputs/tables/data_fusion.RData")

# ---- 1. Nutriments ----
nutrients <- c("NH4", "NO3", "NO2", "PO4", "SIOH4")
nutri <- hydrosurf %>% select(all_of(nutrients))

data_nutri <- cbind(hydrosurf[, 1:10], nutri) %>%
  pivot_longer(cols = 11:15, names_to = "NUTRIMENT", values_to = "CONCENTRATION")

# ---- 2. Abondances ----
abondances <- c("TBACC", "HNABACC", "LNABACC", "CRYC", "SYNC", "PROC", "PICOEC", "NANOEC")
dat_ab <- cbind(piconano[, 1:10], piconano %>% select(all_of(abondances))) %>%
  pivot_longer(cols = 11:18, names_to = "GROUPE", values_to = "ABONDANCE")

# ---- 3. Diffusion lumineuse ----
diff_lum <- c("TBACSSC", "HNABACSSC", "LNABACSSC", "CRYSSC", "SYNSSC", "PROSSC", "PICOESSC", "NANOESSC")
dat_diff <- cbind(piconano[, 1:10], piconano %>% select(all_of(diff_lum))) %>%
  pivot_longer(cols = 11:18, names_to = "GROUPE", values_to = "DIFFUSION")

# ---- 4. Ajout des métadonnées temporelles ----
get_season <- function(month) {
  case_when(
    month %in% c("déc", "janv", "févr") ~ "hiver",
    month %in% c("mars", "avr", "mai")  ~ "printemps",
    month %in% c("juin", "juil", "août") ~ "été",
    month %in% c("sept", "oct", "nov")  ~ "automne"
  )
}

data_fusion <- data_fusion %>%
  mutate(
    DATE = as.Date(DATE, format = "%d/%m/%Y"),
    mois = month(DATE, label = TRUE, abbr = TRUE) %>% as.character(),
    annee = year(DATE),
    site = case_when(
      ID_SITE == 10 ~ "Banyuls",
      ID_SITE == 11 ~ "Marseille",
      ID_SITE == 12 ~ "Villefranche"
    ),
    saison = get_season(as.character(mois))
  )

# ---- Sauvegarde finale ----
save(data_fusion, data_nutri, dat_ab, dat_diff, file = "../outputs/tables/data_tidy.RData")
