module register_set(
    input clk,
    input write_en,
    input [4:0] ReadAdd1,
    input [4:0] ReadAdd2,
    input [4:0] WriteAdd,
    input [31:0] Reg_WriteData,
    output wire [31:0] Data1,
    output wire [31:0] Data2
);
    reg [31:0] registers [0:31]; //32 registers,each 32 bits
    always @(posedge clk) begin
        if (write_en) begin
            registers[WriteAdd]<=Reg_WriteData; //writes data to register only if write_en is high
        end
    end
    assign Data1=registers[ReadAdd1]; //output data from register ReadAdd1
    assign Data2=registers[ReadAdd2]; //output data from register ReadAdd2
endmodule
