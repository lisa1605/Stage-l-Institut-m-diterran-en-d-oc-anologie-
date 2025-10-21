###############################################################
# Script 08a : Importation et nettoyage des données ZOOScan
# Auteur : Lisa Tardivel
# Description :
#   - Lecture du fichier brut ZOOScan
#   - Nettoyage des en-têtes et des unités
#   - Mise en forme des dates et des colonnes
###############################################################

library(tidyverse)
library(lubridate)

setwd("C:/Users/Lisa/Desktop/stage/données/données zoo")

### 1. Lecture du fichier brut ###
df <- read.csv("Data_zooplankton2_FC.csv", skip = 3, sep = ",", header = TRUE, stringsAsFactors = FALSE)

### 2. Nettoyage des en-têtes ###
colnames(df) <- df[1, ]
df <- df[-1, ]  # Retirer ligne d'en-tête dupliquée
units <- df[1, ]  # Ligne des unités
df <- df[-1, ]

### 3. Nettoyage des dates ###
df$Datetime <- gsub("T00:00:00", "", df$Datetime)
df$Datetime <- as.Date(df$Datetime, format = "%Y-%m-%d")

### 4. Renommage et nettoyage des colonnes ###
colnames(df) <- trimws(colnames(df))
df <- df %>% rename(Biomasse_totale_zoo = `Total biomass`)

### 5. Ajout des variables temporelles ###
df <- df %>%
  mutate(
    Mois = format(Datetime, "%B"),
    Année = format(Datetime, "%Y")
  )

### 6. Sauvegarde intermédiaire ###
write.csv(df, "Data_zooplankton2_cleaned.csv", row.names = FALSE)
save(df, file = "../outputs/tables/zoo_clean.RData")
