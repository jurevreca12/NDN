`timescale 1ns / 1ps


module top_tb();
    localparam TIMEOUT = 100000;
    
    logic clock;
    logic resetn;

    top top_inst (
        .clock       (clock),
        .resetn      (resetn), 
        .leds        (leds),
        .switches    ('0),
        .tx          (tx),
        .anode_select(anode_select),
        .segs        (segs)
    );
    
    always #1 clock = ~clock;
    
    initial begin
        $dumpfile("dump.fst");
        $dumpvars();
        clock = 1'b0;
        resetn = 1'b0;
        repeat (3) @(posedge clock);
        resetn = 1'b1;
        repeat (TIMEOUT) @(posedge clock);
        $finish;
    end
endmodule
