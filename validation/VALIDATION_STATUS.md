# Validation Status & Test Log Matrix

This document tracks the verification status for every test executed in the project.

---

## 1. Test Execution Matrix: Circuit A (CMOS Differential Stage)

| Test ID | Domain | Testbench File | Simulation Command | Target Metric | Measured Value | Pass / Fail | Notes & Convergence |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **TEST-01** | Schematic | `CMOS_Differential.asc` | `LTspice.exe -netlist CMOS_Differential.asc` | Clean pin netlist | Generated `CMOS_Differential.net` | **PASS** | Zero unconnected pins (`NC`); matching netlist. |
| **TEST-02** | Schematic | `CMOS_Differential.asc` | `LTspice.exe -b CMOS_Differential.asc` | Batch simulation run | Completed; generated `.log` and `.raw` | **PASS** | 21 iterations; 0.16 s. |
| **TEST-03** | Operating Point | `tb_op.cir` | `LTspice.exe -b tb_op.cir` | $I_{tail} = 2.0\text{ µA} \pm 5\%$ | $I_{tail} = 1.9965\text{ µA}$ | **PASS** | Error = -0.18%; All 5 transistors saturated. |
| **TEST-04** | Branch Balance | `tb_op.cir` | `LTspice.exe -b tb_op.cir` | $|I_1 - I_2| = 0$ | Error = $0.0000\text{ nA}$ | **PASS** | Perfectly balanced input pair. |
| **TEST-05** | Power Consumption | `tb_op.cir` | `LTspice.exe -b tb_op.cir` | $P_{diss} < 10\text{ µW}$ | $P_{diss} = 3.216\text{ µW}$ | **PASS** | Sub-4 µW ultra-low power. |
| **TEST-06** | DC Differential | `tb_dc_diff.cir` | `LTspice.exe -b tb_dc_diff.cir` | $A_{v0} > 40\text{ dB}$ | $A_{v0} = 50.965\text{ dB}$ ($353.39\text{ V/V}$) | **PASS** | Sweep $-50\text{ mV}$ to $+50\text{ mV}$. |
| **TEST-07** | ICMR Headroom | `tb_dc_icmr.cir` | `LTspice.exe -b tb_dc_icmr.cir` | Linear range $> 100\text{ mV}$ | Valid: $0.54\text{ V}$ to $0.72\text{ V}$ | **PASS** | Nominal bias $0.60\text{ V}$ is centered. |
| **TEST-08** | AC Gain & Bandwidth | `tb_ac_diff.cir` | `LTspice.exe -b tb_ac_diff.cir` | $A_d > 40\text{ dB}$ | $A_d = 50.969\text{ dB}$, $\text{GBW} = 5.46\text{ MHz}$ | **PASS** | $f_{-3\text{dB}} = 15.55\text{ kHz}$ with $C_L = 1\text{ pF}$. |
| **TEST-09** | Common-Mode AC & CMRR | `tb_ac_cm.cir` | `LTspice.exe -b tb_ac_cm.cir` | $\text{CMRR} > 80\text{ dB}$ | $\text{CMRR} = 106.17\text{ dB}$ | **PASS** | $A_{cm} = -55.20\text{ dB}$ ($1.737\text{ mV/V}$). |
| **TEST-10** | Transient Response | `tb_tran.cir` | `LTspice.exe -b tb_tran.cir` | $\text{THD} < 1.0\%$ | $\text{THD} = 0.0441\%$ | **PASS** | $1\text{ kHz}$ sine; transient gain = $352.81\text{ V/V}$. |

---

## 2. Test Execution Matrix: Circuit B (Gain / Integrator Stage)

| Test ID | Domain | Testbench File | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **TEST-11** | All | `CMOS_Gain_Integrator.*` | **NOT RUN** | Pending user approval of Circuit A in accordance with Section 9. |

---

## 3. Simulator Warnings & Observability Record

During simulation, the LTspice solver emitted informational warnings:
```text
Instance "M6": Length shorter than recommended for a level 1 MOSFET.
Instance "M6": Width narrower than recommended for a level 1 MOSFET.
```
- **Analysis:** Harmless sanity messages produced by LTspice's default rule set for SPICE Level 1 when device channel lengths are below 1 µm.
- **Action Taken:** Dimensions were established at $L = 1.0\text{ µm}$ and verified. Solver converged via Direct Newton iteration with zero numerical damped iterations and zero timestep cuts.
