module program_memory #(parameter addr_width=7,mem_size=128)(
    input clk,
    input reset,
    input [addr_width-1:0] address,
    output reg[31:0] instruction
);
    reg [31:0] memory [0:mem_size-1];
   
    always@(posedge clk) begin
        if (reset) begin
            memory[0]<=32'b0000000_00000_00000_100_01000_0000011;//load immediate R8=4
            memory[1]<=32'b0000000_00000_00000_011_01001_0000011;//load immediate R9=3
	    memory[2]<=32'b0000000_00000_00000_000_00000_0000000;//nop
            memory[3]<=32'b0000000_01001_01000_000_00001_0110011;//add R1=R8+R9
	    memory[4]<=32'b0100000_01001_01000_000_00010_0110011;//subtract R2=R8-R9
	    memory[5]<=32'b0000000_01001_01000_110_00011_0110011;//and R3=R8&R9
	    memory[6]<=32'b0000000_01001_01000_111_00100_0110011;//or R4=R8|R9
	    memory[7]<=32'b0000000_01001_01000_100_00101_0110011;//xor R5=R8^R9
	    memory[8]<=32'b0000000_00010_00011_000_00001_0110011;//add R1=R2+R3
	    memory[9]<=32'b0000000_00000_00000_000_00000_0000000;//nop
            memory[10]<=32'b0000000_00001_00100_100_00110_0110011;//xor R6=R1^R4
	    memory[11]<=32'b0000000_00000_00000_000_00000_0000000;//nop
        end
	    else instruction<=memory[address];
    end
endmodule
