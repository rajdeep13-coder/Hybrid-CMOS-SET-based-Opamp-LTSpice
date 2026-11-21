# Technical Methodology

## 1. Separate-Stage Simulation

Circuit A and Circuit B are simulated independently because the repository has not yet established a tested SET model or a complete CMOS cascade. Separate testbenches isolate DC biasing, transfer characteristics, frequency response, and transient behavior.

## 2. DC Operating-Point Analysis

An operating-point analysis determines node voltages and transistor currents for a fixed DC input. It validates:

- Supply and node bias voltages.
- Tail, gain, load, and reference currents.
- Saturation margins.
- Quiescent power consumption.

## 3. DC Sweep

A DC sweep applies a controlled incremental input and records the output voltage. The local derivative at the quiescent input is the DC voltage gain:

\[
A_v = \frac{dV_{OUT}}{dV_{IN}}
\]

The sweep also shows saturation limits and output linear range.

## 4. AC Analysis

An AC sweep calculates the small-signal complex transfer \(V_{OUT}/V_{IN}\). For reporting, gain and bandwidth must use magnitude of the ratio:

\[
AdB = 20\log_{10}|V_{OUT}/V_{IN}|
\]

\[
f_{-3dB}: |H(f)| = |H(f_{\text{low}})|/\sqrt{2}
\]

\[
f_u: |H(f_u)|=1
\]

LTspice sometimes displays a complex measurement in dB notation. An amplifier gain must not be calculated by applying 20*log10 to a quantity that is already reported in dB.

## 5. Transient Analysis

A sinusoidal transient determines time-domain output amplitude and waveform distortion. Voltage gain is calculated as:

\[
A_v = \frac{V_{OUT,pp}}{V_{IN,pp}}
\]

and the corresponding dB value is:

\[
A_v(dB)=20\log_{10}(A_v)
\]

THD is calculated from Fourier components of the output waveform.

## 6. Miller Compensation

Circuit B includes a Miller capacitor between OUT and GATE. The physical stage is a lossy integrator with finite low-frequency gain, not an ideal mathematical integrator with infinite DC gain.

The capacitor's Miller multiplication should be evaluated by small-signal AC measurement. It does not by itself prove closed-loop stability.

## 7. Stability and Phase

A standalone transfer phase at the unity-gain frequency is not phase margin. Phase margin requires an appropriate loop-gain analysis around feedback or a separately constructed open-loop test point. No phase-margin or gain-margin claim is made until that analysis exists.

## 8. Generic Level-1 MOS Models

The project uses generic Level-1 MOS models:

- Low parameterization makes the circuits reproducible.
- They provide a baseline topology and operating point.
- They do not model modern short-channel effects accurately.
- They do not include foundry-specific process variability, fabrication spread, parasitic extraction, or a complete noise, reliability, and degradation model.

Warnings about oxide thickness or small dimensions are LTspice model sanity notices for these model assumptions. A converged operating point is not proof of silicon accuracy.
