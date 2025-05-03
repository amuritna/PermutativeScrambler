module GenPermutationKey_TB();

reg     clock;
reg [3*8-1:0] in_key;
wire [3*8-1:0] read_key_L, read_key_R;

GenPermutationKey dut (
    .shift_key(in_key),
    .permutation_key1(read_key_L),
    .permutation_key2(read_key_R)
);

always begin
    clock = 1'b0;
    forever #10 clock = ~clock;
end

initial begin 

    in_key = {
        3'd3, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0
    };

    #20;

    in_key = {
        3'd1, 3'd2, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0
    };

    #20;

    in_key = {
        3'd3, 3'd1, 3'd4, 3'd1, 3'd5, 3'd7, 3'd2, 3'd6
    };

end
endmodule