module string_transmitter_tb;
	logic clock;
	logic reset;
	logic button;
	logic tx;
	logic done;

	string_transmitter dut (
		.clock (clock),
		.reset (reset),
		.button(button),
		.tx    (tx),
		.done  (done)
	);

	initial begin
		clock = 1'b0;
		forever #5 clock = ~clock;
	end

	initial begin
		$dumpfile("output/tb.vcd");
		$dumpvars;
		reset = 1'b1;
		button = 1'b0;
		repeat (2) @(posedge clock);
		reset = 1'b0;
		repeat (1) @(posedge clock);
		button = 1'b1;
		repeat (1) @(posedge clock);
		button = 1'b0;
		wait(done);
		repeat (10) @(posedge clock);
		$finish;
	end
endmodule
