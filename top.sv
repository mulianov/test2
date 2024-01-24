`timescale 1ns / 1ps

module top #(
    parameter WIDTH = 8,
    parameter FIFO_LEN = 2
) (
    input                         clk,
    input                         rst,
    input  wire logic [WIDTH-1:0] i_data,
    output wire logic [WIDTH-1:0] o_data
);

    logic [FIFO_LEN-1:0][WIDTH-1:0] mem;
    integer i;

    assign o_data = mem[FIFO_LEN-1];

    always_ff @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < FIFO_LEN; i++) mem[i] <= 0;
        end else begin
            mem[0] <= i_data;
            for (i = 1; i < FIFO_LEN; i++) mem[i] <= mem[i-1];
        end
    end

endmodule

