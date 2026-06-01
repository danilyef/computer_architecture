module FullAdder(input a, input b, input ci, output s, output co);
    wire wire_and_ab, wire_xor_ab, wire_3;
    and g1(wire_and_ab, a, b);
    xor g2(wire_xor_ab, a, b);
    and g3(wire_3, ci, wire_xor_ab);
    or g4(co, wire_3, wire_and_ab);
    xor g5(s, wire_xor_ab, ci);
endmodule


module FourBitAdder(input [3:0] a, input [3:0] b, output [4:0] s);
    wire [2:0] co; 
    
    FullAdder d1(
        .a(a[0]),
        .b(b[0]),
        .ci(1'b0),
        .s(s[0]),
        .co(co[0])
    );

    FullAdder d2(
        .a(a[1]),
        .b(b[1]),
        .ci(co[0]),
        .s(s[1]),
        .co(co[1])
    );

    FullAdder d3(
        .a(a[2]),
        .b(b[2]),
        .ci(co[1]),
        .s(s[2]),
        .co(co[2])
    );

    FullAdder d4(
        .a(a[3]),
        .b(b[3]),
        .ci(co[2]),
        .s(s[3]),
        .co(s[4])
    );


endmodule


module Decoder(input [3:0] a, output reg [6:0] s);
    always @(*) 
        case(a)
            // Order is 7'b[g][f][e][d][c][b][a]
            4'h0: s = 7'b1000000; //0
            4'h1: s = 7'b1111001; //1
            4'h2: s = 7'b0100100; //2
            4'h3: s = 7'b0110000; //3
            4'h4: s = 7'b0011001; //4
            4'h5: s = 7'b0010010; //5
            4'h6: s = 7'b0000010; //6
            4'h7: s = 7'b1111000; //7
            4'h8: s = 7'b0000000; //8
            4'h9: s = 7'b0010000; //9
            4'hA: s = 7'b0001000; //A
            4'hB: s = 7'b0000011; //B
            4'hC: s = 7'b1000110; //C
            4'hD: s = 7'b0100001; //D
            4'hE: s = 7'b0000110; //E
            4'hF: s = 7'b0001110; //F
            default: s = 7'b1111111;
        endcase
endmodule



`timescale 1ns / 1ps

module tb_BinaryToDisplay;

    // Inputs
    reg [3:0] a;

    // Outputs
    wire [6:0] s;

    // Instantiate the Unit Under Test (UUT)
    Decoder uut (
        .a(a), 
        .s(s)
    );

    integer i;

    initial begin
        // Print header for the simulation output
        $display("Time\t a(Hex)\t a(Bin)\t | s(Bin) [a b c d e f g]");
        $display("---------------------------------------------------------");

        // Loop through all 16 possible hexadecimal inputs
        for (i = 0; i < 16; i = i + 1) begin
            a = i;
            #10; // Wait 10 time units for the combinational logic to settle
            
            // Display the results, manually ordering s[0] to s[6] 
            // so it visually prints left-to-right as a, b, c, d, e, f, g
            $display("%0t\t %h\t %b\t | %b%b%b%b%b%b%b", $time, a, a, s[0], s[1], s[2], s[3], s[4], s[5], s[6]);
        end

        // End the simulation
        $display("---------------------------------------------------------");
        $display("Simulation Complete.");
        $finish;
    end
      
endmodule