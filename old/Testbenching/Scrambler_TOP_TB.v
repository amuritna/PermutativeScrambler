module Scrambler_TOP_TB #(
    parameter   WIDTH = 16,
    parameter   FRAME = 128,
    parameter   N_SAMPLES = 10,
    parameter   T = 54
)();

    reg                 clock, reset, di_en;
    reg     [23:0]      shift_key;
    reg     [WIDTH-1:0] in_arr [FRAME * N_SAMPLES - 1:0];
    
    reg     [WIDTH-1:0] in_re;
    wire    [15:0]      out_re;
    wire                do_en;

    Scrambler_TOP dut (
        .clock      (clock),        // i, sampling clock
        .reset      (reset),        // i, active high 
        .di_en      (di_en),        // i, input enable (remain high when input remains valid)
        .shift_key  (shift_key),    // i, input 24'b0 for no scrambling
        .in_real    (in_re),        // i, representing audio data
        .do_en      (do_en),        // o, output enable (remain high when valid output is still produced)
        .out_real   (out_re)        // o, representing audio data
    );

    // todo: try 18.432 MHz clock speed
    always begin
        clock = 1'b0;
        forever #(T/2) clock = ~clock;
    end

    // for testbenching file i/o
    integer i, j, fd_do_re;

    // input stimulus
    initial begin
        
        reset = 1;
        di_en = 0;
        
        // input audio data
        // scramble_top_di_re.txt <- indices 70001 to 71280
        $readmemb("scramble_top_di_re.txt", in_arr);

        // output audio data
		fd_do_re = $fopen("scramble_top_do_re.txt", "w");

        #(T);

        reset = 0;

        #(T);

        di_en = 1;
        shift_key = {3'd3, 3'd1, 3'd4, 3'd1, 3'd5, 3'd7, 3'd2, 3'd6};
        
        for (i = 0; i < FRAME * N_SAMPLES; i = i + 1) begin
            in_re = in_arr[i];
            #(T);
        end

        di_en = 0;

    end

    // read output
    always @(posedge do_en) begin 
        for (j = 0; j < FRAME * N_SAMPLES; j = j + 1) begin
            $fwriteb(fd_do_re, out_re);
            $fwrite(fd_do_re, "\n");

            #(T);
        end

        $fclose(fd_do_re);

        #(T);

        $stop;
    end

endmodule