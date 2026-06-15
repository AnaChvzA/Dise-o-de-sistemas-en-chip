module MainDecoder(
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
    //Inicializar valores
    RegWrite = 0;
    ImmSrc   = 2'b00;
    ALUSrc   = 0;
    MemWrite = 0;
    ResultSrc = 2'b00;
    Branch = 0;
    ALUOp  = 2'b00;
    Jump = 0;

    case(op)
	 
        7'b0000011: //lw
        begin
            RegWrite = 1;
            ImmSrc = 2'b00;
            ALUSrc = 1;
            ResultSrc = 2'b01;
            ALUOp = 2'b00;
        end

        7'b0100011: //sw
        begin
            ImmSrc = 2'b01;
            ALUSrc = 1;
            MemWrite = 1;
            ALUOp = 2'b00;
        end

        7'b0110011: //R-Type
        begin
            RegWrite = 1;
            ALUSrc = 0;
            ResultSrc = 2'b00;
            ALUOp = 2'b10;
        end

		  7'b1100011: //beq
        begin
            ImmSrc = 2'b10;
            Branch = 1;
            ALUOp = 2'b01;
        end

        7'b0010011: //addi
        begin
            RegWrite = 1;
            ImmSrc = 2'b00;
            ALUSrc = 1;
            ResultSrc = 2'b00;
            ALUOp = 2'b10;
        end

        7'b1101111: //jal
        begin
            RegWrite = 1;
            ImmSrc = 2'b11;
            ResultSrc = 2'b10;
            Jump = 1;
        end

    endcase
end

endmodule