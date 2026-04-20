
module multiplexer(a, b, s, y);
  input  a, b, s;
  output wire y;
  wire   ns, wire_a, wire_b;

  not g1(ns,     s);
  and g2(wire_a, a, ns);
  and g3(wire_b, b,  s);
  or  g4(y, wire_a, wire_b);

endmodule


module multiplexer_4_by_1(d_0, d_1, d_2, d_3, s_0, s_1, y);
  input  d_0, d_1, d_2, d_3, s_0, s_1;
  output wire y;
  wire   mult_1, mult_2;

  multiplexer m1( .a(d_0),   .b(d_1),   .s(s_0), .y(mult_1) );
  multiplexer m2( .a(d_2),   .b(d_3),   .s(s_0), .y(mult_2) );
  multiplexer m3( .a(mult_1),.b(mult_2),.s(s_1), .y(y)      );

endmodule


module testbench2;

  reg  a, b, s;
  wire y;

  multiplexer mux( .a(a), .b(b), .s(s), .y(y) );

  initial begin
    a = 0; b = 0; s = 0; #10;
    a = 1; b = 0; s = 0; #10;
    a = 0; b = 1; s = 0; #10;
    a = 1; b = 1; s = 0; #10;
    a = 0; b = 0; s = 1; #10;
    a = 1; b = 0; s = 1; #10;
    a = 0; b = 1; s = 1; #10;
    a = 1; b = 1; s = 1; #10;
    $finish;
  end

  initial begin
    $monitor("Time=%0t  a=%b b=%b s=%b  y=%b",
              $time, a, b, s, y);
  end

endmodule


module testbench3;

  reg  d_0, d_1, d_2, d_3;
  reg  s_0, s_1;
  wire y;

  multiplexer_4_by_1 mux(
    .d_0(d_0), .d_1(d_1), .d_2(d_2), .d_3(d_3),
    .s_0(s_0), .s_1(s_1), .y(y)
  );

  initial begin
    d_0 = 0; d_1 = 1; d_2 = 0; d_3 = 1;
    s_1 = 0; s_0 = 0; #10; // y = d_0
    s_1 = 0; s_0 = 1; #10; // y = d_1
    s_1 = 1; s_0 = 0; #10; // y = d_2
    s_1 = 1; s_0 = 1; #10; // y = d_3

    d_0 = 1; d_1 = 0; d_2 = 1; d_3 = 0;
    s_1 = 0; s_0 = 0; #10;
    s_1 = 0; s_0 = 1; #10;
    s_1 = 1; s_0 = 0; #10;
    s_1 = 1; s_0 = 1; #10;

    $finish;
  end

  initial begin
    $monitor("Time=%0t  d0=%b d1=%b d2=%b d3=%b  s1=%b s0=%b  y=%b",
              $time, d_0, d_1, d_2, d_3, s_1, s_0, y);
  end

endmodule