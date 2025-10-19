module spi_loop #(
    parameter DATA_WIDTH = 8
) (
    input  logic clk,
    input  logic rst_n,
    
    // Интерфейс для передачи данных мастера
    input  logic [DATA_WIDTH-1:0] data_in_master,
    input  logic data_in_master_valid,
    output logic data_in_master_ack,
    
    // Интерфейс для приема данных мастера
    output logic [DATA_WIDTH-1:0] data_out_master,
    output logic data_out_master_valid,
    input  logic data_out_master_ack,

    // Интерфейс для передачи данных слейва
    input  logic [DATA_WIDTH-1:0] data_in_slave,
    input  logic data_in_slave_valid,
    output logic data_in_slave_ack,
    
    // Интерфейс для приема данных слейва
    output logic [DATA_WIDTH-1:0] data_out_slave,
    output logic data_out_slave_valid,
    input  logic data_out_slave_ack
);

    // Внутренние сигналы для соединения master и slave
    logic sclk;
    logic SS_n;
    logic MOSI;
    logic MISO;

    // Экземпляр SPI мастера
    spi_master #(
        .DATA_WIDTH(DATA_WIDTH)
    ) master_inst (
        .clk(clk),
        .rst_n(rst_n),
        .SS_n(SS_n),
        .data_in(data_in_master),
        .data_in_valid(data_in_master_valid),
        .data_in_ack(data_in_master_ack),
        .MISO(MISO),
        .sclk(sclk),
        .data_out(data_out_master),
        .data_out_valid(data_out_master_valid),
        .data_out_ack(data_out_master_ack),
        .MOSI(MOSI)
    );

    // Экземпляр SPI слейва
    spi_slave #(
        .DATA_WIDTH(DATA_WIDTH)
    ) slave_inst (
        .sclk(sclk),
        .rst_n(rst_n),
        .SS_n(SS_n),
        .data_in(data_in_slave),
        .data_in_valid(data_in_slave_valid),
        .data_in_ack(data_in_slave_ack),
        .MOSI(MOSI),
        .data_out(data_out_slave),
        .data_out_valid(data_out_slave_valid),
        .data_out_ack(data_out_slave_ack),
        .MISO(MISO)
    );

endmodule