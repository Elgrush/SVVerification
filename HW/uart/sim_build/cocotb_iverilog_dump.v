module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/uart_loop.fst");
    $dumpvars(0, uart_loop);
end
endmodule
