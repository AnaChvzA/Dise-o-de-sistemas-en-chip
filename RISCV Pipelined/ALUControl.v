module ALUControl(
    input [1:0] ALUOp,
    input [2:0] funct3,

    input funct7b5,

    output reg [2:0] ALUControl

);

always @(*)
begin

    case(ALUOp)
        
        2'b00: // lw sw
        begin
            ALUControl = 3'b000;
        end

        2'b01: //beq
        begin
            ALUControl = 3'b001;
        end

       
        2'b10:
        begin // R-Type / I-Type 
            case(funct3)
                // add / sub
                3'b000:
                begin
                    if(funct7b5)
                        ALUControl = 3'b001;
                    else
                        ALUControl = 3'b000;
                end
					 
                // slt
                3'b010:
                begin
                    ALUControl = 3'b101;
                end

                // or
					 3'b110:
                begin
                    ALUControl = 3'b011;
                end

                // and
                3'b111:
                begin
                    ALUControl = 3'b010;
                end

                default:
                begin
                    ALUControl = 3'b000;
                end

            endcase

        end


        default: ALUControl = 3'b000;
     
    endcase

end

endmodule