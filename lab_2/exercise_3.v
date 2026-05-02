module FullAdder(input a, input b, input ci, output s, output co);
    wire wire_and_ab, wire_xor_ab, wire_3;

    and g1(wire_and_ab, a, b);
    xor g2(wire_xor_ab, a, b);
    and g3(wire_3, ci, wire_xor_ab);
    or g4(co, wire_3, wire_and_ab);
    xor g5(s, wire_xor_ab, ci);

endmodule


module testbench1;

    reg  a, b, ci;
    wire s, co;

    FullAdder fa(.a(a), .b(b), .ci(ci), .s(s), .co(co));

    initial begin
        a = 0; b = 0; ci = 0; #10;
        a = 1; b = 0; ci = 0; #10;
        a = 0; b = 1; ci = 0; #10;
        a = 1; b = 1; ci = 0; #10;
        a = 0; b = 0; ci = 1; #10;
        a = 1; b = 0; ci = 1; #10;
        a = 0; b = 1; ci = 1; #10;
        a = 1; b = 1; ci = 1; #10;
        $finish;
    end

    initial begin
        $monitor("Time=%0t a=%b b=%b ci=%b s=%b co=%b",
                    $time, a, b, ci, s, co);
    end

endmodule