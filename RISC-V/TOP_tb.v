
module TOP_tb();

reg clk, rst;

TOP uut (
	.clk(clk),
	.rst(rst),
	.PC(),
	.Instr(),
	.RD1(),
	.RD2(),
	.RegWrite()
);

//Debería de salir en el REG[10] = 15, REG[6] = 10 y en el REG[5] = 5

initial begin
	clk = 0;
	repeat(300) #5 clk = ~clk;
end

initial begin
	$display("\n Sim ini");
	
	rst = 1;
	#10;
	rst = 0;
	
	//12 ciclos de reloj
	repeat(12) #10;
	
	$display("\nSim lista");
	$stop;
	$finish;
end

endmodule
