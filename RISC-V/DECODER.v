module DECODER (
	input [6:0] op,
	output reg RegWrite,
	output reg [1:0] ImmSrc, 
	output reg ALUSrc,
	output reg MemWrite, 
	output reg [1:0] ResultSrc, 
	output reg Branch,
	output reg [1:0] ALUOp,
	output reg Jump
	
);

always @(*)
	begin 
		case(op)
		7'd3: begin // lw
			RegWrite = 1;
			ImmSrc = 2'b00;
			ALUSrc = 1;
			MemWrite = 0;
			ResultSrc = 2'b01;
			Branch = 0;
			ALUOp = 2'b00;
			Jump = 0;
			end 
			
		7'd35:begin // sw
			RegWrite = 0;
			ImmSrc = 2'b01;
			ALUSrc = 1;
			MemWrite = 1;
			ResultSrc = 2'bxx;
			Branch = 0;
			ALUOp = 2'b00;
			Jump = 0;
			end
			
		7'd51:begin // R-type
			RegWrite = 1;
			ImmSrc = 2'bxx;
			ALUSrc = 0;
			MemWrite = 0;
			ResultSrc = 2'b00;
			Branch = 0;
			ALUOp = 2'b10;
			Jump = 0;
			end
			
		7'd99:begin // beq
			RegWrite = 0;
			ImmSrc = 2'b10;
			ALUSrc = 0;
			MemWrite = 0;
			ResultSrc = 2'bxx;
			Branch = 1;
			ALUOp = 2'b01;
			Jump = 0;
			end
			
		7'd19:begin //I-type
			RegWrite = 1;
			ImmSrc = 2'b00;
			ALUSrc = 1;
			MemWrite = 0;
			ResultSrc = 2'b00;
			Branch = 0;
			ALUOp = 2'b10;
			Jump = 0;
			end
			
		7'd111:begin // jal 
			RegWrite = 1;
			ImmSrc = 2'b11;
			ALUSrc = 1'bx;
			MemWrite = 0;
			ResultSrc = 2'b10;
			Branch = 0;
			ALUOp = 2'bxx;
			Jump = 1;
			end
		
		default: begin
			RegWrite = 0;
			ImmSrc = 2'bxx;
			ALUSrc = 1'bx;
			MemWrite = 0;
			ResultSrc = 2'bxx;
			Branch = 0;
			ALUOp = 2'bxx;
			Jump = 0;
		end
		
		endcase
	end	

endmodule 
