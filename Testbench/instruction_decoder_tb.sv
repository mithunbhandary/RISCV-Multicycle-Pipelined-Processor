`include "../Design/instruction_decoder.v"

module instruction_decoder_tb;

  // Signals
  reg clk;
  reg [31:0] instruction;
  wire [6:0] opcode;
  wire [2:0] func3;
  wire [6:0] func7;
  wire [19:0] imm_data;
  wire [4:0] WriteAdd;
  wire [4:0] ReadAdd1;
  wire [4:0] ReadAdd2;

  // Reference model signals (for comparison)
  reg [6:0] ref_opcode;
  reg [2:0] ref_func3;
  reg [6:0] ref_func7;
  reg [19:0] ref_imm_data;
  reg [4:0] ref_WriteAdd;
  reg [4:0] ref_ReadAdd1;
  reg [4:0] ref_ReadAdd2;

  // Instantiate the instruction_decoder module
  instruction_decoder uut (
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

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10 time unit clock period
  end

  // Reference Model
  task reference_model(input [31:0] instr);
    begin
      ref_opcode   = instr[6:0];       // opcode 7 bits
      ref_func3    = instr[14:12];     // func3 3 bits
      ref_func7    = instr[31:25];     // func7 7 bits
      ref_imm_data = instr[31:12];     // immediate data 20 bits (for U-type)
      ref_WriteAdd = instr[11:7];      // destination register Rd
      ref_ReadAdd1 = instr[19:15];     // source register Rs1
      ref_ReadAdd2 = instr[24:20];     // source register Rs2
    end
  endtask

  // Stimulus
  initial begin
    // Test 1: Add instruction (opcode = 0110011)
    instruction = 32'b0000000_00010_00001_000_00011_0110011;  // add R3 = R1 + R2
    reference_model(instruction);
    #10;
    check_results(1);
    
    // Test 2: Load immediate instruction (opcode = 0000011)
    instruction = 32'b000000000100_00001_100_00011_0000011;  // Load R3 with an immediate
    reference_model(instruction);
    #10;
    check_results(2);

    // Test 3: Subtract instruction (opcode = 0110011, func7 = 0100000)
    instruction = 32'b0100000_00010_00001_000_00011_0110011;  // sub R3 = R1 - R2
    reference_model(instruction);
    #10;
    check_results(3);

    // Test 4: XOR instruction
    instruction = 32'b0000000_00100_00011_100_00101_0110011;  // xor R5 = R3 ^ R4
    reference_model(instruction);
    #10;
    check_results(4);

    // Test 5: Load Upper Immediate (LUI)
    instruction = 32'b00000000000000000001_00010_0110111;  // LUI R2 with an immediate
    reference_model(instruction);
    #10;
    check_results(5);

    // End simulation
    $finish;
  end

  // Function to check results against the reference model
  task check_results(input int test_num);
    begin
      if (opcode !== ref_opcode ||
          func3 !== ref_func3 ||
          func7 !== ref_func7 ||
          imm_data !== ref_imm_data ||
          WriteAdd !== ref_WriteAdd ||
          ReadAdd1 !== ref_ReadAdd1 ||
          ReadAdd2 !== ref_ReadAdd2) begin
        $display("Test %0d FAILED:", test_num);
        $display("Expected: opcode=%b, func3=%b, func7=%b, imm_data=%b, WriteAdd=%b, ReadAdd1=%b, ReadAdd2=%b", 
                 ref_opcode, ref_func3, ref_func7, ref_imm_data, ref_WriteAdd, ref_ReadAdd1, ref_ReadAdd2);
        $display("Got:      opcode=%b, func3=%b, func7=%b, imm_data=%b, WriteAdd=%b, ReadAdd1=%b, ReadAdd2=%b", 
                 opcode, func3, func7, imm_data, WriteAdd, ReadAdd1, ReadAdd2);
      end else begin
        $display("Test %0d PASSED.", test_num);
      end
    end
  endtask

  // Dump waveform for viewing
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end

endmodule

