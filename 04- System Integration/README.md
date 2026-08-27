# FPGA Mixed-Signal Audio Recorder with PicoBlaze & DDR2 RAM

## Project Overview

**Description:** I architected and implemented a 5-slot audio recording and playback system on the Digilent Anvyl (Spartan-6) FPGA. While assigned as a group project, I independently engineered the top-level hardware integration, multi-clock domain bridging, RAM/codec finite state machine, and the soft-core control software. 

The system interfaces with an SSM2603 Audio Codec (via I2C) and 1Gbit onboard DDR2 RAM to manage five independent 10-second audio message slots ($44.1\text{ kHz} \times 10\text{s} \times 2\text{ bytes} = 441,000\text{ samples/slot}$). A PicoBlaze soft-core microcontroller acts as the central state machine, driving an ASCII-based Serial Terminal (PuTTY) CLI to handle record, play, pause/resume, delete, overwrite protection, and slot validation.

From a MedTech perspective, this project mirrors an embedded clinical voice-memo or accessible diagnostic feedback device. It highlights disciplined clock-domain crossing, memory boundary protection, and deterministic state handling where invalid inputs trigger hard-coded system fail-safes.

**Block Diagram:**
*(Insert Block Diagram Image Here - showing Mic/Speaker -> SSM2603 Codec <-> DDR2 RAM Wrapper <-> PicoBlaze & UART CLI)*

## Architecture & Implementation

### 1. Top-Level Integration & Clock Management (`TOP.v`)
I designed the top-level hardware architecture to resolve complex multi-clock constraints between the board oscillator, RAM controller, and audio subsystem:
*   **Clock Tree & PLL:** The 100MHz master clock (`clk`) feeds the DDR2 RAM interface wrapper, which outputs a native 37.5MHz system clock (`systemCLK`). I instantiated a Xilinx IP Clock Wizard (`clk_wiz_v3_6`) to synthesize a phase-aligned 100MHz clock (`pb_clk`) for the PicoBlaze and UART, alongside 50MHz (`main_clk`) and 11.2896MHz (`audio_clk`) clocks for the SSM2603 codec.
*   **Dual-Process Architecture:** Split control across two synchronous blocks—a 100MHz domain handling PicoBlaze UART port I/O and command handshaking (`state_to_verilog`, `slot_num`), and a 37.5MHz domain running the heavy lifting for audio sample-to-RAM streaming (`stReadFromCodec`, `stMemWrite`, `stMemReadReq`).
*   **Audio Handshaking:** Synchronized the codec's `sample_end[1]` and `sample_req[1]` flags directly into the DDR2 state machine to guarantee zero sample drift or tearing during real-time ADC capture and DAC playback.

### 2. PicoBlaze Soft-Core Control & CLI (`main_controller.psm`)
I wrote the assembly control software to manage user workflow and safety interlocks:
*   **State & Slot Validation:** Maintained real-time tracking of slot occupancy (`slot_1_full` through `slot_5_full`) in scratchpad RAM. Attempting to play or delete an empty slot triggers `empty_slot_error`, while re-recording an occupied slot forces an explicit confirmation prompt (`confirm_overwrite`).
*   **Pause/Resume Flow:** Implemented asynchronous spacebar detection (`read_from_uart_for_pause`) during playback that asserts a hardware `pause` signal to the Verilog FSM (`stWaitForUnPause`) without dropping system state.
*   **Input Sanitization:** Built strict ASCII range-checking (`invalid_operation`, `invalid_combination`) so malformed serial inputs are immediately flushed with descriptive user feedback.

### Engineering Trade-Off: LCD vs. Error-Checking
> *Design Decision:* I originally scoped the project to render the GUI onto the Anvyl board's physical LCD screen. However, as I expanded the PicoBlaze control assembly, I prioritized implementing exhaustive error-handling, overwrite protection, and slot state validation. Because the PicoBlaze soft-core features strict instruction-memory limits, adding deep error-checking exceeded available block RAM when paired with an LCD driver. I made the engineering decision to drop the physical screen and route all UI state through PuTTY. In medical device design, deterministic input sanitization and fail-safe error recovery take precedence over local display hardware.

## Verification & Testing
*   **RAM Address Partitioning:** Verified linear boundary math across the 1Gbit address space:
    *   Slot 1: `0x000000` – `0x06BBEF`
    *   Slot 2: `0x06BBF0` – `0x0D77DF` (and so forth up to Slot 5).
*   **UART/State Handshaking:** Validated transaction integrity using `data_present` and `buffer_full` flags in assembly to prevent UART transmission lockups during multi-line error strings.

## Directory Table of Contents

```text
FPGA Audio Message Recorder/
│
├── src/
│   ├── user_hdl/
│   │   ├── TOP.v                      # My top-level multi-clock architecture & FSM
│   │   └── clock_wizard_100MHz.v      # Custom PLL synthesis wrapper
│   │
│   ├── user_software/
│   │   └── main_controller.psm        # My PicoBlaze CLI, safety locks & UART parser
│   │
│   └── provided_ip/
│       ├── audio_codec/               # I2C config & SSM2603 driver
│       ├── ram_interface/             # 1Gbit DDR2 RAM interface wrapper
│       └── picoblaze/                 # Xilinx PicoBlaze soft-core processor
│
├── sim/
│   └── audio_recorder_tb.sv
│
├── constraints/
│   └── Anvyl_Master.ucf
│
└── README.md
