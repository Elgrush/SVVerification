module spi_slave #(
    parameter DATA_WIDTH = 8
) (
    input  logic sclk,
    input  logic rst_n,
    input  logic SS_n,
    input  logic [DATA_WIDTH-1:0] data_in,
    output logic send_ready,
    input  logic MOSI,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic data_valid,
    output logic MISO
);

logic [DATA_WIDTH-1:0] data_transfer;
logic parity;

logic [$clog2(DATA_WIDTH)-1:0] data_cnt;

typedef enum logic [2:0] { 
    IDLE, DATA_READ, DATA_WRITE, PARITY_READ, PARITY_WRITE
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
        send_ready     <= '1;
        data_valid     <= '0;
        data_transfer  <= '0;
        data_cnt       <= '0;
    end else begin
        send_ready <= '0;
        data_valid <= '0;

        case (current_state)
            IDLE: begin
                if(next_state == DATA_WRITE) begin
                    data_transfer <= data_in;
                end
            end
            DATA_READ : begin
                data_transfer[data_cnt] <= MOSI;

                parity <= parity^MOSI;
            end
            DATA_WRITE : begin
                parity <= parity^MISO;
            end
            PARITY_READ : begin
                parity <= '0;
                if(parity == MOSI) begin
					data_out <= data_transfer;
                    data_valid <= '1;
                end
            end
            PARITY_WRITE : begin
                parity <= '0;
                send_ready <= '1;
            end
        endcase

        if((current_state == DATA_READ) || (current_state == DATA_WRITE)) begin
            if((next_state == PARITY_READ) || (next_state == PARITY_WRITE)) begin
                data_cnt <= '0;
            end else begin
                data_cnt <= data_cnt + 1'b1;
            end
        end

    end
end

always_comb begin : stateSwitchControlBlock
    next_state = current_state;
    case (current_state)
        IDLE : begin
            if(!SS_n) begin
                if(MOSI) begin
                    next_state = DATA_WRITE;
                end else begin
                    next_state = DATA_READ;
                end
            end
        end
        DATA_READ : begin
            if(data_cnt == DATA_WIDTH - 1'b1) begin
                next_state = PARITY_READ;
            end
        end
        DATA_WRITE : begin
            if(data_cnt == DATA_WIDTH - 1'b1) begin
                next_state = PARITY_WRITE;
            end
        end
        PARITY_READ : begin
            next_state = IDLE;
        end
        PARITY_WRITE : begin
            next_state = IDLE;
        end
    endcase
end

always_comb begin : outputPortControlBlock
    MISO = '1;
    case (current_state)
        DATA_WRITE : begin
            MISO = data_transfer[data_cnt];
        end
    PARITY_WRITE : begin
            MISO = parity;
        end
    endcase
end

endmodule