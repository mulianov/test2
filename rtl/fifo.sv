module fifo #(
    parameter int unsigned WIDTH = 8
) (
    input clk,
    input reset,

    // input side
    output             ready_o,  // early
    input  [WIDTH-1:0] data_i,   // late
    input              valid_i,  // late

    // output side
    output             valid_o,  // early
    output [WIDTH-1:0] data_o    // early
    // input           yumi_i   // late
);

endmodule
