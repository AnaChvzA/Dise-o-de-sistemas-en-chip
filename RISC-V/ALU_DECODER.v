module ALU_DECODER (
	input [1:0] ALUOp,
	input [2:0] funct3,
	input funct7,
	input op5,
	output reg [2:0] ALUControl
);

always @(*)
begin
	if (ALUOp == 2'b00)
		ALUControl = 3'b000;  // lw y el sw
	else if (ALUOp == 2'b01)
		ALUControl = 3'b001;  // beq
	else // ALUOp == 2'b10
	begin
		case(funct3)
		3'b000: begin
			if (funct7 == 1'b0)
				ALUControl = 3'b000;  // add
			else
				ALUControl = 3'b001;  // sub
		end
		3'b010:  ALUControl = 3'b101;  // slt
		3'b110:  ALUControl = 3'b011;  // or
		3'b111:  ALUControl = 3'b010;  // and
		default: ALUControl = 3'b111;
		endcase
	end
end

endmodule
