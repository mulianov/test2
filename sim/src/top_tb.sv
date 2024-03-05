`timescale 1ns / 1ps

module top_tb (
`ifdef VERILATOR
    input clk  /*verilator clocker*/
`endif
);
    logic reset = 1'b1;

`ifndef VERILATOR
    localparam HALF_PERIOD = `CLK_PERIOD / 2;
    logic clk = 1'b0;
    always #HALF_PERIOD clk <= ~clk;
`endif

    logic button = 1'b0;
    /* verilator lint_off UNUSEDSIGNAL */
    logic red, green, blue;
    /* verilator lint_on UNUSEDSIGNAL */

    top top_instance (
        .clk(clk),
        .reset(reset),
        .button(button),
        .red(red),
        .green(green),
        .blue(blue)
    );


    initial begin
        repeat (3) @(posedge clk);
        reset = 1'b0;
    end

    int i;

    initial begin
        @(negedge reset);

        @(posedge clk);
        button = 1'b1;
        @(posedge clk);
        button = 1'b0;

        for (i = 0; i < 100; i++) @(posedge clk);

        $finish;
    end

    initial begin
        $dumpfile("wave.fst");
        $dumpvars(0, top_instance);
    end

endmodule
