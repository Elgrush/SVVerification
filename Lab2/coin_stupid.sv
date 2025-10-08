module coin (
    input  logic clk,
    input  logic rst_n,
    input  logic [3:0] coin_in,
    output logic [3:0] reserve,
    output logic [2:0] coin_out
);

typedef enum logic [0:0] {
    RECIVING_COIN,
    GIVING_COIN
} STATE;

STATE current_state, next_state;

always_ff @( posedge clk, negedge rst_n ) begin : OUTPUT_LOGIC
    if(!rst_n) begin
        reserve  <= '0;
    end else begin
        case (current_state)
            GIVING_COIN : begin
                reserve <= reserve - coin_out;
            end
            RECIVING_COIN: begin
                reserve <= reserve + coin_in;
            end
        endcase
    end
end

always_ff @( posedge clk, negedge rst_n ) begin : STATE_SWITCH
    if(!rst_n) begin
        current_state <= RECIVING_COIN;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin : STATE_PREDICTION
    next_state = RECIVING_COIN;
    if(reserve >= 3'b101) begin
        next_state = GIVING_COIN;
    end
end

always_comb begin : COIN_OUTPUT
    coin_out = '0;
    if(current_state == GIVING_COIN) begin
        coin_out = 3'b101;
    end
end

endmodule