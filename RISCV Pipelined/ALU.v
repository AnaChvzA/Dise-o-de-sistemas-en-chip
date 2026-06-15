module ALU(
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [2:0] ALUControl,

    output reg [31:0] ALUResult,
    output reg Zero

);

always @(*)
begin

    case(ALUControl)

        // ADD
        3'b000:
        begin
            ALUResult = SrcA + SrcB;
        end

        // SUB
        3'b001:
        begin
            ALUResult = SrcA - SrcB;
        end

        // AND
		  3'b010:
        begin
            ALUResult = SrcA & SrcB;
        end

        // OR
        3'b011:
        begin
            ALUResult = SrcA | SrcB;
        end

        // SLT
        3'b101:
        begin

            if($signed(SrcA) < $signed(SrcB))
                ALUResult = 32'd1;
            else
                ALUResult = 32'd0;

        end

        default:
        begin
            ALUResult = 32'b0;
        end

    endcase

end

//Flag de Zero
always @(*)
begin

    if(ALUResult == 32'b0)
        Zero = 1'b1;
    else
        Zero = 1'b0;

end

endmodule