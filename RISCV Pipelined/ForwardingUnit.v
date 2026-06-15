module ForwardingUnit(
    input [4:0] Rs1E,
    input [4:0] Rs2E,
    input [4:0] RdM,
    input [4:0] RdW,
    input RegWriteM,
    input RegWriteW,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE

);

always @(*)
begin
    ForwardAE = 2'b00;
    ForwardBE = 2'b00;

    // Forward A
	 if((Rs1E == RdM) &&
       (RegWriteM == 1'b1) &&
       (RdM != 5'b00000))
    begin
        ForwardAE = 2'b10;
    end

    else if((Rs1E == RdW) &&
            (RegWriteW == 1'b1) &&
            (RdW != 5'b00000))
    begin
        ForwardAE = 2'b01;
    end

    // Forward B
	 if((Rs2E == RdM) &&
       (RegWriteM == 1'b1) &&
       (RdM != 5'b00000))
    begin
        ForwardBE = 2'b10;
    end

    else if((Rs2E == RdW) &&
            (RegWriteW == 1'b1) &&
            (RdW != 5'b00000))
    begin

        ForwardBE = 2'b01;

    end

end

endmodule