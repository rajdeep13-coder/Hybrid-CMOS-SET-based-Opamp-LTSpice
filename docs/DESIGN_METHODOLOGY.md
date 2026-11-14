# Analog Design Methodology

## 1. Low-Voltage Headroom Budgeting ($V_{DD} = 0.80\text{ V}$)

Designing analog circuits at sub-1V supply voltages requires strict management of transistor gate overdrive voltages ($V_{ov} = V_{gs} - V_{th}$) and drain-to-source saturation voltages ($V_{dsat} \approx V_{ov}$).

### Vertical DC Voltage Stack (Differential Stage Branch):
In the differential amplifier branch from $V_{DD}$ to $GND$:
$$V_{DD} = |V_{ds,PMOS}| + V_{ds,NMOS} + V_{ds,Tail}$$

With $V_{DD} = 0.80\text{ V}$:
1. **PMOS Active Load ($M_3 / M_4$):**
   - Diode-connected $M_3$ sets $|V_{gs3}| = |V_{thp}| + |V_{ov3}| \approx 0.35\text{ V} + 0.078\text{ V} = 0.428\text{ V}$.
   - Thus, the drain voltage $V(N\_D1) = V_{DD} - |V_{gs3}| = 0.80\text{ V} - 0.428\text{ V} = 0.372\text{ V}$.
   - PMOS saturation margin: $|V_{ds}| = 0.428\text{ V} \gg |V_{ov}| = 0.078\text{ V}$ (safe margin $+350\text{ mV}$).
2. **NMOS Differential Pair ($M_1 / M_2$):**
   - Tail node voltage: $V(TAIL) \approx 0.172\text{ V}$.
   - $V_{ds1} = V_{ds2} = V(N\_D1) - V(TAIL) = 0.372\text{ V} - 0.172\text{ V} = 0.200\text{ V}$.
   - Overdrive voltage: $V_{ov1} = 0.058\text{ V}$.
   - Saturation margin: $V_{ds1} = 0.200\text{ V} > V_{ov1} = 0.058\text{ V}$ (safe margin $+142\text{ mV}$).
3. **NMOS Tail Current Sink ($M_5$):**
   - $V_{ds5} = V(TAIL) = 0.172\text{ V}$.
   - $V_{ov5} = V_{gs5} - V_{thn} = 0.449\text{ V} - 0.350\text{ V} = 0.099\text{ V}$.
   - Saturation margin: $V_{ds5} = 0.172\text{ V} > V_{ov5} = 0.099\text{ V}$ (safe margin $+73\text{ mV}$).

All 5 core active transistors (plus the diode reference $M_6$) reside squarely in the **saturation region**, preventing triode collapse and distortion.

---

## 2. Input Common-Mode Range (ICMR) Analysis

The valid common-mode input range is bounded by:

### Minimum Input Voltage ($V_{ICM,\min}$):
To keep tail transistor $M_5$ saturated ($V_{ds5} \ge V_{dsat5}$):
$$V_{ICM,\min} = V_{dsat5} + V_{gs1} = V_{dsat5} + V_{th1} + V_{ov1}$$
With $V_{th1} \approx 0.37\text{ V}$ (including substrate body effect $\gamma = 0.2$ at $V_{sb} = 0.172\text{ V}$):
$$V_{ICM,\min} \approx 0.10\text{ V} + 0.37\text{ V} + 0.06\text{ V} \approx 0.53\text{ V} \text{ to } 0.55\text{ V}$$

### Maximum Input Voltage ($V_{ICM,\max}$):
To keep input transistors $M_1/M_2$ in saturation ($V_{ds1} \ge V_{gs1} - V_{th1}$):
$$V_{ds1} = V(N\_D1) - V_{tail} \ge V_{ICM} - V_{tail} - V_{th1}$$
$$V_{ICM,\max} \le V(N\_D1) + V_{th1} = 0.372\text{ V} + 0.350\text{ V} = 0.722\text{ V}$$

### Operating Point Choice:
We select nominal **$V_{ICM} = 0.60\text{ V}$**, placing the DC bias directly in the center of the valid $[0.54\text{ V}, 0.72\text{ V}]$ common-mode operating corridor.

---

## 3. Small-Signal Differential Gain Formulation

The low-frequency differential voltage gain $A_d$ is:
$$A_d = g_{m1} \cdot R_{out}$$
Where:
- $g_{m1} = \sqrt{2 \cdot K_p \cdot \left(\frac{W}{L}\right)_1 \cdot I_{D1}} \approx \frac{2 \cdot I_{D1}}{V_{ov1}} \approx \frac{2 \cdot 1.0\text{ µA}}{0.058\text{ V}} \approx 34.5\text{ µS}$
- $r_{o2} = \frac{1}{\lambda_n I_{D2}} = \frac{1}{0.05 \cdot 1.0\text{ µA}} = 20\text{ M}\Omega$
- $r_{o4} = \frac{1}{\lambda_p I_{D4}} = \frac{1}{0.05 \cdot 1.0\text{ µA}} = 20\text{ M}\Omega$
- $R_{out} = r_{o2} \parallel r_{o4} = 10\text{ M}\Omega$
- Predicted $A_d = 34.5\text{ µS} \times 10\text{ M}\Omega \approx 345\text{ V/V} \equiv 50.75\text{ dB}$

**Simulated Result:**
- Small-Signal AC Gain: $353.54\text{ V/V}$ ($50.97\text{ dB}$)
- DC Derivative Gain: $353.39\text{ V/V}$ ($50.96\text{ dB}$)
The theoretical and simulated values align to within $0.22\text{ dB}$.

---

## 4. Frequency Response & Pole Locations

The single-ended differential stage output sees a total load capacitance $C_{out} = C_L + C_{gd2} + C_{gd4} \approx 1.0\text{ pF}$.
The dominant output pole $f_p$ is located at:
$$f_p = \frac{1}{2\pi R_{out} C_{out}} \approx \frac{1}{2\pi \times 10\text{ M}\Omega \times 1.0\text{ pF}} \approx 15.9\text{ kHz}$$
- **Simulated $f_{-3\text{dB}}$:** $15.55\text{ kHz}$ (error $< 2.2\%$).

The Unity Gain Bandwidth is:
$$\text{GBW} \approx \frac{g_{m1}}{2\pi C_L} \approx \frac{34.5\text{ µS}}{2\pi \times 1.0\text{ pF}} \approx 5.49\text{ MHz}$$
- **Simulated GBW:** $5.46\text{ MHz}$ (error $< 0.6\%$).
