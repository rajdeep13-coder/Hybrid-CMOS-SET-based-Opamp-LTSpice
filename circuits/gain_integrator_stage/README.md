# Circuit B: CMOS Gain/Integrator Stage

## Purpose

Circuit B is an independently simulated NMOS common-source gain stage loaded by a PMOS current source. It is a building block for a future two-stage op-amp, not a complete operational amplifier.

## Component Functions

| Component | Function |
|---|---|
| M7 | NMOS common-source gain transistor |
| M8 | PMOS active load and current source |
| M9 | PMOS diode-connected bias reference |
| RPB | Bias resistor for M9 |
| R1, R2 | Divider bias network for M7 |
| CIN | Input DC-blocking capacitor |
| CC | Miller compensation capacitor |
| CL | Output load capacitor |

The supply is 0.8 V. The divider bias is approximately 0.430860 V, and the PMOS reference node VBP is approximately 0.350967 V.

## Files

- Schematic: [CMOS_Gain_Integrator.asc](CMOS_Gain_Integrator.asc)
- Netlist: [CMOS_Gain_Integrator.cir](CMOS_Gain_Integrator.cir)
- Models: [cmos_models.inc](models/cmos_models.inc)
- Testbenches: [testbenches/](testbenches/)
- Archived logs: [results/](results/)

## Testbenches

| File | Purpose |
|---|---|
| [testbenches/tb_op.cir](testbenches/tb_op.cir) | Quiescent voltages, currents, saturation margins, and power |
| [testbenches/tb_dc.cir](testbenches/tb_dc.cir) | Voltage-transfer characteristic and DC gain |
| [testbenches/tb_ac.cir](testbenches/tb_ac.cir) | Small-signal gain and bandwidth |
| [testbenches/tb_tran.cir](testbenches/tb_tran.cir) | 1 kHz transient gain and THD |

## Verified DC Results

From [testbenches/tb_op.log](testbenches/tb_op.log):

| Parameter | Simulated value |
|---|---:|
| VDD | 0.800000 V |
| VBP | 0.350967 V |
| Gate bias | 0.430860 V |
| VOUT | 0.399838 V |
| Id(M7) | 2.000735 uA |
| Id(M8) | -2.000735 uA |
| Id(M9) | -2.005528 uA |
| Supply current | 6.160566 uA |
| Power | 4.928453 uW |

From [testbenches/tb_dc.log](testbenches/tb_dc.log):

| Parameter | Simulated value |
|---|---:|
| DC gain | -252.359510 V/V |
| DC gain magnitude | 48.040393 dB |
| Maximum output | 0.745866 V |
| Minimum output | 0.052253 V |

## Transient Results

From [testbenches/tb_tran.log](testbenches/tb_tran.log), for a 1 kHz, 1 mV peak input:

| Parameter | Simulated value |
|---|---:|
| Output peak-to-peak | 503.512 mV |
| Transient gain | 251.757 V/V |
| Transient gain | 48.020 dB |
| THD | 0.307237% |

## AC Verification Status

The measurement block in [testbenches/tb_ac.cir](testbenches/tb_ac.cir) is defined with linear magnitude values:

```spice
.meas AC Ad_lin FIND mag(V(OUT)/V(VIN)) AT=10
.meas AC f_3db WHEN mag(V(OUT)/V(VIN))=Ad_lin/sqrt(2) FALL=1
.meas AC f_ug WHEN mag(V(OUT)/V(VIN))=1 FALL=1
.meas AC phase_ug FIND ph(V(OUT)/V(VIN)) AT=f_ug
```

The latest [testbenches/tb_ac.log](testbenches/tb_ac.log) shows Ad_lin displayed by LTspice as 48.036286 dB and f_ug approximately 4.538687 MHz. It also contains an incorrectly named f_3db or complex display result that must not be substituted without independent rerun and verification. No phase margin is reported for this standalone voltage-transfer measurement.
