module alu(
    input [31:0] Data1,
    input [31:0] Data2,
    input [3:0] alu_opcode,
    output reg [31:0] alu_out
);
    always @(*) begin
        case (alu_opcode)
            4'b0001: alu_out=Data1+Data2;  //add
            4'b0010: alu_out=Data1-Data2;  //sub
            4'b0011: alu_out=Data1&Data2;  //and
            4'b0100: alu_out=Data1|Data2;  //or
            4'b0101: alu_out=Data1^Data2;  //xor
            default: alu_out=32'b0;        //default alu_out
        endcase
    end
endmodule
