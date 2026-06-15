`timescale 1ns/1ps

module RegisterFile_tb();

reg clk;

reg RegWrite;

reg [4:0] rs1;
reg [4:0] rs2;
reg [4:0] rd;

reg [31:0] wd;

wire [31:0] rd1;
wire [31:0] rd2;

RegisterFile DUT(

    .clk(clk),
    .RegWrite(RegWrite),

    .rs1(rs1),
    .rs2(rs2),

    .rd(rd),
    .wd(wd),

    .rd1(rd1),
    .rd2(rd2)

);

always #5 clk = ~clk;

initial
begin

    clk = 0;

    RegWrite = 0;

    rs1 = 0;
    rs2 = 0;

    rd = 0;
    wd = 0;

    //------------------------------------------------
    // Escribir x1 = 100
    //------------------------------------------------

    #10;

    RegWrite = 1;
    rd = 5'd1;
    wd = 32'd100;

    #10;

    //------------------------------------------------
    // Escribir x2 = 50
    //------------------------------------------------

    rd = 5'd2;
    wd = 32'd50;

    #10;

    //------------------------------------------------
    // Leer x1 y x2
    //------------------------------------------------

    RegWrite = 0;

    rs1 = 5'd1;
    rs2 = 5'd2;

    #10;

    //------------------------------------------------
    // Intentar escribir x0
    //------------------------------------------------

    RegWrite = 1;
    rd = 5'd0;
    wd = 32'd999;

    #10;

    rs1 = 5'd0;

    #10;

    $stop;

end

initial
begin
	$monitor("Rd1=%d, Rd2=%d", rd1,rd2);
end

endmodule