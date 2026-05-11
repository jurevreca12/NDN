module baud_rate_generator // General Purpose counter        
    #(parameter PRESCALER_WIDTH = 4,
      parameter LIMIT = 11)
    (
        input logic clock,
        input logic reset,
        output logic baud_rate_tick
    );

    logic [PRESCALER_WIDTH-1:0] count;
		
		always_ff @(posedge clock) begin
			if (reset || (count == LIMIT))
				count <= '0;
			else
				count <= count + 1'b1;
		end
    // when the counter reaches the limit, the sample_tick signal is generated
		assign baud_rate_tick = (count == LIMIT);
endmodule
