module BranchTest(
    input [31:0] rs,
    input [31:0] rt,
    input [2:0] Branch,
    output BranchResult);
    
    assign BranchResult=(Branch==3'b001)?(rs==rt):
                        (Branch==3'b010)?(rs!=rt):
                        (Branch==3'b011)?(rs<=1'b0):
                        (Branch==3'b100)?(rs>1'b0):
                        (Branch==3'b101)?(rs<1'b0):1'b0;
    
endmodule
