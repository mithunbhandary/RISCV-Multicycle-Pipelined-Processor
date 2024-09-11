module program_counter #(parameter addr_width=7)(
    input clk,
    input reset,
    output reg [addr_width-1:0] address
);
    wire [addr_width-1:0] pc_incremented=address+1; //incrementing PC
    
    always@(posedge clk) begin
        if (reset) begin
            address<={addr_width{1'b0}};  //resets pc to 0 the 1st position in the program memory
        end
        else begin
            address<=pc_incremented; //updates pc with next value
        end
    end
endmodule
