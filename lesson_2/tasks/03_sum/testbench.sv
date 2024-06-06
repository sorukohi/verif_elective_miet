module testbench;

    // Тактовый сигнал и сигнал сброса
    logic clk;
    logic aresetn;

    // Остальные сигналы
    logic [7:0] A;
    logic [7:0] B;
    logic [7:0] C;

    sum DUT (
        .clk     ( clk     ),
        .aresetn ( aresetn ),
        .a       ( A       ),
        .b       ( B       ),
        .c       ( C       )
    );

    // TODO:
    // Определите период тактового сигнала
    parameter CLK_PERIOD = 2;// ?;

    // TODO:
    // Cгенерируйте тактовый сигнал
    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD / 2) clk <= ~clk;
            // Пишите тут.
        end
    end
    
    // Генерация сигнала сброса
    initial begin
        aresetn <= 0;
        #(CLK_PERIOD);
        aresetn <= 1;
    end

    // TODO:
    // Cгенерируйте входные воздействия и проверки
    // в соответствии с диаграммой.

    //                |10ns-|
    //           __   |__   |__    __    __    __    __    
    // clk     _|  |__|  |__|  |__|  |__|  |__|  |__|  |__|
    //              __|_____|_____|_____|_____|_____|_____|
    // aresetn ____|  |     |     |     |     |     |     |
    //                |     |     |     |     |     |     |
    // A       <XXXXX>|<2-->|<20--+---->|<4-->|<40->|<2---|
    // B       <XXXXX>|<3-->|<30--+---->|<5-->|<50->|<1---|
    // C       <0---->|<XXX>|<5-->|<50--+---->|<9-->|<90--|
    //                |     |     |     |
    //               15ns  25ns  35ns  45ns ...

    initial begin
        // Входные воздействия опишите здесь.
        // Не забудьте про ожидание сигнала сброса!
        
        wait(aresetn);

        @(posedge clk);
        A <= 2;
        B <= 3;
        @(posedge clk);
        A <= 20;
        B <= 30;
        @(posedge clk);
        @(posedge clk);
        A <= 4;
        B <= 5;
        @(posedge clk);
        A <= 40;
        B <= 50;
        @(posedge clk);
        A <= 2;
        B <= 1;

    end

    int errors_amount = 0;

    initial begin
        // Проверки опишите здесь.
        // Не забудьте про ожидание сигнала сброса!

        wait(aresetn);

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);         
        if (C !== 5) begin 
            $display("Time = %t: POOPER!!! Real C = %d, Expected = %d", $time(), C, 5); 
            errors_amount++;
        end

        @(posedge clk);        
        if (C !== 50) begin
            $display("Time = %t: POOPER!!! Real C = %d, Expected = %d", $time(), C, 50);
            errors_amount++;
        end

        @(posedge clk);
        @(posedge clk);        
        if (C !== 9) begin
            $display("Time = %t: POOPER!!! Real C = %d, Expected = %d", $time(), C, 9);
            errors_amount++;
        end
        
        @(posedge clk);        
        if (C !== 90) begin
            $display("Time = %t: POOPER!!! Real C = %d, Expected = %d", $time(), C, 90);
            errors_amount++;
        end

        @(posedge clk);        
        if (C !== 3) begin
            $display("Time = %t: POOPER!!! Real C = %d, Expected = %d", $time(), C, 3);
            errors_amount++;
        end

        if (errors_amount == 0) begin
            $display("GOOD!!!");
            $finish();
        end else begin
            $display("BAD!!! %d ERRORS", errors_amount);
            $finish();
        end
    end

endmodule
