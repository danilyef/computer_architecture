`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench: runs snake_patterns.asm on the MIPS processor and checks the
// memory-mapped I/O writes that would drive the 7-segment display.
//
// It self-checks: the expected pattern sequence is read straight out of the
// data memory, so if you edit datamem_h.txt for the optional challenge the
// testbench follows along automatically.
//
// Plusargs:
//   +loopcnt=N   override the software delay loop counter (default 2).
//                The real value in datamem_h.txt is 0x001e8484 = 2000004, which
//                would need ~72 million clock cycles to show 12 patterns.
//   +writes=N    stop after N I/O writes (default 26, i.e. just over 2 full cycles)
//   +vcd         dump waveforms to sim/snake.vcd for GTKWave
//////////////////////////////////////////////////////////////////////////////////
module tb_snake;

  localparam NPAT       = 12;   // number of patterns ($t5 = 48 bytes / 4)
  localparam LOOPCNT_AD = 12;   // word index of 'loopcnt' in data memory

  reg         CLK = 0;
  reg         RESET = 1;
  wire [31:0] IOWriteData;
  wire  [3:0] IOAddr;
  wire        IOWriteEn;
  reg  [31:0] IOReadData = 32'h0;   // Part 2 will drive this; unused in Part 1

  integer writes    = 0;
  integer errors    = 0;
  integer max_writes = 26;
  integer loopcnt    = 2;
  integer i;

  reg [31:0] expected [0:NPAT-1];

  MIPS dut (
    .CLK(CLK),
    .RESET(RESET),
    .IOWriteData(IOWriteData),
    .IOAddr(IOAddr),
    .IOWriteEn(IOWriteEn),
    .IOReadData(IOReadData)
  );

  always #5 CLK = ~CLK;    // 100 MHz in sim; the real board runs this at 10 MHz

  initial begin
    if ($test$plusargs("vcd")) begin
      $dumpfile("sim/snake.vcd");
      $dumpvars(0, tb_snake);
    end
    if ($value$plusargs("loopcnt=%d", loopcnt)) ;
    if ($value$plusargs("writes=%d", max_writes)) ;

    // Let the memories' $readmemh initial blocks settle, then grab the
    // expected pattern list and shorten the software delay loop.
    #1;
    for (i = 0; i < NPAT; i = i + 1)
      expected[i] = dut.i_dmem.DataArr[i];
    dut.i_dmem.DataArr[LOOPCNT_AD] = loopcnt;

    $display("=== Snake program simulation ===");
    $display("loopcnt overridden to %0d (real value 0x%08h), stopping after %0d I/O writes",
             loopcnt, 32'h001e8484, max_writes);
    $display("Expecting this pattern sequence to repeat:");
    for (i = 0; i < NPAT; i = i + 1)
      $display("   [%0d] 0x%08h", i, expected[i]);
    $display("");

    repeat (2) @(posedge CLK);
    RESET = 0;
  end

  // ---------------------------------------------------------------------------
  // Check every I/O write
  // ---------------------------------------------------------------------------
  always @(posedge CLK)
    if (!RESET && IOWriteEn) begin
      writes = writes + 1;

      if (IOWriteData !== expected[(writes - 1) % NPAT]) begin
        $display("write %0d: FAIL data     got 0x%08h expected 0x%08h",
                 writes, IOWriteData, expected[(writes - 1) % NPAT]);
        errors = errors + 1;
      end
      else if (IOAddr !== 4'h0) begin
        // 0x00007FF0 is the LED register, so the low nibble of the address is 0
        $display("write %0d: FAIL IOAddr   got 0x%h expected 0x0", writes, IOAddr);
        errors = errors + 1;
      end
      else if (dut.DataMemWrite !== 1'b0) begin
        // An I/O store must NOT also write the data memory array
        $display("write %0d: FAIL DataMemWrite asserted during an I/O write", writes);
        errors = errors + 1;
      end
      else
        $display("write %0d: ok  IOAddr=0x%h IOWriteData=0x%08h -> DispReg=0x%07h",
                 writes, IOAddr, IOWriteData, IOWriteData[27:0]);

      if (writes >= max_writes) finish_up;
    end

  task finish_up;
    begin
      $display("");
      if (errors == 0)
        $display("=== PASS: %0d I/O writes, all correct ===", writes);
      else
        $display("=== FAIL: %0d error(s) in %0d I/O writes ===", errors, writes);
      $finish;
    end
  endtask

  // Watchdog: catches a processor that never stores, or that hangs
  initial begin
    #2000000;
    $display("");
    $display("=== TIMEOUT: only %0d I/O writes happened ===", writes);
    if (writes == 0)
      $display("    IOWriteEn never asserted -- check MemWrite, IsIO and IOWriteEn.");
    $finish;
  end

endmodule
