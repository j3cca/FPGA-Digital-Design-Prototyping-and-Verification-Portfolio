# Configurable Timing Engine: Pulse and PWM Generators

<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/stim_pulse_gen.gif" alt="Demonstration" width="400"> 

> *The demonstration above shows the functionality of a square-wave pulse generator. Because the clock is operating at 12MHz, the human eye is unable to distinguish between high and low intervals, which become "averaged" and dim according to the values applied. The above demonstration shows how the pulse generator can act as a dimmer for an LED. The LOW interval is set to 8 and the HIGH interval is set to 1, 2, 4, and 8 respectively.* 

## Project Overview
**Description:** For this project, I designed and verified two timing engine modules: a parametrized square-wave pulse generator for macro timing control and a parametrized pulse width modulation generator for amplitude control.

The parameterized square-wave pulse generator produces a wave with variable-length high and low intervals. The duration of the intervals is specified by two 4-bit control signals, which are controlled by switches wired to the CMOD S7. The square wave output, for the purpose of demonstration, is wired to an external LED. The design utilizes the CMOD S7's 12MHz onboard crystal oscillator as the clock and onboard button 0 as the asynchronous reset signal.

The pulse width modulation (PWM) generator accepts a control signal that determines the duty cycle of the square wave, which is specified by a 4-bit input wired to switches connected to the device. Like the square-wave pulse generator, this design also utilizes the CMOD S7's 12MHz onboard crystal oscillator as the clock and onboard button 0 as the asynchronous reset signal.

**Pulse Generator Block Diagram:** 
<br>
<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/pulse_gen_block_diagram.png" width="700">
> *The design consists of a synchronous cycle counter that acts as a clock enable signal, and a state machine that tracks the `high_interval` and `low_interval` durations. The logic includes a routing path that forces the output to a safe state if either interval is set to zero, preventing counter underflow.*

**PWM Generator Block Diagram:** 
<br>
<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/PWM_block_diagram.png" width="700">
> *The design consists of a synchronous counter that establishes the fixed cycle frequency, and a comparator that evaluates the count against the incoming duty_cycle value. The logic includes a routing path to handle the 0% and 100% boundary conditions, forcing a clean output to prevent glitches at the extremes.*

## Simulation
**Verification Summary:** To verify the pulse generator design, I wrote a self-checking testbench in SystemVerilog that exhaustively sweeps all 256 input configurations. 

The testbench drives stimulus changes and de-asserts the reset on the negative clock edge to prevent race conditions with the design's active-high reset. Because the 12 MHz clock has a fractional period 83.333 ns, the testbench uses a 1ns / 1fs timescale and verifies output pulse widths using `$realtime` checks with a 1 ps tolerance to handle rounding errors. 

Finally, I wrapped the transition checks in parallel `fork...join_any` watchdogs; if a pulse fails to trigger, the watchdog times out instead of hanging the simulator.

To verify the PWM generator design, I reused the pulse generator testbench to sweep all 16 possible duty cycle lengths. This was a great demonstration of how modular design can decrease production time.

**Pulse Generation Simulation Waveform**
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/pulse_gen_waveforms.png)
> *This image shows the simulation waveform successfully transitioning between dynamic high and low interval configurations, including the handling of zero-interval edge cases.*

**PWM Generation Simulation Waveform**
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/PWM_waveforms.png)
> *This image shows the simulation waveform successfully outputting a high pulse based on the inputted duty cycle. In cases 0 and 15, the square wave remains low and high respectively.*

**Pulse Generation Simulation Log Snippet**
<details>
<summary><i>Click to expand</i></summary>

``` 
-- Starting Test Bench --
Test number 0 executing...
PASS test:
 high = 0
 low = 0

PASS test:
 high = 1
 duration = 1000.000 ns

PASS test:
 low = 1
 duration = 1000.000 ns

Test number 20 executing...

PASS test:
 high = 2
 duration = 2000.000 ns

PASS test:
 low = 10
 duration = 10000.000 ns
...

-- Test Bench Summary --
Pass count: 512
Fail count: 0
All tests passed!
$finish called at time : 854000 ns
```
</details>

## Implementation  
**Pulse Generator Schematic:**  
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/pulse_gen_schematic.png)

**Pulse Generator FPGA Utilization and Propagation Delay:**  
<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/pulse_gen_utilization.png" width="400">

**PWM Generator Schematic:**  
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/PWM_schematic.png)

**PWM Generator FPGA Utilization and Propagation Delay:**  
<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/PWM_utilization.png" width="400">

## Reflection
This project was a great exercise in shifting from basic value checking testbenches to verifying temporal behavior. Previously, I primarily focused on checking if the DUT's output matched an expected static value. However, because timing precision was what I needed to verify, I learned how to implement `fork...join_any` watchdog threads to catch missing pulses without hanging the simulator, which seems an essential skill for designs where deterministic timing is critical.

I also saw how visual verification of the design on a board belies the actual functioning of the design: for the pulse generator design, the LED appeared to dim like it would for a PWM generator, but the LED was actually flashing so quickly I couldn't see it. This optical averaing made the two designs look nearly identical physically, even though their internal RTL is completely different. This further cements the importance of designing a robust testbench to verify correctness.

## Directory Table of Contents
<pre>
Configurable Timing Engine: Pulse and PWM Generators/
│
├── src/
│   ├── <a href="./src/stim_pulse_gen.sv">stim_pulse_gen.sv</a>
│   └── <a href="./src/pulse_width_modulation.sv">pulse_width_modulation.sv</a>
│
├── sim/
│   ├── <a href="./sim/TB_stim_pulse_gen.sv">TB_stim_pulse_gen.sv</a>
│   ├── <a href="./sim/TB_PWM.sv">TB_PWM.sv</a>
│   ├── <a href="./sim/TB_stim_pulse_gen_behav.wcfg">TB_stim_pulse_gen_behav.wcfg</a>
│   └── <a href="./sim/TB_PWM_behav.wcfg">TB_PWM_behav.wcfg</a>
│
├── constraints/
│   ├── <a href="./constraints/Cmod-S7-25_stim_pulse_gen.xdc">Cmod-S7-25_stim_pulse_gen.xdc</a>
│   └── <a href="./constraints/Cmod-S7-25_PWM.xdc">Cmod-S7-25_PWM.xdc</a>
│
└── <a href="./README.md">README.md</a>
</pre>
