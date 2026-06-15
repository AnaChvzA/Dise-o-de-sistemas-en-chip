module HazardUnit(
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] RdE,
    input [1:0] ResultSrcE,
	 input PCSrcE,
	
    output reg StallF,
    output reg StallD,
    output reg FlushD,
    output reg FlushE

);

reg lwStall;

always @(*)
begin
    // Detectar Load Hazard
    if((ResultSrcE == 2'b01) &&
       ((Rs1D == RdE) || (Rs2D == RdE)) &&
       (RdE != 5'b00000))
    begin
        lwStall = 1'b1;
    end

    else
    begin
        lwStall = 1'b0;
    end
end

always @(*)
begin

    StallF = 0;
    StallD = 0;
    FlushD = 0;
    FlushE = 0;

    if(lwStall)
    begin
        StallF = 1;
        StallD = 1;
        FlushE = 1;
    end

    if(PCSrcE)
    begin
        FlushD = 1;
        FlushE = 1;
    end

end

endmodule