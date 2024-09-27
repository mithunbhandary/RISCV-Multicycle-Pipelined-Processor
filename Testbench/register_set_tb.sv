`include "../Design/register_set.v"

module register_set_tb;

  // Inputs
  reg clk;
  reg write_en;
  reg [4:0] ReadAdd1;
  reg [4:0] ReadAdd2;
  reg [4:0] WriteAdd;
  reg [31:0] Reg_WriteData;

  // Outputs
  wire [31:0] Data1;
  wire [31:0] Data2;

  // Internal register file reference model (32 registers of 32 bits each)
  reg [31:0] register_file [0:31];

  // Instantiate the DUT (Device Under Test)
  register_set dut (
    .clk(clk),
    .write_en(write_en),
    .ReadAdd1(ReadAdd1),
    .ReadAdd2(ReadAdd2),
    .WriteAdd(WriteAdd),
    .Reg_WriteData(Reg_WriteData),
    .Data1(Data1),
    .Data2(Data2)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns clock period
  end

  // Reference model to mimic the behavior of the register file
  always @(posedge clk) begin
    if (write_en) begin
      register_file[WriteAdd] <= Reg_WriteData; // Write operation
    end
  end

  // Test procedure
  initial begin
    integer seed = 32'hDEADBEEF;
    integer i;
    reg [4:0] random_address;

    // Initialize the register file (reference model)
    for (i = 0; i < 32; i = i + 1) begin
      register_file[i] = 0;
    end

    // Initialize inputs
    write_en = 0;
    ReadAdd1 = 0;
    ReadAdd2 = 0;
    WriteAdd = 0;
    Reg_WriteData = 0;

    // Wait for the system to initialize
    #10;

    // Randomized test cases with write and read from the same address
    repeat (10) begin
      // Randomize values for writing to the register file
      random_address = $random(seed) % 32;  // Generate a random address
      write_en = 1;
      WriteAdd = random_address;            // Write to a random address
      Reg_WriteData = $random(seed);        // Random data to write
      #10;
      write_en = 0;

      // Read from the same address
      ReadAdd1 = random_address;
      ReadAdd2 = $random(seed) % 32;        // Read from a different random address
      #10;

      // Check if the DUT output matches the reference model for ReadAdd1
      if (Data1 !== register_file[ReadAdd1]) begin
        $display("FAIL: Time = %0t | ReadAdd1 = %d | Expected = %h | Got = %h", 
                  $time, ReadAdd1, register_file[ReadAdd1], Data1);
      end else begin
        $display("PASS: Time = %0t | ReadAdd1 = %d | Data = %h", 
                  $time, ReadAdd1, Data1);
      end

      // Check if the DUT output matches the reference model for ReadAdd2
      if (Data2 !== register_file[ReadAdd2]) begin
        $display("FAIL: Time = %0t | ReadAdd2 = %d | Expected = %h | Got = %h", 
                  $time, ReadAdd2, register_file[ReadAdd2], Data2);
      end else begin
        $display("PASS: Time = %0t | ReadAdd2 = %d | Data = %h", 
                  $time, ReadAdd2, Data2);
      end
    end

    // Finish the simulation
    $finish;
  end

  // Monitor the key signals for debugging
  initial begin
    $monitor("Time = %0t | clk = %b | write_en = %b | WriteAdd = %d | Reg_WriteData = %h | ReadAdd1 = %d | Data1 = %h | ReadAdd2 = %d | Data2 = %h",
              $time, clk, write_en, WriteAdd, Reg_WriteData, ReadAdd1, Data1, ReadAdd2, Data2);
  end

endmodule

