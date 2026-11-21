# Circuit A: CMOS Differential Input Stage

## Purpose

Circuit A is an independently simulated low-voltage CMOS differential amplifier. It converts a differential input around a 0.6 V common-mode level into an amplified single-ended output.

## Topology

- M1 and M2: NMOS differential input pair.
- M3 and M4: PMOS active current-mirror load.
- M5: NMOS tail current sink.
- M6: diode-connected NMOS bias reference.
- Rbias: 173.5 kohm resistor setting the reference branch current.
- CL: 1 pF output load.

The supply is 0.8 V. VIP and VIN are nominally 0.6 V for differential operating-point conditions.

## Testbenches

| File | Purpose |
|---|---|
| [tb_op.cir](tb_op.cir) | Operating point, node voltages, currents, and power |
| [tb_dc_diff.cir](tb_dc_diff.cir) | Differential DC voltage transfer |
| [tb_dc_icmr.cir](tb_dc_icmr.cir) | Input common-mode range |
| [tb_ac_diff.cir](tb_ac_diff.cir) | Differential AC gain and bandwidth |
| [tb_ac_cm.cir](tb_ac_cm.cir) | Common-mode gain and CMRR |
| [tb_tran.cir](tb_tran.cir) | Transient response and THD |

The graphical schematic is [CMOS_Differential.asc](CMOS_Differential.asc), and the standalone netlist is [CMOS_Differential.cir](CMOS_Differential.cir). Generic models are in [cmos_models.inc](models/cmos_models.inc).

## Verified Operating Point

From [tb_op.log](tb_op.log):

| Parameter | Simulated value |
|---|---:|
| VDD | 0.800000 V |
| VBIAS | 0.448867 V |
| VTAIL | 0.172467 V |
| VOUT | 0.371845 V |
| Id(M1), Id(M2) | 0.998232 uA each |
| Id(M5) | 1.996463 uA |
| Id(M6) | 2.023819 uA |
| Dissipation | 3.216226 uW |

## Verified Frequency Response

From [tb_ac_diff.log](tb_ac_diff.log):

| Parameter | Simulated value | Status |
|---|---:|---|
| Differential AC gain | 50.969 dB | Verified in log |
| -3 dB bandwidth | 15.550 kHz | Verified in log |
| Unity-gain frequency | 5.461958 MHz | Verified in log |

The -3 dB and GBW measurements in this log use the measured magnitude in V/V, and the corresponding twice-log-converted metric is not used.

## Other Available Results

- DC differential gain and input common-mode range logs are in [results/](results/).
- Common-mode gain and CMRR log: [tb_ac_cm.log](results/tb_ac_cm.log).
- Transient gain and THD log: [tb_tran.log](results/tb_tran.log).

These are LTspice simulation results using generic Level-1 MOS models, not fabricated hardware measurements.
