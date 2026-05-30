
//PC

module PROGRAM_COUNTER (
	input clk,
	input rst,
	input [31:0] PCNext,
	output reg [31:0] PC
);

always @(posedge clk or posedge rst)
begin
	if (rst)
		PC <= 32'h0;
	else
		PC <= PCNext;
end

endmodule
