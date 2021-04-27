module ForwardControl(IFID_RegisterRs, IFID_RegisterRt, IDEX_RegWrite, IDEX_WriteRegister, IDEX_MemtoReg, 
    EXMEM_RegWrite, EXMEM_MemtoReg, EXMEM_WriteRegister, MEMWB_RegWrite, MEMWB_WriteRegister, MEMWB_MemtoReg, 
    RFForward1, RFForward2, ALUForward1, ALUForward2, JrForward); 
    input [4:0] IFID_RegisterRs;
    input [4:0] IFID_RegisterRt;
    input IDEX_RegWrite;
    input [4:0] IDEX_WriteRegister;
    input [1:0] IDEX_MemtoReg;
    input EXMEM_RegWrite;
    input [1:0] EXMEM_MemtoReg;
    input [4:0] EXMEM_WriteRegister;
    input MEMWB_RegWrite;
    input [4:0] MEMWB_WriteRegister;
    input [1:0] MEMWB_MemtoReg;
    output reg [1:0] RFForward1;
    output reg [1:0] RFForward2;
    output reg [2:0] ALUForward1;
    output reg [2:0] ALUForward2;
    output reg [2:0] JrForward;
    
    //RFForward1
    always @(*) begin
        if(MEMWB_RegWrite && (MEMWB_WriteRegister != 0) && (MEMWB_WriteRegister == IFID_RegisterRs) && (MEMWB_MemtoReg == 2'b00)) begin
            RFForward1 <= 2'b01;
        end
        else if (MEMWB_RegWrite && (MEMWB_WriteRegister != 0) && (MEMWB_WriteRegister == IFID_RegisterRs) && (MEMWB_MemtoReg == 2'b01)) begin
            RFForward1 <= 2'b10;
        end
        else if (MEMWB_RegWrite && (MEMWB_WriteRegister != 0) && (MEMWB_WriteRegister == IFID_RegisterRs) && (MEMWB_MemtoReg == 2'b10)) begin
            RFForward1 <= 2'b11;
        end
        else begin
            RFForward1 <= 2'b00;
        end
    end
    //RFForward2
    always @(*) begin
        if(MEMWB_RegWrite && (MEMWB_WriteRegister != 0) && (MEMWB_WriteRegister == IFID_RegisterRt) && (MEMWB_MemtoReg == 2'b00)) begin
            RFForward2 <= 2'b01;
        end
        else if (MEMWB_RegWrite && (MEMWB_WriteRegister != 0) && (MEMWB_WriteRegister == IFID_RegisterRt) && (MEMWB_MemtoReg == 2'b01)) begin
            RFForward2 <= 2'b10;
        end
        else if (MEMWB_RegWrite && (MEMWB_WriteRegister != 0) && (MEMWB_WriteRegister == IFID_RegisterRt) && (MEMWB_MemtoReg == 2'b10)) begin
            RFForward2 <= 2'b11;
        end
        else begin
            RFForward2 <= 2'b00;
        end
    end        
    //ALUForward1
    always @(*) begin
        //从EXMEM_ALUout转发到ALU输入1    
        if (IDEX_RegWrite && (IDEX_WriteRegister != 0) && (IDEX_WriteRegister == IFID_RegisterRs) && (IDEX_MemtoReg == 2'b00)) begin
            ALUForward1 <= 3'b001;
        end
        //从EXMEM_PC_plus_4转发到ALU输入1
        else if (IDEX_RegWrite && (IDEX_WriteRegister != 0) && (IDEX_WriteRegister == IFID_RegisterRs) && (IDEX_MemtoReg == 2'b10)) begin
            ALUForward1 <= 3'b010;
        end
        //从MEMWB_ALUout转发到ALU输入1
        else if (EXMEM_RegWrite && (EXMEM_WriteRegister != 0) && (EXMEM_WriteRegister == IFID_RegisterRs) && (IDEX_WriteRegister != IFID_RegisterRs || !IDEX_RegWrite) && (EXMEM_MemtoReg == 2'b00)) begin
            ALUForward1 <= 3'b011;
        end
        //从MDR转发到ALU输入1
        else if (EXMEM_RegWrite && (EXMEM_WriteRegister != 0) && (EXMEM_WriteRegister == IFID_RegisterRs) && (IDEX_WriteRegister != IFID_RegisterRs || !IDEX_RegWrite) && (EXMEM_MemtoReg == 2'b01)) begin
            ALUForward1 <= 3'b100;
        end
        //从MEMWB_PC_plus_4转发到ALU输入1
        else if (EXMEM_RegWrite && (EXMEM_WriteRegister != 0) && (EXMEM_WriteRegister == IFID_RegisterRs) && (IDEX_WriteRegister != IFID_RegisterRs || !IDEX_RegWrite) && (EXMEM_MemtoReg == 2'b10)) begin
            ALUForward1 <= 3'b101;
        end
        else begin
            ALUForward1 <= 3'b000;
        end
    end
    //ALUForward2
    always @(*) begin
        //从EXMEM_ALUout转发到ALU输入2
        if (IDEX_RegWrite && (IDEX_WriteRegister != 0) && (IDEX_WriteRegister == IFID_RegisterRt) && (IDEX_MemtoReg == 2'b00)) begin
            ALUForward2 <= 3'b001;
        end
        //从EXMEM_PC_plus_4转发到ALU输入2
        else if (IDEX_RegWrite && (IDEX_WriteRegister != 0) && (IDEX_WriteRegister == IFID_RegisterRt) && (IDEX_MemtoReg == 2'b10)) begin
            ALUForward2 <= 3'b010;
        end
        //从MEMWB_ALUout转发到ALU输入2
        else if (EXMEM_RegWrite && (EXMEM_WriteRegister != 0) && (EXMEM_WriteRegister == IFID_RegisterRt) && (IDEX_WriteRegister != IFID_RegisterRt || !IDEX_RegWrite) && (EXMEM_MemtoReg == 2'b00)) begin
            ALUForward2 <= 3'b011;
        end
        //从MDR转发到ALU输入2 
        else if (EXMEM_RegWrite && (EXMEM_WriteRegister != 0) && (EXMEM_WriteRegister == IFID_RegisterRt) && (IDEX_WriteRegister != IFID_RegisterRt || !IDEX_RegWrite) && (EXMEM_MemtoReg == 2'b01)) begin
            ALUForward2 <= 3'b100;
        end
        //从MEMWB_PC_plus_4转发到ALU输入2
        else if (EXMEM_RegWrite && (EXMEM_WriteRegister != 0) && (EXMEM_WriteRegister == IFID_RegisterRt) && (IDEX_WriteRegister != IFID_RegisterRt || !IDEX_RegWrite) && (EXMEM_MemtoReg == 2'b10)) begin
            ALUForward2 <= 3'b101;
        end
        else begin
            ALUForward2 <= 3'b000;
        end
    end
    //JrForward
    always @(*) begin
        //从EXMEM_ALUout转发到jr
        if (EXMEM_RegWrite && (EXMEM_WriteRegister != 0) && (EXMEM_WriteRegister == IFID_RegisterRs) && (EXMEM_MemtoReg == 2'b00)) begin
            JrForward <= 3'b001;
        end
        //从EXMEM_PC_plus_4转发到jr
        else if (EXMEM_RegWrite && (EXMEM_WriteRegister != 0) && (EXMEM_WriteRegister == IFID_RegisterRs) && (EXMEM_MemtoReg == 2'b10)) begin
            JrForward <= 3'b010;
        end
        //从MEM_ALUout转发到jr
        else if (MEMWB_RegWrite && (MEMWB_WriteRegister != 0) && (MEMWB_WriteRegister == IFID_RegisterRs) && (EXMEM_WriteRegister != IFID_RegisterRs || !EXMEM_RegWrite) && (MEMWB_MemtoReg == 2'b00)) begin
            JrForward <= 3'b011;
        end
        //从MDR转发到jr
        else if (MEMWB_RegWrite && (MEMWB_WriteRegister != 0) && (MEMWB_WriteRegister == IFID_RegisterRs) && (EXMEM_WriteRegister != IFID_RegisterRs || !EXMEM_RegWrite) && (MEMWB_MemtoReg == 2'b01)) begin
            JrForward <= 3'b100;
        end
        //从MEMWB_PC_plus_4转发到jr
        else if (MEMWB_RegWrite && (MEMWB_WriteRegister != 0) && (MEMWB_WriteRegister == IFID_RegisterRs) && (EXMEM_WriteRegister != IFID_RegisterRs || !EXMEM_RegWrite) && (MEMWB_MemtoReg == 2'b10)) begin
            JrForward <= 3'b101;
        end
        else begin
            JrForward <= 3'b000;
        end
    end
    
endmodule
