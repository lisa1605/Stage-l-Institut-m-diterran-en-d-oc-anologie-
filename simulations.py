from scipy.integrate import solve_ivp
import numpy as np
from src.model_equations import make_F_P
from src.forcingfunctions import temperature_saisonniere, C_saisonnier, irradiance_saisonniere
from src.constantes import Period, N0


def run_model_for_sites(sites):
    """
    Exécute le modèle écologique différentiel pour chaque site défini dans 'sites'.

    Parameters
    ----------
    sites : dict
        Dictionnaire contenant les paramètres de température, flux et irradiance pour chaque station.

    Returns
    -------
    results : dict
        Dictionnaire contenant, pour chaque site :
        - la solution du modèle (sol)
        - la température saisonnière (T)
        - la constante de rappel saisonnière (C_values)
        - l’irradiance saisonnière (iparz0)
    """

    results = {}

    for site, params in sites.items():
        print(f"Simulation en cours pour {site}...")

        # --- Récupération des paramètres du site ---
        Tmin = params["Tmin"]
        Tmax = params["Tmax"]
        phiT = params["phiT"]
        Cmin = params["Cmin"]
        Cmax = params["Cmax"]
        phiF = params["phiF"]
        I0 = params["I0"]
        obl_deg = params["obl_deg"]
        lat_deg = params["lat_deg"]
        phiI = params["phiI"]

        # --- Calcul des forçages saisonniers ---
        t = np.linspace(0, Period, Period)
        T = [temperature_saisonniere(ti, Tmin, Tmax, Period, phiT) for ti in t]
        C_values = [C_saisonnier(ti, Cmin, Cmax, Period, phiF) for ti in t]
        iparz0 = irradiance_saisonniere(I0, obl_deg, lat_deg, Period, phiI)

        # --- Conditions initiales ---
        u0 = [0.05] * 9  # 9 compartiments (Pcyano, Peuk, Pµphyt, Z, BLNA, BHNA, N, Dlab, Dsemlab)

        # --- Création du modèle différentiel ---
        F_P_site = make_F_P(T, C_values, N0, iparz0)

        # --- Intégration sur 3 années (1080 jours) ---
        sol = solve_ivp(
            F_P_site,
            (0, 1080),
            u0,
            t_eval=np.linspace(0, 1080, 4320),
            method='RK45'
        )

        # --- Stockage des résultats ---
        results[site] = {
            "sol": sol,
            "T": T,
            "flux": C_values,
            "irradiance": iparz0
        }

    print("Simulation terminée pour tous les sites.")
    return results
