
//Extensor del immediate

module EXTENDER (
	input [31:7] instr,
	input [1:0] ImmSrc,
	output reg [31:0] ImmExt
);

always @(*)
begin
	case(ImmSrc)
	
	2'b00: begin
		// I-type
		ImmExt = {{20{instr[31]}}, instr[31:20]};
	end
	
	2'b01: begin
		// S-type
		ImmExt = {{20{instr[31]}}, instr[31:25], instr[11:7]};
	end
	
	2'b10: begin
		// B-type
		ImmExt = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
	end
	
	2'b11: begin
		// J-type
		ImmExt = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
	end
	
	default: ImmExt = 32'b0;
	
	endcase
end 

endmodule
