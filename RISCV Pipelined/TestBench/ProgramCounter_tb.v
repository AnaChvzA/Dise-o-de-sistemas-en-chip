`timescale 1ns/1ps

module ProgramCounter_tb();

reg clk;
reg rst;
reg StallF;
reg [31:0] PCNext;

wire [31:0] PC;

ProgramCounter DUT(
    .clk(clk),
    .rst(rst),
    .StallF(StallF),
    .PCNext(PCNext),
    .PC(PC)
);

always #5 clk = ~clk;

initial
begin

    clk = 0;
    rst = 1;
    StallF = 0;
    PCNext = 0;

    #20;

    rst = 0;

    PCNext = 32'd4;
    #10;

    PCNext = 32'd8;
    #10;

    StallF = 1;
    PCNext = 32'd12;
    #10;

    StallF = 0;
    #10;

    $stop;

end

initial
begin
	$monitor("PCNext=%d", PCNext);
end

endmodule