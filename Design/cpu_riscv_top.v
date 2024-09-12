`include "alu.v"
`include "control_unit.v"
`include "dff.v"
`include "instruction_decoder.v"
`include "mux_2x1.v"
`include "program_counter.v"
`include "program_memory.v"
`include "register_set.v"


module cpu_riscv(
    input clk,
    input reset
);
    parameter ADDR_WIDTH=7,MEM_SIZE=128;

    wire [ADDR_WIDTH-1:0] pc_address,pc_next;
    wire [31:0] instruction,imm_data_ext,Data1,Data2,alu_out,pipelined_alu_out,pipelined_imm_data_ext,Reg_WriteData;
    wire [6:0] opcode,func7;
    wire [2:0] func3;
    wire [19:0] imm_data;
    wire [3:0] alu_opcode;
    wire is_load,write_en,pipelined_write_en,pipelined_is_load;
    wire [4:0] pipelined_WriteAdd,WriteAdd,ReadAdd1,ReadAdd2;

    //program counter instance
    program_counter #(ADDR_WIDTH) pc_instance(
        .clk(clk),
        .reset(reset),
        .address(pc_address)
    );

    //program memory instance
    program_memory #(ADDR_WIDTH, MEM_SIZE) program_memory_instance(
        .clk(clk),
        .reset(reset),
        .address(pc_address),
        .instruction(instruction)
    );

    //instruction decoder instance
    instruction_decoder instruction_decoder_instance(
        .clk(clk),
        .instruction(instruction),
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .imm_data(imm_data),
        .WriteAdd(WriteAdd),
        .ReadAdd1(ReadAdd1),
        .ReadAdd2(ReadAdd2)
    );

    //control unit instance
    control_unit control_unit_instance(
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .imm_data(imm_data),
        .imm_data_ext(imm_data_ext),
        .alu_opcode(alu_opcode),
        .is_load(is_load),
        .write_en(write_en)
    );

    //alu instance
    alu alu_instance(
        .Data1(Data1),
        .Data2(Data2),
        .alu_opcode(alu_opcode),
        .alu_out(alu_out)
    );
	
	//register set instance
    register_set register_set_instance(
        .clk(clk),
        .write_en(pipelined_write_en),
        .ReadAdd1(ReadAdd1),
        .ReadAdd2(ReadAdd2),
        .WriteAdd(pipelined_WriteAdd),
        .Reg_WriteData(Reg_WriteData),
        .Data1(Data1),
        .Data2(Data2)
    );
   
    //pipeline for write_en
    dff #(1) dff_instance1(
        .clk(clk),
        .in(write_en),
        .pipelined_out(pipelined_write_en)
    );

    //pipeline for alu_out
    dff  #(32) dff_instance2(
        .clk(clk),
        .in(alu_out),
        .pipelined_out(pipelined_alu_out)
    );

    //pipeline for load immediate data extension
    dff  #(32) dff_instance3(
        .clk(clk),
        .in(imm_data_ext),
        .pipelined_out(pipelined_imm_data_ext)
    );


    //pipeline for is_load
    dff  #(1) dff_instance4(
        .clk(clk),
        .in(is_load),
        .pipelined_out(pipelined_is_load)
    );
	 
	 //pipeline for WriteAdd
    dff  #(5) dff_instance5(
        .clk(clk),
        .in(WriteAdd),
        .pipelined_out(pipelined_WriteAdd)
    );
	 
    //multiplexer for Reg_WriteData
    mux_2x1 #(32) mux1(
        .in0(pipelined_alu_out),
        .in1(pipelined_imm_data_ext),
        .sel(pipelined_is_load),
        .out(Reg_WriteData)
    );

endmodule
