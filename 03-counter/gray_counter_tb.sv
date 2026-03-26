`timescale 1ns/1ns
module gray_counter_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns

    // Signals
    logic clk;
    logic reset;
    logic [3:0] count;
		logic [3:0] prev_count;
    logic sw0;
    // Instantiate the counter module
    gray_counter #(.LIMIT(1)) uut (
        .clk(clk),
        .rst(reset),
        .up_down(sw0),
        .gray_code(count)
    );

		always_ff @(posedge clk) begin
			if (reset)
				prev_count <= 4'b0000;
			else
				prev_count <= count;
		end

    // Clock generation
    always #((CLK_PERIOD)/2) clk = ~clk;

    // Reset generation
    initial begin
        $dumpfile("./output/gray_counter_tb.vcd");
        $dumpvars;
        clk = 0;
        reset = 1;
        #((CLK_PERIOD)*2) 
        reset = 0;
        sw0 = 1;
        #((CLK_PERIOD*30)) 
        $finish;
    end

		int diff = 0;
    always @(posedge clk) begin
        $display("Count: %4b", count);
				diff = $countones(prev_count ^ count); 
				assert(diff <= 1) else $error("ERROR: prev_count: %4b, count: %4b, diff:%d", prev_count, count, diff);
    end

endmodule
