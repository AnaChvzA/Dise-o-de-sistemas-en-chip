module InstructionMemory(

    input  [31:0] addr,
    output [31:0] instr

);

reg [31:0] memory [0:255];

//initial
//begin
  //  $readmemh("InstrMem.hex", memory);
//end
integer i;

initial begin
    
    for(i = 0; i < 256; i = i + 1)
        memory[i] = 32'h00000013;  // NOP por defecto
    $readmemh("InstrMem.hex", memory);  // sobreescribe con tu programa
end

assign instr = memory[addr[31:2]];

endmodule

