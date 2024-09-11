module instruction_decoder(
    input clk,
    input [31:0] instruction,
    output reg [6:0] opcode,
    output reg [2:0] func3,
    output reg [6:0] func7,
    output reg [19:0] imm_data,
    output reg [4:0] WriteAdd,
    output reg [4:0] ReadAdd1,
    output reg [4:0] ReadAdd2
);
    always@(posedge clk) begin
        opcode<=instruction[6:0];       //opcode 7 bits (bits[6:0])
        func3<=instruction[14:12];      //func3 3 bits (bits[14:12])
        func7<=instruction[31:25];      //func7 7 bits (bits[31:25])

        //utype load immediate
        imm_data<=instruction[31:12];   //immediate data 20 bits (bits[31:12])

        //register addresses
        WriteAdd<=instruction[11:7];    //destination register Rd 5 bits (bits[11:7])
        ReadAdd1<=instruction[19:15];   //source register Rs1 5 bits (bits[19:15])
        ReadAdd2<=instruction[24:20];   //source register Rs2 5 bits (bits[24:20])
    end
endmodule
