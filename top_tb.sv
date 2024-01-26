`timescale 1ns / 1ps

module top_tb ();

    localparam integer WIDTH = 8;
    // localparam integer OUT_WIDTH = $clog2(WIDTH);

    // integer seed = 12345;  // начальное значение генератора случайных чисел
    // integer trans_number = 10;  // число суммирований
    logic [WIDTH-1:0] trans_number;  // счетчик суммирований
    logic [WIDTH-1:0] trans_cnt;  // счетчик суммирований

    logic [WIDTH-1:0] i_data;
    logic [WIDTH-1:0] o_data;
    logic o_valid;
    // logic [WIDTH-1:0] out_ref;
    logic rst = 1'b1;
    logic clk = 1'b0;

    top #(
        .WIDTH   (WIDTH),
        .FIFO_LEN(2)
        // .OUT_WIDTH(OUT_WIDTH)
    ) top_i (
        .i_data(i_data),
        .o_data(o_data),
        .clk(clk),
        .rst(rst),
        .o_valid(o_valid)
    );

    always #5 clk <= ~clk;

    // удержание сигнала сброса в активном уровне в течение 3 тактов
    initial begin
        trans_number = 10;
        repeat (3) @(posedge clk);
        rst = 1'b0;
    end

    initial begin
        // ожидание снятия сброса
        @(negedge rst);

        for (trans_cnt = 0; trans_cnt < trans_number; trans_cnt = trans_cnt + 1) begin
            i_data <= trans_cnt;
            // i_data  <= $urandom(seed);
            // out_ref <= $countbits(i_data, '1);
            @(posedge clk);
            // assert (o_data === out_ref) else $error("error %x", data_o, out_ref);
        end
        $finish;
    end

    // дамп waveforms в VCD формате
    initial begin
        $dumpfile("wave_icarus.fst");
        $dumpvars(0, top_i, top_tb);
    end

    initial $monitor($stime,, trans_cnt,, rst,, clk, i_data,, o_data,, o_valid,, top_i.valid_counter);

endmodule
