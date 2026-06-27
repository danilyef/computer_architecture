markdown_content = """# LAB 4: Finite-State Machines - Ford Thunderbird Tail Lights

## Overview
The goal of this lab is to design and implement a finite-state machine (FSM) in Verilog that emulates the blinking tail light sequence of a 1965 Ford Thunderbird .

## System Specifications
- **Inputs:** `clk` (Clock), `rst`/`reset` (Reset), `left` (Left Turn), `right` (Right Turn) 
- **Outputs:** `LA`, `LB`, `LC` (Left tail lights) and `RA`, `RB`, `RC` (Right tail lights) 
- **Behavior:**
  - **Reset:** FSM enters a state with all lights off .
  - **Left Turn:** Sequence progresses as `LA` -> `LA`+`LB` -> `LA`+`LB`+`LC` -> All Off . Repeats if `left` is held down .
  - **Right Turn:** Sequence progresses as `RA` -> `RA`+`RB` -> `RA`+`RB`+`RC` -> All Off . Repeats if `right` is held down .
  - *Note:* You must choose a simple behavior for when both `left` and `right` inputs are pressed simultaneously .

## Required Tasks

### Part 1: FSM Design (Written Task)
1. **State Transition Diagram (1a):** Draw the state transition diagram on paper. Indicate state names, transition conditions using the 1-bit `left` and `right` signals, and assign values to every output in each state .
2. **State Encoding Table (1b):** Create a table mapping your defined states to specific binary values .
3. **Output Logic Table (1c):** Create a table or pseudocode describing how to map the states to the six LED output signals .

### Part 2: Verilog Implementation
- Create a new Vivado project and a Verilog source file .
- Write the Verilog module for the FSM . Use best coding practices by clearly separating the three components of the FSM:
  1. **State Register:** Updates present state to next state on clock events .
  2. **Next State Logic:** Determines the next state based on inputs and present state .
  3. **Output Logic:** Determines the outputs based on present state and inputs .
- Use intuitive and consistent naming conventions (e.g., `state_p` for present state, `state_n` for next state) .

### Part 3: Implementing the Clock Divider
The FPGA's onboard crystal oscillator runs at 100MHz (10ns period), which is too fast for the human eye to perceive the blinking sequence (40ns total) .
- Create a second Verilog file for the provided `clk_div` module .
- The module uses a 25-bit counter to generate a `clk_en` (clock enable) signal every 33,554,432 cycles (approx. 0.335 seconds) .
- **Integration:** Instantiate `clk_div` in your top-level module . Modify your state register to only transition states when the `clk_en` signal is '1' . 
- *Warning:* Do not use push buttons directly for the clock signal due to mechanical bouncing . 


