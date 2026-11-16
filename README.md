# Hybrid CMOS–SET Operational Amplifier (LTspice Implementation)

An ultra-low-power, sub-1V operational amplifier project implemented and verified in **LTspice** on Windows.

---

## 1. Project Objective

The goal of this project is to develop an operational amplifier by combining conventional **CMOS analog design** with **Single-Electron Transistor (SET)** quantum-confinement devices. 

In accordance with the incremental milestone plan:
- **Milestone 1:** Implement two independent CMOS-only baseline circuits:
  1. **Circuit A:** CMOS Differential Input Stage (**COMPLETED & VALIDATED**).
  2. **Circuit B:** CMOS Voltage Gain / Miller-Compensated Integrator Stage (**COMPLETED & VALIDATED**).
- **Milestone 2 (Next Milestone):** Integrate Single-Electron Transistor compact macro-models to exploit Coulomb blockade and oscillatory transconductance.
- **Milestone 3 (Future):** Complete two-stage closed-loop hybrid op-amp system characterization and closed-loop feedback stability analysis.

---

## 2. Current Implementation Status

| Stage / Component | Status | Deliverables | Key Validated Metric |
| :--- | :--- | :--- | :--- |
| **Circuit A: CMOS Differential Stage** | **COMPLETED** | `.asc`, `.cir`, 6 testbenches, logs | $A_d = 50.97\text{ dB}$, $\text{CMRR} = 106.17\text{ dB}$, $P = 3.22\text{ µW}$ |
| **Circuit B: CMOS Gain / Integrator Stage** | **COMPLETED** | `.asc`, `.cir`, 4 testbenches, logs | $A_v = 48.04\text{ dB}$, $\text{GBW} = 4.54\text{ MHz}$, $P = 4.93\text{ µW}$, $\text{THD} = 0.31\%$ |
| **SET Device Integration** | Next Step | Roadmap established | Reserved for Milestone 2 |

---

## 3. Circuit Architecture & Operating Principles

### Circuit A: CMOS Differential Input Stage
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

#### How Circuit A Works:
1. **Bias Generator ($M_6, R_{bias}$):** A self-biased branch drops $V_{DD}$ across $R_{bias} = 173.5\text{ k}\Omega$ into diode-connected NMOS $M_6$, creating a stable gate voltage $V_{BIAS} \approx 0.449\text{ V}$ carrying $I_{ref} \approx 2.02\text{ µA}$.
2. **Tail Current Sink ($M_5$):** Mirrors $V_{BIAS}$ to establish a constant tail current $I_{tail} = 1.9965\text{ µA}$ (target: $2.00\text{ µA}$, error $< 0.2\%$).
3. **Differential Input Pair ($M_1, M_2$):** Matched NMOS devices convert differential input voltage $V_{id} = V_{in+} - V_{in-}$ into complementary small-signal currents $\pm g_m v_{id} / 2$.
4. **Active Current Mirror Load ($M_3, M_4$):** PMOS pair reflects the small-signal current from $M_1$ to the output node, doubling effective transconductance to $g_{m1}$ while providing high dynamic output resistance $R_{out} = r_{o2} \parallel r_{o4} \approx 10\text{ M}\Omega$.

---

### Circuit B: CMOS Voltage Gain / Miller-Compensated Integrator Stage
Located in [`circuits/gain_integrator_stage/`](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/gain_integrator_stage/):

```text
                                VDD = 0.80 V
                                     |
               +---------------------+---------------------+
               |                                           |
               | [Source]                                  | [Source]
             +---+                                       +---+
             |   | M8                                    |   | M9
    VBP ---->|   | PMOS Active Load             VBP ---->|   | PMOS Diode Reference
             +---+                                       +---+ (Gate tied to Drain)
               | [Drain]                                   | [Drain]
               |                                           +------- VBP
               +---------------- OUT                               |
               |                  |                                |
               | [Drain]        +---+                             [ ] RPB
             +---+              |   | CC                          [ ] (175 kΩ)
  GATE ----->|   | M7           +---+ (1 pF)                       |
             +---+ NMOS CS Gain   |                               GND
               | [Source]         |
              GND                 +---------------- GATE
                                                     |
                                   CIN (10 µF)       |
           VIN o-----------------------||------------+
                                                     |
                                            +--------+--------+
                                            |                 |
                                           [ ] R1            [ ] R2
                                           [ ] (171.35 kΩ)   [ ] (200 kΩ)
                                            |                 |
                                           VDD               GND
```

#### How Circuit B Works:
1. **Common-Source Core ($M_7$):** An NMOS common-source amplifier ($W = 4.0\text{ µm}, L = 1.0\text{ µm}$) providing transconductance $g_{m7} \approx 49\text{ µS}$ and open-loop voltage gain $A_v = -g_{m7}(r_{o7} \parallel r_{o8}) \approx -252\text{ V/V}$ ($48.04\text{ dB}$).
2. **Active PMOS Current-Source Load ($M_8$):** Sourced from $V_{\text{DD}}$ and biased by $V_{\text{BP}}$ to supply $I_{\text{D8}} \approx 2.00\text{ µA}$, providing high incremental resistance $r_{o8} \approx 10\text{ M}\Omega$.
3. **PMOS Mirror Reference ($M_9, R_{\text{PB}}$):** Diode-connected PMOS $M_9$ loaded by $R_{\text{PB}} = 175\text{ k}\Omega$ sets $V_{\text{BP}} = 0.3510\text{ V}$ carrying $I_{\text{REF}} = 2.006\text{ µA}$.
4. **NMOS Bias Divider ($R_1, R_2$):** Precision divider with $R_1 = 171.35\text{ k}\Omega$ and $R_2 = 200\text{ k}\Omega$ establishes $V_{\text{GATE}} = 0.43086\text{ V}$, centering quiescent $V_{\text{OUT}}$ at $0.3998\text{ V}$ ($\approx V_{\text{DD}}/2$) with $> 300\text{ mV}$ of symmetrical saturation headroom for both transistors.
5. **Miller Frequency Compensation ($C_C = 1.0\text{ pF}$):** Multiplied by stage gain ($C_{\text{in,eff}} \approx 253\text{ pF}$), establishing a dominant pole at $f_{-3\text{dB}} = 15.57\text{ kHz}$ and a $-20\text{ dB/decade}$ lossy integrator roll-off up to $\text{GBW} = 4.54\text{ MHz}$ with $80.3^\circ$ phase margin.

---

## 4. Repository Structure

```text
Hybrid-CMOS-SET-based-Opamp-LTSpice/
├── README.md                                   <- Master project guide
├── circuits/
│   ├── differential_stage/                     <- Circuit A: Differential Input Stage
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
│   │   ├── results/                           <- Verified LTspice simulation logs
│   │   └── README.md                          <- Stage-specific design report
│   └── gain_integrator_stage/                  <- Circuit B: Gain / Integrator Stage
│       ├── CMOS_Gain_Integrator.asc           <- Master LTspice schematic (AC active)
│       ├── CMOS_Gain_Integrator.cir           <- Standalone SPICE netlist
│       ├── models/
│       │   └── cmos_models.inc                <- Local portable model deck
│       ├── testbenches/
│       │   ├── tb_op.cir                      <- Operating point & currents testbench
│       │   ├── tb_dc.cir                      <- DC transfer & linear range testbench
│       │   ├── tb_ac.cir                      <- AC frequency response & GBW testbench
│       │   └── tb_tran.cir                    <- Transient sine (1 kHz, 1 mVpk) testbench
│       ├── results/                           <- Empirical simulation logs (.log)
│       └── README.md                          <- Circuit B comprehensive engineering report
├── docs/
│   ├── PROJECT_OVERVIEW.md                    <- System overview & roadmap
│   ├── DESIGN_METHODOLOGY.md                  <- Headroom, ICMR & small-signal theory
│   ├── DESIGN_PARAMETERS.md                   <- Device geometry & model specs
│   ├── SIMULATION_GUIDE.md                    <- GUI & CLI simulation instructions
│   ├── RESULTS.md                             <- Complete empirical measurement data
│   └── ROADMAP.md                             <- Multi-milestone execution plan
├── scripts/
│   ├── run_differential_stage.ps1             <- Circuit A automated validation harness
│   └── run_gain_integrator_stage.ps1          <- Circuit B automated validation harness
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

### Option A: One-Command Automated Validation Runners
Run the automated test harnesses directly from PowerShell:

```powershell
# Validate Circuit A (CMOS Differential Input Stage)
powershell -ExecutionPolicy Bypass -File scripts\run_differential_stage.ps1

# Validate Circuit B (CMOS Gain / Integrator Stage)
powershell -ExecutionPolicy Bypass -File scripts\run_gain_integrator_stage.ps1
```

Each script automatically compiles netlists, executes testbenches in batch mode, records logs in `results/`, and prints a formatted validation summary.

### Option B: Interactive LTspice GUI
1. Open LTspice.
2. Select **File -> Open...** and browse to either:
   - `circuits/differential_stage/CMOS_Differential.asc` (Circuit A)
   - `circuits/gain_integrator_stage/CMOS_Gain_Integrator.asc` (Circuit B)
3. Click the **Run** button (`Alt + R`).
4. Click node `OUT` to inspect waveforms / frequency response.
5. Press `Ctrl + L` to view measured parameters in the SPICE Error Log.

---

## 7. Empirical Simulation Results

All figures below are **empirically measured** using LTspice 26.1.1 (zero fabricated numbers):

### Circuit A: CMOS Differential Stage
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

### Circuit B: CMOS Gain / Integrator Stage
| Metric | Theoretical / Target | Measured Result | Unit | Agreement |
| :--- | :--- | :--- | :--- | :--- |
| **Supply Voltage ($V_{DD}$)** | 0.80 | **$0.8000$** | V | Exact |
| **PMOS Mirror Bias ($V_{\text{BP}}$)** | $\sim 0.35$ | **$0.3510$** | V | Exact |
| **NMOS Gate Bias ($V_{\text{GATE}}$)** | $\sim 0.43$ | **$0.4309$** | V | Optimal tuning |
| **Quiescent Output ($V_{\text{OUT}}$)** | $0.40 \pm 0.05$ | **$0.3998$** | V | Centered mid-rail |
| **PMOS Load Current ($|I_{\text{D8}}|$)** | $\sim 2.0$ | **$2.001$** | µA | Exact |
| **NMOS Gain Current ($I_{\text{D7}}$)** | $\sim 2.0$ | **$2.001$** | µA | Exact |
| **Current Balance Error ($\Delta I$)** | $< 0.05$ | **$0.000$** | µA | $100\%$ balanced |
| **$M_7$ Saturation Margin** | $> 100$ | **$+319.0$** | mV | Deep saturation |
| **$M_8$ Saturation Margin** | $> 100$ | **$+301.1$** | mV | Deep saturation |
| **Total Power Dissipation** | $< 8$ | **$4.928$** | µW | Ultra-low power |
| **DC Voltage Gain ($A_{v0}$)** | $> 40$ | **$48.04$** ($252.36$) | dB (V/V) | Matches AC response |
| **Dominant Pole ($f_{-3\text{dB}}$)** | $10 - 25$ | **$15.57$** | kHz | Miller compensation pole |
| **Unity Gain Bandwidth (GBW)** | $> 3.0$ | **$4.54$** | MHz | Exact crossing |
| **Phase Margin** | $> 60^\circ$ | **$80.3^\circ$** | deg | Single-pole stability |
| **Transient Gain ($1\text{ kHz}$)** | $> 40$ | **$48.02$** ($251.76$) | dB (V/V) | Matches small-signal gain |
| **Transient THD ($1\text{ mV}_{\text{pk}}$)** | $< 1\%$ | **$0.307$** | % | High linearity |

---

## 8. Model Limitations & PDK Migration

The simulation results use generic Level-1 (Shichman-Hodges) analytical MOSFET models ([cmos_models.inc](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/models/cmos_models.inc)):
- **Topological Proof-of-Concept:** These generic models establish baseline topological proof of concept prior to physical foundry process selection.
- **Unmodeled Effects:** They do not capture sub-threshold exponential conduction, short-channel velocity saturation, or drain-induced barrier lowering (DIBL).
- **Tape-out Requirement:** For physical layout and silicon fabrication, circuits must be ported to foundry-qualified BSIM4 models (e.g., TSMC 180nm or SkyWater 130nm).

---

## 9. Next Milestone

With both **Circuit A** (CMOS Differential Input Stage) and **Circuit B** (CMOS Gain / Integrator Stage) fully designed, verified, and characterized:
- **Milestone 2:** Implement Single-Electron Transistor (SET) compact macro-models, establish Coulomb blockade oscillation regions, and couple SET elements into the CMOS amplifier core.
