# Development Roadmap

## 1. Verify All Individual CMOS Stages

- [ ] Recheck Circuit A logs and measurement expressions.
- [ ] Recheck Circuit B operating-point and DC sweep logs.
- [ ] Complete the independent corrected Circuit B AC rerun.
- [ ] Validate transient measurements and THD.

## 2. Finalize and Validate Measurement Directives

- [ ] Use linear magnitude values for Circuit B gain and bandwidth.
- [ ] Remove or clearly label older incorrect dB measurements.
- [ ] Archive a final set of corrected LTspice logs.
- [ ] Cross-check all documentation against those logs.

## 3. Integrate the CMOS Stages

- [ ] Cascade the differential stage and gain stage.
- [ ] Verify operating-point bias compatibility.
- [ ] Measure overall open-loop DC and AC response.
- [ ] Build and validate feedback testbenches.

## 4. Develop the SET Device Model

- [ ] Select an appropriate SET modeling approach.
- [ ] Establish Coulomb-blockage and charging-energy parameters.
- [ ] Define temperature and device-parameter assumptions.
- [ ] Validate the standalone SET model against chosen reference data.

## 5. Integrate SET with the CMOS Architecture

- [ ] Add SET elements to a defined CMOS node or load.
- [ ] Verify each hybrid sub-block.
- [ ] Identify additional bias constraints and operating conditions.

## 6. Simulate the Complete Hybrid CMOS-SET Op-Amp

- [ ] Run operating-point, DC, AC, transient, and feedback simulations.
- [ ] Reassess compensation and stability for the complete circuit.
- [ ] Compare predicted behavior against the CMOS baseline.

## 7. Evaluate Performance

- [ ] Gain
- [ ] Bandwidth and unity-gain frequency
- [ ] Power consumption
- [ ] Input common-mode range
- [ ] CMRR and PSRR, if testable
- [ ] Slew rate
- [ ] Transient response and THD
- [ ] Phase margin and gain margin through loop-gain analysis

## 8. Compare with CMOS-Only Baseline

- [ ] Document gains and bandwidth differences.
- [ ] Separate SET benefits from model assumptions.
- [ ] Report uncertainty and parameter sensitivity.

## 9. Prepare Final Plots and Report

- [ ] Generate verified plots from archived raw data.
- [ ] Create final tables and references.
- [ ] Prepare the technical report for evaluation.

This roadmap is prospective. No item listed as future work is currently represented as completed.
