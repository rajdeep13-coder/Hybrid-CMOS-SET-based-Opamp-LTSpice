# Simulation Results

All values below are LTspice simulated results, not hardware measurements.

## Verification Status Definitions

- **Verified in current log:** the value is present in the identified `.log` file.
- **Previously archived:** the value exists in older repository documentation or logs but should be cross-checked before final use.
- **Pending independent rerun:** the measurement expression exists but needs a fresh verified run.

## Circuit A: CMOS Differential Stage

Source: [differential-stage operating-point log](../circuits/differential_stage/tb_op.log) and [AC log](../circuits/differential_stage/tb_ac_diff.log).

| Parameter | Value | Status | Source |
|---|---:|---|---|
| VDD | 0.800000 V | Verified | `tb_op.log` |
| VBIAS | 0.448867 V | Verified | `tb_op.log` |
| VTAIL | 0.172467 V | Verified | `tb_op.log` |
| VOUT | 0.371845 V | Verified | `tb_op.log` |
| Id(M1), Id(M2) | 0.998232 uA each | Verified | `tb_op.log` |
| Id(M5) | 1.996463 uA | Verified | `tb_op.log` |
| Id(M6) | 2.023819 uA | Verified | `tb_op.log` |
| Dissipation | 3.216226 uW | Verified | `tb_op.log` |
| Differential AC gain | 50.968997 dB | Verified | `tb_ac_diff.log` |
| -3 dB bandwidth | 15.550169 kHz | Verified | `tb_ac_diff.log` |
| Unity-gain frequency | 5.461958 MHz | Verified | `tb_ac_diff.log` |

Additional archived Circuit A results include DC sweep gain and CMRR. These require use of their corresponding testbench logs and should not be confused with Circuit B values.

## Circuit B: CMOS Gain/Integrator Stage

### DC Operating Point

Source: [tb_op.log](../circuits/gain_integrator_stage/testbenches/tb_op.log).

| Parameter | Value | Status |
|---|---:|---|
| VDD | 0.800000 V | Verified |
| VBP | 0.350967 V | Verified |
| Gate bias | 0.430860 V | Verified |
| VOUT | 0.399838 V | Verified |
| Id(M7) | 2.000735 uA | Verified |
| Id(M8) | -2.000735 uA | Verified |
| Id(M9) | -2.005528 uA | Verified |
| Supply current | 6.160566 uA | Verified |
| Power | 4.928453 uW | Verified |

### DC Sweep

Source: [tb_dc.log](../circuits/gain_integrator_stage/testbenches/tb_dc.log).

| Parameter | Value | Status |
|---|---:|---|
| Voltage gain | -252.359509 V/V | Verified |
| Gain magnitude | 48.040393 dB | Verified |
| Maximum output | 0.745866 V | Verified |
| Minimum output | 0.052253 V | Verified |

### AC Analysis

Source: [tb_ac.cir](../circuits/gain_integrator_stage/testbenches/tb_ac.cir) and [tb_ac.log](../circuits/gain_integrator_stage/testbenches/tb_ac.log).

| Parameter | Latest displayed value | Status |
|---|---:|---|
| Linear low-frequency gain | 48.036286 dB display for `Ad_lin` | Linear magnitude; pending independent final verification |
| Incorrectly converted `Ad_db` | 34.834797 dB | Invalid for amplifier gain |
| Unity-gain frequency | 4.538687 MHz | Pending corrected-block verification |
| -3 dB bandwidth | 15.568982 kHz in current log | Pending independent rerun because it must match the corrected expression |
| Transfer phase at unity gain | 0 degrees in the latest pasted status | Standalone response phase, not phase margin |

The previous 48.04 dB low-frequency gain and 15.569 kHz bandwidth are archived values. They may be consistent with the DC result but are not a substitute for a fresh corrected AC verification.

### Transient Analysis

Source: [tb_tran.log](../circuits/gain_integrator_stage/testbenches/tb_tran.log).

| Parameter | Value | Status |
|---|---:|---|
| Input frequency | 1 kHz | Verified |
| Input amplitude | 1 mV peak | Verified |
| Output peak-to-peak | 503.511876 mV | Verified |
| Transient gain | 251.757186 V/V | Verified |
| Transient gain | 48.019638 dB | Verified |
| THD | 0.307237% | Verified |

## Comparison

| Metric | Circuit A | Circuit B |
|---|---:|---:|
| Supply | 0.8 V | 0.8 V |
| Low-frequency gain | 50.969 dB AC | 48.040 dB DC |
| -3 dB bandwidth | 15.550 kHz | 15.569 kHz archived / corrected run pending |
| Unity-gain frequency | 5.462 MHz | approximately 4.539 MHz, pending corrected verification |
| Transient gain | Archived stage-specific result | 251.757 V/V |
| THD | Stage-specific log where available | 0.307237% |

No complete hybrid CMOS-SET op-amp result is included.
