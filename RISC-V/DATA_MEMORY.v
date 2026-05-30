//ejemplo la memoria del periodo pasado
//Sacar del ejemplo
//Crearle el archivo para iniciar con valores random simples

module DATA_MEMORY (
	input clk,
	input WE,
	input [31:0] A,
	input [31:0] WD,
	output [31:0] RD
);

reg [31:0] mem [0:2];

initial begin
	$readmemh("mem.hex", mem); //Archivo en carpeta se llama mem.hex 
end


assign RD = mem[A[31:2]];

always @(posedge clk)
begin
	if (WE)
		mem[A[31:2]] <= WD;
end

endmodule
