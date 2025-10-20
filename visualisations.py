

def plot_phyto_zoo_and_chlorophyll_with_obs(results, observation, chla_jour_moy):
    sites = list(results.keys())
    CN_ratio = 6.6
    ratio_chlC = 0.03
    mois_labels = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
                   'Juil', 'Août', 'Sept', 'Oct', 'Nov', 'Déc']
    ticks = np.arange(0, 361, 30)

    # Taille équilibrée + léger resserrement vertical
    fig, axs = plt.subplots(
        nrows=3, ncols=2,
        figsize=(16, 15),
        sharex=True,
        sharey='col',
        gridspec_kw={"hspace": 0.1, "wspace": 0.12}
    )

    for i, site in enumerate(sites):
        sol = results[site]["sol"]
        t3 = sol.t[-1440:-1] - 720

        # --- Colonne 1 : Phyto & Zoo ---
        ax = axs[i, 0]
        for label, idx, color in [
            ("Pcyano modélisé", 0, "orange"),
            ("Peuk modélisé",    1, "blue"),
            ("Pµphyt modélisé",  2, "green"),
            ("Zoo modélisé",     3, "red")
        ]:
            ax.plot(t3, sol.y[idx][-1440:-1], label=label, color=color,linewidth=2.5)

        obs_site = observation[observation["site"] == site].copy()
        obs_site["jour"] = obs_site["mois"] * 30 - 15
        for col_obs, color, label_obs in [
            ("cyanobactéries", "orange", "cyanobactéries obs"),
            ("Eucaryotes",     "blue",   "Eucaryotes obs"),
            ("Zoo",            "red",    "Zoo obs"),
            ("µphyto",         "green",  "µphyto obs")
        ]:
            if col_obs in obs_site.columns:
                df = obs_site[["jour", col_obs]].dropna()
                if not df.empty:
                    sm = lowess(df[col_obs], df["jour"], frac=0.3)
                    ax.plot(sm[:, 0], sm[:, 1], "--", label=label_obs, color=color,linewidth=2.5)

        ax.set_xlim(0, 360)
        ax.set_ylim(0)
        ax.tick_params(axis='y', labelsize=14)
        ax.grid(True)

        # --- Colonne 2 : Chlorophylle ---
        ax2 = axs[i, 1]
        phyto_total_C = (sol.y[0] + sol.y[1] + sol.y[2]) * CN_ratio
        chl3 = phyto_total_C[-1440:-1] * 12.0 * ratio_chlC
        ax2.plot(t3, chl3, label="Chlorophylle modélisée", color="teal",linewidth=2.5)

        df_chl = chla_jour_moy[chla_jour_moy["site"] == site]
        if not df_chl.empty:
            sm = lowess(df_chl["CHLA"], df_chl["jour"], frac=0.5, it=0)
            ax2.plot(sm[:, 0], sm[:, 1], "--", label="CHLA obs ", color="teal",linewidth=2.5)

        ax2.set_xlim(0, 360)
        ax2.set_ylim(0)
        ax2.tick_params(axis='y', labelsize=14)
        ax2.grid(True)

    # Titres des colonnes
    axs[0, 0].set_title("Phytoplancton & Zoo", fontsize=19, loc='right', pad=10)

    axs[0, 1].set_title("Chlorophylle a", fontsize=19, loc='right', pad=10)

# Forcer l'affichage des mois en abscisse
    for j in range(2):
        axs[2, j].set_xticks(ticks)
        axs[2, j].set_xticklabels(mois_labels, rotation=45, ha='right', fontsize=10)


        # Force le rendu même si matplotlib l’étouffe
        plt.setp(axs[2, j].get_xticklabels(), visible=True)
        fig.align_labels()  # aligne proprement tous les labels


    #  Légende globale
    handles, labels = axs[0, 0].get_legend_handles_labels()
    fig.legend(handles, labels, loc="lower center", ncol=4, frameon=False, fontsize=11)

    #  Marges extérieures ajustées
    fig.subplots_adjust(left=0.07, right=0.97, top=0.92, bottom=0.12)

    #  Affichage
    plt.show()

    
def plot_bacteria_and_mo_nutrients_with_obs(results, observation):
    sites = list(results.keys())
    mois_labels = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
                   'Juil', 'Août', 'Sept', 'Oct', 'Nov', 'Déc']
    ticks = np.arange(0, 361, 30)

    # Taille équilibrée
    fig, axs = plt.subplots(
        nrows=3, ncols=2,
        figsize=(16, 15),
        sharex=True,
        sharey='col',
        gridspec_kw={"hspace": 0.1, "wspace": 0.12}
    )

    for i, site in enumerate(sites):
        sol = results[site]["sol"]
        t3 = sol.t[-1440:-1] - 720

        # --- Colonne 1 : Bactéries ---
        ax = axs[i, 0]
        for label, idx, color in [
            ("BLNA modélisé", 4, "purple"),
            ("BHNA modélisé", 5, "brown")
        ]:
            ax.plot(t3, sol.y[idx][-1440:-1], label=label, color=color,linewidth=2.5)

        obs_site = observation[observation["site"] == site].copy()
        obs_site["jour"] = obs_site["mois"] * 30 - 15
        for col_obs, label_obs, color in [
            ("LNA", "LNA obs", "purple"),
            ("HNA", "HNA obs", "brown")
        ]:
            if col_obs in obs_site.columns:
                df = obs_site[["jour", col_obs]].dropna()
                if not df.empty:
                    sm = lowess(df[col_obs], df["jour"], frac=0.3)
                    ax.plot(sm[:, 0], sm[:, 1], "--", label=label_obs, color=color,linewidth=2.5)

        ax.set_xlim(0, 360)
        ax.tick_params(axis='y', labelsize=14)
        ax.set_ylim(0)
        ax.grid(True)

        # --- Colonne 2 : Nutriments & MO ---
        ax2 = axs[i, 1]
        for label, idx, color in [
            ("N modélisé",       6, "fuchsia"),
            ("Dlab modélisé",    7, "grey"),
            ("Dsemlab modélisé", 8, "black")
        ]:
            ax2.plot(t3, sol.y[idx][-1440:-1], label=label, color=color,linewidth=2.5)

        df_nut = obs_site[["jour", "azote_total"]].dropna()
        if not df_nut.empty:
            sm_nut = lowess(df_nut["azote_total"], df_nut["jour"], frac=0.3)
            ax2.plot(sm_nut[:, 0], sm_nut[:, 1], "--", label="DIN obs", color="fuchsia",linewidth=2.5)

        ax2.set_xlim(0, 360)
        ax2.tick_params(axis='y', labelsize=14)
        ax2.set_ylim(0)
        ax2.grid(True)

    # Titres de colonne
    axs[0, 0].set_title("Bactéries", fontsize=19, loc='right', pad=10)
    axs[0, 1].set_title("Nutriments & MO", fontsize=19, loc='right', pad=10)

    # Axe X : mois en base uniquement
    for j in range(2):
        axs[2, j].set_xticks(ticks)
        axs[2, j].set_xticklabels(mois_labels, rotation=45, ha='right', fontsize=10)

    # Légende commune
    handles, labels = axs[0, 0].get_legend_handles_labels()
    fig.legend(handles, labels, loc="lower center", ncol=4, frameon=False, fontsize=11)

    # Marges extérieures
    fig.subplots_adjust(left=0.07, right=0.97, top=0.95, bottom=0.12)


    plt.show()


results = run_model_for_sites(sites)
#plot_bacteria_and_mo_nutrients_with_obs(results, observation)
plot_phyto_zoo_and_chlorophyll_with_obs(results, observation, chla_jour_moy)
