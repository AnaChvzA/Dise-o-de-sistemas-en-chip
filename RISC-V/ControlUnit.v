module CONTROL_UNIT (
	input [6:0] op,
	input [2:0] funct3,
	input funct7,
	input Zero,
	output [2:0] ALUControl,
	output [1:0] ImmSrc,
	output RegWrite,
	output ALUSrc,
	output [1:0] ResultSrc,
	output MemWrite,
	output PCSrc
);

wire Branch;
wire Jump;
wire [1:0] ALUOp;

// Main decoder
DECODER MainDec (
	.op(op),
	.ALUOp(ALUOp),
	.ImmSrc(ImmSrc),
	.RegWrite(RegWrite),
	.ALUSrc(ALUSrc),
	.ResultSrc(ResultSrc),
	.MemWrite(MemWrite),
	.Branch(Branch),
	.Jump(Jump)
);

// ALU decoder
ALU_DECODER ALUDecoder (
	.ALUOp(ALUOp),
	.funct3(funct3),
	.funct7(funct7),
	.op5(op[5]),
	.ALUControl(ALUControl)
);

// PC mux
assign PCSrc = (Zero & Branch) || Jump;

endmodule
