module HazardDetect(IFID_RegisterRs, IFID_RegisterRt, PCSrc, BranchResult, IDEX_RegWrite, IDEX_WriteRegister, 
                    IDEX_MemRead, EXMEM_RegWrite, EXMEM_WriteRegister, EXMEM_MemRead, DataHazard, ControlHazard_jump, ControlHazard_branch);
    input [4:0] IFID_RegisterRs;
    input [4:0] IFID_RegisterRt;
    input [2:0] PCSrc;
    input BranchResult;
    input IDEX_RegWrite;
    input [4:0] IDEX_WriteRegister;
    input IDEX_MemRead;
    input EXMEM_RegWrite;
    input [4:0] EXMEM_WriteRegister;
    input EXMEM_MemRead;
    output DataHazard;
    output ControlHazard_jump;
    output ControlHazard_branch;
    //DataHazard
    wire correlation_1;
    wire correlation_2;
    assign correlation_1 = (IDEX_RegWrite) && (IDEX_WriteRegister != 5'd0) && (IDEX_WriteRegister == IFID_RegisterRs || IDEX_WriteRegister ==IFID_RegisterRt);
    assign correlation_2 = (EXMEM_RegWrite) && (EXMEM_WriteRegister != 5'd0) &&(EXMEM_WriteRegister == IFID_RegisterRs || EXMEM_WriteRegister == IFID_RegisterRt);
    wire DataHazard_lw, DataHazard_jr, DataHazard;
    assign DataHazard_lw = IDEX_MemRead && correlation_1; //Ò»°ãload-use
    assign DataHazard_jr = (PCSrc == 3'b010) && (correlation_1 || (correlation_2 && EXMEM_MemRead)); //load-jr, load-?-jr, $-jr
    assign DataHazard = DataHazard_lw || DataHazard_jr;
    //ControlHazard
    wire ControlHazard_jump, ControlHazard_branch;
    assign ControlHazard_branch = (DataHazard == 1'b0) && BranchResult;    
    assign ControlHazard_jump = (!ControlHazard_branch) && (DataHazard == 1'b0) && (PCSrc >= 3'b001) && (PCSrc <= 3'b010);
    
endmodule
