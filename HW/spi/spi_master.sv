module spi_master #(
    parameter DATA_WIDTH = 8
) (
    input  logic clk,
    input  logic rst_n,
    output logic SS_n,
    input  logic [DATA_WIDTH-1:0] data_in,
    input  logic data_in_valid,
    output logic data_in_ack,
    input  logic MISO,
    output logic sclk,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic data_out_valid,
    input  logic data_out_ack,
    output logic MOSI
);

localparam [$clog2(DATA_WIDTH)-1:0] DATA_WIDTH_COMP = DATA_WIDTH;

logic [$clog2(DATA_WIDTH)-1:0] data_cnt;

typedef enum logic [0:0] { 
    IDLE, DATA
} STATE;

STATE current_state, next_state;

always_ff @( posedge clk or negedge rst_n ) begin : stateControl
    if(!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

always_ff @( posedge clk or negedge rst_n ) begin : memoryControl
    if(!rst_n) begin
        data_in_ack    <= '0;
        data_out_valid <= '0;
        data_cnt       <= '0;
        data_out       <= '0;
    end else begin

        if(!data_in_valid) begin
            data_in_ack <= '0;
        end
        
        case (current_state)
            IDLE : begin
                if(!data_out_ack) begin
                    data_out_valid <= '0;
                end
                if(next_state == DATA) begin
                    data_out <= data_in;
                    data_out_valid <= '0;
                    data_in_ack <= '1;
                end
            end
            DATA : begin
                data_out <= {MISO, data_out[DATA_WIDTH-1:1]};
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
            if(data_in_valid && !data_in_ack && !data_out_valid) begin
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
    sclk = clk;

    MOSI = data_out[0];
    
    if(next_state==DATA) begin
        SS_n = '0;
    end else begin
        SS_n = '1;
    end
end

endmodule