module ALU (
	input [31:0] A, 
	input [31:0] B,
	input [2:0] ALUControl,
	output reg [31:0] Result,
	output reg Flag
);

// Bloque de ejecución de operaciones
always @(*) 
begin 
	case(ALUControl)
		3'b000 : Result = A + B;           // add
		3'b001 : Result = A - B;           // sub
		3'b010 : Result = A & B;           // and
		3'b011 : Result = A | B;           // or
		3'b101 : Result = A << B[4:0];     // shift
		default: Result = 32'b0; 
	endcase

	if(Result == 32'b0)
		Flag = 1'b1;
	else
		Flag = 1'b0;
end

endmodule
