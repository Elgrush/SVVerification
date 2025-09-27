`timescale 1ps/1ps
module tb_bin_seg7_con;

    logic [3:0] seg_in;
    logic BI, RBI, LT;
    logic [6:0] seg_out;

    bin_seg7_con seg7 (seg_in, BI, RBI, LT, seg_out);

    logic[6:0] ar [] = {
        7'b1111110,
        7'b0110000,
        7'b1101101,
        7'b1111001,
        7'b0110011,
        7'b1011011,
        7'b1011111,
        7'b1110000,
        7'b1111111,
        7'b1111011,
        7'b1110111,
        7'b0011111,
        7'b1001110,
        7'b0111101,
        7'b1001111
    };

    logic clk;
    
    initial begin
        clk = 1'b1;
    end

    initial forever #10 clk = ~clk;

    initial begin

        $dumpfile("tb_test.vcd");
        $dumpvars(0, tb_bin_seg7_con);

        BI  = '1;
        RBI = '1;
        LT  = '1;

        for (int i = 0; i < 16; i++) begin
            seg_in = i;
            
            @(posedge clk);
            assert (seg_out == ar[i]) 
            else   $display("Failed scenatio %d: got %h, expected %h", i, seg_out, ar[i]);

        end

        seg_in = 8;

        RBI = '0;

        @(posedge clk);
        assert (seg_out == ar[8]) 
        else   $display("Failed RBI scenario not zero: got %h", seg_out);

        seg_in = 0;
        @(posedge clk);
        assert (seg_out == 0) 
        else   $display("Failed RBI scenario zero: got %h", seg_out);

        LT = '0;
        @(posedge clk);
        assert (seg_out == 7'hFF) 
        else   $display("Failed LT scenario: got %h", seg_out);

        BI = '0;
        @(posedge clk);
        assert (seg_out == 0) 
        else   $display("Failed BI scenario: got %h", seg_out);

	$display("Test finished");

        $finish;
    end

endmodule : tb_bin_seg7_con
