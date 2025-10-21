#  Analyse SOMLIT – Fusion Piconano & Hydrologie

### Auteur
**Lisa Tardivel**  
Institut Méditerranéen d’Océanographie (MIO), Aix-Marseille Université  

---

## Objectif
Ce projet a pour but de préparer, fusionner et structurer les données SOMLIT issues :
- de la cytométrie en flux (piconano),
- et des paramètres hydrologiques de surface (hydro).

Les jeux de données obtenus sont destinés à des analyses écologiques :  
corrélations, PCA, NMDS, relations nutriments–abondance, etc.

---

## Étapes principales
| Étape | Script | Description |
|-------|---------|-------------|
| 1 | `01_import_cleaning.R` | Importation, nettoyage, harmonisation des données |
| 2 | `02_data_fusion.R` | Fusion des jeux piconano & hydro, nettoyage et renommage |
| 3 | `03_preparation_tidy.R` | Format long pour les nutriments, abondances et diffusion, ajout des métadonnées temporelles |


