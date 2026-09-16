# FPGA Mixed-Signal Audio Recorder (HW/SW Co-Design)

<img src="https://github.com/j3cca/FPGA-Digital-Design-Prototyping-and-Verification-Portfolio/blob/main/images/audio_recorder_block_diagram.png" alt="System Block Diagram" width="700"> 

> *The system block diagram above shows the architecture for this audio recorder and playback device. The architecture interfaces an SSM2603 Audio Codec and 1Gbit DDR2 RAM via custom FSMs, which is managed by a PicoBlaze soft-core microcontroller driving a serial terminal CLI.* 

## Project Overview
**Description:** For this project, I designed and implemented a 5-slot audio recording and playback system on the Digilent Anvyl (Spartan-6) FPGA. 

The system interfaces with an SSM2603 Audio Codec over I2C and uses 1Gbit of onboard DDR2 RAM to store up to five independent 10-second audio messages. At a 44.1 kHz sample rate, each 10-second slot requires 441,000 16-bit memory addresses. To manage the system, I used a PicoBlaze soft-core microcontroller as the central state machine. It drives an ASCII-based Serial Terminal (PuTTY) CLI, allowing users to record, play, pause, resume, and delete audio while handling overwrite protection and slot validation.

Overall, this project was a deep dive into hardware/software co-design, clock-domain crossing, memory management, and building robust fail-safes for user input.

## Architecture & Implementation

**1. Top-Level Integration & Clock Management (`audio_recorder_top.v`)**
Handling multiple clock domains was one of the core challenges of the hardware design:
* **Clock Tree:** The master clock drives the DDR2 RAM interface, which outputs the main system clock. I used a Xilinx Clock Wizard IP to generate the 100MHz clock for the PicoBlaze and UART, plus 50MHz and 11.2896MHz clocks for the audio codec.
* **Dual Architecture:** The control logic is split across two synchronous blocks. The 100MHz block handles the PicoBlaze UART I/O and command handshaking, while a RAM-clocked block streams audio samples to and from memory.
* **Audio Handshaking:** I synchronized the codec's sample flags directly into the DDR2 state machine to ensure zero sample drift or tearing during capture and playback.

**2. PicoBlaze Soft-Core Control & CLI (`PB_controller.psm`)**
I wrote the assembly control software to manage the user workflow and keep the system stable:
* **State Tracking:** The system tracks slot occupancy in scratchpad RAM. If a user tries to play or delete an empty slot, the controller returns an error message. If they try to record over an existing message, the controller prompts the user for explicit confirmation; however, upon confirmation, the user can decide to overwrite a recording without first deleting the slot.
* **Pause/Resume:** I added asynchronous spacebar detection during playback. This sends a hardware pause signal to the Verilog FSM without losing the current system state.
* **Input Sanitization:** Strict ASCII range-checking ensures that any invalid serial inputs are not passed through to the system, which will return specific error messages detailing the issue and allowing the user to make their selection again with the proper input.

## Verification & Testing
* **Memory Boundaries:** I mapped out and verified the boundary math across the 1Gbit address space to guarantee slots wouldn't overflow into each other. 
  * Slot 1: `0x000000 – 0x06BBEF` (0 to 440,999)
  * Slot 2: `0x06BBF0 – 0x0D77DF` (441,000 to 881,999)
  * *(and so forth up to Slot 5)*
  * Although my initial implementation scoped twelve, 60-second recordings, I decided to decrease the recording length and number of recordings to better demonstrate the capabilities of the system.
* **UART Handshaking:** I used `data_present` and `buffer_full` flags in assembly to validate transaction integrity and prevent UART transmission lockups when sending multi-line error messages.

## Reflection
Originally, I planned to build a graphical user interface for the Anvyl board's physical LCD screen. However, the PicoBlaze soft-core processor has a 1K instruction memory limit (for 1 block RAM). Adding thorough error-checking and overwrite protection filled most of the available BRAM, meaning an LCD driver would no longer fit. 

Because I wanted to maintain strict error checking guidelines, I decided to drop the physical screen and route all UI through PuTTY via UART. I wanted to aim for robustness instead of maximizing features, which I ultimately believe was the best choice.

The biggest weakness of my implementation was the lack of a solid testbench. While I did test a simplified UART loopback system, I hadn't yet learned how to build self-checking testbenches, and I wasn't sure how to simulate audio signals effectively. As a result, I ended up relying primarily on debugging directly on the hardware, which was time consuming and much less effective. If I were to do this project again, I would design a self-checking testbench that reads from a bank of simulated audio files to verify the implementation before flashing the bitsteam to the hardware.

## Directory Table of Contents
<pre>
FPGA Mixed-Signal Audio Recorder (HW/SW Co-Design)/
│
├── src/
│   ├── <a href="./src/audio_recorder_top.v">audio_recorder_top.v</a>           # Top-level Architecture & FSM
│   ├── <a href="./src/PB_controller.psm">PB_controller.psm</a>              # PicoBlaze Controller
│   ├── <a href="./src/ram_interface_wrapper.v">ram_interface_wrapper.v</a>        # Modified DDR2 RAM interface wrapper
│   ├── <a href="./src/i2c_controller.v">i2c_controller.v</a>               # Modified I2C controller for audio codec
│   ├── <a href="./src/i2c_av_config.v">i2c_av_config.v</a>                # Modified Audio codec configuration
│   └── <i>[Standard Xilinx/Digilent IP omitted for brevity]</i>
│
├── constraints/
│   ├── <a href="./constraints/anvyl_audio_recorder.ucf">anvyl_audio_recorder.ucf</a>       # Main board pinout and clock constraints
│   └── <a href="./constraints/RAM_Reference_Pins.ucf">RAM_Reference_Pins.ucf</a>         # DDR2 constraints
│
└── <a href="./README.md">README.md</a>
</pre>
