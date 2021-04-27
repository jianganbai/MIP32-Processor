module CPU(reset, clk, digi, led);
	input reset, clk;
	output [11:0] digi;
    output [7:0] led;
    //PC definition
	reg [31:0] PC;
	wire [31:0] PC_next, BranchTarget, BranchTarget_temp;
	wire BranchResult, PC_stall, IRQ, core;
    //IF definition
    wire [31:0] PC_plus_4_temp, PC_plus_4;
    wire [31:0] Instruction;
    reg [31:0] IFID_PC, IFID_PC_plus_4, IFID_Instruction;
    reg IFID_nop_label;
    wire IFID_stall, IFID_flush;
	//ID definition
    wire MemRead, MemWrite, ExtOp, LuOp;
    wire ALUSrc1, ALUSrc2, RegWrite, Sign;
    wire [1:0] RegDst, MemtoReg;
    wire [2:0] PCSrc, Branch;
    wire [3:0] ALUOp;
    wire [4:0] WriteRegister, ALUCtl, RegisterRs, RegisterRt;
    wire [31:0] RFDatabus1, RFDatabus2, Databus1, Databus2, Databus3, PC_IE;
    wire [31:0] Ext_out, LU_out, JumpTarget;
    wire [1:0] RFForward1, RFForward2;
    wire [2:0] ALUForward1, ALUForward2, JrForward;
    wire [31:0] JrTarget;
	reg [31:0] IDEX_Databus1, IDEX_Databus2, IDEX_LU_out, IDEX_PC, IDEX_PC_plus_4, IDEX_PC_IE;
    reg [4:0] IDEX_RegisterRs, IDEX_RegisterRt, IDEX_WriteRegister, IDEX_Shamt, IDEX_ALUCtl;
    reg [2:0] IDEX_PCSrc, IDEX_Branch, IDEX_ALUForward1, IDEX_ALUForward2;
    reg [1:0] IDEX_MemtoReg;
    reg IDEX_ALUSrc1, IDEX_ALUSrc2, IDEX_MemRead, IDEX_MemWrite, IDEX_RegWrite;
    reg IDEX_Sign, IDEX_nop_label;
    wire IDEX_flush;
    wire DataHazard, ControlHazard_jump, ControlHazard_branch, Interrupt, Exception;
	//EX definition
    wire [31:0] Forwardbus1, Forwardbus2;
    wire [31:0] ALUin1, ALUin2, ALUout;
    reg [31:0] EXMEM_ALUout, EXMEM_WriteData, EXMEM_PC, EXMEM_PC_plus_4, EXMEM_PC_IE;
    reg [4:0] EXMEM_WriteRegister;
    reg [1:0] EXMEM_MemtoReg; 
    reg EXMEM_MemRead, EXMEM_MemWrite, EXMEM_RegWrite, EXMEM_nop_label;
    //MEM definition
    wire [31:0] ReadData;
	reg [31:0] MEMWB_PC, MEMWB_PC_plus_4, MEMWB_ALUout, MEMWB_MDR, MEMWB_PC_IE;
	reg [4:0] MEMWB_WriteRegister;
    reg [1:0] MEMWB_MemtoReg;
    reg MEMWB_RegWrite, MEMWB_nop_label;
	wire Data_MemRead, CLKCounter_MemRead;
    wire Data_MemWrite, Timer_MemWrite, LED_MemWrite, BCD_MemWrite;
    wire [31:0] Data_ReadData, CLKCounter_ReadData;
    wire [31:0] Address;

    
	//PC
	assign PC_next = (reset == 1'b1)? 32'h80000000:
	                 (BranchResult==1'b1)? BranchTarget: //beq类
	                 (PCSrc == 3'b001)? JumpTarget: //j, jal
	                 (PCSrc == 3'b010)? JrTarget: //jr, jalr
	                 (PCSrc == 3'b011)? 32'h80000004: //中断
	                 (PCSrc == 3'b100)? 32'h80000008: //异常
	                 PC_plus_4;    //默认PC+4
	assign core = PC[31];
	always @(posedge reset or posedge clk) //reset为1时复位PC
	begin
		if (reset) begin
			PC <= 32'h80000000;
	    end
		else begin
			PC <= PC_stall? PC: PC_next;
	    end
	end

	//IF
	assign PC_plus_4_temp = (reset == 1'b1)? 32'h80000000: (PC + 32'd4);
	assign PC_plus_4 = {PC[31],PC_plus_4_temp[30:0]};
	InstructionMemory instruction_memory1(.reset(reset), .Address(PC), .Instruction(Instruction));	
	//IFID register
	always @(posedge reset or posedge clk)
	begin
	   if (reset) begin
	       IFID_PC <= 32'h80000000;
	       IFID_PC_plus_4 <= 32'h80000000;
	       IFID_Instruction <= 32'h00000000; //nop
	       IFID_nop_label <= 1'b0;
	   end
	   else begin //先判断flush再stall
	   	   IFID_PC <= IFID_flush? {PC[31],31'd0}: 
	   	              IFID_stall? IFID_PC: PC;
	   	   IFID_PC_plus_4 <= IFID_flush? {PC[31],31'd4}: 
	   	                     IFID_stall? IFID_PC_plus_4: PC_plus_4;
           IFID_Instruction <= IFID_flush? 32'h00000000: 
                               IFID_stall? IFID_Instruction: Instruction;
           IFID_nop_label <= IFID_flush? 1'b1: 1'b0;
	   end
	end
	
    //ID
	//Control
	Control control1(
		.reset(reset), .IRQ(IRQ), .core(core), .OpCode(IFID_Instruction[31:26]), .Funct(IFID_Instruction[5:0]),
		.PCSrc(PCSrc), .Branch(Branch), .RegWrite(RegWrite), .RegDst(RegDst), .MemRead(MemRead), .MemWrite(MemWrite), 
		.MemtoReg(MemtoReg), .ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .ExtOp(ExtOp), .LuOp(LuOp), .ALUOp(ALUOp), 
		.Interrupt(Interrupt), .Exception(Exception));
    //RegisterFile
    assign RegisterRs = IFID_Instruction[25:21];
    assign RegisterRt = IFID_Instruction[20:16];
    RegisterFile register_file1(.reset(reset), .clk(clk), .RegWrite(MEMWB_RegWrite), .Write_register(MEMWB_WriteRegister),
        .Write_data(Databus3), .Read_register1(RegisterRs), .Read_register2(RegisterRt), 
        .Read_data1(RFDatabus1), .Read_data2(RFDatabus2));
    //ForwardControl
    ForwardControl forwardcontrol1(.IFID_RegisterRs(RegisterRs), .IFID_RegisterRt(RegisterRt), .IDEX_RegWrite(IDEX_RegWrite), 
        .IDEX_WriteRegister(IDEX_WriteRegister), .IDEX_MemtoReg(IDEX_MemtoReg), .EXMEM_RegWrite(EXMEM_RegWrite), 
        .EXMEM_MemtoReg(EXMEM_MemtoReg), .EXMEM_WriteRegister(EXMEM_WriteRegister), .MEMWB_RegWrite(MEMWB_RegWrite), 
        .MEMWB_WriteRegister(MEMWB_WriteRegister), .MEMWB_MemtoReg(MEMWB_MemtoReg), .RFForward1(RFForward1), 
        .RFForward2(RFForward2), .ALUForward1(ALUForward1), .ALUForward2(ALUForward2), .JrForward(JrForward));
    //RFForward
    assign Databus1 = (RFForward1 == 2'b01)? MEMWB_ALUout: 
                      (RFForward1 == 2'b10)? MEMWB_MDR: 
                      (RFForward1 == 2'b11)? MEMWB_PC_plus_4: RFDatabus1;
    assign Databus2 = (RFForward2 == 2'b01)? MEMWB_ALUout: 
                      (RFForward2 == 2'b10)? MEMWB_MDR: 
                      (RFForward2 == 2'b11)? MEMWB_PC_plus_4: RFDatabus2; 
    //HazardDetect
    HazardDetect hazarddetect1(.IFID_RegisterRs(RegisterRs), .IFID_RegisterRt(RegisterRt), .PCSrc(PCSrc), .BranchResult(BranchResult), .IDEX_RegWrite(IDEX_RegWrite), 
        .IDEX_WriteRegister(IDEX_WriteRegister), .IDEX_MemRead(IDEX_MemRead), .EXMEM_RegWrite(EXMEM_RegWrite), .EXMEM_WriteRegister(EXMEM_WriteRegister), 
        .EXMEM_MemRead(EXMEM_MemRead), .DataHazard(DataHazard), .ControlHazard_jump(ControlHazard_jump), .ControlHazard_branch(ControlHazard_branch));
    assign PC_stall = DataHazard;
    assign IFID_stall = DataHazard;
    assign IFID_flush = ControlHazard_jump || ControlHazard_branch || Interrupt || ((!core) && Exception);
    assign IDEX_flush = DataHazard || ControlHazard_branch;
    //PCforIE IE:Interrupt and Exception
    PCforIE pcforie(.IFID_PC(IFID_PC), .IDEX_PC(IDEX_PC), .EXMEM_PC(EXMEM_PC), .MEMWB_PC(MEMWB_PC), .IFID_nop_label(IFID_nop_label), 
        .IDEX_nop_label(IDEX_nop_label), .EXMEM_nop_label(EXMEM_nop_label), .PC_IE(PC_IE));
	//RegDst
	assign WriteRegister = (RegDst == 2'b11)? 5'b11010: 
	                       (RegDst == 2'b00)? IFID_Instruction[20:16]: 
	                       (RegDst == 2'b01)? IFID_Instruction[15:11]: 
	                       (RegDst == 2'b10)? 5'b11111: 5'b00000;
	                       
	//ExtOp
	assign Ext_out = {ExtOp? {16{IFID_Instruction[15]}}: 16'h0000, IFID_Instruction[15:0]};
	//Luop为最终获得的立即数
	assign LU_out = LuOp? {IFID_Instruction[15:0], 16'h0000}: Ext_out;
	//ALUcontrol
	ALUControl alu_control1(.ALUOp(ALUOp), .Funct(IFID_Instruction[5:0]), .ALUCtl(ALUCtl), .Sign(Sign));
	//JumpTarget
	assign JrTarget = (JrForward == 3'b001)? EXMEM_ALUout:
	                  (JrForward == 3'b010)? EXMEM_PC_plus_4: 
	                  (JrForward == 3'b011)? MEMWB_ALUout:
	                  (JrForward == 3'b100)? MEMWB_MDR:
	                  (JrForward == 3'b101)? MEMWB_PC_plus_4: Databus1;
    assign JumpTarget = (PCSrc==3'b001)? {IFID_PC_plus_4[31:28], IFID_Instruction[25:0], 2'b00}:  //jal和jalr的结果会写入寄存器，写不写看MemtoReg
                        (PCSrc==3'b010)? JrTarget: {IFID_PC[31],31'd0};
    	
	//IDEX register
	always @(posedge reset or posedge clk)
	begin
	   if (reset) begin
	       IDEX_Databus1 <= 32'h00000000;
           IDEX_Databus2 <= 32'h00000000;
           IDEX_RegisterRs <= 5'd0;
           IDEX_RegisterRt <= 5'd0;
           IDEX_LU_out <= 32'h00000000;
           IDEX_WriteRegister <= 5'd0;
           IDEX_PC <= 32'h80000000;
           IDEX_PC_plus_4 <= 32'h80000000;
           IDEX_Shamt <= 5'b00000;
           IDEX_PCSrc <= 3'b000;
           IDEX_Branch <= 3'b000;
           IDEX_ALUSrc1 <= 1'b0;
           IDEX_ALUSrc2 <= 1'b0;
           IDEX_MemRead <= 1'b0;
           IDEX_MemWrite <= 1'b0;
           IDEX_RegWrite <= 1'b0;
           IDEX_MemtoReg <= 2'b00;
           IDEX_ALUCtl <= ALUCtl;
           IDEX_Sign <= Sign;
           IDEX_nop_label <= 1'b0;
           IDEX_PC_IE <= 32'h80000000;
           IDEX_ALUForward1 <= 3'b000;
           IDEX_ALUForward2 <= 3'b000;
	   end
	   else begin
	       IDEX_Databus1 <= IDEX_flush? 32'h00000000: Databus1;
           IDEX_Databus2 <= IDEX_flush? 32'h00000000: Databus2;
           IDEX_RegisterRs <= IDEX_flush? 5'd0: RegisterRs;
           IDEX_RegisterRt <= IDEX_flush? 5'd0: RegisterRt;
           IDEX_LU_out <= LU_out;
           IDEX_WriteRegister <= IDEX_flush? 5'd0: WriteRegister;
           IDEX_PC <= IDEX_flush? {IFID_PC[31], 31'd0}: IFID_PC;
           IDEX_PC_plus_4 <= IDEX_flush? {IFID_PC[31], 31'd4}: IFID_PC_plus_4;
           IDEX_Shamt <= IFID_Instruction[10:6];
           IDEX_PCSrc <= IDEX_flush? 3'b000: PCSrc;
           IDEX_Branch <= IDEX_flush? 3'b000: Branch;
           IDEX_ALUSrc1 <= ALUSrc1;
           IDEX_ALUSrc2 <= ALUSrc2;
           IDEX_MemRead <= IDEX_flush? 1'b0: MemRead;
           IDEX_MemWrite <= IDEX_flush? 1'b0: MemWrite;
           IDEX_RegWrite <= IDEX_flush? 1'b0: RegWrite;
           IDEX_MemtoReg <= IDEX_flush? 2'b00: MemtoReg;
           IDEX_ALUCtl <= ALUCtl;
           IDEX_Sign <= Sign;
           IDEX_nop_label <= IDEX_flush? 1'b1: 
                             IFID_nop_label? 1'b1: 1'b0;
           IDEX_PC_IE <= PC_IE;
           IDEX_ALUForward1 <= ALUForward1;
           IDEX_ALUForward2 <= ALUForward2;
	   end
	end
	
	//EX
	//ALUForward
	assign Forwardbus1 = (IDEX_ALUForward1 == 3'b000)? IDEX_Databus1: 
	                     (IDEX_ALUForward1 == 3'b001)? EXMEM_ALUout: 
	                     (IDEX_ALUForward1 == 3'b010)? EXMEM_PC_plus_4: 
	                     (IDEX_ALUForward1 == 3'b011)? MEMWB_ALUout:
	                     (IDEX_ALUForward1 == 3'b100)? MEMWB_MDR:
	                     (IDEX_ALUForward1 == 3'b101)? MEMWB_PC_plus_4: 32'h00000000;
	assign Forwardbus2 = (IDEX_ALUForward2 == 3'b000)? IDEX_Databus2: 
	                     (IDEX_ALUForward2 == 3'b001)? EXMEM_ALUout: 
	                     (IDEX_ALUForward2 == 3'b010)? EXMEM_PC_plus_4: 
                         (IDEX_ALUForward2 == 3'b011)? MEMWB_ALUout:
                         (IDEX_ALUForward2 == 3'b100)? MEMWB_MDR:
                         (IDEX_ALUForward2 == 3'b101)? MEMWB_PC_plus_4: 32'h00000000;
    //ALU
	assign ALUin1 = IDEX_ALUSrc1 ? {17'h00000, IDEX_Shamt}: Forwardbus1;
	assign ALUin2 = IDEX_ALUSrc2 ? IDEX_LU_out: Forwardbus2;
	ALU alu1(.in1(ALUin1), .in2(ALUin2), .ALUCtl(IDEX_ALUCtl), .Sign(IDEX_Sign), .out(ALUout)); 
    //beq类
    BranchTest branch_test(.rs(ALUin1), .rt(ALUin2), .Branch(IDEX_Branch), .BranchResult(BranchResult));
    assign BranchTarget_temp = IDEX_PC_plus_4 + {IDEX_LU_out[29:0], 2'b00};
    assign BranchTarget = {IDEX_PC_plus_4[31],BranchTarget_temp[30:0]};
    //EXMEM register
    always @(posedge reset or posedge clk)
    begin
        if (reset) begin
            EXMEM_ALUout <= 32'h00000000;
            EXMEM_WriteData <= 32'h00000000;
            EXMEM_WriteRegister <= 5'b00000;
            EXMEM_PC <= 32'h80000000;
            EXMEM_PC_plus_4 <= 32'h80000000;
            EXMEM_MemRead <= 1'b0;
            EXMEM_MemWrite <= 1'b0;
            EXMEM_RegWrite <= 1'b0;
            EXMEM_MemtoReg <= 2'b00;
            EXMEM_nop_label <= 1'b0;
            EXMEM_PC_IE <= 32'h80000000;
        end
        else begin
            EXMEM_ALUout <= ALUout;
            EXMEM_WriteData <= Forwardbus2;
            EXMEM_WriteRegister <= IDEX_WriteRegister;
            EXMEM_PC <= IDEX_PC;
            EXMEM_PC_plus_4 <= IDEX_PC_plus_4;
            EXMEM_MemRead <= IDEX_MemRead;
            EXMEM_MemWrite <= IDEX_MemWrite;
            EXMEM_RegWrite <= IDEX_RegWrite;
            EXMEM_MemtoReg <= IDEX_MemtoReg;
            EXMEM_nop_label <= IDEX_nop_label;
            EXMEM_PC_IE <= IDEX_PC_IE;
        end
    end
    
	//MEM
    assign Address = EXMEM_ALUout;
	assign Data_MemRead = (Address >= 32'h00000000 && Address <= 32'h000007ff)? EXMEM_MemRead: 1'b0;
    assign Data_MemWrite = (Address >= 32'h00000000 && Address <= 32'h000007ff)? EXMEM_MemWrite: 1'b0;
    assign Timer_MemWrite = (Address >= 32'h40000000 && Address <= 32'h4000000b)? EXMEM_MemWrite: 1'b0;
    assign LED_MemWrite = (Address == 32'h4000000c)? EXMEM_MemWrite: 1'b0;
    assign BCD_MemWrite = (Address == 32'h40000010)? EXMEM_MemWrite: 1'b0;
    assign CLKCounter_MemRead = (Address == 32'h40000014)? EXMEM_MemRead: 1'b0;
    assign ReadData = (Address >= 32'h00000000 && Address <= 32'h000007ff)? Data_ReadData:  
                      (Address == 32'h40000014)? CLKCounter_ReadData: 32'h00000000;
    
	DataMemory data_memory1(.reset(reset), .clk(clk), .Address(Address), .Write_data(EXMEM_WriteData),
	                       .Read_data(Data_ReadData), .MemRead(Data_MemRead), .MemWrite(Data_MemWrite));
	Timer timer1(.reset(reset), .clk(clk), .Address(Address), .Write_data(EXMEM_WriteData), 
	             .MemWrite(Timer_MemWrite), .IRQ(IRQ));
	LED led1(.reset(reset), .clk(clk), .Address(Address), .Write_data(EXMEM_WriteData), 
	         .MemWrite(LED_MemWrite), .led(led));
	CLKCounter clkcounter1(.reset(reset), .clk(clk), .Address(Address),  
	                       .Read_data(CLKCounter_ReadData), .MemRead(CLKCounter_MemRead));
    BCD bcd1(.reset(reset), .clk(clk), .Address(Address), .Write_data(EXMEM_WriteData), 
              .MemWrite(BCD_MemWrite), .digi(digi));
	//MEMWB register
	always @(posedge reset or posedge clk)
	begin
	   if (reset) begin
	       MEMWB_MDR <= 32'h00000000;
	       MEMWB_PC <= 32'h80000000;
           MEMWB_PC_plus_4 <= 32'h80000000;
           MEMWB_ALUout <= 32'h00000000;
           MEMWB_WriteRegister <= 5'b00000;
           MEMWB_RegWrite <= 1'b0;
           MEMWB_MemtoReg <= 2'b00;
           MEMWB_nop_label <= 1'b0;
           MEMWB_PC_IE <= 32'h80000000;
	   end
	   else begin
	       MEMWB_MDR <= ReadData;
	       MEMWB_PC <= EXMEM_PC;
           MEMWB_PC_plus_4 <= EXMEM_PC_plus_4;
           MEMWB_ALUout <= EXMEM_ALUout;
           MEMWB_WriteRegister <= EXMEM_WriteRegister;
           MEMWB_RegWrite <= EXMEM_RegWrite;
           MEMWB_MemtoReg <= EXMEM_MemtoReg;
           MEMWB_nop_label <= EXMEM_nop_label;
           MEMWB_PC_IE <= EXMEM_PC_IE;
	   end
	end
	
	//WB
	assign Databus3 = (MEMWB_MemtoReg == 2'd3)? MEMWB_PC_IE:
	                  (MEMWB_MemtoReg == 2'd0)? MEMWB_ALUout: 
	                  (MEMWB_MemtoReg == 2'd1)? MEMWB_MDR: MEMWB_PC_plus_4;

endmodule
	