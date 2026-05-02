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




module testbench1;

    reg  [3:0] a, b;
    wire [4:0] s;

    integer i, j;

    FourBitAdder adder(.a(a), .b(b), .s(s));

    initial begin
        // Test all combinations
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a = i;
                b = j;
                #1; // wait for propagation

                // Check result
                if (s !== (a + b)) begin
                    $display("ERROR: a=%d b=%d | s=%d (expected %d)", 
                              a, b, s, a + b);
                end
            end
        end

        $display("Test completed.");
        $finish;
    end

endmodule


