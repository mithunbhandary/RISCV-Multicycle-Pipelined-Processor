'include "cpu_riscv_top.v"

module cpu_riscv_tb;

	// Inputs
	reg clk;
	reg reset;

	// Instantiate the Design Under Test (UUT)
	cpu_riscv_top dut (
		.clk(clk), 
		.reset(reset)
	);
   always #5 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		#10 reset = 0;
    #1000;
	end     
endmodule
