module EX_MEM(
    input clk,
    input rst,
    // Datos
    input [31:0] ALUResultE,
    input [31:0] WriteDataE,
    input [31:0] PCPlus4E,

    // Destino
	 input [4:0] RdE,

	 // Control
    input RegWriteE,
    input [1:0] ResultSrcE,
    input MemWriteE,

    // Salidas
	 output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [31:0] PCPlus4M,
    output reg [4:0] RdM,
    output reg RegWriteM,
    output reg [1:0] ResultSrcM,
    output reg MemWriteM

);

always @(posedge clk or posedge rst)
begin
    // RESET
    if(rst)
    begin

        ALUResultM <= 0;
        WriteDataM <= 0;
        PCPlus4M <= 0;
        RdM <= 0;
        RegWriteM <= 0;
        ResultSrcM <= 0;
        MemWriteM <= 0;
    end

    // NORMAL
    else
    begin
        ALUResultM <= ALUResultE;
        WriteDataM <= WriteDataE;
        PCPlus4M <= PCPlus4E;

        RdM <= RdE;

        RegWriteM <= RegWriteE;
        ResultSrcM <= ResultSrcE;
        MemWriteM <= MemWriteE;

    end

end

endmodule 