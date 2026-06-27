
module Lab4FSmv2(
    input clk,
    input reset,
    input left,
    input right,
    output reg [5:0] y
);

    reg [2:0] state, nextstate;
    
    parameter IDLE = 3'b000;
    parameter LA = 3'b001;
    parameter LB = 3'b010;
    parameter LC = 3'b011;
    parameter RA = 3'b100;
    parameter RB = 3'b101;
    parameter RC = 3'b110;

    // state register
    always @ (posedge clk, posedge reset)
        if(reset) state <= IDLE;
        else state <= nextstate;

    always @ (*)
        case(state)
            IDLE: if (left & right) nextstate = IDLE;
                  else if (left) nextstate = LA;  
                  else if (right) nextstate = RA;
                  else nextstate = IDLE;
            LA: nextstate = LB;
            LB: nextstate = LC;
            LC: nextstate = IDLE;
            RA: nextstate = RB;
            RB: nextstate = RC;
            RC: nextstate = IDLE;
            default: nextstate = IDLE;
        endcase

    // output logic
    always @ (*)
        case(state)
            IDLE: y = 6'b000000; 
            LA: y = 6'b001000;
            LB: y = 6'b011000;
            LC: y = 6'b111000;
            RA: y = 6'b000100;
            RB: y = 6'b000110;
            RC: y = 6'b000111;
            default: y = 6'b000000;
        endcase

endmodule


`timescale 1ns / 1ps

module testbenchv2();
    reg clk, reset, left, right;
    wire [5:0] y;

    // Instantiate the FSM (named connections)
    Lab4FSmv2 fsm(
        .clk(clk),
        .reset(reset),
        .left(left),
        .right(right),
        .y(y)
    );

    // Clock: 10 ns period
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Print every change. Output order is [LC LB LA RA RB RC]
    initial begin
        $display("  time | rst left right | y=LC LB LA RA RB RC");
        $display("-------------------------------------------------");
        $monitor("%5t |  %b    %b     %b   |    %b  %b  %b  %b  %b  %b",
                 $time, reset, left, right,
                 y[5], y[4], y[3], y[2], y[1], y[0]);
    end

    initial begin
        // Apply reset
        reset = 1; left = 0; right = 0;
        @(posedge clk); #1;
        reset = 0;

        // ---- Left turn: hold for a few clocks (should repeat) ----
        left = 1; right = 0;
        repeat (5) @(posedge clk);

        // Release left mid-idle
        left = 0;
        repeat (2) @(posedge clk);

        // ---- Left pulse: press once, release immediately ----
        // Sequence must still complete on its own
        left = 1; @(posedge clk); #1;
        left = 0;
        repeat (4) @(posedge clk);

        // ---- Right turn: hold for a few clocks ----
        right = 1;
        repeat (5) @(posedge clk);
        right = 0;
        repeat (2) @(posedge clk);

        // ---- Both pressed: should stay IDLE ----
        left = 1; right = 1;
        repeat (3) @(posedge clk);
        left = 0; right = 0;

        // ---- Reset mid-sequence ----
        left = 1; @(posedge clk); #1;  // start a left sequence
        left = 0;
        @(posedge clk);
        reset = 1; @(posedge clk); #1; // force back to IDLE
        reset = 0;
        repeat (2) @(posedge clk);

        $display("-------------------------------------------------");
        $display("Simulation Complete.");
        $finish;
    end
endmodule