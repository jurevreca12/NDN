module uart_fsm #(
    parameter DATA_WIDTH = 8
) (
    input logic clock,
    input logic reset,
    input logic [DATA_WIDTH-1:0] data_in,
    input logic baud_rate_tick,
    input logic tx_start,
    output logic tx,
    output logic tx_done,
    output logic baud_rst // used for baud rate generator reset
);
		typedef enum logic [1:0] {
			IDLE,
			START,
			DATA,
			STOP
		} state_uart_t;
		state_uart_t state, next_state;

		logic [$clog2(DATA_WIDTH)-1:0] data_cnt;
		logic [DATA_WIDTH-1:0] tx_data;
		logic start_trans, end_data, end_start, end_stop;
		
		always_ff @(posedge clock) begin : tx_data_reg
			if (reset)
				tx_data <= '0;
			else if (tx_start && state == IDLE)
				tx_data <= data_in;
		end

		always_comb begin : tx_line
			if (state == START)
				tx <= 1'b0;
			else if (state == DATA)
				tx <= tx_data[data_cnt];
			else if (state == STOP)
				tx <= 1'b1;
			else
				tx <= 1'b1;
		end

		always_ff @(posedge clock) begin : data_counter
			if (reset || end_data)
				data_cnt <= '0;
			else if (state == DATA && baud_rate_tick)
				data_cnt <= data_cnt + 1'b1;
		end

		assign tx_done = end_stop;
		assign baud_rst = (state == IDLE);

		// state register
		always_ff @(posedge clock) begin : fsm_state_advance
			if (reset)
				state <= IDLE;
			else
				state <= next_state;
		end

		always_comb begin : fsm_signals
			start_trans = (state == IDLE)  && tx_start;
			end_start   = (state == START) && baud_rate_tick;
			end_stop    = (state == STOP)  && baud_rate_tick;
			end_data    = (state == DATA)  && (data_cnt == (DATA_WIDTH-1) && baud_rate_tick);
		end
		always_comb begin : fsm_transitions
			next_state = start_trans ? START : state;
			next_state = end_start   ? DATA  : next_state;
			next_state = end_data    ? STOP  : next_state;
			next_state = end_stop    ? IDLE  : next_state;
		end
endmodule
