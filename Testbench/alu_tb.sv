`include "../Design/alu.v"
module alu_tb;

  // Inputs
  reg [31:0] Data1;
  reg [31:0] Data2;
  reg [3:0] alu_opcode;

  // Outputs
  wire [31:0] alu_out;

  // Reference model output
  reg [31:0] ref_alu_out;

  // Instantiate the DUT (Device Under Test)
  alu dut (
    .Data1(Data1),
    .Data2(Data2),
    .alu_opcode(alu_opcode),
    .alu_out(alu_out)
  );

  // Reference model logic (emulating ALU operations)
  always @(*) begin
    case (alu_opcode)
      4'b0001: ref_alu_out = Data1 + Data2;   // Addition
      4'b0010: ref_alu_out = Data1 - Data2;   // Subtraction
      4'b0011: ref_alu_out = Data1 & Data2;   // AND
      4'b0100: ref_alu_out = Data1 | Data2;   // OR
      4'b0101: ref_alu_out = Data1 ^ Data2;   // XOR
      default: ref_alu_out = 32'h0;           // Default case (NOP or invalid operation)
    endcase
  end

  // Test procedure
  initial begin
    // Initialize inputs
    Data1 = 32'h0;
    Data2 = 32'h0;
    alu_opcode = 4'b0000;

    // Wait for initialization
    #10;

    // Test case 1: Addition
    Data1 = 32'h5;
    Data2 = 32'hA;
    alu_opcode = 4'b0001; // Add
    #10;
    check_result();

    // Test case 2: Subtraction
    alu_opcode = 4'b0010; // Sub
    #10;
    check_result();

    // Test case 3: AND operation
    alu_opcode = 4'b0011; // AND
    #10;
    check_result();

    // Test case 4: OR operation
    alu_opcode = 4'b0100; // OR
    #10;
    check_result();

    // Test case 5: XOR operation
    alu_opcode = 4'b0101; // XOR
    #10;
    check_result();

    // Test case 6: Default case
    alu_opcode = 4'b0000; // Default
    #10;
    check_result();

    // Finish simulation
    $finish;
  end

  // Monitor outputs
  initial begin
    $monitor("Time = %0t | Data1 = %h | Data2 = %h | alu_opcode = %b | alu_out = %h | Expected = %h", 
             $time, Data1, Data2, alu_opcode, alu_out, ref_alu_out);
  end

  // Task to check the result and print pass/fail
  task check_result;
    if (alu_out === ref_alu_out) begin
      $display("PASS: Time = %0t | alu_opcode = %b | alu_out = %h | Expected = %h", $time, alu_opcode, alu_out, ref_alu_out);
    end else begin
      $display("FAIL: Time = %0t | alu_opcode = %b | alu_out = %h | Expected = %h", $time, alu_opcode, alu_out, ref_alu_out);
    end
  endtask
  
  // Dump waveform for viewing
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end

endmodule

