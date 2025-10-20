#Calcule de l'erreur moyenne quadratique 

def calculer_rmse(obs_site, sol, var_obs, idx_mod, t, couleurs, site):
    """
    Calcule et affiche la RMSE entre observations et modèle pour une variable donnée.
    
    obs_site : dataframe des observations pour un site
    sol      : solution du modèle
    var_obs  : nom de la colonne dans obs_site (ex: "cyanobactéries")
    idx_mod  : index de la variable modélisée dans sol.y (ex: 0 pour Pcyano)
    t        : temps du modèle (jours)
    couleurs : dictionnaire de couleurs
    site     : nom du site
    """
    # Associer mois -> jour (centre du mois)
    obs_valid = obs_site[["mois", var_obs]].dropna().copy()
    obs_valid["jour"] = obs_valid["mois"] * 30 - 15

    # Extraire les valeurs modélisées aux jours des observations
    model_interp = np.interp(obs_valid["jour"], t-720, sol.y[idx_mod][-1440:-1])

    # Calcul RMSE
    rmse = np.sqrt(np.mean((obs_valid[var_obs] - model_interp)**2))
    
    print(f"RMSE {var_obs} ({site}): {rmse:.3f} mmolN/m³")

    return rmse
