//PC Adder


module PCADDER (

	input [31:0] PC, //Adress og
	input [31:0] PC_suma, // Si es 4 del offset o si es el immediate
	output [31:0] PC_next //Resultado 
	

);

assign PC_next = PC + PC_suma;


endmodule 
