définition des fonctions de forçages saisonniers : 

def temperature_saisonniere(t, Tmin, Tmax, Period, phi):
    """
    Fonction sinusoidale de température en fonction du jour t (0 à 360).
    VARIABLES D'ENTRÉE
    - t    : jour de l'année
    - Tmin : température minimale
    - Tmax : température maximale
    - P    : période (nombre de jours par an)
    - phi  : jour du maximum de température  
    VARIABLES INTERMÉDIAIRES
    - Tmoy : température moyenne annuelle
    - amplitude : amplitude des variations saisonnières
    """
    Tmoy = (Tmax+Tmin)/2
    amplitude = (Tmax-Tmin)/2
    return Tmoy + amplitude * np.cos(2 * np.pi * (t - phi) / Period)


def C_saisonnier(t, Cmin, Cmax, Period, phi):
    """
    Variation saisonnière de la constante C [1/jour]
   
    Cette fonction génère une variation saisonnière lissée de la constante
    de rappel C, plus élevée en hiver (maximum au jour phi) et plus faible en été.
   
    VARIABLES D'ENTRÉE
    - t      : jour de l'année (de 0 à Period)
    - Cmin   : Valeur minimale de C (été)
    - Cmax   : Valeur maximale de C (ehiver)
    - Period : période annuelle (nombre de jours par an 360)
    - phi    : jour du maximum de C ( jour du flux hivernal maximal)
   
    VARIABLES INTERMÉDIAIRES
    - Cmoy   : Moyenne harmonique entre Cmin et Cmax
    - a      : Amplitude relative du dénominateur (entre 0 et 1)
   
    SORTIE
    - C(t)   : valeur de la constante C au jour t
    """
    Cmoy = 2 * Cmin * Cmax / (Cmin + Cmax)  
    a    = (Cmax - Cmin) / (Cmax + Cmin)    
    return Cmoy / (1 - a * np.cos(2 * np.pi * (t - phi) / Period))

def fluxext_saisonnier(t, Fmin, Fmax, Period, phi):
    """
    Variation saisonnière du flux de nutriments [mmolN/m3/j]
    VARIABLES D'ENTRÉE
    - t    : jour de l'année
    - Fmin : Flux minimal
    - Fmax : Flux maximal
    - P    : période (nombre de jours par an)
    - phi  : jour du flux maximal
    VARIABLES INTERMÉDIAIRES
    - Fmoy : Moyenne harmonique du flux
    - a    : amplitude relative du dénominateur
    """
    Fmoy  = 2*Fmin*Fmax / (Fmin+Fmax)
    a     = (Fmax-Fmin) / (Fmax+Fmin)
   
    return Fmoy / (1 - a*np.cos(2*np.pi*(t-phi)/Period))

def irradiance_saisonniere(I0, obl, lat_deg, Period, phi):
    """
    Variation saisonnière de l'irradiance solaire [W/m2]
    VARIABLES D'ENTRÉE
    - I0      : irradiance moyenne au sommet des nuages
    - obl_deg : obliquité de la Terre [en degrés]
    - lat_deg : Latitude [en degrés]
    - P       : période (nombre de jours par an)
    - phi     : jour de l'irradiance maximale
    VARIABLES INTERMÉDIAIRES
    - obl  : obliquité de la Terre en radians
    - lat  : latitude en radians
    - decl : déclinaison
    """
    obl = np.deg2rad(obl)
    lat = np.deg2rad(lat_deg)
    iparz0 = np.zeros(Period)
    for jt in range(1, Period + 1):
        decl = obl * np.cos(2 * np.pi * (jt - phi) / 360)
        if abs(lat) + abs(decl) < np.pi / 2:
            iparz0[jt - 1] = (I0 / np.pi) * (
                np.sin(decl) * np.sin(lat) * np.arccos(-np.tan(decl) * np.tan(lat)) +
                np.cos(decl) * np.cos(lat) * np.sqrt(1 - (np.tan(decl) * np.tan(lat)) ** 2)
            )
        elif np.sign(lat) == np.sign(decl):
            iparz0[jt - 1] = I0 * np.sin(decl) * np.sin(lat)
        else:
            iparz0[jt - 1] = 0
    return iparz0

