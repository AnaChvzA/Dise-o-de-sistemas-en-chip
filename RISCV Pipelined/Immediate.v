module Immediate(

    input [31:0] instr,
    input [1:0] ImmSrc,

    output reg [31:0] ImmExt

);

always @(*)
begin

    case(ImmSrc)

        
        // I-Type
        2'b00:
        begin
            ImmExt = {{20{instr[31]}},
                       instr[31:20]};
        end

        // S-Type
        2'b01:
        begin
            ImmExt = {{20{instr[31]}},
                       instr[31:25],
                       instr[11:7]};
        end

        // B-Type
        2'b10:
        begin
            ImmExt = {{19{instr[31]}},
                       instr[31],
                       instr[7],
                       instr[30:25],
                       instr[11:8],
                       1'b0};
        end

        // J-Type
        2'b11:
        begin
            ImmExt = {{11{instr[31]}},
                       instr[31],
                       instr[19:12],
                       instr[20],
                       instr[30:21],
                       1'b0};
        end

        default:
        begin
            ImmExt = 32'b0;
        end

    endcase

end

endmodule