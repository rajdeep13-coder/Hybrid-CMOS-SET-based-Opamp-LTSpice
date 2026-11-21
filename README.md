# Hybrid CMOS-SET Based Op-Amp LTspice Project

## Abstract

This repository contains LTspice work toward a low-voltage operational amplifier using CMOS and future Single-Electron Transistor (SET) components. Two CMOS stages have been developed and simulated separately: a differential input stage and a common-source gain/integrator stage. The complete hybrid CMOS-SET operational amplifier, SET model integration, and closed-loop stability analysis remain future work.

## Introduction and Motivation

SET devices offer quantized electron transport and potentially high sensitivity, but implementation and parameterization require a validated compact model and supporting process assumptions. This project therefore separates the CMOS baseline stages before attempting hybrid integration. The separate stages provide reproducible DC biasing, frequency-response, and transient baselines.

## Problem Statement

The repository does not yet contain an implemented, tested hybrid CMOS-SET amplifier. The current problem is to characterize each CMOS building block accurately, identify verified and pending measurements, and establish a reliable CMOS baseline before SET integration.

## Project Objectives

- Develop and document a low-voltage CMOS differential input stage.
- Develop and document a CMOS gain/integrator stage.
- Verify quiescent bias, DC transfer characteristics, AC response, and transient behavior through LTspice logs.
- Preserve the distinction between voltage-transfer phase and loop-gain phase margin.
- Establish a roadmap for SET modeling and final CMOS-SET integration.

## Proposed System Architecture

The intended architecture is a multi-stage amplifier containing:

1. A differential input stage.
2. A high-gain gain/integrator stage.
3. A future SET-enhanced or SET-integrated element.
4. A future closed-loop feedback network for stability evaluation.

The two existing CMOS circuits are independent building blocks. They are not presently cascaded as a complete hybrid op-amp in the repository.

## Circuit A: CMOS Differential Stage

Circuit A is an NMOS differential pair with a PMOS active current-mirror load and an NMOS tail-current sink. An NMOS diode-connected reference resistor branch sets the bias voltage.

- Supply: 0.8 V
- Nominal differential inputs: 0.6 V common-mode
- Tail current: approximately 1.9965 uA
- Differential AC gain: approximately 50.969 dB
- -3 dB bandwidth: approximately 15.550 kHz
- Unity-gain bandwidth: approximately 5.462 MHz
- Source: [Circuit A README](circuits/differential_stage/README.md)

## Circuit B: CMOS Gain/Integrator Stage

Circuit B is an NMOS common-source gain transistor loaded by a PMOS active current source. A PMOS diode-connected reference and resistor set the load bias. A divider biases M7, CIN blocks DC at the input, CC is a Miller compensation capacitor, and CL is the output load.

- Supply: 0.8 V
- DC gain: approximately 252.36 V/V, or 48.040 dB
- DC operating-point values and detailed transient measurements are listed in [SIMULATION_RESULTS.md](docs/SIMULATION_RESULTS.md).
- Source: [Circuit B README](circuits/gain_integrator_stage/README.md)

The corrected Circuit B AC block uses linear voltage-magnitude measurements for gain and bandwidth. The latest log run contains a valid linear gain result and a linear magnitude measurement, but the 34.834797 dB value shown in an earlier run is not valid as amplifier gain because of double dB conversion. The corrected measurement block has to remain independently rerun when final reporting is performed.

## Simulation Environment and Tools

- LTspice 26.1.1 for Windows
- Windows PowerShell for batch automation
- Generic Level-1 Shichman-Hodges MOS models

The models do not represent a foundry process. LTspice warnings about oxide thickness, channel length, and channel width are model sanity warnings and do not by themselves indicate simulation failure.

## Simulation Methodology

- DC operating point: validates node voltages, branch currents, power, and transistor headroom.
- DC sweep: evaluates voltage transfer and local gain.
- AC sweep: evaluates low-frequency gain and bandwidth.
- Transient sweep: evaluates time-domain gain and distortion.

See [METHODOLOGY.md](docs/METHODOLOGY.md).

## Results Summary

Verified logs are documented in [SIMULATION_RESULTS.md](docs/SIMULATION_RESULTS.md). Values are reported as simulated values, not physical measurements. The existing Circuit B AC gain and bandwidth block needs an independent rerun before the corrected values are promoted to fully verified final figures.

## Current Development Status

| Item | Status |
|---|---|
| Circuit A schematic/netlist | Developed |
| Circuit A DC, AC, CMRR, and transient testbenches | Executed where logs exist |
| Circuit B schematic/netlist | Developed |
| Circuit B DC, AC, operating-point, and transient testbenches | Executed; AC corrected block pending final independent verification |
| Complete CMOS two-stage cascade | Not established |
| SET model | Not implemented with verified parameters |
| Complete hybrid CMOS-SET op-amp | Future work |
| Closed-loop stability/phase-margin analysis | Not performed |

## Limitations

- Generic Level-1 MOS models are used instead of a foundry PDK.
- No SET model or verified SET parameters are present.
- The circuits are simulations, not fabricated hardware.
- Circuit B voltage-transfer phase is not loop-gain phase margin.
- Some older or superseded results may exist in logs and must not be silently substituted for corrected measurements.

## Future Work

The detailed staged plan is in [ROADMAP.md](docs/ROADMAP.md).

## Repository Structure

```text
circuits/
  differential_stage/       Circuit A schematic, netlist, testbenches, and logs
  gain_integrator_stage/    Circuit B schematic, netlist, testbenches, and logs
docs/                       Engineering documentation
scripts/                    PowerShell batch runners
validation/                 Validation status
Diagrams/                   Existing project diagrams
```

## Opening and Running Simulations in LTspice

1. Open LTspice for Windows.
2. Open `circuits/differential_stage/CMOS_Differential.asc` or `circuits/gain_integrator_stage/CMOS_Gain_Integrator.asc`.
3. Run the schematic with the Run command or press `Alt+R`.
4. Use `View -> SPICE Error Log` or press `Ctrl+L` to inspect measured values.

Standalone testbenches can be run from the repository root with LTspice batch mode:

```powershell
& "C:\path\to\LTspice.exe" -b circuits\differential_stage\tb_op.cir
& "C:\path\to\LTspice.exe" -b circuits\gain_integrator_stage\testbenches\tb_op.cir
```
