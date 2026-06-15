`timescale 1ns/1ps

module Pipelined_tb();

reg clk;
reg rst;

//================================================
// DUT
//================================================

Pipelined DUT(
    .clk(clk),
    .rst(rst)
);

//================================================
// CLOCK
//================================================

initial
begin
    clk = 1'b0;
end

always #5 clk = ~clk;

//================================================
// RESET
//================================================

initial
begin

    rst = 1'b1;
    @(posedge clk);  // espera posedge
    @(posedge clk);  // dos ciclos completos en reset
    @(posedge clk);
    #1;           
    rst = 1'b0;

end

//================================================
// MONITOR PRINCIPAL
//================================================

always @(posedge clk)
begin

    $display("==============================================================");

    $display(
        "TIME=%0t",
        $time
    );

    $display(
        "PC=%h  INSTR=%h",
        DUT.PCF,
        DUT.InstrF
    );

    $display(
        "ALUResultE=%d  ResultW=%d  RdW=%d  RegWriteW=%b",
        DUT.ALUResultE,
        DUT.ResultW,
        DUT.RdW,
        DUT.RegWriteW
    );
	 
	 $display("funct3E=%b funct7b5E=%b ALUOpE=%b ALUCtrl=%b",
             DUT.funct3E,
             DUT.funct7b5E,
             DUT.ALUOpE,
             DUT.ALUControlE);

    $display("ForwardAE=%b ForwardBE=%b",
             DUT.ForwardAE,
             DUT.ForwardBE);

    $display("SrcAE=%d ForwardBData=%d SrcBE=%d",
             DUT.SrcAE,
             DUT.ForwardBData,
             DUT.SrcBE);
	
	$display("RD1E=%d RD2E=%d", DUT.RD1E, DUT.RD2E);
	
	$display("rs1D=%d rs2D=%d", DUT.rs1D, DUT.rs2D);
	$display("RD1D=%d RD2D=%d",DUT.RD1D, DUT.RD2D);

    $display(
        "x1=%d  x2=%d  x3=%d  x4=%d  x5=%d  x6=%d",
        DUT.RF.registers[1],
        DUT.RF.registers[2],
        DUT.RF.registers[3],
        DUT.RF.registers[4],
        DUT.RF.registers[5],
        DUT.RF.registers[6]
    );

    $display(
        "StallF=%b  StallD=%b  FlushD=%b  FlushE=%b",
        DUT.StallF,
        DUT.StallD,
        DUT.FlushD,
        DUT.FlushE
    );

end

//================================================
// HAZARDS
//================================================

always @(posedge clk)
begin

    if(DUT.StallF || DUT.StallD || DUT.FlushD || DUT.FlushE)
    begin

        $display(
            "*** HAZARD DETECTADO ***"
        );

        $display(
            "StallF=%b StallD=%b FlushD=%b FlushE=%b",
            DUT.StallF,
            DUT.StallD,
            DUT.FlushD,
            DUT.FlushE
        );

    end

end


//================================================
// RESULTADO FINAL
//================================================

initial
begin

    #500;

    $display("");
    $display("==============================================================");
    $display("RESULTADOS FINALES");
    $display("==============================================================");

    $display("x1 = %d", DUT.RF.registers[1]);
    $display("x2 = %d", DUT.RF.registers[2]);
    $display("x3 = %d", DUT.RF.registers[3]);
    $display("x4 = %d", DUT.RF.registers[4]);
    $display("x5 = %d", DUT.RF.registers[5]);
    $display("x6 = %d", DUT.RF.registers[6]);

    $display("==============================================================");

    $stop;

end

endmodule