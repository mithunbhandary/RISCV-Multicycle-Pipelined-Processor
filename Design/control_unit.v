module control_unit(
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    input [19:0] imm_data,
    output reg [31:0] imm_data_ext,  //32bit extended immediate data
    output reg [3:0] alu_opcode,     //defines opcodes for alu operations 
    output reg is_load,              //controls load operation between load immediate and alu output
    output reg write_en              //controls the write operation to the destination register
);

    always @(*) begin
        //defaults
        imm_data_ext={12'b0,imm_data};  //extend 20bits immediate data to 32bits
        is_load=0;
        write_en=1;
        alu_opcode=4'b0;
        case (opcode)
            7'b0000011: is_load = 1;  //load immediate
            7'b0110011: begin  //alu operations
                case ({func7,func3})
                    10'b0000000_000: alu_opcode=4'b0001; //add
                    10'b0100000_000: alu_opcode=4'b0010; //sub
                    10'b0000000_110: alu_opcode=4'b0011; //and
                    10'b0000000_111: alu_opcode=4'b0100; //or
                    10'b0000000_100: alu_opcode=4'b0101; //xor
                    default: alu_opcode=4'b0000; //default for alu operation
                endcase
            end
            7'b0000000: write_en=0; //nop
            default:  write_en=0; //default operation is nop
        endcase
    end
endmodule
