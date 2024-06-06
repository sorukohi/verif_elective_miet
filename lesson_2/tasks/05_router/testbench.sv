module testbench;

    // Тактовый сигнал и сигнал сброса
    logic clk;
    logic aresetn;

    // Остальные сигналы
    logic  [3:0][1:0] sel;
    logic       [3:0] in;
    logic       [3:0] out;

    router DUT(
        .clk     ( clk     ),
        .aresetn ( aresetn ),
        .sel     ( sel     ),
        .in      ( in      ),
        .out     ( out     )
    );

    // TODO:
    // Найдите все ошибки в модуле ~router~

    // TODO:
    // Определите период тактового сигнала
    parameter CLK_PERIOD = 2;

    // TODO:
    // Cгенерируйте тактовый сигнал
    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD / 2);
            clk <= ~clk;
        end
    end
    
    // TODO:
    // Cгенерируйте сигнал сброса
    initial begin
        aresetn <= 0;
        #(CLK_PERIOD);
        aresetn <= 1;
    end

    // TODO:
    // Сгенерируйте входные сигналы
    // Не забудьте про ожидание сигнала сброса!
    initial begin
        // Входные воздействия опишите здесь.
        wait(aresetn);
        for (int i = 0; i < 4; i++) begin
            for (int j = 0; j < 64; j++) begin
                @(posedge clk);
                {sel[i], in} <= j;
            end
        end
        $stop();
    end

    // Пользуйтесь этой структурой
    typedef struct {
        logic  [3:0][1:0] sel;
        logic       [3:0] in;
        logic       [3:0] out;
    } packet;

    mailbox#(packet) mon2chk = new();

    // TODO:
    // Сохраняйте сигналы каждый положительный
    // фронт тактового сигнала
    initial begin
        packet pkt;
        wait(aresetn);
        forever begin
            @(posedge clk);
            pkt.sel = sel;
            pkt.in  = in;
            pkt.out = out;
            mon2chk.put(pkt);
        end
    end

    // TODO:
    // Выполните проверку выходных сигналов
    initial begin
        packet pkt_prev, pkt_cur;
        wait(aresetn);
        mon2chk.get(pkt_prev);
        forever begin
            mon2chk.get(pkt_cur);
            for (int i = 0; i < 4; i++) begin
                if (pkt_prev.sel[i] == pkt_prev.in[i] && pkt_cur.out[i] != pkt_prev.in[i]) $display("Time: %0t | ERROR: sel dont switch in to out: sel[%0d] = %0d, in = %0b, out = %0b",
                    $time(), i, pkt_prev.sel[i], pkt_prev.in, pkt_cur.out);
            end
            pkt_prev = pkt_cur;
        end
    end

endmodule
