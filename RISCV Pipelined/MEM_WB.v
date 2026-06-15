module MEM_WB(
    input clk,
    input rst,
	 
    // Datos
    input [31:0] ReadDataM,
    input [31:0] ALUResultM,
    input [31:0] PCPlus4M,

    // Destino
	input [4:0] RdM,

    // Control
    input RegWriteM,
    input [1:0] ResultSrcM,

    // Salidas
    output reg [31:0] ReadDataW,
    output reg [31:0] ALUResultW,
    output reg [31:0] PCPlus4W,
    output reg [4:0] RdW,
    output reg RegWriteW,
    output reg [1:0] ResultSrcW

);

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        ReadDataW <= 0;
        ALUResultW <= 0;
        PCPlus4W <= 0;
        RdW <= 0;
        RegWriteW <= 0;
        ResultSrcW <= 0;
    end
	 
    // NORMAL
    else
    begin
        ReadDataW <= ReadDataM;
        ALUResultW <= ALUResultM;
        PCPlus4W <= PCPlus4M;
        RdW <= RdM;
        RegWriteW <= RegWriteM;
        ResultSrcW <= ResultSrcM;
    end

end



endmodule 