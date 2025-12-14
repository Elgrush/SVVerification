module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/spi_loop.fst");
    $dumpvars(0, spi_loop);
end
endmodule
