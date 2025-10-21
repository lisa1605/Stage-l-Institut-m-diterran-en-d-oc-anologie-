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
