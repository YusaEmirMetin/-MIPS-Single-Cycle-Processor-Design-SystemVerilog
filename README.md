# MIPS Single-Cycle Processor Design – SystemVerilog

This project implements a simplified **MIPS 32-bit single-cycle processor** using SystemVerilog. It supports basic arithmetic, logic, memory, and control instructions. The design combines custom datapath elements with textbook control logic and is simulated using EDA Playground.


## 🎯 Objective

Design and simulate a single-cycle MIPS processor capable of executing a subset of MIPS instructions. Use your custom ALU (from Lab 1.2) and integrate it into a complete datapath and control unit system.

## 🧰 Tools & Technologies

- **Language**: SystemVerilog  
- **Simulator**: EDA Playground  
- **Textbook**: Digital Design and Computer Architecture (Section 7.3 & 7.6)

## 🧱 Supported Instructions

- Arithmetic: `add`, `addi`, `sub`  
- Logical: `and`, `or`, `slt`  
- Memory: `lw`, `sw`  
- Control: `beq`, `j`

## 🧩 Project Structure

### 🔹 Modules

- `top`: Main module; instantiates memory and processor
- `mips`: Integrates `controller` and `datapath`
- `controller`: Contains `maindec` and `aludec` submodules
- `datapath`: Implements register file, ALU, muxes, PC logic, and memory access
- `alu`: Reused from Lab 1.2 (custom-designed ALU)

### 🔹 Memory

- Instruction Memory: 64 x 32-bit
- Data Memory: 64 x 32-bit
- Instruction data initialized from `hexfile.dat`

## 🧪 Testing

Simulation is performed using the provided **testbench**. The test program is written in MIPS assembly, compiled into machine code, and stored in `hexfile.dat`.

### 🧾 Example Verification

The testbench checks if the instruction `sw` writes value `7` to memory address `84`:

```systemverilog
if (memwrite && dataadr === 84 && writedata === 7) {
    $display("Simulation succeeded");
}
