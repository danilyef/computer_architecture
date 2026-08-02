`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Simulation-only stub for the Xilinx DIST_MEM_GEN_V4_1 distributed RAM core.
//
// reg_half.v instantiates this Xilinx IP block, which normally comes from the
// reg_half.ngc netlist inside Vivado. Icarus Verilog has no idea what it is, so
// this file provides a plain behavioural model with the same interface:
//   - synchronous write to address A when WE is high
//   - asynchronous read of address A    on SPO  (single port out)
//   - asynchronous read of address DPRA on DPO  (dual port out)
//
// FOR SIMULATION ONLY 
//////////////////////////////////////////////////////////////////////////////////
module DIST_MEM_GEN_V4_1 (
    input  [4:0]  A,
    input  [31:0] D,
    input  [4:0]  DPRA,
    input         CLK,
    input         WE,
    output [31:0] SPO,
    output [31:0] DPO,
    input  [4:0]  SPRA,
    input         I_CE,
    input         QSPO_CE,
    input         QDPO_CE,
    input         QDPO_CLK,
    input         QSPO_RST,
    input         QDPO_RST,
    input         QSPO_SRST,
    input         QDPO_SRST,
    output [31:0] QSPO,
    output [31:0] QDPO
);
  // The real IP takes all of these as parameters; declare them so the
  // #(...) override list in reg_half.v binds cleanly.
  parameter C_ADDR_WIDTH     = 5;
  parameter C_DEFAULT_DATA   = "0";
  parameter C_DEPTH          = 32;
  parameter C_HAS_CLK        = 1;
  parameter C_HAS_D          = 1;
  parameter C_HAS_DPO        = 1;
  parameter C_HAS_DPRA       = 1;
  parameter C_HAS_I_CE       = 0;
  parameter C_HAS_QDPO       = 0;
  parameter C_HAS_QDPO_CE    = 0;
  parameter C_HAS_QDPO_CLK   = 0;
  parameter C_HAS_QDPO_RST   = 0;
  parameter C_HAS_QDPO_SRST  = 0;
  parameter C_HAS_QSPO       = 0;
  parameter C_HAS_QSPO_CE    = 0;
  parameter C_HAS_QSPO_RST   = 0;
  parameter C_HAS_QSPO_SRST  = 0;
  parameter C_HAS_SPO        = 1;
  parameter C_HAS_SPRA       = 0;
  parameter C_HAS_WE         = 1;
  parameter C_MEM_INIT_FILE  = "no_coe_file_loaded";
  parameter C_MEM_TYPE       = 2;
  parameter C_PARSER_TYPE    = 1;
  parameter C_PIPELINE_STAGES = 0;
  parameter C_QCE_JOINED     = 0;
  parameter C_QUALIFY_WE     = 0;
  parameter C_READ_MIF       = 0;
  parameter C_REG_A_D_INPUTS = 0;
  parameter C_REG_DPRA_INPUT = 0;
  parameter C_SYNC_ENABLE    = 1;
  parameter C_WIDTH          = 32;

  reg [C_WIDTH-1:0] mem [C_DEPTH-1:0];

  integer i;
  initial for (i = 0; i < C_DEPTH; i = i + 1) mem[i] = 0;

  always @(posedge CLK)
    if (WE) mem[A] <= D;

  assign SPO  = mem[A];
  assign DPO  = mem[DPRA];
  assign QSPO = 0;   // registered outputs unused by reg_half.v
  assign QDPO = 0;

endmodule
