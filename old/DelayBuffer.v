// makes use of code from
// https://github.com/nanamake/r22sdf

// implements a shift buffer with constant delay that shifts at posedge

module DelayBuffer #(
    parameter   BUF_DEPTH = 32,     // depth of buffer (the structure)
    parameter   DATA_WIDTH = 16     // width of data (the input/output)
)(
    input                       clock,  //  Master Clock
    input   [DATA_WIDTH-1:0]    di_re,  //  Data Input (Real)
    input   [DATA_WIDTH-1:0]    di_im,  //  Data Input (Imag)
    output  [DATA_WIDTH-1:0]    do_re,  //  Data Output (Real)
    output  [DATA_WIDTH-1:0]    do_im   //  Data Output (Imag)
);

reg     [DATA_WIDTH-1:0] buf_re[0:BUF_DEPTH-1];
reg     [DATA_WIDTH-1:0] buf_im[0:BUF_DEPTH-1];

integer n;

always @(posedge clock) begin
    
    for (n = BUF_DEPTH-1; n > 0; n = n - 1) begin
        buf_re[n] <= buf_re[n-1];
        buf_im[n] <= buf_im[n-1];
    end

    buf_re[0] <= di_re;
    buf_im[0] <= di_im;
end

assign  do_re = buf_re[BUF_DEPTH-1];
assign  do_im = buf_im[BUF_DEPTH-1];

endmodule