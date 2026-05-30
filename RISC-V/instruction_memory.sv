module instruction_memory (
	input [31:0] A,
	output [31:0] RD
);

	reg [31:0] instr_mem [0:2];

initial begin
	$readmemh("instrMem.hex", instr_mem);
	$display("instr_mem[0] = %h", instr_mem[0]);
	$display("instr_mem[1] = %h", instr_mem[1]);
	$display("instr_mem[2] = %h", instr_mem[2]);
end

//No me funciona con secuencial asi que es combinacional 
assign RD = instr_mem[A[31:2]];

endmodule
