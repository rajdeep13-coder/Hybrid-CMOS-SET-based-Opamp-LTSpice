# LTspice Simulation Guide

This guide describes how to run and verify the CMOS Differential Stage simulations using LTspice on Windows.

---

## 1. Prerequisites

- **Simulator:** LTspice (tested on LTspice 26.1.1 64-bit for Windows).
  - Executable path on this machine: `C:\Users\rajde\OneDrive\Desktop\LTSPICE\LTspice.exe`.
- **Command Line Shell:** Windows PowerShell 5.1+ or PowerShell 7.

---

## 2. Automated One-Command Batch Execution

To execute all analyses, update logs, and display a formatted metrics summary table, run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\run_differential_stage.ps1
```

The script automatically executes:
1. `CMOS_Differential.asc` (netlist extraction and validation)
2. `tb_op.cir` (Operating point)
3. `tb_dc_diff.cir` (Differential DC sweep)
4. `tb_dc_icmr.cir` (Common-mode range sweep)
5. `tb_ac_diff.cir` (Differential AC response)
6. `tb_ac_cm.cir` (Common-mode rejection)
7. `tb_tran.cir` (Transient sine response & THD)

All results and measurement outputs are placed directly in `circuits/differential_stage/results/`.

---

## 3. Manual Command-Line Execution

You can run individual testbenches in batch mode directly using LTspice `-b`:

```powershell
# Navigate to circuit directory
cd circuits\differential_stage

# Run master schematic
& "C:\Users\rajde\OneDrive\Desktop\LTSPICE\LTspice.exe" -b CMOS_Differential.asc

# Run master netlist
& "C:\Users\rajde\OneDrive\Desktop\LTSPICE\LTspice.exe" -b CMOS_Differential.cir

# Run specific testbench
& "C:\Users\rajde\OneDrive\Desktop\LTSPICE\LTspice.exe" -b tb_op.cir
```

### Viewing Simulation Outputs:
- **Simulation Log (`.log`):** Contains iteration count, operating point matrix, and all `.meas` values.
  ```powershell
  Get-Content tb_op.log
  ```
- **Raw Waveform Data (`.raw`):** Binary/ASCII file containing simulated node traces. Open in LTspice GUI to view plots.

---

## 4. Interactive Graphical User Interface (GUI) Execution

1. Launch LTspice.
2. In LTspice, select **File -> Open...** and browse to:
   `circuits\differential_stage\CMOS_Differential.asc`
3. Click the **Run** button (Running human icon) or press `Alt + R`.
4. Plot probes:
   - Click node `OUT` to plot output voltage.
   - Click node `TAIL` to plot tail source voltage.
   - Click node `VBIAS` to plot bias generator voltage.
   - Alt-click transistor drains to view branch currents.
5. To view measurement results in GUI:
   - Go to **View -> SPICE Error Log** (Shortcut: `Ctrl + L`).

---

## 5. Notes on Informational Log Messages

When running simulations, LTspice prints messages such as:
```text
Instance "M1": Length shorter than recommended for a level 1 MOSFET.
Instance "M1": Width narrower than recommended for a level 1 MOSFET.
```
These are standard informative notices produced by LTspice's built-in model sanity checker for Level 1 MOSFETs when $L < 1\text{ µm}$ or when modern submicron parameters are used. They do not indicate convergence failure, numerical instability, or syntax errors. The solver completes via direct Newton iteration in 21 iterations.
