module Adder(input [31:0] a, input [31:0] b, input cin, output [31:0] y);
    assign y = a + b + cin;
endmodule


module Arithmetic(input [31:0] a, input [31:0] b, input aluop, output [31:0] arithm_y);
    reg [31:0] final_b;
    reg cin;
    always@(*) begin
        if(aluop) begin
            final_b = ~b;
            cin = 1;
        end
        else begin
            final_b = b;
            cin = 0;
        end
    end

    Adder adder(
        .a(a),
        .b(final_b),
        .cin(cin),
        .y(arithm_y)
    );
endmodule



module Logic(input [31:0] a, input [31:0] b, input [1:0] aluop, output reg [31:0] logic_y);
    always@(*)
        case(aluop)
            2'b00 : logic_y = a & b;
            2'b01 : logic_y = a | b;
            2'b10 : logic_y = a ^ b;
            2'b11 : logic_y = ~ (a | b);
            default: logic_y = a & b;
        endcase
endmodule


module ALU(input [31:0] a, input [31:0] b, input [3:0] aluop, output reg [31:0] y);
    wire [31:0] arithm_y, logic_y, extend_zero;

    Logic logic_mod(
        .a(a),
        .b(b),
        .aluop(aluop[1:0]),
        .logic_y(logic_y)
    );

    Arithmetic arithmetic_mod(
        .a(a),
        .b(b),
        .aluop(aluop[1]),
        .arithm_y(arithm_y)
    );

    assign extend_zero = {31'b0, arithm_y[31]};

    always@(*)
        case(aluop)
            4'b0000: y= arithm_y;//ADD
            4'b0010: y = arithm_y; //SUBTRACT
            4'b0100: y = logic_y; //AND
            4'b0101: y = logic_y; //OR 
            4'b0110: y = logic_y; //XOR 
            4'b0111: y = logic_y; //NOR 
            4'b1010: y = extend_zero; //SLT 
            default: y = 32'bx;
        endcase

endmodule
    

module testbench();

    reg  signed [31:0] a, b;
    reg         [3:0]  aluop;
    wire signed [31:0] y;

    ALU alu(
        .a(a),
        .b(b),
        .aluop(aluop),
        .y(y)
    );

    task run_test(input [8*8-1:0] name, input signed [31:0] ta, tb, input [3:0] top);
        begin
            a     = ta;
            b     = tb;
            aluop = top;
            #1;
            $display("%-9s: a=%0d, b=%0d, y=%0d", name, a, b, y);
        end
    endtask

    initial begin
        //        name         a          b       aluop
        run_test("ADD",       32'd10,  32'd20, 4'b0000);
        run_test("ADD",      -32'd10,  32'd20, 4'b0000);

        run_test("SUBTRACT",  32'd10,  32'd20, 4'b0010);
        run_test("SUBTRACT", -32'd10,  32'd20, 4'b0010);

        run_test("AND",       32'd10,  32'd20, 4'b0100);
        run_test("AND",      -32'd10,  32'd20, 4'b0100);

        run_test("OR",        32'd10,  32'd20, 4'b0101);
        run_test("OR",       -32'd10,  32'd20, 4'b0101);

        run_test("XOR",       32'd10,  32'd20, 4'b0110);
        run_test("XOR",      -32'd10,  32'd20, 4'b0110);

        run_test("NOR",       32'd10,  32'd20, 4'b0111);
        run_test("NOR",      -32'd10,  32'd20, 4'b0111);

        run_test("SLT",       32'd10,  32'd20, 4'b1010);
        run_test("SLT",       32'd40,  32'd20, 4'b1010);

        $finish;
    end
endmodule
