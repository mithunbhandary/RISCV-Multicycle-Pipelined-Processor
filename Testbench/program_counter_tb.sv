`include "../Design/program_counter.v"

module pc_tb #(parameter addr_width = 7);

  bit clk, reset;
  logic [addr_width-1:0]pc_addr_out, temp_pc_addr_out;
  
  program_counter#(addr_width) pc_inst(clk, reset, pc_addr_out);
  
  always #5 clk = ~clk;
  
  initial begin
    reset = 1;
    #10;
    reset = 0;
    #50;
    reset = 1;
    #10;
    reset = 0;
    #100;
    $finish;
  end  
  
  always@(posedge clk) begin	    
    if(reset == 1) begin
      temp_pc_addr_out = 0;
      
      #1;
      if(pc_addr_out == 0) begin
        $display("\nProgram counter reset condition passed!");
        $display("reset = %0d, address = %0d\n", reset, pc_addr_out);
        temp_pc_addr_out = 0;
      end 
      
      else begin        
        $display("Program counter reset condition failed!");
        $display("reset = %0d, address = %0d", reset, pc_addr_out);        
      end             
    end  
    
    else begin       
      #1;
      if(pc_addr_out == temp_pc_addr_out + 1) begin
        $display("PC increment operation :Pass!");
        $display("Present Address = %0d, Previous Adrress = %0d", pc_addr_out, temp_pc_addr_out);
        temp_pc_addr_out++;
      end
      
      else begin        
        $display("PC increment operation :Fail!");
        $display("Present Address = %0d, Previous Adrress = %0d", pc_addr_out, temp_pc_addr_out);        
      end
    end
  end   
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
endmodule
