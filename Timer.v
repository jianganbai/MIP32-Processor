module Timer(reset, clk, Address, Write_data, MemWrite,IRQ);
	input reset, clk;
	input [31:0] Address, Write_data;
	input MemWrite;
    output IRQ;
    
    reg [2:0] TCON;
    reg [31:0] TH, TL;
    
    assign IRQ = TCON[2];
    always @(posedge reset or posedge clk) begin
        if (reset) begin
            TCON <= 3'b000;
            TH <= 32'h00000000;
            TL <= 32'h00000000;
        end
        else begin
            if (MemWrite) begin
                case(Address)
                    32'h40000000: TH <= Write_data;
                    32'h40000004: TL <= Write_data;
                    32'h40000008: TCON <= Write_data[2:0];
                    default: ;
                 endcase
            end
            else begin
                if (TCON[0]) begin
                    if(TL == 32'hffffffff) begin
                        TL <= TH;
                        if(TCON[1]) begin
                            TCON[2] <= 1'b1; //IRQ enabled
                        end
                    end
                    else begin
                        TL <= TL + 1'b1;
                    end
                end
            end            
        end
    end
endmodule