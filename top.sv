`timescale 1ns / 1ps

module top #(
    parameter int unsigned COUNTER_MAX = 10
) (
    input        clk,
    input        reset,
    input  logic button,
    output logic red,
    output logic green,
    output logic blue
);
    typedef enum logic [1:0] {
        BLANK = 2'b00,
        RED   = 2'b01,
        GREEN = 2'b11,
        BLUE  = 2'b10,
        XXX   = 'x
    } state_e;

    state_e state, next;
    logic n_red, n_green, n_blue;

    logic [COUNTER_MAX-1:0] counter;

    always_ff @(posedge clk or posedge reset)
        if (reset) counter <= 0;
        else counter <= counter + 1;

    always_ff @(posedge clk or posedge reset)
        if (reset) state <= BLANK;
        else state <= next;

    // verilog_format: off
    always_comb begin
        next = XXX;
        case (state)
            BLANK: if (button) next = RED;
                   else        next = BLANK; // @lb
            RED:               next = GREEN;
            GREEN:             next = BLUE;
            BLUE:              next = BLANK;
            default :          next = XXX;
        endcase
    end
    // verilog_format: on

    // `define STYLE3
`ifdef STYLE3
    always_ff @(posedge clk or posedge reset)
        if (reset) begin
            red   <= 0;
            green <= 0;
            blue  <= 0;
        end else begin
            red   <= '0;
            green <= '0;
            blue  <= '0;
            case (next)
                BLANK:   ;
                RED:     red <= '1;
                GREEN:   green <= '1;
                BLUE:    blue <= '1;
                default: {red, green, blue} <= 'x;
            endcase
        end
`else  // STYLE4
    always_comb begin
        n_red   = '0;
        n_green = '0;
        n_blue  = '0;
        case (state)
            BLANK:   if (button) n_red = '1;  /* RED */
                     else        ;
            RED:                 n_green = '1;
            GREEN:               n_blue = '1;
            BLUE:                ;
            default:             {n_red, n_green, n_blue} = 'x;
        endcase
    end

    always_ff @(posedge clk or posedge reset)
        if (reset) begin
            red   <= 0;
            green <= 0;
            blue  <= 0;
        end else begin
            red   <= n_red;
            green <= n_green;
            blue  <= n_blue;
        end
`endif

endmodule
