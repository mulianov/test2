`timescale 1ns / 1ps

module top #(
    parameter WIDTH = 8,
    parameter FIFO_LEN = 3
) (
    input                         clk,
    input                         rst,
    input  wire logic [WIDTH-1:0] i_data,
    output wire logic [WIDTH-1:0] o_data,
    output wire logic             o_valid
);

    logic [FIFO_LEN-1:0][WIDTH-1:0] mem;
    integer i;
    logic [$clog2(FIFO_LEN):0] valid_counter;

    export "DPI-C" task publicSetBool;

    bit var_bool;

    task publicSetBool;
       input bit in_bool;
       var_bool = in_bool;
    endtask

    initial
        $display("fuuu %01b", var_bool);

    // import "DPI-C" function int add (input int a, input int b);

    // initial begin
    //    $display("%x + %x = %x", 1, 2, add(1,2));
    // endtask

    assign o_data = mem[FIFO_LEN-1];

    always_ff @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < FIFO_LEN; i++) mem[i] <= 0;
            valid_counter <= FIFO_LEN + 1;
            // if (0 != $sampled(valid_counter))
            //     $display("FUUU %0b", valid_counter);
        end else begin
            mem[0] <= i_data;
            for (i = 1; i < FIFO_LEN; i++) mem[i] <= mem[i-1];
            valid_counter <= valid_counter > 0 ? valid_counter - 1 : 0;
        end
    end

    `ifndef __ICARUS__
    assert property(@(negedge rst) valid_counter == FIFO_LEN + 1)
        else begin
            $display("t=%0t  $past assert 1 failed, %0d", $time, valid_counter);
            $stop;
        end
    `endif

    assign o_valid = valid_counter == 0;

endmodule
