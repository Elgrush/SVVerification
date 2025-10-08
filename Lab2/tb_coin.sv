`timescale 1ps/1ps
module tb_coin;

    logic [3:0] coin_in;
    logic [2:0] coin_out;
    logic [2:0] reserve;

    coin coin_instance (
        .clk(clk),
        .rst_n(rst_n),
        .coin_in(coin_in),
        .coin_out(coin_out),
        .reserve(reserve)
        );

    logic[4:0] ar [] = {
        5,
        5,
        2,
        1,
        1,
        2,
        10
    };

    logic clk;
    logic rst_n;

    int ref_reserve;
    int ref_coin_out;
    
    initial begin
        clk = 1'b1;
    end

    initial forever #10 clk = ~clk;

    initial begin

        $dumpfile("tb_test.vcd");
        $dumpvars(0, tb_coin);

        rst_n  = '0;

        @(posedge clk);
        rst_n = '1;

        for (int i = 0; i < $size(ar); i++) begin
            coin_in = ar[i];

            ref_reserve = ref_reserve + coin_in;
            if (ref_reserve >= 5) begin
                ref_coin_out = 5;
                ref_reserve = ref_reserve - 3'b101;
            end else begin
                ref_coin_out = 0;
            end
            
            @(posedge clk);

            assert (ref_coin_out == coin_out)
            else   $display("Failed assert coin_out of coin %d: %d != %d", i, coin_out, ref_coin_out); 
            assert (ref_reserve  == reserve) 
            else   $display("Failed assert reserve of coin %d: %d != %d", i, reserve, ref_reserve); 

        end

	    $display("Test finished");

        $finish;
    end

endmodule : tb_coin

