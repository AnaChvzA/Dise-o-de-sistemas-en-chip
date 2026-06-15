module ProgramCounter(
    input clk,
    input rst,

    input StallF,

    input [31:0] PCNext,

    output reg [31:0] PC
);

always @(posedge clk or posedge rst)
begin
    if(rst)
        PC <= 32'b0;

    else if(!StallF)
        PC <= PCNext;
end

endmodule