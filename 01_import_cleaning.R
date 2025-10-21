###############################################################
# Script 01 : Importation et nettoyage des données SOMLIT
# Auteur : Lisa Tardivel
# Date : 2025-01-21
# Description :
#   - Import des fichiers SOMLIT piconano & hydro
#   - Attribution des en-têtes
#   - Nettoyage des valeurs manquantes et formatage des dates
###############################################################

# ---- Librairies ----
library(dplyr)
library(tidyr)
library(readr)
library(lubridate)
library(naniar)

# ---- Dossier de travail ----
setwd("C:/Users/Lisa/Desktop/stage/données")

# ---- Importation PICONANO ----
titrcol <- read.csv("Somlit_Extraction_piconano_20250121_163406_25af863e759b5434.csv",
                    skip = 2, sep = ";", nrows = 1, header = FALSE, stringsAsFactors = FALSE)

piconano <- read.csv("Somlit_Extraction_piconano_20250121_163406_25af863e759b5434.csv",
                     skip = 4, sep = ";", header = FALSE, stringsAsFactors = FALSE)

# ---- Importation HYDRO ----
titrcol2 <- read.csv("Somlit_Extraction_hydro_210125.csv.csv",
                     skip = 2, sep = ";", nrows = 1, header = FALSE, stringsAsFactors = FALSE)

hydro <- read.csv("Somlit_Extraction_hydro_210125.csv.csv",
                  skip = 4, sep = ";", header = FALSE, stringsAsFactors = FALSE)

# ---- Attribution des noms de colonnes ----
colnames(hydro) <- titrcol2
colnames(piconano) <- unlist(titrcol)

# ---- Formats de dates et types ----
piconano$DATE <- as.Date(piconano$DATE, format = "%d/%m/%Y")
hydro$DATE <- as.Date(hydro$DATE, format = "%Y-%m-%d")
piconano$ID_SITE <- as.character(piconano$ID_SITE)
hydro$ID_SITE <- as.character(hydro$ID_SITE)

# ---- Sélection surface uniquement ----
hydrosurf <- hydro %>% filter(PROF_TEXT == "S")

# ---- Traitement des valeurs manquantes ----
hydrosurf <- hydrosurf %>% replace_with_na_all(condition = ~.x == 999999)
piconano  <- piconano %>% replace_with_na_all(condition = ~.x == 999999)

# ---- Sauvegarde intermédiaire ----
save(piconano, hydrosurf, file = "../outputs/tables/data_clean.RData")
