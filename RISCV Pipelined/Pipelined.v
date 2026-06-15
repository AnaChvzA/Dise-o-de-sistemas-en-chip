module Pipelined(
    input clk,
    input rst
);

// IF
wire [31:0] PCF;
wire [31:0] InstrF;
wire [31:0] PCPlus4F;

// Hazard Unit
wire StallF;
wire StallD;
wire FlushD;
wire FlushE;

// PC
wire [31:0] PCNextF;
wire [31:0] PCTargetE;
wire PCSrcE;

mux #(.N(2)) PCMux(
    .mux_in({
        PCTargetE,
        PCPlus4F
    }),
    .mux_sel(PCSrcE),
    .mux_out(PCNextF)
);

ProgramCounter PC(
    .clk(clk),
    .rst(rst),
    .StallF(StallF),
    .PCNext(PCNextF),
    .PC(PCF)
);

Adder PCPlus4Adder(
    .A(PCF),
    .B(32'd4),
    .Y(PCPlus4F)
);

InstructionMemory IMEM(
    .addr(PCF),
    .instr(InstrF)
);

// IF/ID

wire [31:0] InstrD;
wire [31:0] PCD;
wire [31:0] PCPlus4D;

IF_ID IF_ID_REG(
    .clk(clk),
    .rst(rst),
    .StallD(StallD),
    .FlushD(FlushD),
    .InstrF(InstrF),
    .PCF(PCF),
    .PCPlus4F(PCPlus4F),
    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D)
);

// Decode fields
wire [6:0] opD;
wire [2:0] funct3D;
wire funct7b5D;
wire [4:0] rs1D;
wire [4:0] rs2D;
wire [4:0] rdD;

assign opD = InstrD[6:0];
assign rdD = InstrD[11:7];
assign funct3D = InstrD[14:12];
assign rs1D = InstrD[19:15];
assign rs2D = InstrD[24:20];
assign funct7b5D = InstrD[30];

wire [31:0] RD1D;
wire [31:0] RD2D;
wire [31:0] ResultW;
wire [4:0] RdW;
wire RegWriteW;
	

RegisterFile RF(
    .clk(clk),
    .RegWrite(RegWriteW),
    .rs1(rs1D),
    .rs2(rs2D),
    .rd(RdW),
    .wd(ResultW),
    .rd1(RD1D),
    .rd2(RD2D)
);

wire [31:0] ImmExtD;
wire [1:0] ImmSrcD;

Immediate IMMGEN(
    .instr(InstrD),
    .ImmSrc(ImmSrcD),
    .ImmExt(ImmExtD)
);

// DECODER
wire RegWriteD;
wire [1:0] ResultSrcD;
wire MemWriteD;
wire JumpD;
wire BranchD;
wire ALUSrcD;
wire [1:0] ALUOpD;

MainDecoder DECODER(
    .op(opD),
    .RegWrite(RegWriteD),
    .ImmSrc(ImmSrcD),
    .ALUSrc(ALUSrcD),
    .MemWrite(MemWriteD),
    .ResultSrc(ResultSrcD),
    .Branch(BranchD),
    .ALUOp(ALUOpD),
    .Jump(JumpD)
);

// ID/EX
wire [31:0] RD1E;
wire [31:0] RD2E;
wire [31:0] ImmExtE;
wire [31:0] PCE;
wire [31:0] PCPlus4E;
wire [4:0] Rs1E;
wire [4:0] Rs2E;
wire [4:0] RdE;
wire [2:0] funct3E;
wire funct7b5E;
wire RegWriteE;
wire [1:0] ResultSrcE;
wire MemWriteE;
wire JumpE;
wire BranchE;
wire ALUSrcE;
wire [1:0] ALUOpE;

ID_EX ID_EX_REG(
    .clk(clk),
    .rst(rst),
    .FlushE(FlushE),
    .RD1D(RD1D),
    .RD2D(RD2D),
    .ImmExtD(ImmExtD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D),
    .Rs1D(rs1D),
    .Rs2D(rs2D),
    .RdD(rdD),
    .funct3D(funct3D),
    .funct7b5D(funct7b5D),
    .RegWriteD(RegWriteD),
    .ResultSrcD(ResultSrcD),
    .MemWriteD(MemWriteD),
    .JumpD(JumpD),
    .BranchD(BranchD),
    .ALUSrcD(ALUSrcD),
    .ALUOpD(ALUOpD),
    .RD1E(RD1E),
    .RD2E(RD2E),
    .ImmExtE(ImmExtE),
    .PCE(PCE),
    .PCPlus4E(PCPlus4E),
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdE(RdE),
    .funct3E(funct3E),
    .funct7b5E(funct7b5E),
    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .JumpE(JumpE),
    .BranchE(BranchE),
    .ALUSrcE(ALUSrcE),
    .ALUOpE(ALUOpE)
);

// EX
wire [2:0] ALUControlE;
wire [1:0] ForwardAE;
wire [1:0] ForwardBE;
wire [31:0] SrcAE;
wire [31:0] ForwardBData;
wire [31:0] SrcBE;
wire [31:0] ALUResultE;
wire ZeroE;

ALUControl ALUCTRL(
    .ALUOp(ALUOpE),
    .funct3(funct3E),
    .funct7b5(funct7b5E),
    .ALUControl(ALUControlE)
);


wire [31:0] ALUResultM;
wire [4:0] RdM;
wire RegWriteM;

ForwardingUnit FWD(
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdM(RdM),
    .RdW(RdW),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE)
);

mux #(.N(3)) ForwardAMux(
    .mux_in({
        ALUResultM,
        ResultW,
        RD1E
    }),
    .mux_sel(ForwardAE),
    .mux_out(SrcAE)
);


mux #(.N(3)) ForwardBMux(
    .mux_in({
        ALUResultM,
        ResultW,
        RD2E
    }),
    .mux_sel(ForwardBE),
    .mux_out(ForwardBData)
);

mux #(.N(2)) ALUSrcMux(
    .mux_in({
        ImmExtE,
        ForwardBData
    }),
    .mux_sel(ALUSrcE),
    .mux_out(SrcBE)
);


//ALU
ALU ALU_CORE(
    .SrcA(SrcAE),
    .SrcB(SrcBE),
    .ALUControl(ALUControlE),
    .ALUResult(ALUResultE),
    .Zero(ZeroE)
);


Adder BranchAdder(
    .A(PCE),
    .B(ImmExtE),
    .Y(PCTargetE)
);

assign PCSrcE = (BranchE & ZeroE) | JumpE;

// EX/MEM

wire [31:0] WriteDataM;
wire [31:0] PCPlus4M;
wire [1:0] ResultSrcM;
wire MemWriteM;

wire [31:0] ReadDataW;
wire [31:0] ALUResultW;
wire [31:0] PCPlus4W;
wire [1:0] ResultSrcW;


EX_MEM EX_MEM_REG(
    .clk(clk),
    .rst(rst),
    .ALUResultE(ALUResultE),
    .WriteDataE(ForwardBData),
    .PCPlus4E(PCPlus4E),
    .RdE(RdE),
    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .PCPlus4M(PCPlus4M),
    .RdM(RdM),
    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .MemWriteM(MemWriteM)
);


// MEM
wire [31:0] ReadDataM;
DataMemory DMEM(
    .clk(clk),
    .MemWrite(MemWriteM),
    .addr(ALUResultM),
    .writeData(WriteDataM),
    .readData(ReadDataM)
);


// MEM/WB

MEM_WB MEM_WB_REG(
    .clk(clk),
    .rst(rst),
    .ReadDataM(ReadDataM),
    .ALUResultM(ALUResultM),
    .PCPlus4M(PCPlus4M),
    .RdM(RdM),
    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .ReadDataW(ReadDataW),
    .ALUResultW(ALUResultW),
    .PCPlus4W(PCPlus4W),
    .RdW(RdW),
    .RegWriteW(RegWriteW),
    .ResultSrcW(ResultSrcW)
);

mux #(.N(4)) ResultMux(
    .mux_in({
        32'b0,
        PCPlus4W,
        ReadDataW,
        ALUResultW
    }),
    .mux_sel(ResultSrcW),
    .mux_out(ResultW)
);


//Hazard
HazardUnit HAZARD(
    .Rs1D(rs1D),
    .Rs2D(rs2D),
    .RdE(RdE),
    .ResultSrcE(ResultSrcE),
    .PCSrcE(PCSrcE),
    .StallF(StallF),
    .StallD(StallD),
    .FlushD(FlushD),
    .FlushE(FlushE)
);

endmodule 