# SystemVerilog FPGA Prototyping and Verification Portfolio

A growing collection of synthesizable SystemVerilog modules and self-checking testbenches. 

### About Me
As a Computer Engineering senior with a prior B.S. in Biomedical Sciences, my focus is on bridging hardware engineering and healthcare. I am passionate about designing robust, high-performance digital logic and DSP architectures for MedTech applications. This repository serves as a comprehensive portfolio of my independent prototyping, academic projects, and capstone work.

### Hardware Platforms & Prototyping
Projects in this repository were primarily developed and verified in Vivado, targeting various FPGA platforms:

*   **CMOD S7 (Xilinx Spartan-7):** A significant portion of this portfolio was developed independently during Summer 2026. Because the CMOD S7 is a DIP-format FPGA, I built a custom peripheral interface on a solderless breadboard—including DIP switches, indicator LEDs, current-limiting resistors, and pull-down networks—mapped to custom XDC pin constraints. *(Guided by "FPGA Prototyping by SystemVerilog Examples" by Pong P. Chu and "SystemVerilog for Verification" by Chris Spear).*
*   **Digilent Anvyl (Xilinx Spartan-6):** Utilized for mixed-signal audio processing and soft-core microcontroller integration via Xilinx ISE. Working with the board's onboard microphone, speaker ports, and hardware controls, I implemented a PicoBlaze soft-core processor to manage data flow. Navigating strict BRAM constraints, I made the deliberate architectural decision to prioritize robust error-checking routines over driving the onboard displays, opting instead to route system telemetry through a custom UART transmitter to a serial terminal.

---

## Table of Contents

### 01 - Foundational Logic Primitives
*   **[4-Bit Greater-Than Comparator](./path)** (CMOD S7)
*   **[4-to-16 Decoder](./path)** (CMOD S7)

### 02 - Data Processing and DSP
*   **[Bidirectional Int to Floating Point Converter](./path)** (CMOD S7)
    *   *Simulates the data-formatting stage of a medical DSP pipeline using a custom 13-bit IEEE-esque format.*
*   **[Parametric Bit-Manipulation Unit](./path)** (CMOD S7)

### 03 - Timing and Control
*   **[Configurable Timing Engine: Pulse and PWM Generators](./path)** (CMOD S7)

### 04 - Advanced Systems & Capstone
*   **[codec]
