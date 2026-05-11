module transmitter_system(
    input logic clock,
    input logic reset,
    input logic tx_start,
    input logic [7:0] data_in,
    output logic tx,
    output logic tx_done
);

    logic baud_rate_tick;
    logic baud_rst;
    logic local_reset;

    
    assign local_reset = reset | baud_rst;

    baud_rate_generator #(
        .PRESCALER_WIDTH(15),
        .LIMIT(5209)
    ) baud_rate_generator_inst (
        .clock(clock),
        .reset(local_reset),
        .baud_rate_tick(baud_rate_tick)
    );

    uart_fsm #(
        .DATA_WIDTH(8)
    ) uart_fsm_inst (
        .clock(clock),
        .reset(reset),
        .data_in(data_in),
        .baud_rate_tick(baud_rate_tick),
        .tx_start(tx_start),
        .tx(tx),
        .tx_done(tx_done),
        .baud_rst(baud_rst)
    );


endmodule

