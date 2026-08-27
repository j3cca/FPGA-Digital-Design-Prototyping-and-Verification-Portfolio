# FPGA Mixed-Signal Audio Recorder (HW/SW Co-Design)

<img src="https://github.com/j3cca/SystemVerilog-FPGA-Prototyping-and-Verification-Portfolio/blob/main/images/placeholder_audio_recorder.png" alt="System Block Diagram" width="700"> 

> *The system block diagram above shows the end-to-end architecture: interfacing an SSM2603 Audio Codec and 1Gbit DDR2 RAM via custom FSMs, managed centrally by a PicoBlaze soft-core microcontroller driving a serial terminal CLI.* 

## Project Overview
**Description:** I architected and implemented a 5-slot audio recording and playback system on the Digilent Anvyl (Spartan-6) FPGA. While initially assigned as a group project, I took end-to-end technical ownership of the design, independently engineering the top-level hardware integration, multi-clock domain bridging, RAM/codec finite state machines, and the soft-core control software.

The system interfaces with an SSM2603 Audio Codec (via I2C) and 1Gbit onboard DDR2 RAM to manage five independent 10-second audio message slots. At a 44.1 kHz sample rate, each 10-second slot requires 441,000 16-bit memory addresses. A PicoBlaze soft-core microcontroller acts as the central state machine, driving an ASCII-based Serial Terminal (PuTTY) CLI to handle record, play, pause/resume, delete, overwrite protection, and slot validation.

From a MedTech perspective, this project mirrors the architecture of an embedded clinical voice-memo or accessible diagnostic feedback device. It highlights disciplined hardware/software co-design, clock-domain crossing, memory boundary protection, and deterministic state handling where invalid inputs trigger hard-coded system fail-safes.

## Architecture & Implementation

**1. Top-Level Integration & Clock Management (`TOP.v`)**
I designed the top-level hardware architecture to resolve complex multi-clock constraints between the board oscillator, RAM controller, and audio subsystem:
* **Clock Tree & PLL:** The master clock feeds the DDR2 RAM interface wrapper, which outputs a native system clock (`systemCLK`). I instantiated a Xilinx IP Clock Wizard (`clk_wiz_v3_6`) to synthesize a phase-aligned 100MHz clock (`pb_clk`) for the PicoBlaze and UART, alongside 50MHz (`main_clk`) and 11.2896MHz (`audio_clk`) clocks for the SSM2603 codec.
* **Dual-Process Architecture:** Control is split across two synchronous blocks—a 100MHz domain handling PicoBlaze UART port I/O and command handshaking (`state_to_verilog`, `slot_num`), and a RAM-clocked domain running the heavy lifting for audio sample-to-RAM streaming (`stReadFromCodec`, `stMemWrite`, `stMemReadReq`).
* **Audio Handshaking:** Synchronized the codec's `sample_end[1]` and `sample_req[1]` flags directly into the DDR2 state machine to guarantee zero sample drift or tearing during real-time ADC capture and DAC playback.

**2. PicoBlaze Soft-Core Control & CLI (`main_controller.psm`)**
I wrote the assembly control software to manage user workflow and safety interlocks:
* **State & Slot Validation:** Maintained real-time tracking of slot occupancy (`slot_1_full` through `slot_5_full`) in scratchpad RAM. Attempting to play or delete an empty slot triggers an `empty_slot_error`, while re-recording an occupied slot forces an explicit confirmation prompt (`confirm_overwrite`).
* **Pause/Resume Flow:** Implemented asynchronous spacebar detection (`read_from_uart_for_pause`) during playback that asserts a hardware pause signal to the Verilog FSM (`stWaitForUnPause`) without dropping the system state.
* **Input Sanitization:** Built strict ASCII range-checking (`invalid_operation`, `invalid_combination`) so malformed serial inputs are immediately flushed with descriptive user feedback.

## Verification & Testing
**Verification Summary:** 
* **RAM Address Partitioning:** Verified linear boundary math across the 1Gbit address space to prevent memory overflow between slots:
  * Slot 1: `0x000000 – 0x06BBEF` (0 to 440,999)
  * Slot 2: `0x06BBF0 – 0x0D77DF` (441,000 to 881,999)
  * *(and so forth up to Slot 5)*
* **UART/State Handshaking:** Validated transaction integrity using `data_present` and `buffer_full` flags in assembly to prevent UART transmission lockups during multi-line error strings.

## Reflection
This project was a masterclass in resource management and the realities of hardware/software co-design.

**Engineering Trade-Off: UI vs. System Integrity**  
I originally scoped the project to render the graphical user interface onto the Anvyl board's physical LCD screen. However, as I expanded the PicoBlaze control assembly, I prioritized implementing exhaustive error-handling, overwrite protection, and slot state validation. Because the PicoBlaze soft-core features strict instruction-memory limits (1K instructions), adding deep error-checking exceeded available block RAM when paired with an LCD driver.

I made the engineering decision to drop the physical screen and route all UI state through PuTTY via UART. In medical device design, deterministic input sanitization and fail-safe error recovery must always take precedence over local display hardware. Ensuring the system could never overwrite a file without permission, or crash due to a malformed input, was ultimately more valuable to the system's robustness than a local display.

## Directory Table of Contents
<pre>
FPGA Audio Message Recorder/
│
├── src/
│   ├── user_hdl/
│   │   ├── <a href="./src/user_hdl/TOP.v">TOP.v</a>                      # My top-level multi-clock architecture & FSM
│   │   └── <a href="./src/user_hdl/clock_wizard_100MHz.v">clock_wizard_100MHz.v</a>      # Custom PLL synthesis wrapper
│   │
│   ├── user_software/
│   │   └── <a href="./src/user_software/main_controller.psm">main_controller.psm</a>        # My PicoBlaze CLI, safety locks & UART parser
│   │
│   └── provided_ip/
│       ├── audio_codec/               # I2C config & SSM2603 driver
│       ├── ram_interface/             # 1Gbit DDR2 RAM interface wrapper
│       └── picoblaze/                 # Xilinx PicoBlaze soft-core processor
│
├── sim/
│   └── <a href="./sim/audio_recorder_tb.sv">audio_recorder_tb.sv</a>
│
├── constraints/
│   └── <a href="./constraints/Anvyl_Master.ucf">Anvyl_Master.ucf</a>
│
└── <a href="./README.md">README.md</a>
</pre>
