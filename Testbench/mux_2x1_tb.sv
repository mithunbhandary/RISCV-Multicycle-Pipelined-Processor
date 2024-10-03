`include "../Design/mux_2x1.v"

module mux_2x1_tb;

  // Parameters
  parameter WIDTH = 32;

  // Inputs
  reg [WIDTH-1:0] in0;
  reg [WIDTH-1:0] in1;
  reg sel;

  // Outputs
  wire [WIDTH-1:0] out;

  // Reference Model Output
  reg [WIDTH-1:0] ref_out;

  // Instantiate the DUT (Device Under Test)
  mux_2x1 #(WIDTH) dut (
    .in0(in0),
    .in1(in1),
    .sel(sel),
    .out(out)
  );

  // Reference Model Logic (mimics the behavior of DUT)
  always @(*) begin
    ref_out = sel ? in1 : in0;
  end

  // Test procedure with randomization
  initial begin
    // Seed the random number generator
    integer seed = 32'hDEADBEEF;

    // Run several test cases
    repeat (10) begin
      // Randomize inputs and select line
      in0 = $random(seed);
      in1 = $random(seed);
      sel = $random(seed) % 2; // Randomize sel as 0 or 1

      // Wait for a small delay to allow signals to propagate
      #5;

      // Check if DUT output matches the reference model output
      if (out === ref_out) begin
        $display("PASS: Time = %0t | in0 = %h | in1 = %h | sel = %b | out = %h", 
                 $time, in0, in1, sel, out);
      end else begin
        $display("FAIL: Time = %0t | in0 = %h | in1 = %h | sel = %b | out = %h | expected = %h", 
                 $time, in0, in1, sel, out, ref_out);
      end

      // Wait for next test case
      #10;
    end

    $finish;
  end

  // Monitor output for debugging purposes
  initial begin
    $monitor("Monitor: Time = %0t | in0 = %h | in1 = %h | sel = %b | out = %h", 
             $time, in0, in1, sel, out);
  end

  // Dump waveform for viewing
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end

endmodule

