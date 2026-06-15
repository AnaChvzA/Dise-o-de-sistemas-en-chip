module IF_ID(
    input clk,
    input rst,
    input StallD,
    input FlushD,

    input [31:0] InstrF,
    input [31:0] PCF,
    input [31:0] PCPlus4F,

    output reg [31:0] InstrD,
    output reg [31:0] PCD,
    output reg [31:0] PCPlus4D

);

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin

        InstrD   <= 32'b0;
        PCD      <= 32'b0;
        PCPlus4D <= 32'b0;

    end
	 
    // Flush
    else if(FlushD)
    begin
        InstrD   <= 32'b0;
        PCD      <= 32'b0;
        PCPlus4D <= 32'b0;
    end

    // Stall
    else if(StallD)
    begin
        InstrD   <= InstrD;
        PCD      <= PCD;
        PCPlus4D <= PCPlus4D;
    end

    // Normal
    else
    begin
        InstrD   <= InstrF;
        PCD      <= PCF;
        PCPlus4D <= PCPlus4F;
    end

end

endmodule