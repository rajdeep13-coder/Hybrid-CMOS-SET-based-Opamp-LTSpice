* ==============================================================================
* FILE: cmos_models.inc
* PROJECT: Hybrid CMOS-SET Op-Amp (LTspice Implementation)
* STAGE: Milestone 1 - CMOS Differential Input Stage
* ==============================================================================
* MODEL DESCRIPTION:
* Generic Level 1 (Shichman-Hodges) MOSFET models for low-voltage (0.8 V)
* analog CMOS exploratory design.
*
* STATUS: PROVISIONAL / GENERIC BENCHMARK MODEL
* NOTE: These models do NOT represent any proprietary foundry PDK (e.g. TSMC,
* GlobalFoundries, or SkyWater). They are established for reproducible baseline
* topological and architectural design prior to physical process mapping.
*
* MODEL PARAMETERS JUSTIFICATION:
* - VTO (Threshold voltage):
*     NMOS = +0.35 V, PMOS = -0.35 V.
*     Selected for sub-1V operation (VDD = 0.8 V) to preserve gate overdrive
*     and saturation headroom under low supply voltages without gate overdrive starvation.
* - KP (Transconductance parameter mu*Cox):
*     NMOS = 150 uA/V^2, PMOS = 50 uA/V^2.
*     Reflects electron-to-hole mobility ratio mu_n / mu_p ~ 3:1 in silicon.
* - LAMBDA (Channel-length modulation parameter):
*     0.05 V^-1 for nominal L = 1.0 um (equivalent Early voltage VA ~ 20 V).
*     Provides realistic finite output impedance ro = 1 / (lambda * Id).
* - GAMMA (Body effect coefficient):
*     0.2 V^0.5, realistic for lightly doped substrates.
* - PHI (Surface potential):
*     0.65 V, standard silicon band bending parameter.
* - CGSO, CGDO (Overlap capacitances):
*     0.3 nF/m (0.3 fF/um), provides parasitic capacitances for realistic GBW.
* - CJ, CJSW (Junction capacitances):
*     CJ = 5e-4 F/m^2, CJSW = 3e-10 F/m.
*
* LIMITATIONS:
* 1. Does not capture subthreshold weak-inversion exponential conduction.
* 2. Does not capture short-channel velocity saturation (DIBL, carrier heating).
* 3. Must be replaced with BSIM3v3 / BSIM4 / PSP or foundry PDK models for tape-out.
* ==============================================================================

.model NMOS_LV NMOS (
+ LEVEL   = 1
+ VTO     = 0.35
+ KP      = 150e-6
+ LAMBDA  = 0.05
+ GAMMA   = 0.20
+ PHI     = 0.65
+ CGSO    = 3.0e-10
+ CGDO    = 3.0e-10
+ CJ      = 5.0e-4
+ CJSW    = 3.0e-10
+ TOX     = 4.0e-9
+ )

.model PMOS_LV PMOS (
+ LEVEL   = 1
+ VTO     = -0.35
+ KP      = 50e-6
+ LAMBDA  = 0.05
+ GAMMA   = 0.20
+ PHI     = 0.65
+ CGSO    = 3.0e-10
+ CGDO    = 3.0e-10
+ CJ      = 5.0e-4
+ CJSW    = 3.0e-10
+ TOX     = 4.0e-9
+ )

* ==============================================================================
* End of cmos_models.inc
* ==============================================================================
