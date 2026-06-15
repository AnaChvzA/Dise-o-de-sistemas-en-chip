module ID_EX(

    input clk,
    input rst,

    input FlushE,
    // Datos
    input [31:0] RD1D,
    input [31:0] RD2D,
    input [31:0] ImmExtD,
    input [31:0] PCD,
    input [31:0] PCPlus4D,

    // Campos instrucción
	 input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] RdD,
    input [2:0] funct3D,
    input funct7b5D,

    // Control
	 input RegWriteD,
    input [1:0] ResultSrcD,
    input MemWriteD,
    input JumpD,
    input BranchD,
    input ALUSrcD,
    input [1:0] ALUOpD,
    
	 // Salidas
    output reg [31:0] RD1E,
    output reg [31:0] RD2E,
    output reg [31:0] ImmExtE,
    output reg [31:0] PCE,
    output reg [31:0] PCPlus4E,
    output reg [4:0] Rs1E,
    output reg [4:0] Rs2E,
    output reg [4:0] RdE,
    output reg [2:0] funct3E,
    output reg funct7b5E,
    output reg RegWriteE,
    output reg [1:0] ResultSrcE,
    output reg MemWriteE,
    output reg JumpE,
    output reg BranchE,
    output reg ALUSrcE,
    output reg [1:0] ALUOpE

);

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        RD1E <= 0;
        RD2E <= 0;
        ImmExtE <= 0;

        PCE <= 0;
        PCPlus4E <= 0;

        Rs1E <= 0;
        Rs2E <= 0;
        RdE <= 0;

        funct3E <= 0;
        funct7b5E <= 0;

        RegWriteE <= 0;
        ResultSrcE <= 0;

        MemWriteE <= 0;

        JumpE <= 0;
        BranchE <= 0;

        ALUSrcE <= 0;
        ALUOpE <= 0;

    end

    // FLUSH
    else if(FlushE)
    begin

        RegWriteE <= 0;
        ResultSrcE <= 0;
        MemWriteE <= 0;
        JumpE <= 0;
        BranchE <= 0;
        ALUSrcE <= 0;
        ALUOpE <= 0;

        RD1E <= 0;
        RD2E <= 0;
        ImmExtE <= 0;

        PCE <= 0;
        PCPlus4E <= 0;

        Rs1E <= 0;
        Rs2E <= 0;
        RdE <= 0;

        funct3E <= 0;
        funct7b5E <= 0;

    end

    // NORMAL
    else
    begin

        RD1E <= RD1D;
        RD2E <= RD2D;
        ImmExtE <= ImmExtD;

        PCE <= PCD;
        PCPlus4E <= PCPlus4D;

        Rs1E <= Rs1D;
        Rs2E <= Rs2D;
        RdE <= RdD;

        funct3E <= funct3D;
        funct7b5E <= funct7b5D;

        RegWriteE <= RegWriteD;
        ResultSrcE <= ResultSrcD;

        MemWriteE <= MemWriteD;

        JumpE <= JumpD;
        BranchE <= BranchD;

        ALUSrcE <= ALUSrcD;
        ALUOpE <= ALUOpD;

    end

end

endmodule 