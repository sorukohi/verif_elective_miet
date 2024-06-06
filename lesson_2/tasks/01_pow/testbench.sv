`timescale 1ns/1ps

module testbench;

    logic        clk;
    logic [31:0] A;
    logic [31:0] B;

    pow DUT(
        .clk ( clk ),
        .a   ( A   ),
        .b   ( B   )
    );

    `include "checker.svh"

    // TODO:
    // Определите период тактового сигнала
    parameter CLK_PERIOD = 2;

    // TODO:
    // Cгенерируйте тактовый сигнал
    initial begin
        clk <= 0;
        forever begin
            // Пишите тут.
            #(CLK_PERIOD/2) clk <= ~clk;
        end
    end

    localparam SEVERAL = 5;

    initial begin

        logic [31:0] A_tmp;

        // TODO:
        // Сгенерируйте несколько чисел в интервале от 0 до 25.
        // Используйте цикл + @(posedge clk).
        for (int i = 0; i < SEVERAL; i++) begin
            @(posedge clk);
            A <= $urandom_range(0, 25);
        end


        -> done_100;

        // TODO:
        // Сгенерируйте несколько только четных чисел.
        // Используйте цикл + @(posedge clk).
        // Подумайте, как сделать число четным после рандомизации.

        for (int i = 0; i < SEVERAL; i++) begin
            A_tmp <= $urandom();
            @(posedge clk);
            A <= {A_tmp[31:1], 0};
        end

        -> done_2;

        // TODO:
        // Сгенерируйте несколько чисел чисел, которые делятся на 3
        // без остатка.
        // Используйте цикл + @(posedge clk).
        // Здесь нужно рандомизировать число, пока не выполнится
        // условие деления на 3 без остатка: <число> % 3 == 0.

        for (int i = 0; i < SEVERAL; i++) begin
            do begin
                A_tmp <= $urandom();
            end
            while(A_tmp % 3 == 0);
            @(posedge clk);
            A <= A_tmp;
        end

        -> done_3;

    end

endmodule
