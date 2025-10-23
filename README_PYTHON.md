# Stage-l-Institut-mediterraneen d oceanologie-
Seasonal microbial ecosystem model – Mediterranean Sea (Python, SciPy, Matplotlib)

# Modélisation saisonnière des communautés microbiennes en Méditerranée

Ce dépôt présente un modèle 0D de dynamique saisonnière pour trois stations SOMLIT (Banyuls, Marseille, Villefranche).  
Le modèle couple phytoplancton, bactéries hétérotrophes, zooplancton, nutriments et matière organique.

 Objectif
- Simuler les variations saisonnières de biomasse microbienne.
- Comparer les résultats modélisés aux observations in situ.
- Quantifier les erreurs par RMSE et visualiser les dynamiques.

 Technologies
- **Langage** : Python (3.10+)
- **Bibliothèques principales** : NumPy, Pandas, SciPy, Matplotlib

 Organisation
- `main_model.py` : script principal contenant les équations différentielles.
- `data/` : fichiers d’observation et de chlorophylle.
- `notebooks/` : analyses complémentaires ou visualisations.
- `figures/` : sorties graphiques du modèle.

##  Résultats

Les figures ci-dessous présentent les dynamiques saisonnières simulées par le modèle 0D et leur comparaison avec les observations issues de l’analyse et du traitement des données sur R.  

**Légende :**  
- **Lignes continues** = valeurs modélisées par le modèle écologique différentiel.  
- **Lignes pointillées** = observations issues des jeux de données (SOMLIT, PHYTOBS, cytométrie, etc.) après traitement sous R.  

### 1. Phytoplancton, Zooplancton et Chlorophylle a
- Biomasses simulées et observées des principaux groupes phytoplanctoniques (cyanobactéries, eucaryotes, microphytoplancton) et du zooplancton.  
- Comparaison des concentrations de chlorophylle a modélisées vs observées (courbes LOESS).

![Phytoplancton, Zooplancton & Chlorophylle a](figures/phytozooXchloromêmeehelle.png)

### 2. Bactéries hétérotrophes et Nutriments
- Dynamique des bactéries hétérotrophes (HNA, LNA) comparées aux observations.  
- Évolution des nutriments et de la matière organique dissoute, modélisés vs observés.

![Bactéries & Nutriments](figures/bacterieXnutMO.png)
