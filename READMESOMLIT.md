# Analyse SOMLIT – Piconano, Hydrologie 

###  Auteur  
**Lisa Tardivel**  
Institut Méditerranéen d’Océanographie (MIO), Aix-Marseille Université  
Projet de modélisation 0D – Dynamiques saisonnières microbiennes en Méditerranée

---

##  Objectif du projet

Ce dépôt contient l’ensemble du pipeline R permettant de :

- importer, nettoyer et fusionner les données **SOMLIT** de cytométrie en flux (*piconano*) et d’hydrologie (température, salinité, oxygène, nutriments) ;
- transformer ces jeux en formats **tidy** pour analyses écologiques ;
- estimer la **chlorophylle-a** à partir de la **fluorescence rouge (FLR)** et convertir les résultats en biomasses (mmolN/m³) ;
- visualiser les dynamiques saisonnières par site, groupe microbien et indicateur biogéochimique.

---

## Étapes principales du pipeline

| Étape | Script | Description |
|-------|---------|-------------|
| **1** | `01_import_cleaning.R` | Importation des fichiers SOMLIT (piconano & hydro), harmonisation des formats et nettoyage des valeurs aberrantes. |
| **2** | `02_data_fusion.R` | Fusion des jeux *piconano* et *hydro* (surface uniquement), sélection des variables utiles et renommage cohérent. |
| **3** | `03_preparation_tidy.R` | Mise au format *tidy* des données (nutriments, abondances, diffusion lumineuse) et ajout des métadonnées temporelles (mois, saison, site). |
| **4a** | `04a_fluorescence_cleaning.R` | Extraction des colonnes de **fluorescence rouge (FLR)**, suppression des valeurs extrêmes, calcul des FLR moyens par site et totaux. |
| **4b** | `04b_regression_chla_estimation.R` | Régression entre FLR et **chlorophylle-a (CHLA)** par site, estimation de la CHLA par groupe et conversion en mmolN/m³. |
| **4c** | `04c_biomass_adjustment.R` | Ajustement des biomasses eucaryotes à partir du ratio FLR/Biomasse calculé sur *Synechococcus*. |
| **5** | `05_visualisations.R` | Génération des graphiques : dynamiques saisonnières FLR, CHLA (mesurée/estimée) et biomasses ajustées (mensuelles ou journalières). |
| **6a** | `06a_biomass_calculation.R` | Calcul des biomasses carbone et azote à partir des abondances et volumes cellulaires moyens. |
| **6b** | `06b_biomass_statistics.R` | Calcul des moyennes mensuelles et annuelles, ainsi que des écarts-types par groupe microbien et par site. |
| **6c** | `06c_biomass_visualisations.R` | Visualisations des biomasses : barplots annuels, séries journalières et dynamiques saisonnières des principaux groupes microbiens. |

---

##  Données utilisées

| Type | Description | Source |
|------|--------------|--------|
| **Piconano** | Données de cytométrie en flux (abondances, FLR, SSC, groupes microbiens) | SOMLIT |
| **Hydrologie** | Température, salinité, oxygène, nutriments (NO₃⁻, NH₄⁺, PO₄³⁻, SiOH₄) | SOMLIT |
| **Biomasses** | Biomasses microbiennes calculées à partir des abondances et tailles cellulaires | Calculées ou observées localement |





