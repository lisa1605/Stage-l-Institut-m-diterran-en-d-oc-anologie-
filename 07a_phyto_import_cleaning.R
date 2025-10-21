###############################################################
# Script 07a : Importation et nettoyage des données PHYTOBS
# Auteur : Lisa Tardivel
# Description :
#   - Lecture des jeux de données PHYTOBS (Banyuls, Marseille, Villefranche)
#   - Filtrage et harmonisation des colonnes
#   - Préparation des dates et métadonnées temporelles
###############################################################

library(tidyverse)
library(lubridate)

setwd("C:/Users/Lisa/Desktop/stage/données/données phytobs")

### 1. Importation des fichiers ###
Banyuls <- read.csv("Banyuls-Phytobs.csv", sep = ";", header = TRUE, stringsAsFactors = FALSE)
Villefranche <- read.csv("Villefranche-Phytobs.csv", sep = ";", header = TRUE, stringsAsFactors = FALSE)
Marseille <- read.csv("Marseille-Phytobs.csv", sep = ";", header = TRUE, stringsAsFactors = FALSE)

### 2. Fonction de préparation ###
prepare_data <- function(df) {
  df %>%
    rename(Date = sampling_date) %>%
    mutate(
      Date = as.Date(Date, format = "%d/%m/%Y"),
      Année = year(Date),
      Mois = month(Date, label = TRUE, abbr = TRUE)
    )
}

### 3. Application ###
Banyuls <- prepare_data(Banyuls)
Villefranche <- prepare_data(Villefranche)
Marseille <- prepare_data(Marseille) %>%
  filter(!taxonomic_group %in% c("Chromista", "Chrysophyceae"))

save(Banyuls, Marseille, Villefranche, file = "../outputs/tables/phyto_clean.RData")
