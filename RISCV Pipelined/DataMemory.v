module DataMemory(
    input clk,
    input MemWrite,
    input [31:0] addr,
    input [31:0] writeData,
    output reg [31:0] readData
);

reg [31:0] memory [0:255];
integer i;

//Iniciar en 0 la memoria
initial
begin

    for(i = 0; i < 256; i = i + 1)
        memory[i] = 32'b0;

end

// Write
always @(posedge clk)
begin
    if(MemWrite)
    begin
        memory[addr[31:2]] <= writeData;
    end

end

// Read
always @(*)
begin
    readData = memory[addr[31:2]];
end

endmodule