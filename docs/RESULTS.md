# Milestone 1: Simulation Results & Verification Record

> This document is a detailed record of Circuit A. For the combined and independently marked Circuit A/Circuit B status, including pending Circuit B AC verification, see [SIMULATION_RESULTS.md](SIMULATION_RESULTS.md).

All results recorded below are **empirically measured** from actual LTspice 26.1.1 batch simulations executed on Windows 11. Raw logs are preserved under [results/](file:///C:/Users/rajde/OneDrive/Desktop/Hybrid-CMOS-SET-based-Opamp-LTSpice/circuits/differential_stage/results/).

---

## 1. DC Operating Point Analysis (`tb_op.log`)

- **Simulation Command:** `LTspice.exe -b tb_op.cir`
- **Solver Details:** Direct Newton iteration converged in 21 iterations (Elapsed time: 0.16 s).

### Node Voltages & Quiescent Biasing:
| Node | Simulated Voltage (V) | Target / Design Value | Description |
| :--- | :--- | :--- | :--- |
| `V(VDD)` | 0.8000 | 0.80 V | Positive supply rail |
| `V(VBIAS)` | 0.4489 | ~0.45 V | Tail mirror gate bias |
| `V(TAIL)` | 0.1725 | ~0.17 V | Differential pair common source |
| `V(N_D1)` | 0.3718 | ~0.37 V | Diode load drain voltage |
| `V(OUT)` | 0.3718 | ~0.37 V | Quiescent output DC operating level |

### Branch Currents & Balance:
| Branch Current | Simulated Value (µA) | Target Value | Mismatch Error |
| :--- | :--- | :--- | :--- |
| $I_{bias}$ ($R_{bias}$) | 2.0238 | 2.00 µA | +1.19% |
| $I_{tail}$ ($M_5$ drain) | 1.9965 | 2.00 µA | -0.18% |
| $I_{D1}$ ($M_1$ drain) | 0.9982 | 1.00 µA | -0.18% |
| $I_{D2}$ ($M_2$ drain) | 0.9982 | 1.00 µA | -0.18% |
| $I_{D3}$ ($M_3$ drain) | 0.9982 | 1.00 µA | -0.18% |
| $I_{D4}$ ($M_4$ drain) | 0.9982 | 1.00 µA | -0.18% |
| **Current Balance Error** | **0.0000 nA** | **0.000 nA** | **0.000% (Perfect symmetry)** |

### Power Consumption:
- Total Quiescent Current: $I_{tot} = 4.020\text{ µA}$
- **Total Power Dissipation:** $P_{diss} = 0.80\text{ V} \times 4.020\text{ µA} = \mathbf{3.216\text{ µW}}$

### Transistor Saturation Margin Verification:
| Transistor | $V_{gs}$ (V) | $V_{th}$ (V) | $V_{ov} = V_{gs}-V_{th}$ (V) | $V_{ds}$ (V) | Saturation Criterion ($V_{ds} > V_{ov}$) | Margin (mV) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **M5** (Tail) | 0.4489 | 0.350 | 0.0989 | 0.1725 | **SATURATION** | +73.6 mV |
| **M1** (Input 1)| 0.4275 | 0.370*| 0.0575 | 0.1994 | **SATURATION** | +141.9 mV|
| **M2** (Input 2)| 0.4275 | 0.370*| 0.0575 | 0.1994 | **SATURATION** | +141.9 mV|
| **M3** (Mirror 1)| -0.4282 | -0.350 | -0.0782 | -0.4282 | **SATURATION** | +350.0 mV|
| **M4** (Mirror 2)| -0.4282 | -0.350 | -0.0782 | -0.4282 | **SATURATION** | +350.0 mV|
| **M6** (Reference)| 0.4489 | 0.350 | 0.0989 | 0.4489 | **SATURATION** | Diode-connected |

*\*Note: $V_{th}$ for M1/M2 includes the body effect due to source-to-bulk potential $V_{sb} = 0.1725\text{ V}$.*

---

## 2. DC Differential Input Sweep (`tb_dc_diff.log`)

- **Simulation Command:** `LTspice.exe -b tb_dc_diff.cir`
- **Sweep Range:** Differential voltage $V_{id} = V_{in+} - V_{in-}$ swept from $-50\text{ mV}$ to $+50\text{ mV}$ in $0.1\text{ mV}$ steps around common-mode $V_{ICM} = 0.60\text{ V}$.

### Key DC Transfer Metrics:
- **Output Midpoint Voltage ($V_{id} = 0$):** $0.37185\text{ V}$
- **Upper Saturation Limit ($V_{out,\max}$):** $0.7932\text{ V}$ (approaching $V_{DD} - |V_{dsat4}|$)
- **Lower Saturation Limit ($V_{out,\min}$):** $0.1671\text{ V}$ (approaching $V(TAIL)$)
- **Linear DC Differential Gain ($dV_{out} / dV_{id}$ at $V_{id} = 0$):**
  $$A_{v0} = \mathbf{353.39\text{ V/V}} \quad (\mathbf{50.965\text{ dB}})$$

---

## 3. AC Small-Signal Frequency Response (`tb_ac_diff.log`)

- **Simulation Command:** `LTspice.exe -b tb_ac_diff.cir`
- **Sweep Range:** $1\text{ Hz}$ to $1\text{ GHz}$ (20 points/decade). Output load: $C_L = 1.0\text{ pF}$.

### Key AC Differential Metrics:
- **Low-Frequency Gain ($A_d$ at $1\text{ Hz}$):** $\mathbf{50.969\text{ dB}}$ ($353.54\text{ V/V}$)
- **Dominant Pole ($-3\text{ dB}$ Cut-Off Frequency $f_{-3\text{dB}}$):** $\mathbf{15.55\text{ kHz}}$
- **Unity Gain Bandwidth ($\text{GBW}$ where $|A_d| = 1$):** $\mathbf{5.462\text{ MHz}}$
- **Low-Frequency Phase:** $-180^\circ$ (inverting differential response from $IN_N$ to $OUT$)

---

## 4. Common-Mode Rejection Analysis (`tb_ac_cm.log`)

- **Simulation Command:** `LTspice.exe -b tb_ac_cm.cir`
- **Common-Mode Input:** Both inputs driven synchronously with $1.0\text{ V}$ AC small signal.

### Rejection Metrics:
- **Common-Mode Gain ($A_{cm}$ at $1\text{ Hz}$):**
  $$A_{cm} = -55.20\text{ dB} \quad (1.737\text{ mV/V})$$
- **Common-Mode Rejection Ratio ($\text{CMRR}$):**
  $$\text{CMRR} = \frac{A_d}{A_{cm}} = \frac{353.54\text{ V/V}}{1.737 \times 10^{-3}\text{ V/V}} = \mathbf{203,500\text{ (Linear)}} \equiv \mathbf{106.17\text{ dB}}$$

---

## 5. Transient Sinusoidal Response & Linearity (`tb_tran.log`)

- **Simulation Command:** `LTspice.exe -b tb_tran.cir`
- **Test Input:** $1.0\text{ kHz}$ sinusoidal differential signal, amplitude $0.1\text{ mV}$ per side ($0.2\text{ mV}$ peak differential, $0.4\text{ mV}_\text{pp}$).

### Waveform Metrics:
- Output Maximum ($V_{out,\max}$): $0.4425\text{ V}$
- Output Minimum ($V_{out,\min}$): $0.3013\text{ V}$
- Peak-to-Peak Swing ($\Delta V_{out}$): $0.1411\text{ V}$
- **Transient Voltage Gain ($V_{out,\text{pp}} / V_{in,\text{pp}}$):** $\mathbf{352.81\text{ V/V}}$ ($\mathbf{50.95\text{ dB}}$)
- **Total Harmonic Distortion ($\text{THD}$ at $1\text{ kHz}$):** $\mathbf{0.0441\%}$

---

## 6. Synthesis & Metric Consistency Check

| Analysis Domain | Measured Gain | Deviation vs Theoretical Target |
| :--- | :--- | :--- |
| Large-Signal DC Derivative | $353.39\text{ V/V}$ ($50.965\text{ dB}$) | Baseline reference |
| Small-Signal AC | $353.54\text{ V/V}$ ($50.969\text{ dB}$) | $+0.04\%$ ($+0.004\text{ dB}$) |
| Transient Time-Domain | $352.81\text{ V/V}$ ($50.951\text{ dB}$) | $-0.16\%$ ($-0.014\text{ dB}$) |

The near-perfect agreement ($< 0.2\%$) across DC, AC, and Transient confirms complete numerical and circuit consistency.
