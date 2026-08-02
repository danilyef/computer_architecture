`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench: ControlUnit + ALU, wired exactly the way MIPS.v wires them
// (in particular aluop = ALUControl[3:0]).
//
// snake_patterns.asm only uses lw / sw / addi / beq / j, so it never checks that
// R-type Funct codes decode correctly. This does.
//////////////////////////////////////////////////////////////////////////////////
module tb_aluctrl;

  reg  [5:0] Op, Funct;
  wire [5:0] ALUControl;
  wire       Jump, MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite;

  reg  [31:0] a, b;
  wire [31:0] result;
  wire        zero;

  integer errors = 0;

  ControlUnit cu (
    .Op(Op), .Funct(Funct),
    .Jump(Jump), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .Branch(Branch),
    .ALUControl(ALUControl), .ALUSrc(ALUSrc), .RegDst(RegDst), .RegWrite(RegWrite)
  );

  ALU alu (
    .a(a), .b(b),
    .aluop(ALUControl[3:0]),   // <-- the slice under test
    .result(result), .zero(zero)
  );

  task check_result;
    input [16*8:1] name;
    input [31:0]   golden;
    begin
      #1;
      if (result === golden)
        $display("  ok    %0s  Op=%b Funct=%b ALUControl=%b -> 0x%08h",
                 name, Op, Funct, ALUControl, result);
      else begin
        $display("  FAIL  %0s  Op=%b Funct=%b ALUControl=%b -> got 0x%08h want 0x%08h",
                 name, Op, Funct, ALUControl, result, golden);
        errors = errors + 1;
      end
    end
  endtask

  // NOTE: `got` is sampled when the task is CALLED, so the caller must let the
  // stimulus settle with a #1 before calling this.
  task check_ctrl;
    input [16*8:1] name;
    input          got;
    input          golden;
    begin
      if (got === golden)
        $display("  ok    %0s = %b", name, got);
      else begin
        $display("  FAIL  %0s = %b, want %b", name, got, golden);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    a = 32'h0000_00F0;
    b = 32'h0000_000F;

    $display("=== R-type Funct decode (a=0x%08h b=0x%08h) ===", a, b);
    Op = 6'b000000;
    Funct = 6'b100000; check_result("ADD", a + b);
    Funct = 6'b100010; check_result("SUB", a - b);
    Funct = 6'b100100; check_result("AND", a & b);
    Funct = 6'b100101; check_result("OR",  a | b);
    Funct = 6'b100110; check_result("XOR", a ^ b);
    Funct = 6'b100111; check_result("NOR", ~(a | b));
    Funct = 6'b101010; check_result("SLT",  32'd0);   // 0xF0 < 0x0F ? no
    a = 32'h0000_000F; b = 32'h0000_00F0;
    Funct = 6'b101010; check_result("SLTrev", 32'd1); // 0x0F < 0xF0 ? yes

    $display("");
    $display("=== Non-R-type: Funct must be ignored ===");
    a = 32'h0000_00F0; b = 32'h0000_000F;
    Op = 6'b100011; Funct = 6'b101010; check_result("LW",   a + b);
    Op = 6'b101011; Funct = 6'b100111; check_result("SW",   a + b);
    Op = 6'b001000; Funct = 6'b100100; check_result("ADDI", a + b);
    Op = 6'b000100; Funct = 6'b100000; check_result("BEQ",  a - b);

    $display("");
    $display("=== Zero flag (drives PCSrc for beq) ===");
    Op = 6'b000100;
    a = 32'h1234_5678; b = 32'h1234_5678; #1; check_ctrl("equal",   zero, 1'b1);
    a = 32'h1234_5678; b = 32'h1234_5679; #1; check_ctrl("unequal", zero, 1'b0);

    $display("");
    $display("=== Control signals per opcode ===");
    Op = 6'b000000; #1; check_ctrl("Rtype.RegWrite", RegWrite, 1'b1);
                        check_ctrl("Rtype.RegDst",   RegDst,   1'b1);
                        check_ctrl("Rtype.ALUSrc",   ALUSrc,   1'b0);
                        check_ctrl("Rtype.Jump",     Jump,     1'b0);
    Op = 6'b100011; #1; check_ctrl("LW.MemtoReg",    MemtoReg, 1'b1);
                        check_ctrl("LW.RegWrite",    RegWrite, 1'b1);
                        check_ctrl("LW.ALUSrc",      ALUSrc,   1'b1);
                        check_ctrl("LW.MemWrite",    MemWrite, 1'b0);
    Op = 6'b101011; #1; check_ctrl("SW.MemWrite",    MemWrite, 1'b1);
                        check_ctrl("SW.RegWrite",    RegWrite, 1'b0);
                        check_ctrl("SW.ALUSrc",      ALUSrc,   1'b1);
    Op = 6'b000100; #1; check_ctrl("BEQ.Branch",     Branch,   1'b1);
                        check_ctrl("BEQ.RegWrite",   RegWrite, 1'b0);
    Op = 6'b001000; #1; check_ctrl("ADDI.RegWrite",  RegWrite, 1'b1);
                        check_ctrl("ADDI.RegDst",    RegDst,   1'b0);
    Op = 6'b000010; #1; check_ctrl("J.Jump",         Jump,     1'b1);
                        check_ctrl("J.RegWrite",     RegWrite, 1'b0);

    $display("");
    if (errors == 0) $display("=== PASS: all ALU/control checks correct ===");
    else             $display("=== FAIL: %0d error(s) ===", errors);
    $finish;
  end

endmodule
