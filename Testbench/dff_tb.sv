`include "../Design/dff.v"

module dff_tb;

  // Parameters
  parameter WIDTH = 32;

  // Inputs
  reg clk;
  reg [WIDTH-1:0] in;

  // Outputs
  wire [WIDTH-1:0] pipelined_out;

  // Instantiate the D flip-flop module
  dff #(WIDTH) uut (
    .clk(clk),
    .in(in),
    .pipelined_out(pipelined_out)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // Toggle clock every 5 time units
  end

  // Stimulus block
  initial begin
    // Initialize inputs
    in = 32'b0;

    // Test 1: Set input to 1
    #10;
    in = 32'hFFFFFFFF; // Set all bits to 1
    #10; // Wait for one clock cycle

    // Test 2: Set input to 0
    #10;
    in = 32'b0; // Set all bits to 0
    #10; // Wait for one clock cycle

    // Test 3: Alternate input values
    #10;
    in = 32'hA5A5A5A5; // Set input to a specific pattern
    #10; // Wait for one clock cycle

    // Test 4: Another pattern
    #10;
    in = 32'h5A5A5A5A; // Set input to the inverted pattern
    #10; // Wait for one clock cycle

    // Test 5: Random input
    #10;
    in = 32'h12345678; // Set input to a random value
    #10; // Wait for one clock cycle

    // End simulation
    #10;
    $finish;
  end

  // Monitor outputs
  initial begin
    $monitor("Time: %0t | clk: %b | in: %h | pipelined_out: %h", $time, clk, in, pipelined_out);
  end

  // Dump waveform for viewing
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end

endmodule

