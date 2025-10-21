# Analyse SOMLIT – Piconano, Hydrologie / PHYTOBS - Phytoplancton / Zoonet 


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
- calculer les **biomasses microbiennes** à partir des volumes cellulaires moyens et des abondances, en les exprimant en carbone et azote selon les relations allométriques issues de la littérature (Menden-Deuer & Lessard, 2000 ; Bertilsson et al., 2003 ; Godwin et al., 2015) ;  
- comparer les **dynamiques saisonnières de biomasse** entre sites et groupes microbiens (bactéries hétérotrophes, cyanobactéries, eucaryotes) afin d’évaluer leurs contributions relatives à la productivité primaire.
- intégrer les données **PHYTOBS** de microphytoplancton pour compléter les observations SOMLIT, en estimant leurs biomasses saisonnières (mmol N/m³) et en comparant les cycles entre Banyuls, Marseille et Villefranche.
- intégrer les données **ZOOScan** pour caractériser la **biomasse et la structure de taille du zooplancton**,  et comparer leurs variations saisonnières à celles des communautés microbiennes et phytoplanctoniques.  



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
| **7a** | `07a_phyto_import_cleaning.R` | Importation, harmonisation et nettoyage des jeux de données PHYTOBS pour Banyuls, Marseille et Villefranche. |
| **7b** | `07b_phyto_biomass_conversion.R` | Calcul des abondances mensuelles moyennes et conversion en biomasses (pgC/L puis mmol N/m³). |
| **7c** | `07c_phyto_visualisations.R` | Visualisations des cycles saisonniers des biomasses phytoplanctoniques avec lissage LOESS et intervalles de confiance. |


---

##  Données utilisées

| Type | Description | Source |
|------|--------------|--------|
| **Piconano** | Données de cytométrie en flux (abondances, FLR, SSC, groupes microbiens) | SOMLIT |
| **Hydrologie** | Température, salinité, oxygène, nutriments (NO₃⁻, NH₄⁺, PO₄³⁻, SiOH₄) | SOMLIT |
| **Biomasses** | Biomasses microbiennes calculées à partir des abondances et tailles cellulaires | Calculées ou observées localement |
| **PHYTOBS** | Comptages de microphytoplancton (>10 µm) par taxon et par site (Banyuls, Marseille, Villefranche), utilisés pour estimer la biomasse phytoplanctonique saisonnière. | Réseau national PHYTOBS |
| **ZOOScan** | Données d’imagerie zooplanctonique (biomasse totale et par classe de taille) issues d’analyses semi-automatisées à Marseille, converties en mmol N/m³ pour l’étude des cycles saisonniers. | Plateforme ZOOScan – MIO |








