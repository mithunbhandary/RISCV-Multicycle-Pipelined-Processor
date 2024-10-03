`include "../Design/control_unit.v"
module control_unit_tb;

  // Inputs
  reg [6:0] opcode;
  reg [2:0] func3;
  reg [6:0] func7;
  reg [19:0] imm_data;

  // Outputs
  wire [31:0] imm_data_ext;  // 32-bit extended immediate data
  wire [3:0] alu_opcode;     // ALU operation opcode
  wire is_load;              // Load operation control
  wire write_en;             // Register write enable

  // Instantiate the control_unit module
  control_unit uut (
    .opcode(opcode),
    .func3(func3),
    .func7(func7),
    .imm_data(imm_data),
    .imm_data_ext(imm_data_ext),
    .alu_opcode(alu_opcode),
    .is_load(is_load),
    .write_en(write_en)
  );

  // Clock generation (not needed for combinational logic, but kept for completeness)
  reg clk;
  always #5 clk = ~clk;

  // Stimulus block
  initial begin
    // Test 1: Load Immediate
    opcode = 7'b0000011; // Load
    func3 = 3'b000;
    func7 = 7'b0000000;
    imm_data = 20'hFFFFF; // Immediate data
    #10;
    check_results(1, 32'h000FFFFF, 4'b0000, 1, 1); // Expected results

    // Test 2: ALU Add
    opcode = 7'b0110011; // ALU operation
    func3 = 3'b000;      // Function code for add
    func7 = 7'b0000000;  // Function code
    imm_data = 20'b0;    // No immediate data
    #10;
    check_results(2, 32'h00000000, 4'b0001, 0, 1); // Expected results

    // Test 3: ALU Subtract
    opcode = 7'b0110011; // ALU operation
    func3 = 3'b000;      // Function code for subtract
    func7 = 7'b0100000;  // Function code
    imm_data = 20'b0;    // No immediate data
    #10;
    check_results(3, 32'h00000000, 4'b0010, 0, 1); // Expected results

    // Test 4: ALU AND
    opcode = 7'b0110011; // ALU operation
    func3 = 3'b110;      // Function code for AND
    func7 = 7'b0000000;  // Function code
    imm_data = 20'b0;    // No immediate data
    #10;
    check_results(4, 32'h00000000, 4'b0011, 0, 1); // Expected results

    // Test 5: NOP
    opcode = 7'b0000000; // NOP
    func3 = 3'b000;
    func7 = 7'b0000000;
    imm_data = 20'b0;    // No immediate data
    #10;
    check_results(5, 32'h00000000, 4'b0000, 0, 0); // Expected results

    // End simulation
    $finish;
  end

  // Task to check the results
  task check_results(input integer test_num, 
                     input [31:0] expected_imm_data_ext,
                     input [3:0] expected_alu_opcode,
                     input expected_is_load,
                     input expected_write_en);
    begin
      if (imm_data_ext !== expected_imm_data_ext ||
          alu_opcode !== expected_alu_opcode ||
          is_load !== expected_is_load ||
          write_en !== expected_write_en) begin
        $display("Test %0d FAILED:", test_num);
        $display("Expected: imm_data_ext = %h, alu_opcode = %b, is_load = %b, write_en = %b", 
                  expected_imm_data_ext, expected_alu_opcode, expected_is_load, expected_write_en);
        $display("Got:      imm_data_ext = %h, alu_opcode = %b, is_load = %b, write_en = %b", 
                  imm_data_ext, alu_opcode, is_load, write_en);
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

