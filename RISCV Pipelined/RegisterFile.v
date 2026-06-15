module RegisterFile(

    input clk,
    input RegWrite,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] wd,

    output reg [31:0] rd1,
    output reg [31:0] rd2

);

reg [31:0] registers [0:31];

integer i;

initial
begin
    for(i=0; i<32; i=i+1)
        registers[i] = 32'b0;
end


always @(posedge clk)
begin
    if(RegWrite)
    begin
        if(rd != 5'd0)
            registers[rd] <= wd;
    end
end


// Puerto 1
always @(*)
begin
    if(rs1 == 5'd0)
        rd1 = 32'b0;
    else if(RegWrite && (rd == rs1) && (rd != 5'd0))
        rd1 = wd;
    else
        rd1 = registers[rs1];
end

// Puerto 2
always @(*)
begin
    if(rs2 == 5'd0)
        rd2 = 32'b0;
    else if(RegWrite && (rd == rs2) && (rd != 5'd0))
        rd2 = wd;       
    else
        rd2 = registers[rs2];
end

endmodule