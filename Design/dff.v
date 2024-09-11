module dff #(parameter WIDTH = 32) (
    input clk,
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] pipelined_out  //used for pipelining
);
    always @(posedge clk) begin
        pipelined_out<=in;   
    end
endmodule
