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




module DisplayNumber(input [3:0] a, input [3:0] b, output [6:0] s1, output s2);
    wire [4:0] s_temp;
    
    FourBitAdder adder(
        .a(a),
        .b(b),
        .s(s_temp)
    );

    Decoder decoder(
        .a(s_temp[3:0]),
        .s(s1)
    );

    assign s2 = s_temp[4];

endmodule



`timescale 1ns / 1ps

module tb_DisplayNumber;

    // Inputs
    reg [3:0] a;
    reg [3:0] b;

    // Outputs
    wire [6:0] s1;
    wire s2;

    // Instantiate the Top-Level Module
    DisplayNumber uut (
        .a(a),
        .b(b),
        .s1(s1),
        .s2(s2)
    );

    // ---------------------------------------------------------
    // TASK: Print the math equation and draw the 7-segment display
    // ---------------------------------------------------------
    task print_segment;
        input [3:0] in_a;
        input [3:0] in_b;
        input [6:0] seg;
        input overflow;
        
        // Internal registers to hold inverted logic (1 = ON, 0 = OFF)
        reg sa, sb, sc, sd, se, sf, sg;
        begin
            // Since the board is active-low (0 is ON), we invert the signals 
            // here just so it's easier to think about for the ASCII drawing
            sa = ~seg[0]; 
            sb = ~seg[1]; 
            sc = ~seg[2]; 
            sd = ~seg[3]; 
            se = ~seg[4]; 
            sf = ~seg[5]; 
            sg = ~seg[6];

            $display("=======================================");
            $display(" EQUATION: %d + %d = %d", in_a, in_b, in_a + in_b);
            $display(" OVERFLOW LED (s2): %s", overflow ? "[*] ON" : "[ ] OFF");
            $display(" 7-SEGMENT DISPLAY:");
            
            // Draw the segments! 
            // If the segment variable is 1, print the segment character. 
            // If 0, print blank spaces.
            $display("    %s ",  sa ? "---" : "   ");
            $display("   %s   %s", sf ? "|" : " ", sb ? "|" : " ");
            $display("   %s   %s", sf ? "|" : " ", sb ? "|" : " ");
            $display("    %s ",  sg ? "---" : "   ");
            $display("   %s   %s", se ? "|" : " ", sc ? "|" : " ");
            $display("   %s   %s", se ? "|" : " ", sc ? "|" : " ");
            $display("    %s \n",  sd ? "---" : "   ");
        end
    endtask

    // ---------------------------------------------------------
    // Test Vectors
    // ---------------------------------------------------------
    initial begin
        $display("\nSTARTING SIMULATION...\n");

        // Test Case 1: 2 + 3 = 5 (Should show '5', Overflow OFF)
        a = 4'd2; b = 4'd3;
        #10;
        print_segment(a, b, s1, s2);

        // Test Case 2: 7 + 5 = 12 (Should show 'C', Overflow OFF)
        a = 4'd7; b = 4'd5;
        #10;
        print_segment(a, b, s1, s2);

        // Test Case 3: 8 + 8 = 16 (Should show '0', Overflow ON)
        a = 4'd8; b = 4'd8;
        #10;
        print_segment(a, b, s1, s2);

        // Test Case 4: 15 + 15 = 30 (Should show 'E', Overflow ON)
        a = 4'd15; b = 4'd15;
        #10;
        print_segment(a, b, s1, s2);

        $display("=======================================");
        $display("Simulation Complete.\n");
        $finish;
    end
      
endmodule