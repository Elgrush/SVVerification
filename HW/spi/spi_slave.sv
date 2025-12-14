module spi_slave #(
    parameter DATA_WIDTH = 8
) (
    input  logic sclk,
    input  logic rst_n,
    input  logic SS_n,
    input  logic [DATA_WIDTH-1:0] data_in,
    input  logic data_in_valid,
    output logic data_in_ack,
    input  logic MOSI,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic data_out_valid,
    input  logic data_out_ack,
    output logic MISO
);

localparam [$clog2(DATA_WIDTH)-1:0] DATA_WIDTH_COMP = DATA_WIDTH;

logic [$clog2(DATA_WIDTH)-1:0] data_cnt;

typedef enum logic [0:0] { 
    IDLE, DATA
} STATE;

STATE current_state, next_state;

always_ff @( posedge sclk or negedge rst_n ) begin : stateControl
    if(!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

always_ff @( posedge sclk or negedge rst_n ) begin : memoryControl
    if(!rst_n) begin
        data_out_valid <= '0;
        data_cnt       <= '0;
        data_out       <= '0;
    end else begin

        if(data_out_ack) begin
            data_out_valid <= '0;
        end

        data_in_ack <= '0;

        case (current_state)
            IDLE: begin
                if(data_in_valid && ((!data_out_valid) || (data_out_ack))) begin
                    data_in_ack <= '1;
                    data_out <= data_in;
                end
                if(next_state == DATA) begin
                    data_out_valid <= '0;
                end
            end
            DATA : begin
                data_out <= {MOSI, data_out[DATA_WIDTH-1:1]};
                data_cnt <= data_cnt + 1'b1;
                if(next_state == IDLE) begin
                    data_cnt <=  '0;
                    data_out_valid <='1;
                end
            end
        endcase
    end
end

always_comb begin : stateSwitchControlBlock
    next_state = current_state;
    case (current_state)
        IDLE : begin
            if(!SS_n) begin
                next_state = DATA;
            end
        end
        DATA : begin
            if(data_cnt == DATA_WIDTH_COMP - 1'b1) begin
                next_state = IDLE;
            end
        end
    endcase
end

always_comb begin : outputPortControlBlock
    MISO = data_out[0];
end

endmodule