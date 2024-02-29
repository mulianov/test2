`timescale 1ns / 1ps

module top_tb ();
    logic reset = 1'b1;
    logic clk = 1'b0;

    logic button = 1'b0;
    logic red, green, blue;

    top top_instance (
        .clk(clk),
        .reset(reset),
        .button(button),
        .red(red),
        .green(green),
        .blue(blue)
    );

    always #5 clk <= ~clk;

    initial begin
        repeat (3) @(posedge clk);
        reset = 1'b0;
    end

    int i;

    initial begin
        @(negedge reset);

        // for (i = 0; i < 1; i++) begin
            @(posedge clk);
            button <= 1'b1;
            @(posedge clk);
            button <= 1'b0;
        // end

        for (i = 0; i < 100; i++)
            @(posedge clk);

        $finish;
    end

    initial begin
        $dumpfile("wave_icarus.fst");
        $dumpvars(0, top_instance);
    end

    // initial $monitor($stime,, reset,, clk,, button,, red,, green,, blue);

endmodule
