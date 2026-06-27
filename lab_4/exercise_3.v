
module clk_div(input clk, input rst, output clk_en);
    reg [24:0] clk_count;
    always @ (posedge clk)
    // posedge defines a rising edge (transition from 0 to 1)
    begin
        if (rst)
            clk_count <= 0;
        else
            clk_count <= clk_count + 1;
    end
    assign clk_en = &clk_count;
endmodule


module Lab4FSmv2(
    input clk,
    input rst,
    input left,
    input right,
    output reg [5:0] y
);

    reg [2:0] state, nextstate;
    wire clk_en;
    
    clk_div clk_new(.clk(clk), .rst(rst), .clk_en(clk_en));
    
    parameter IDLE = 3'b000;
    parameter LA = 3'b001;
    parameter LB = 3'b010;
    parameter LC = 3'b011;
    parameter RA = 3'b100;
    parameter RB = 3'b101;
    parameter RC = 3'b110;

    // state register
    always @ (posedge clk, posedge rst)
        if(rst) state <= IDLE;
        else if(clk_en) state <= nextstate;

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

