module coin (
    input  logic clk,
    input  logic rst_n,
    input  logic [3:0] coin_in,
    output logic [3:0] reserve,
    output logic [2:0] coin_out
);

always_ff @( posedge clk, negedge rst_n ) begin : OUTPUT_LOGIC
    if(!rst_n) begin
        reserve  <= '0;
    end else begin
        reserve <= reserve + coin_in;
        coin_out <= '0;
        if(reserve + coin_in >= 3'b101) begin
            reserve <= reserve + coin_in - 3'b101;
            coin_out <= 3'b101;
        end
    end
end

endmodule