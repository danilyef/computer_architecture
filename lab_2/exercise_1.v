
module decoder(a, b, o1, o2, o3, o4);
  input  a, b;
  output wire o1, o2, o3, o4;
  wire   na, nb;

  not g1(na, a);
  not g2(nb, b);
  and g3(o1, na, nb);
  and g4(o2, na,  b);
  and g5(o3,  a, nb);
  and g6(o4,  a,  b);

endmodule


module testbench1;

  reg  a, b;
  wire o1, o2, o3, o4;

  decoder dec(
    .a(a),  .b(b),
    .o1(o1), .o2(o2),
    .o3(o3), .o4(o4)
  );

  initial begin
    a = 0; b = 0; #10; // Test case 1
    a = 0; b = 1; #10; // Test case 2
    a = 1; b = 0; #10; // Test case 3
    a = 1; b = 1; #10; // Test case 4
    $finish;
  end

  initial begin
    $monitor("Time=%0t  a=%b b=%b  o1=%b o2=%b o3=%b o4=%b",
              $time, a, b, o1, o2, o3, o4);
  end

endmodule
