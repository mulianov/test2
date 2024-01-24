`timescale 1ns / 1ps

// module crossdomain (
//   input reset,
//   input clk,
//   input data_in,
//   output reg data_out
// );
//     reg [1:0] data_tmp;
//
//     always @(posedge clk) begin
//         if (reset) begin
//             {data_out, data_tmp} <= 0;
//         end else begin
//             {data_out, data_tmp} <= {data_tmp, data_in};
//         end
//     end
// endmodule

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

// module top
// (
//     input               clk,
//     input               rstn,
//     input  logic [17:0] in,
//     output logic [ 4:0] out
// );
//
//   logic [4:0] out_i;
//   logic [4:0] res;
//
//   assign out = res;
//
//   popcount popcount_i (
//       .in (in),
//       .out(out_i)
//   );
//
//   always_ff @(posedge clk) begin
//     if (!rstn) res <= 0;
//     else res <= out_i;
//   end
//
// endmodule
//
// module popcount6 (
//     input  logic [5:0] in,
//     output logic [2:0] out
// );
//
//   always_comb
//     case (in)
//       6'b000000: out = 0;
//       6'b000001, 6'b000010, 6'b000100, 6'b001000, 6'b010000, 6'b100000: out = 1;
//       6'b000011,
//             6'b000101,
//             6'b000110,
//             6'b001001,
//             6'b001010,
//             6'b001100,
//             6'b010001,
//             6'b010010,
//             6'b010100,
//             6'b011000,
//             6'b100001,
//             6'b100010,
//             6'b100100,
//             6'b101000,
//             6'b110000 :
//       out = 2;
//       6'b000111,
//             6'b001011,
//             6'b001110,
//             6'b010011,
//             6'b010101,
//             6'b010110,
//             6'b011001,
//             6'b011010,
//             6'b011100,
//             6'b100011,
//             6'b100101,
//             6'b100110,
//             6'b101001,
//             6'b101010,
//             6'b101100,
//             6'b110001,
//             6'b110010,
//             6'b110100,
//             6'b111000 :
//       out = 3;
//       6'b001111,
//             6'b010111,
//             6'b011011,
//             6'b011101,
//             6'b011110,
//             6'b100111,
//             6'b101011,
//             6'b101101,
//             6'b101110,
//             6'b110011,
//             6'b110101,
//             6'b110110,
//             6'b111001,
//             6'b111010,
//             6'b111100 :
//       out = 4;
//       6'b011111, 6'b101111, 6'b110111, 6'b111011, 6'b111101, 6'b111110: out = 5;
//       6'b111111: out = 6;
//       default: out = 0;
//     endcase
//
// endmodule
//
// module popcount (
//     input  logic [17:0] in,
//     output logic [4:0] out
// );
//
//   // logic [2:0][2:0] a;
//   //
//   // popcount6 p0 (in[5:0], a[0]);
//   // popcount6 p1 (in[11:6], a[1]);
//   // popcount6 p2 (in[17:12], a[2]);
//   //
//   // assign out = a[0] + a[1] + a[2];
//
//   integer i;
//   always_comb begin
//       out = 0;
//       for (i = 0; i < $bits(in); i++) out = out + in[i];
//   end
// endmodule
