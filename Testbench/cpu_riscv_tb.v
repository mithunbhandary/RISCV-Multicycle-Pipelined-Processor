`include "../Design/cpu_riscv_top.v"

module cpu_riscv_tb;
	// Inputs
	reg clk;
	reg reset;
	wire [31:0] pipelined_alu_out;

	// Instantiate the Design Under Test (UUT)
	cpu_riscv dut (
		.clk(clk), 
		.reset(reset),
		.pipelined_alu_out(pipelined_alu_out)
	);
	
	always #5 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		#10 reset = 0;
		#1000;
	end     

	// Dump waveform for viewing
	initial begin
		$dumpfile("dump.vcd"); 
		$dumpvars;
	end
endmodule
