module LED(reset, clk, Address, Write_data, MemWrite, led);
	input reset, clk;
    input [31:0] Address, Write_data;
    input MemWrite;
    output reg [7:0] led;
    
    always @(posedge reset or posedge clk) begin
        if (reset) begin
            led <= 8'h00;
        end
        else if (MemWrite) begin
            led <= Write_data[7:0];
        end
    end
    
endmodule
