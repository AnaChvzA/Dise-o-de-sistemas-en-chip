
//Register file con A1, A2, A3

//Con un solo always que depende del reloj para escritura
//Escribe si WE3 está activo, lee en el registro apuntado 
//Registro x0 siempre vale 0
module REGISTER_FILE (
	input clk,
	input [4:0] A1,
	input [4:0] A2,
	input [4:0] A3,
	input WE3,
	input [31:0] WD3,
	output [31:0] RD1,
	output [31:0] RD2
);

reg [31:0] REG [31:0];

//Igual combinacional 
assign RD1 = (A1 == 5'b0) ? 32'h0 : REG[A1];
assign RD2 = (A2 == 5'b0) ? 32'h0 : REG[A2];

// Escritura 
always @(posedge clk)
begin
	if (WE3 && A3 != 5'b0)
		REG[A3] <= WD3;
end

endmodule
