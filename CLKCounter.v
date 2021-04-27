module CLKCounter(reset, clk, Address, Read_data, MemRead);
	input reset, clk;
    input [31:0] Address;
    input MemRead;
    output [31:0] Read_data;    
    
    reg [31:0] counter; //counter²»ÔÊĞíĞ´Èë
    assign Read_data = MemRead? counter: 32'h00000000;
    always @(posedge reset or posedge clk) begin
        if (reset) begin
            counter <= 32'h00000000;
        end
        else begin
            counter <= counter + 32'd1;
        end
    end
    
endmodule
