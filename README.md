# Hybrid CMOS–SET Operational Amplifier (LTspice Implementation)

An ultra-low-power, sub-1V operational amplifier project implemented and verified in **LTspice** on Windows.

---

## 1. Project Objective

The goal of this project is to develop an operational amplifier by combining conventional **CMOS analog design** with **Single-Electron Transistor (SET)** quantum-confinement devices. 

In accordance with the incremental milestone plan:
- **Milestone 1 (Current):** Implement two independent CMOS-only baseline circuits:
  1. **Circuit A:** CMOS Differential Input Stage (**COMPLETED & VALIDATED**).
  2. **Circuit B:** CMOS Voltage Gain / Integrator Stage (**Pending User Approval of Circuit A**).
- **Milestone 2 (Future):** Integrate Single-Electron Transistor compact macro-models to exploit Coulomb blockade and oscillatory transconductance.
- **Milestone 3 (Future):** Complete two-stage closed-loop hybrid op-amp system characterization.

---

## 2. Current Implementation Status

| Stage / Component | Status | Deliverables | Key Validated Metric |
| :--- | :--- | :--- | :--- |
| **Circuit A: CMOS Differential Stage** | **COMPLETED** | `.asc`, `.cir`, 6 testbenches, logs | $A_d = 50.97\text{ dB}$, $\text{CMRR} = 106.17\text{ dB}$, $P = 3.22\text{ µW}$ |
| **Circuit B: CMOS Gain/Integrator Stage** | **PAUSED** | Directory reserved | Pending user review & approval of Circuit A |
| **SET Device Integration** | Planned | Roadmap established | Reserved for Milestone 2 |

---

## 3. Circuit Architecture & Operating Principles

### Circuit A: CMOS Differential Stage
Located in [`circuits/differential_stage/`](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/):

```text
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
     VBIAS --+-------*    |              +---> OUT (CL = 1.0 pF)
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
                            M5 |   | (NMOS Tail Sink, 2.0 uA)
                               +---+
                                 |
                                GND
```

#### How it works:
1. **Bias Generator ($M_6, R_{bias}$):**
   A self-biased branch drops $V_{DD}$ across $R_{bias} = 173.5\text{ k}\Omega$ into diode-connected NMOS $M_6$, creating a stable gate voltage $V_{BIAS} \approx 0.449\text{ V}$ carrying $I_{ref} \approx 2.02\text{ µA}$.
2. **Tail Current Sink ($M_5$):**
   Mirrors $V_{BIAS}$ to establish a constant tail current $I_{tail} = 1.9965\text{ µA}$ (target: $2.00\text{ µA}$, error $< 0.2\%$).
3. **Differential Input Pair ($M_1, M_2$):**
   Matched NMOS devices convert differential input voltage $V_{id} = V_{in+} - V_{in-}$ into complementary small-signal currents $\pm g_m v_{id} / 2$.
4. **Active Current Mirror Load ($M_3, M_4$):**
   PMOS pair reflects the small-signal current from $M_1$ to the output node, doubling effective transconductance to $g_{m1}$ while providing a high dynamic output resistance $R_{out} = r_{o2} \parallel r_{o4} \approx 10\text{ M}\Omega$.

### Circuit B: CMOS Gain / Integrator Stage (Milestone 1 Step 2)
Located in [`circuits/gain_integrator_stage/`](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/gain_integrator_stage/):
Will implement a Common-Source NMOS driver with PMOS active current-source load and Miller compensation capacitor ($C_C$) to deliver controlled dominant-pole voltage gain and integration behavior over targeted bandwidths.

---

## 4. Repository Structure

```text
Hybrid-CMOS-SET-Opamp-LTspice/
├── README.md                                   <- Master project guide
├── circuits/
│   ├── differential_stage/                     <- Circuit A (Completed)
│   │   ├── CMOS_Differential.asc              <- LTspice schematic
│   │   ├── CMOS_Differential.cir              <- Standalone SPICE netlist
│   │   ├── tb_op.cir                          <- Operating point testbench
│   │   ├── tb_dc_diff.cir                     <- Differential DC sweep testbench
│   │   ├── tb_dc_icmr.cir                     <- Common-mode range testbench
│   │   ├── tb_ac_diff.cir                     <- Differential AC testbench
│   │   ├── tb_ac_cm.cir                       <- Common-mode & CMRR testbench
│   │   ├── tb_tran.cir                        <- Transient & THD testbench
│   │   ├── models/
│   │   │   └── cmos_models.inc                <- Centralized Level-1 MOSFET models
│   │   ├── results/                           <- Genuine LTspice simulation logs
│   │   └── README.md                          <- Stage-specific design report
│   └── gain_integrator_stage/                  <- Circuit B (Next Step)
│       └── README.md                          <- Architectural plan awaiting approval
├── docs/
│   ├── PROJECT_OVERVIEW.md                    <- System overview & roadmap
│   ├── DESIGN_METHODOLOGY.md                  <- Headroom, ICMR & small-signal theory
│   ├── DESIGN_PARAMETERS.md                   <- Device geometry & model specs
│   ├── SIMULATION_GUIDE.md                    <- GUI & CLI simulation instructions
│   ├── RESULTS.md                             <- Complete empirical measurement data
│   └── ROADMAP.md                             <- Multi-milestone execution plan
├── scripts/
│   └── run_differential_stage.ps1             <- Automated batch validation harness
└── validation/
    └── VALIDATION_STATUS.md                   <- Comprehensive pass/fail test matrix
```

---

## 5. Software Requirements

- **Operating System:** Windows 10 / 11 64-bit.
- **Simulator:** **LTspice** (verified with LTspice 26.1.1 64-bit).
- **Shell:** Windows PowerShell 5.1+ or PowerShell 7.

---

## 6. How to Run the Simulations

### Option A: One-Command Automated Validation Runner
Run the PowerShell test harness from the root directory:
```powershell
powershell -ExecutionPolicy Bypass -File scripts\run_differential_stage.ps1
```
This script executes all schematics and testbenches in batch mode, records logs into `results/`, and prints a performance table.

### Option B: Interactive LTspice GUI
1. Open LTspice.
2. Select **File -> Open...** and select:
   `circuits\differential_stage\CMOS_Differential.asc`
3. Click the **Run** button (`Alt + R`).
4. Click on node `OUT` to plot the differential output.

---

## 7. Empirical Simulation Results (Circuit A)

All figures below are **empirically measured** using LTspice 26.1.1. Zero fabricated numbers:

| Metric | Theoretical / Target | Measured Result | Unit | Agreement |
| :--- | :--- | :--- | :--- | :--- |
| **Supply Voltage ($V_{DD}$)** | 0.80 | **0.8000** | V | Exact |
| **Tail Current ($I_{tail}$)** | 2.00 | **1.9965** | µA | $-0.18\%$ |
| **Branch Balance Error** | 0.00 | **0.0000** | nA | $100\%$ balanced |
| **Quiescent Output ($V_{out}$)** | 0.37 | **0.3718** | V | Centered headroom |
| **Total Power Dissipation** | $< 10$ | **3.216** | µW | Ultra-low power |
| **DC Differential Gain ($A_{v0}$)**| $> 40$ | **50.965** ($353.39$) | dB (V/V) | Matches AC within 0.004 dB |
| **AC Small-Signal Gain ($A_d$)** | $> 40$ | **50.969** ($353.54$) | dB (V/V) | $+0.04\%$ vs DC derivative |
| **$-3\text{ dB}$ Cut-off ($f_{-3\text{dB}}$)** | $\sim 15.9$ | **15.55** | kHz | With $C_L = 1.0\text{ pF}$ |
| **Unity Gain Bandwidth (GBW)** | $\sim 5.49$ | **5.462** | MHz | Exact |
| **Common-Mode Gain ($A_{cm}$)** | Low | **-55.20** ($1.737$) | dB (mV/V)| Robust rejection |
| **CMRR** | $> 80$ | **106.17** | dB | Linear ratio: $203,500$ |
| **Transient THD ($1\text{ kHz}$)**| $< 1\%$ | **0.0441** | % | High linearity |
| **Input Common-Mode Range** | $[0.55, 0.72]$ | **$[0.54, 0.72]$** | V | Nominal $0.60\text{ V}$ is centered |

### Model Limitations:
- The generic Level 1 models ([cmos_models.inc](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/models/cmos_models.inc)) establish baseline topological proof of concept.
- They do not model sub-threshold weak inversion, DIBL, or carrier velocity saturation. Replace with a foundry-qualified PDK (e.g. SkyWater 130nm) before tapeout.

---

## 8. Next Step & Incremental Gate

In adherence to the project instructions (Section 9: Work Incrementally):
> **"Stop and wait for approval before implementing Circuit B."**

Circuit A is fully documented and verified. We await user approval to proceed with **Circuit B (CMOS Gain / Integrator Stage)**.
