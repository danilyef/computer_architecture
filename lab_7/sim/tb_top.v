`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench: the whole board -- top.v driving MIPS, the display register and the
// SWITCH input. This is the Part 2 counterpart to tb_snake.v, which instantiates
// MIPS directly and therefore cannot see top.v at all.
//
// Checks:
//   1. the IOReadData mux returns {30'b0, SWITCH} at IOAddr 0x4
//   2. no 'x' ever reaches the register file write port
//   3. DispReg walks through the snake patterns
//   4. (once the .asm reads 0x7FF4) the write interval changes with SWITCH
//
// Plusargs:
//   +loopcnt=N   shorten the software delay loop (default 2)
//   +switch=N    value driven onto SWITCH (default 0)
//   +writes=N    stop after N display updates (default 13)
//   +vcd         dump sim/top.vcd
//////////////////////////////////////////////////////////////////////////////////
module tb_top;

  localparam NPAT       = 12;
  localparam LOOPCNT_AD = 12;

  reg        FPGACLK = 0;
  reg        RESET   = 1;
  reg  [1:0] SWITCH  = 2'b00;
  wire [6:0] LED;
  wire [3:0] AN;

  integer loopcnt    = 2;
  integer switch_val = 0;
  integer max_writes = 13;
  integer writes       = 0;
  integer errors       = 0;
  integer switch_reads = 0;   // how many times the program actually read 0x7FF4
  integer i;
  integer last_time  = 0;
  integer interval   = 0;

  reg [31:0] expected [0:NPAT-1];

  top dut (
    .FPGACLK(FPGACLK),
    .SWITCH(SWITCH),
    .RESET(RESET),
    .LED(LED),
    .AN(AN)
  );

  always #5 FPGACLK = ~FPGACLK;   // clockdiv divides this down to dut.CLK

  initial begin
    if ($test$plusargs("vcd")) begin
      $dumpfile("sim/top.vcd");
      $dumpvars(0, tb_top);
    end
    if ($value$plusargs("loopcnt=%d", loopcnt))   ;
    if ($value$plusargs("switch=%d",  switch_val)) ;
    if ($value$plusargs("writes=%d",  max_writes)) ;
    SWITCH = switch_val[1:0];

    #1;
    for (i = 0; i < NPAT; i = i + 1)
      expected[i] = dut.processor.i_dmem.DataArr[i];
    dut.processor.i_dmem.DataArr[LOOPCNT_AD] = loopcnt;

    $display("=== top.v simulation ===");
    $display("SWITCH = %b, loopcnt = %0d, stopping after %0d display updates",
             SWITCH, loopcnt, max_writes);
    $display("");

    repeat (8) @(posedge FPGACLK);
    RESET = 0;
  end

  // ---------------------------------------------------------------------------
  // 1. The IOReadData mux: whenever the processor addresses 0x7FF4, the switch
  //    value must appear on the low 2 bits and the upper 30 must be zero.
  //
  //    Sampled on the clock edge, NOT on an IOAddr change: ALUResult settles
  //    combinationally through several deltas after each edge, so a
  //    change-triggered check sees transient addresses that never really
  //    occurred and reports phantom failures.
  // ---------------------------------------------------------------------------
  //    Gated on IsIO && MemtoReg, not on IOAddr alone: IOAddr is just
  //    ALUResult[3:0], so it reads 0x4 on any cycle whose ALU result happens to
  //    end in 4 (e.g. "addi $t4,$t4,4"). Only a load inside the I/O window
  //    actually consumes IOReadData.
  always @(posedge dut.CLK)
    if (!RESET && dut.IOAddr === 4'b0100
              && dut.processor.IsIO     === 1'b1
              && dut.processor.MemtoReg === 1'b1) begin
      switch_reads = switch_reads + 1;
      if (dut.IOReadData !== {30'b0, SWITCH}) begin
        $display("FAIL IOReadData mux: IOAddr=0x%h -> 0x%08h, want 0x%08h",
                 dut.IOAddr, dut.IOReadData, {30'b0, SWITCH});
        errors = errors + 1;
      end
    end

  // ---------------------------------------------------------------------------
  // 2. 'x' must never be written into the register file. This is what catches a
  //    bad default in the IOReadData mux leaking into the datapath.
  // ---------------------------------------------------------------------------
  always @(posedge dut.CLK)
    if (!RESET && dut.processor.RegWrite === 1'b1)
      if (^dut.processor.Result === 1'bx) begin
        $display("FAIL x written to register file: WriteReg=%0d Result=0x%08h (IsIO=%b IOAddr=0x%h)",
                 dut.processor.WriteReg, dut.processor.Result,
                 dut.processor.IsIO, dut.IOAddr);
        errors = errors + 1;
      end

  // ---------------------------------------------------------------------------
  // 3./4. Watch the display register and report the interval between updates
  // ---------------------------------------------------------------------------
  always @(dut.DispReg)
    if (!RESET) begin
      writes   = writes + 1;
      interval = $time - last_time;
      last_time = $time;

      if (dut.DispReg !== expected[(writes - 1) % NPAT][27:0]) begin
        $display("update %0d: FAIL DispReg=0x%07h, want 0x%07h",
                 writes, dut.DispReg, expected[(writes - 1) % NPAT][27:0]);
        errors = errors + 1;
      end
      else
        $display("update %0d: ok DispReg=0x%07h   (%0d ns since previous)",
                 writes, dut.DispReg, interval);

      if (writes >= max_writes) finish_up;
    end

  task finish_up;
    begin
      $display("");
      $display("Interval between the last two display updates: %0d ns", interval);
      $display("Loads from 0x7FF4 observed: %0d", switch_reads);
      if (switch_reads == 0) begin
        $display("  NOTE: the program never read the switch register, so the value");
        $display("  on IOReadData's true branch is UNVERIFIED by this run. That is");
        $display("  expected until Step 2 adds the lw from 0x7FF4 to the assembly.");
      end
      $display("");
      if (errors == 0) $display("=== PASS: %0d display updates, no errors ===", writes);
      else             $display("=== FAIL: %0d error(s) ===", errors);
      $finish;
    end
  endtask

  initial begin
    #4000000;
    $display("");
    $display("=== TIMEOUT: only %0d display updates ===", writes);
    $finish;
  end

endmodule
