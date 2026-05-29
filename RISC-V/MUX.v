
//Mux de 4 a 1

module MUX ( 
	input [31:0] a,
	input [31:0] b, 
	input [31:0] c, 
	input [31:0] d,
	input [1:0] sel,
	output reg [31:0] salida 


);



always @(*)
begin
	case (sel)
	
	2'b00: salida = a;
	2'b01: salida = b;
	2'b10: salida = c;
	2'b11: salida = d;
	default salida = 32'b0;
	
	endcase 
	
	
end 


endmodule 
