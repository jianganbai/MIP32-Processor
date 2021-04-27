module Control(reset, core, IRQ, OpCode, Funct,
	PCSrc, Branch, RegWrite, RegDst, MemRead, MemWrite, 
	MemtoReg, ALUSrc1, ALUSrc2, ExtOp, LuOp, ALUOp, Interrupt, Exception);
	input reset, IRQ, core;
	input [5:0] OpCode;    
	input [5:0] Funct; //¹¦ÄÜÂë
	output reg [2:0] PCSrc;
	output [2:0] Branch;
	output reg RegWrite;
	output reg [1:0] RegDst;
	output MemRead;
	output MemWrite;
	output reg [1:0] MemtoReg;
	output ALUSrc1;
	output reg ALUSrc2;
	output ExtOp;
	output LuOp;
	output [3:0] ALUOp;
	output Interrupt;
	output reg Exception;
	
	//IE signal
	assign Interrupt = IRQ && (!core);
	always @(OpCode or Funct) begin
	   if (OpCode == 6'h00) begin
	       if (Funct>=6'h20 && Funct <= 6'h27) begin
	           Exception <= 1'b0;
	       end
	       else if (Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03 || Funct == 6'h08 || Funct == 6'h09 || Funct == 6'h2a || Funct == 6'h2b) begin
	           Exception <= 1'b0;
	       end
	       else begin
	           Exception <= 1'b1;
	       end
	   end
	   else if (OpCode == 6'h01 || (OpCode >= 6'h04 && OpCode <= 6'h07)) begin
	       Exception <= 1'b0;
	   end
	   else if (OpCode == 6'h23 || OpCode == 6'h2b || OpCode == 6'h0f || OpCode == 6'h08 || OpCode == 6'h09 || OpCode == 6'h0a || OpCode == 6'h0b || OpCode == 6'h0c || OpCode == 6'h02 || OpCode == 6'h03) begin
	       Exception <= 1'b0;
	   end
	   else begin
	       Exception <= 1'b1;
	   end
	end
	//PCSrc
	always @(OpCode or Funct or Interrupt or Exception) begin
	   if (Interrupt) begin
	       PCSrc <= 3'b011;
	   end
	   else if (Exception) begin
	       PCSrc <= 3'b100;
	   end
	   else if(OpCode==6'h02 || OpCode==6'h03) begin
	       PCSrc <= 3'b01;
	   end
	   else if(OpCode==0 && (Funct==6'h08 || Funct==6'h09)) begin
	       PCSrc <= 3'b10;
	   end
	   else begin
	       PCSrc <= 3'b00;
	   end
	end
	//Branch
	assign Branch=(Interrupt || Exception)? 3'd0: 
	              (OpCode==6'b000100)? 3'd1:
	              (OpCode==6'b000101)? 3'd2:
	              (OpCode==6'b000110)? 3'd3:
	              (OpCode==6'b000111)? 3'd4:
	              (OpCode==6'b000001)? 3'd5: 3'd0;
	//RegWrite
	always @(OpCode or Funct or Interrupt or Exception) begin
	   if (Interrupt || Exception) begin
	       RegWrite <= 1'b1;
	   end
	   else if(OpCode==6'h2b || OpCode==6'h04 || OpCode==6'h02 ||(OpCode==0 && Funct==6'h08)) begin
	       RegWrite <= 1'b0;
	   end
	   else begin
	       RegWrite <= 1'b1;
	   end
	end
	//RegDst
	always @(OpCode or Funct or Interrupt or Exception) begin
        if (Interrupt || Exception) begin
            RegDst <= 2'b11; //Ìøµ½$26
        end
        else if(OpCode==6'h23 || OpCode==6'h0f || OpCode==6'h08 || OpCode==6'h09 || OpCode==6'h0c || OpCode==6'h0a || OpCode==6'h0b) begin
            RegDst <= 0;
        end
        else if(OpCode==6'h03) begin
            RegDst <= 2'b10;
        end
        else begin
            RegDst <= 2'b01;
        end
    end
    //MemRead
	assign MemRead = (OpCode==6'h23 && !Interrupt && !Exception)? 1: 0;
	//MemWrite
	assign MemWrite = (OpCode==6'h2b && !Interrupt && !Exception)? 1: 0;
	//MemtoReg
	always @(OpCode or Funct or Interrupt or Exception) begin
        if (Interrupt || Exception) begin
            MemtoReg <= 2'b11;
        end
        else if(OpCode==6'h23) begin
            MemtoReg <= 2'b01;
        end
        else if(OpCode==6'h03 || (OpCode==0 && Funct==6'h09)) begin
            MemtoReg <= 2'b10;
        end
        else begin
            MemtoReg <= 0;
        end
    end
	//ALUSrc1
	assign ALUSrc1=(OpCode==6'h0 && (Funct==6'h0 || Funct==6'h02 || Funct==6'h03))?1:0;
	//ALUSrc2
	always @(OpCode or Funct) begin
        if(OpCode==6'h23 || OpCode==6'h2b || OpCode==6'h0f || OpCode==6'h08 || OpCode==6'h09 || OpCode==6'h0c || OpCode==6'h0a ||OpCode==6'h0b) begin
            ALUSrc2 <= 1;
        end
        else begin
            ALUSrc2 <= 0;
        end
    end
    //ExtOp
    assign ExtOp=(OpCode==6'h0c)?0:1;
    //LuOp
	assign LuOp=(OpCode==6'h0f)?1:0;
	//ALUOp
	assign ALUOp[2:0] = 
		(OpCode == 6'h00)? 3'b010: 
		(OpCode == 6'h04)? 3'b001: 
		(OpCode == 6'h0c)? 3'b100: 
		(OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101: 
		3'b000;
	assign ALUOp[3] = OpCode[0];
	
endmodule