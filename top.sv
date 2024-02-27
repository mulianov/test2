`timescale 1ns / 1ps

module top #(
    parameter COUNTER_MAX = 10
) (
    input clk,
    input reset,
    input  logic button,
    output logic red,
    output logic green,
    output logic blue
);
    typedef enum logic [1:0] {
        BLANK = 2'b00,
        RED = 2'b01,
        GREEN = 2'b11,
        BLUE = 2'b10,
        XXX = 'x } state_e;

    state_e state, next;
    logic n_red, n_green, n_blue;

    logic [COUNTER_MAX-1:0] counter;

    always_ff @(posedge clk or posedge reset)
        if (reset) counter <= 0;
        else counter <= counter + 1;

    always_ff @(posedge clk or posedge reset)
        if (reset) state <= BLANK;
        else state <= next;

    always_comb begin
        next = XXX;
        case (state)
            BLANK : if (button) next = RED;
                    else        next = BLANK;
            RED : next = GREEN;
            GREEN : next = BLUE;
            BLUE : next = BLANK;
        endcase
    end

    always_comb begin
        n_red = '0;
        n_green = '0;
        n_blue = '0;
        case (state)
            BLANK : ;
            RED : n_red = '1;
            GREEN : n_green = '1;
            BLUE : n_blue = '1;
        endcase
    end

    always_ff @(posedge clk or posedge reset)
        if (reset) begin
            red <= 0;
            green <= 0;
            blue <= 0;
        end else begin
            red <= n_red;
            green <= n_green;
            blue <= n_blue;
        end

endmodule
