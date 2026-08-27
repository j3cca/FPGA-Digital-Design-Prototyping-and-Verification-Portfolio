# FPGA Digital Design, Prototyping, and Verification Portfolio

A growing collection of synthesizable RTL modules, DSP pipelines, and self-checking testbenches developed across **SystemVerilog, Verilog, and VHDL**. 

*(Guided in part by "FPGA Prototyping by SystemVerilog Examples" by Pong P. Chu, "FPGA Prototyping by VHDL Examples" by Pong P. Chu, and "SystemVerilog for Verification" by Chris Spear).*

### About Me
As a Computer Engineering senior with a prior B.S. in Biomedical Sciences, my focus is on bridging hardware engineering and healthcare. I am passionate about designing robust, high-performance digital logic and DSP architectures for MedTech applications. This repository serves as a comprehensive portfolio of my independent prototyping, academic projects, and capstone work.

### Hardware Platforms & Prototyping
Projects in this repository were primarily developed and verified in Vivado, targeting various FPGA platforms:

*   **CMOD S7 (Xilinx Spartan-7):** A significant portion of this portfolio was developed independently during Summer 2026. Because the CMOD S7 is a DIP-format FPGA, I built a custom peripheral interface on a solderless breadboard—including DIP switches, indicator LEDs, current-limiting resistors, and pull-down networks—mapped to custom XDC pin constraints.
*   **Digilent Anvyl (Xilinx Spartan-6):** Utilized for mixed-signal audio processing and soft-core microcontroller integration via Xilinx ISE. Working with the board's onboard microphone, speaker ports, and hardware controls, I implemented a PicoBlaze soft-core processor to manage data flow. 

---

## Table of Contents

### <a href="./01- Foundational Logic Primitives">01 - Foundational Logic Primitives</a>
*   <a href="./01- Foundational Logic Primitives/4-Bit-Greater-Than-Comparator">4-Bit Greater-Than Comparator</a> (CMOD S7)
*   <a href="./01- Foundational Logic Primitives/4-to-16-Decoder">4-to-16 Decoder</a> (CMOD S7)

### <a href="./02- Data Processing and DSP">02 - Data Processing and DSP</a>
*   <a href="./02- Data Processing and DSP/Bidirectional-Int-to-Floating-Point-Converter">Bidirectional Int to Floating Point Converter</a> (CMOD S7)
    *   *Simulates the data-formatting stage of a medical DSP pipeline using a custom 13-bit IEEE-esque format.*
*   <a href="./02- Data Processing and DSP/Parametric-Bit-Manipulation-Unit">Parametric Bit-Manipulation Unit</a> (CMOD S7)

### <a href="./03- Timing and Control">03 - Timing and Control</a>
*   <a href="./03- Timing and Control/Configurable Timing-Engine-Pulse-and-PWM-Generators">Configurable Timing Engine: Pulse and PWM Generators</a> (CMOD S7)
