//Main decoder es solo un case con 6 casos y el default 
//Case y todas las salidas de las señales 
//Hacer un multiplexor e instanciarlo varias veces
//Crear una rom que instancie un archivo, entrada y salida de 32 bits
//PC Plus entran dos señales y las suma, usar el mismo sumador pero instanciarlo dos veces


//Register File, tener bloques que lean al mismo tiempo, monitorear todos los registros al mismo tiempo 

//Extensor, de la instruccion le llega todo menos el opcode. Tiene del 31 al 7 de la instrucción y se tiene immSrc y dependiendo de la combinacion 
//depende, es otro case con 4 posibles casos, se tienen que mapear los bits y ya 


//Data memory, como las memorias que vimos, escribir dato en posicion de memoria y sacar dato en la posicion de memoria 

//Quitarle los bits de 1 y 0 al op, para que no se salte la dirección de memoria porque solo hay 3 y avanza de 4 en 4 

module TOP (
	input clk,
	input rst,
	output [31:0] PC,
	output [31:0] Instr,
	output [31:0] RD1,
	output [31:0] RD2,
	output RegWrite
);

wire [31:0] PCNext, PC4, PCTarget;
wire [31:0] ImmExt, SrcB;
wire [31:0] ALUResult, ReadData, Result;
wire Zero;
wire [1:0] ALUOp, ResultSrc, ImmSrc;
wire ALUSrc, MemWrite, PCSrc;
wire [2:0] ALUControl;

// Program Counter
PROGRAM_COUNTER pc_reg (
	.clk(clk),
	.rst(rst),
	.PCNext(PCNext),
	.PC(PC)
);

// Instruction Memory
instruction_memory instr_mem (
	.A(PC),
	.RD(Instr)
);

// Control Unit
CONTROL_UNIT ctrl (
	.op(Instr[6:0]),
	.funct3(Instr[14:12]),
	.funct7(Instr[30]),
	.Zero(Zero),
	.ALUControl(ALUControl),
	.ImmSrc(ImmSrc),
	.RegWrite(RegWrite),
	.ALUSrc(ALUSrc),
	.ResultSrc(ResultSrc),
	.MemWrite(MemWrite),
	.PCSrc(PCSrc)
);

// Register File
REGISTER_FILE reg_file (
	.clk(clk),
	.A1(Instr[19:15]),
	.A2(Instr[24:20]),
	.A3(Instr[11:7]),
	.WE3(RegWrite),
	.WD3(Result),
	.RD1(RD1),
	.RD2(RD2)
);

// Extensor del immediato 
EXTENDER imm_extender (
	.instr(Instr[31:7]),
	.ImmSrc(ImmSrc),
	.ImmExt(ImmExt)
);

// ALU Mux
MUX alu_mux (
	.a(RD2),
	.b(ImmExt),
	.c(32'b0),
	.d(32'b0),
	.sel({1'b0, ALUSrc}),
	.salida(SrcB)
);

// ALU
ALU alu (
	.A(RD1),
	.B(SrcB),
	.ALUControl(ALUControl),
	.Result(ALUResult),
	.Flag(Zero)
);

// Data Memory
DATA_MEMORY data_mem (
	.clk(clk),
	.WE(MemWrite),
	.A(ALUResult),
	.WD(RD2),
	.RD(ReadData)
);

// Result Mux
MUX result_mux (
	.a(ALUResult),
	.b(ReadData),
	.c(PC4),
	.d(32'b0),
	.sel(ResultSrc),
	.salida(Result)
);

// PC + 4
PCADDER pcMas4 (
	.PC(PC),
	.PC_suma(32'd4),
	.PC_next(PC4)
);

// PC + Immediate
PCADDER pc_imm (
	.PC(PC),
	.PC_suma(ImmExt),
	.PC_next(PCTarget)
);

// PC Next Mux
MUX pc_mux (
	.a(PC4),
	.b(PCTarget),
	.c(32'b0),
	.d(32'b0),
	.sel({1'b0, PCSrc}),
	.salida(PCNext)
);

endmodule
