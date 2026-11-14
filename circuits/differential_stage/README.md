# Circuit A: CMOS Differential Input Stage

This directory contains the schematic, netlist, testbenches, model cards, and empirical simulation logs for the **Milestone 1 CMOS Differential Input Stage** of the Hybrid CMOS–SET Operational Amplifier project.

---

## 1. Circuit Schematic & Architecture

```
                     VDD (0.80 V)
             +------------+------------+
             |            |            |
           +---+        +---+          |
     Rbias |   |     M3 | / |       M4 |   |
    173.5k |   |   (PMOS) /       (PMOS)
           +---+        +---+          +---+
             |            |              |
             |       +----+              |
             |       |    |              |
     VBIAS --+-------*    |              +---> OUT (CL = 1 pF)
             |       |    |              |
           +---+     |  +---+          +---+
        M6 | / |     |  |   | M1    M2 |   |
    (NMOS)   /       |  |   |          |   |
           +---+     |  +---+          +---+
             |       |    |              |
            GND      |  IN_P (VIP)     IN_N (VIN)
                     |    |              |
                     +----+--------------+
                                 |
                               TAIL
                                 |
                               +---+
                            M5 |   | (NMOS Tail Sink)
                               +---+
                                 |
                                GND
```

### Device Dimensioning & Roles

| Component | Type | W (µm) | L (µm) | Function | Operating Region |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **M1** | NMOS | 4.0 | 1.0 | Non-inverting input transistor | Saturation ($V_{ds} = 0.199\text{ V} > V_{ov} = 0.058\text{ V}$) |
| **M2** | NMOS | 4.0 | 1.0 | Inverting input transistor | Saturation ($V_{ds} = 0.199\text{ V} > V_{ov} = 0.058\text{ V}$) |
| **M3** | PMOS | 6.4 | 1.0 | Diode-connected mirror active load | Saturation ($|V_{ds}| = 0.428\text{ V} > |V_{ov}| = 0.078\text{ V}$) |
| **M4** | PMOS | 6.4 | 1.0 | High-impedance active load | Saturation ($|V_{ds}| = 0.428\text{ V} > |V_{ov}| = 0.078\text{ V}$) |
| **M5** | NMOS | 2.7 | 1.0 | Tail current sink ($I_{tail} = 1.996\text{ µA}$) | Saturation ($V_{ds} = 0.172\text{ V} > V_{ov} = 0.099\text{ V}$) |
| **M6** | NMOS | 2.7 | 1.0 | Diode-connected reference mirror | Saturation ($V_{ds} = V_{gs} = 0.449\text{ V}$) |
| **Rbias**| Resistor | — | — | Sets $I_{ref} \approx 2.02\text{ µA}$ from VDD | Passive resistor (173.5 kΩ) |
| **CL** | Capacitor| — | — | Output load capacitance | 1.0 pF nominal load |

---

## 2. Directory Contents

- [CMOS_Differential.asc](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/CMOS_Differential.asc): LTspice graphical schematic with full electrical pin connectivity.
- [CMOS_Differential.cir](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/CMOS_Differential.cir): Master SPICE netlist with integrated `.op`, `.ac`, and automated `.meas` directives.
- `models/`:
  - [cmos_models.inc](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/models/cmos_models.inc): Generic low-voltage Level-1 MOSFET model library ($V_{TO} = \pm 0.35\text{ V}$).
- Standalone Testbenches:
  - [tb_op.cir](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/tb_op.cir): Quiescent operating point, branch balance, and power dissipation.
  - [tb_dc_diff.cir](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/tb_dc_diff.cir): Large-signal differential DC input sweep ($-50\text{ mV}$ to $+50\text{ mV}$) and linear derivative gain.
  - [tb_dc_icmr.cir](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/tb_dc_icmr.cir): Common-mode input voltage range ($0\text{ V}$ to $0.8\text{ V}$) headroom sweep.
  - [tb_ac_diff.cir](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/tb_ac_diff.cir): Small-signal differential frequency response ($A_d$, $f_{-3\text{dB}}$, GBW).
  - [tb_ac_cm.cir](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/tb_ac_cm.cir): Common-mode gain ($A_{cm}$) and Common-Mode Rejection Ratio (CMRR).
  - [tb_tran.cir](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/tb_tran.cir): Transient sinusoidal response ($1\text{ kHz}$) and Total Harmonic Distortion (THD).
- `results/`:
  - [tb_op.log](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/results/tb_op.log)
  - [tb_dc_diff.log](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/results/tb_dc_diff.log)
  - [tb_dc_icmr.log](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/results/tb_dc_icmr.log)
  - [tb_ac_diff.log](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/results/tb_ac_diff.log)
  - [tb_ac_cm.log](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/results/tb_ac_cm.log)
  - [tb_tran.log](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/results/tb_tran.log)
  - [CMOS_Differential_asc.log](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/results/CMOS_Differential_asc.log)

---

## 3. Measured Performance Summary (Empirical LTspice 26.1.1)

| Parameter | Specification / Target | Simulated Result | Units | Status |
| :--- | :--- | :--- | :--- | :--- |
| **Supply Voltage ($V_{DD}$)** | 0.80 | 0.8000 | V | PASS |
| **Tail Current ($I_{tail}$)** | 2.00 | 1.9965 | µA | PASS (< 0.2% error) |
| **Branch Currents ($I_{M1}, I_{M2}$)** | 1.00 each | 0.9982, 0.9982 | µA | PASS (Balance error = 0.000 nA) |
| **Quiescent Output ($V_{out}$)** | ~0.37 | 0.3718 | V | PASS (Centered headroom) |
| **Total Power Consumption** | Low (< 10 µW) | 3.216 | µW | PASS |
| **Differential DC Gain ($A_{v0}$)** | > 40 dB | 50.96 (353.4 V/V) | dB | PASS |
| **Differential AC Gain ($A_d$)** | > 40 dB | 50.97 (353.5 V/V) | dB | PASS |
| **Dominant Pole ($f_{-3\text{dB}}$)** | Evaluated | 15.55 | kHz | PASS |
| **Unity Gain Bandwidth (GBW)** | Evaluated | 5.46 | MHz | PASS |
| **Common-Mode Gain ($A_{cm}$)** | Low | -55.20 (1.74 mV/V) | dB | PASS |
| **CMRR** | > 80 dB | 106.17 | dB | PASS |
| **Total Harmonic Distortion (THD)**| Low (< 1%) | 0.0441 | % | PASS (at $0.4\text{ mV}_\text{pp}$ input) |
| **Input Common-Mode Range (ICMR)** | ~0.55 to 0.72 | 0.54 to 0.72 | V | PASS |

---

## 4. How to Run

Execute the automated PowerShell runner from the project root:
```powershell
powershell -ExecutionPolicy Bypass -File scripts\run_differential_stage.ps1
```
Or run individually via the command line:
```powershell
& "C:\Users\rajde\OneDrive\Desktop\LTSPICE\LTspice.exe" -b circuits\differential_stage\CMOS_Differential.cir
```
