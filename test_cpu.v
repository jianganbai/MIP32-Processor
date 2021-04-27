`timescale 1ns/1ps
module test_cpu();
	
	reg reset;
	reg clk;
	wire [11:0] digi;
	wire [7:0] led;
	
	CPU cpu1(.reset(reset), .clk(clk), .digi(digi), .led(led));
	
	initial begin
		reset = 1;
		clk = 1;
		#50 reset = 0;
	end
	//clkÖÜÆÚÎª10ns
	always #5 clk = ~clk;
		
endmodule
