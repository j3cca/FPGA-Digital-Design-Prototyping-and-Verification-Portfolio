# Bidirectional Int to Floating Point Converter

## Project Overview
**Description:** For this project, I designed and verified a bidirectional Integer-to-Floating-Point conversion unit. This simulates the data-formatting stage of a medical DSP pipeline, where raw 8-bit signed integer sensor data is converted into a high-precision floating-point format for algorithmic processing, and then converted back for hardware output.

Rather than utilizing the Chu textbook's simplified format, I engineered a custom 13-bit IEEE-esque format.

`[12] Sign | [11:8] Exponent | [7:0] Mantissa`

This required routing to handle an implicit hidden leading bit within the mantissa and a 4-bit exponent bias, which allows for more data to be contained within fewer bits, increasing the precision and range of the floating point values. I also included overflow and underflow flags in the decoder to account for the asymmetrical limits of 8-bit 2's Complement arithmetic.

**Block Diagram:** 
<br>
><img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/int_to_fp_block_diagram.png" width="700">  
> *The unit consists of two main modules. The `int_to_fp` encoder extracts the sign, takes the absolute magnitude, then uses a priority encoder to find the leading '1', which is used to calculate the exponent with bias. I used a barrel shifter to align the mantissa while hiding the leading bit.*

><img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/fp_to_int_block_diagram.png" width="800"> 
> *The `fp_to_int` decoder reverses this process by un-biasing the exponent, restoring the hidden '1' (or 0 in the case of denormal numbers), shifting the mantissa back into an integer format, and applying a Two's Complement inverter if the original sign bit was negative. It also includes parallel logic to flag underflow (uf) and overflow (of) conditions.*

## Simulation
**Verification Summary:** To ensure mathematical integrity without relying on a tautological testbench, I implemented a Built-In Self-Test Loopback architecture. 

The testbench instantiates both the encoder and decoder back-to-back. It exhaustively tests the 8-bit signed integer space (-128 to 127), feeding the output of the encoder directly into the input of the decoder. A self-checking assertion guarantees that the input and output match, mathematically proving that no data is lost to truncation or rounding errors during the bidirectional conversion. It also strictly verifies that the underflow and overflow flags remain low for valid data.

**Simulation Waveform**
![image](https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/bidirectional_int_fp_converter_simulation_waveforms.png)
> *This image shows the final portion of the simulation waveform with all test cases passed*

**Simulation Log Snippet**
<details>
<summary><i>Click to expand</i></summary>

``` Time resolution is 1 ps
-- Starting Test Bench --
Test number        -120 executing...
Test number        -100 executing...
Test number         -80 executing...
Test number         -60 executing...
Test number         -40 executing...
Test number         -20 executing...
Test number           0 executing...
Test number          20 executing...
Test number          40 executing...
Test number          60 executing...
Test number          80 executing...
Test number         100 executing...
Test number         120 executing...
-- Test Bench Summary --
Pass count: 256
Fail count: 0
All tests passed!
$finish called at time : 2560 ns
```
</details>

## Implementation  
**Schematic:**  
<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/bidirectional_int_fp_converter_schematic.png" width="800">

**FPGA Utilization and Propagation Delay:**  
<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/bidirectional_int_fp_converter_resource_utilization.png" width="600">

## Reflection
This project was a great exercise in precision and understanding the design decisions behind different numerical representations and the implications of those decisions. 

I realized that the integer inputs 1 and 0 are identical when examining only the mantissa and exponent fields due to the implicit leading 1. In order to reconcile this, I implemented a bias field in the exponent so that I could represent results with a leading 0, allowing for denormal numbers.

The bit manipulation was a nice challenge, and I enjoyed how the project coalesced with the BIST Testbench. If I were to do this project again, however, I would implement a golden testbench for both modules individually to best verify that the designs perform as they should in all cases.

## Directory Table of Contents
<pre>
Bidirectional Int to Floating Point Converter/
│
├── src/
│   ├── <a href="./src/int_to_fp.sv">int_to_fp.sv</a>
│   └── <a href="./src/fp_to_int.sv">fp_to_int.sv</a>
│
├── sim/
│   ├── <a href="./sim/BIST_loopback_TB.sv">BIST_loopback_TB.sv</a>
│   └── <a href="./sim/BIST_loopback_behav.wcfg">BIST_loopback_behav.wcfg</a>
│
├── constraints/
│   └── <a href="./constraints/Cmod-S7-25-Master.xdc">Cmod-S7-25-Master.xdc</a>
│
└── <a href="./README.md">README.md</a>
</pre>
