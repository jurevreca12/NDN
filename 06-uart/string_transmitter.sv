module string_transmitter(
    input logic clock,
    input logic reset,
    input logic button,
    output logic tx,
    output logic done
);

    logic [7:0] char_data [13:0];
 		logic [3:0] char_cnt; 
		logic tx_start, tx_start_r, tx_done, tx_done_r;
		logic start, finish;

		// initalize array 
		initial begin
		    char_data[0] = 8'h48; // H
		    char_data[1] = 8'h65; // e
		    char_data[2] = 8'h6C; // l
		    char_data[3] = 8'h6C; // l
		    char_data[4] = 8'h6F; // o
		    char_data[5] = 8'h20; // (space)
		    char_data[6] = 8'h57; // W
		    char_data[7] = 8'h6F; // o
		    char_data[8] = 8'h72; // r
		    char_data[9] = 8'h6C; // l
		    char_data[10] = 8'h64; // d
		    char_data[11] = 8'h21; // !
		    char_data[12] = 8'h0D; // Carriage return
		    char_data[13] = 8'h0A; // 
		end

		// state machine
		typedef enum logic  { // binary encoding
		        IDLE,
		        SEND
		} state_sender_t;	
			state_sender_t state, state_next;

		transmitter_system uart_tx (
			.clock    (clock),
			.reset    (reset),
			.tx_start (tx_start_r),
			.data_in  (char_data[char_cnt]),
			.tx       (tx),
			.tx_done  (tx_done)
		);

		always_ff @(posedge clock) begin
			if (reset)
				tx_done_r <= 1'b0;
			else
				tx_done_r <= tx_done;
		end

		assign tx_start = (((state == IDLE) && start) || 
											 ((state == SEND) && tx_done_r && ~finish));
		always_ff @(posedge clock) begin
			if (reset)
				tx_start_r <= 1'b0;
			else
				tx_start_r <= tx_start;
		end

		assign done = finish;

		always_ff @(posedge clock) begin
			if (reset)
				char_cnt <= '0;
			else if (tx_done)
				char_cnt <= char_cnt + 1'b1;
		end
		
		always_ff @(posedge clock) begin
		    if (reset)
		        state <= IDLE;
		    else 
		        state <= state_next;
		end

		always_comb begin
			start  = (state == IDLE) && button;
			finish = (state == SEND) && (char_cnt == 13);
		end
		always_comb begin
			state_next = start  ? SEND : state;
			state_next = finish ? IDLE : state_next; 
		end
endmodule
