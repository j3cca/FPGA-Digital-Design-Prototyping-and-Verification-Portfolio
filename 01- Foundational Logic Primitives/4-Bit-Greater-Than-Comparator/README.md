# 4-Bit Greater-Than Comparator

<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/4_bit_comparator.gif" alt="Demonstration" width="400"> 

> *The above demonstration is for a 4-bit greater than comparator, which compares value A with value B and lights up the external LED if A > B, and the on-board LED if A !> B. This design was implemented on a CMOD S7.* 

## Project Overview
**Description:** This project consists of a 4-bit greater-than comparator written in RTL using only gate-level logical operators. The 4-bit greater-than comparator accepts two 4-bit inputs and outputs 1 if input A is greater than B, and 0 if A is not greater than B. 

The 4-bit comparator is composed of two 2-bit greater-than comparator modules and one 2-bit equal-to module joined using a minimal number of logic gates. 

Each module was verified with a self-checking testbench that iterated through all possible input combinations to ensure rigorous correctness.

The bitfile was flashed to a CMOD S7 FPGA board. To interface with the FPGA, 8 DIP-switches were wired to accept the inputs and an external LED was wired to output the result.

**Block Diagram:**  
<br>
<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/greater_4bit_block_diagram.jpg" width="700">
> *The 4-bit greater-than comparator accepts two 4-bit inputs (called A and B). The most significant bits of the inputs are fed into both the MSB greater-than comparator and the MSB equal-to comparator. The least significant bits of the inputs are fed into the LSB greater-than comparator.*

> *The outputs of these comparators are joined with glue logic, outputting from the 4-bit module a 1 if A is greater than B, and 0 if A is not greater than B.* 

## Simulation
**Verification Summary:** To verify the functionality of each module, self-checking testbenches were constructed using for-loops to iterate through all possible input combinations, ensuring rigorous correctness. For troubleshooting, $display statements printed the inputs and outputs of each test and whether it passed or failed. 

**Simulation Waveform**  
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/greater_4bit_simulation_waveforms.png)
> *This image shows the full simulation waveform for all inputs of A and B. The onboardLED is inverted from externalLED to provide a visual reference for inputs in which A is not greater than B.*

**Simulation Log Snippet**
<details>
<summary><i>Click to expand</i></summary>

``` Time resolution is 1 ps  
-- Starting Test Bench --  
PASS test: 0000 > 0000 (0)  
PASS test: 0000 > 0001 (0)  
PASS test: 0000 > 0010 (0)  
PASS test: 0000 > 0011 (0)   
...  
PASS test: 1111 > 1100 (1)  
PASS test: 1111 > 1101 (1)  
PASS test: 1111 > 1110 (1)  
PASS test: 1111 > 1111 (0)  
-- Test Bench Summary --  
Pass count: 256  
Fail count: 0  
All tests passed!  
$finish called at time : 2560 ns
```
</details>

## Implementation  
**Schematic:**  
<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/greater_4bit_schematic.png" width="800">

**FPGA Utilization:**  
<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/greater_4bit_utilization.png" width="600">

## Directory Table of Contents
<pre>
4-bit Greater-Than Comparator/
│
├── src/
│   ├── <a href="./src/greater_4bit_top.sv">greater_4bit_top.sv</a>
│   ├── <a href="./src/greater_2bit.sv">greater_2bit.sv</a>
│   └── <a href="./src/equal_2bit.sv">equal_2bit.sv</a>
│
├── sim/
│   ├── <a href="./sim/TB_greater_4bit.sv">TB_greater_4bit.sv</a>
│   └── <a href="./sim/TB_greater_4bit_behav.wcfg">TB_greater_4bit_behav.wcfg</a>
│
├── constraints/
│   └── <a href="./constraints/Cmod-S7-25-Master.xdc">Cmod-S7-25-Master.xdc</a>
│
└── <a href="./README.md">README.md</a>
</pre>
