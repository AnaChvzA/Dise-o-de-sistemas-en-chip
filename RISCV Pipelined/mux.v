module mux #(parameter N=2) (
    input [N*32-1:0] mux_in,
    input [$clog2(N)-1:0] mux_sel,

    output reg [31:0] mux_out
);

always @(*)
begin

    mux_out = 32'b0;

    if(mux_sel < N)
        mux_out = mux_in[mux_sel*32 +: 32];

end
endmodule