module coin (
    input  logic clk,
    input  logic rst_n,
    input  logic [3:0] coin_in,
    output logic [3:0] reserve,
    output logic [2:0] coin_out
);

logic [3:0] reserve_next;

always_comb begin
    coin_out = '0;
    reserve_next = reserve + coin_in;
    if(reserve_next >= 3'b101) begin
        coin_out = 3'b101;
        reserve_next = reserve_next - coin_out;
    end
end

always_ff @( posedge clk, negedge rst_n ) begin : OUTPUT_LOGIC
    if(!rst_n) begin
        reserve  <= '0;
    end else begin
        reserve <= reserve_next;
    end
end

endmodule