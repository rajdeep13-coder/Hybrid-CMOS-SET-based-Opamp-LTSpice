* ==============================================================================
* FILE: cmos_models.inc
* PROJECT: Hybrid CMOS-SET Op-Amp (LTspice Implementation)
* STAGE: Milestone 2 - CMOS Voltage Gain / Miller-Compensated Integrator Stage
* ==============================================================================
* Generic Level 1 (Shichman-Hodges) MOSFET models for low-voltage (0.8 V)
* analog CMOS exploratory design.
*
* MODEL PARAMETERS JUSTIFICATION:
* - VTO (Threshold voltage):
*     NMOS = +0.35 V, PMOS = -0.35 V.
* - KP (Transconductance parameter mu*Cox):
*     NMOS = 150 uA/V^2, PMOS = 50 uA/V^2.
* - LAMBDA (Channel-length modulation parameter):
*     0.05 V^-1 for nominal L = 1.0 um.
* - GAMMA (Body effect coefficient): 0.20 V^0.5.
* - PHI (Surface potential): 0.65 V.
* - CGSO, CGDO: 0.3 nF/m.
* - CJ: 5e-4 F/m^2, CJSW: 3e-10 F/m.
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
