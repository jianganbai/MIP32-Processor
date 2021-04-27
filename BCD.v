module BCD(reset, clk, Address, Write_data, MemWrite, digi);
	input reset, clk;
    input [31:0] Address, Write_data;
    input MemWrite;
    output reg [11:0] digi;
    
    always @(posedge reset or posedge clk) begin
        if (reset) begin
            digi <= 12'h000;
        end
        else if (MemWrite)begin
            digi <= Write_data[11:0];
        end
    end
endmodule
