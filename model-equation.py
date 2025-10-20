
# # période
Period = 360
t = np.linspace(0, Period, Period)
N0 =3  # µM

#------------------------------------
# MODÈLE
#------------------------------------


def make_F_P(T, C_values, N0, iparz0):
    def F_P(t, u):
        jourj = int(t % Period)
        I = iparz0[jourj]
        limI = math.tanh(I / Isat)
        Pcyano, Peuk, Pµphyt, Z, BLNA, BHNA, N, Dlab,Dsemlab = u
        Q10 = math.exp(alpha * (T[jourj] - T0))
        Dprim= Dlab+ eps*Dsemlab
        
        # Croissance
        µcyano = µ0cyano * Q10 * (N / (N + Kncyano)) * limI
        µeuk   = µ0euk   * Q10 * (N / (N + Kneuk  )) * limI
        µµphyt = µ0µphyt * Q10 * (N / (N + Knµphyt)) * limI
        µbLNA  = µ0bLNA  * Q10 * (Dlab / (Dlab + KdLNA))
        µbHNA  = µ0bHNA  * Q10 * (Dprim / (Dprim + KdHNA))

        # Sécuriser les puissances KTW
        Pcyano_KTW = Pcyano**a_KTW
        Peuk_KTW   = Peuk**a_KTW
        Pµphyt_KTW = Pµphyt**a_KTW
        BLNA_KTW   = BLNA**a_KTW
        BHNA_KTW   = BHNA**a_KTW
        #B_KTW      = (BLNA+BHNA)**a_KTW
       

        PB_KTW = Pcyano_KTW + Peuk_KTW + Pµphyt_KTW + BLNA_KTW + BHNA_KTW
        #PB_KTW = Pcyano_KTW + Peuk_KTW + Pµphyt_KTW + B_KTW
        PB     = Pcyano + Peuk + Pµphyt + BLNA + BHNA

        # Sécuriser les fractions
        if PB_KTW == 0:
            frac_Pcyano = frac_Peuk = frac_Pµphyt = frac_BLNA = frac_BHNA = 0
        else:
            frac_Pcyano = Pcyano_KTW / PB_KTW
            frac_Peuk   = Peuk_KTW   / PB_KTW
            frac_Pµphyt = Pµphyt_KTW / PB_KTW
            frac_BLNA   = BLNA_KTW   / PB_KTW
            frac_BHNA   = BHNA_KTW   / PB_KTW
            #frac_BLNA = (B_KTW / PB_KTW) * (BLNA / (BLNA + BHNA))
            #frac_BHNA = (B_KTW / PB_KTW) * (BHNA / (BLNA + BHNA))

        # Broutage
        # G = g * Q10 * Z * PB / (Kp + PB) # Holling type II
        G = g * Q10 * Z * PB**2 / (Kp**2 + PB**2) # Holling type III

        # Flux externe (rappel vers N0)
        #fluxext = flux_values[jourj]
        fluxext =  C_values[jourj] * (N0- N)
        fluxDSL =  C_values[jourj] * (3.0 - Dsemlab)

        # Équations différentielles
        dPcyano = µcyano * Pcyano - G * frac_Pcyano - mcyano * Pcyano * Q10 - psi * Pcyano
        dPeuk   = µeuk   * Peuk   - G * frac_Peuk   - meuk   * Peuk   * Q10 - psi * Peuk
        dPµphyt = µµphyt * Pµphyt - G * frac_Pµphyt - mµphyt * Pµphyt * Q10 - psi * Pµphyt
        dZ      = e * G - mzoo * (Z**2) * Q10 - psi * Z
        dBLNA   = Beta * µbLNA * BLNA - G * frac_BLNA - mbLNA * BLNA * Q10 - psi * BLNA
        dBHNA   = Beta * µbHNA * BHNA - G * frac_BHNA - mbHNA * BHNA * Q10 - psi * BHNA
        dN      = - (µeuk * Peuk + µcyano * Pcyano + µµphyt * Pµphyt) + (1 - Beta) * (µbLNA * BLNA + µbHNA * BHNA) + fluxext - psi*N
        dDlab   = - (µbLNA * BLNA + (µbHNA * BHNA)*Dlab/Dprim) \
                  + Q10 *(1-prosemlab)* (mcyano * Pcyano + meuk * Peuk + mµphyt * Pµphyt + mzoo * (Z**2) + mbLNA * BLNA + mbHNA * BHNA) \
                  + (1 - e) *(1-prosemlab)* G- psi * Dlab
        dDsemlab = - ( (µbHNA * BHNA)*eps*Dsemlab/Dprim) \
                   + Q10 *prosemlab* (mcyano * Pcyano + meuk * Peuk + mµphyt * Pµphyt + mzoo * (Z**2) + mbLNA * BLNA + mbHNA * BHNA) \
                   + (1 - e) *prosemlab* G - psi * Dsemlab + fluxDSL
       
        return [dPcyano, dPeuk, dPµphyt, dZ, dBLNA, dBHNA, dN, dDlab,dDsemlab]
   
    return F_P
  
