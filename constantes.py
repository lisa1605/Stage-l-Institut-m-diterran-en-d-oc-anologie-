# # période
Period = 360
t = np.linspace(0, Period, Period)
N0 =3  # µM

#Taux de croissance max (j-1)
µ0cyano = 0.35
µ0euk   = 0.98
µ0µphyt = 1.2
µ0bLNA  = 1.13
µ0bHNA  = 1.44

# Demi-saturations (mmolN m−3)
Kneuk   = 0.88 # 0.2
Kncyano = 0.26 # 0.15 # essayer avec demi sat plus haute pour cyano  0.25
Knµphyt = 1.7 # 0.3
KdLNA   = 1.2/2
KdHNA   = 2.8/2
Kp      = 1.0 # 2.0


# Efficiences [adimensionnelles]
e       = 0.28   # assimilation [Phyto -> Zoo]
Beta    = 0.47 #0.79  # conversion [MO -> bactéries]

# Mortalités [j-1]
mcyano  = 0.05 #0.012
meuk    = 0.07 #0.0185
mµphyt  = 0.06
mzoo    = 10   # mortalité quadratique [µM-N.j-1]
mbHNA   = 0.055
mbLNA   = 0.05

# Broutage [j-1]

g       = 13 # j-1

a_KTW   = 1.5 # adim



# Vitesse de sédimentation [m/j] ramenée à un taux [j-1]
psi = 0.8 / 50  #0.43 / 50  # si h=50m par ex

# Variation des taux métaboliques avec la température
alpha = 0.05 # Q10 de 1.64, predit par la theorie metabolique de l'ecologie [Sal and Lopez-Urrutia, 2011]
T0    = 20   # Phytoplankton growth rates are often assessed around 20°C [Maranon et al. 2013]

# Irradiance de saturation [W/m2]
Isat = 60 # Vallina et al. (2023)

# Constantes pour l'analyse
CN_ratio = 6.6 # 106/16

# Constantes pour ajout Dsemilabile
prosemlab = 0.2 #0.3 #0.2 #proportion de particules semi labile( quand plancton meurt quelle proportion devient semi labile) hypothèses 80% vers labile et 20% semi lab
eps= 0.2/2 #0.2 #doit etre <1 c'est l'affinité des bactéries pour le semi labile

