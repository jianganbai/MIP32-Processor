module PCforIE(IFID_PC, IDEX_PC, EXMEM_PC, MEMWB_PC, 
    IFID_nop_label, IDEX_nop_label, EXMEM_nop_label, PC_IE);
    input [31:0] IFID_PC, IDEX_PC, EXMEM_PC, MEMWB_PC;
    input IFID_nop_label, IDEX_nop_label, EXMEM_nop_label;
    output [31:0] PC_IE;
    
    assign PC_IE = (!IFID_nop_label)? IFID_PC:
                   (!IDEX_nop_label)? IDEX_PC:
                   (!EXMEM_nop_label)? EXMEM_PC: MEMWB_PC; 
endmodule
