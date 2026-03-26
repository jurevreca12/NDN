module gray_counter (
    input logic clk,
    input logic rst,
    input logic up_down, // Switch for up/down counting
    output logic [3:0] gray_code
);
    
    logic [26:0] prescale_count; // 27-bit binary counter to scale to 1 Hz
    logic [3:0]  binary_code_count; // 4-bit gray code counter
    logic [3:0]  gray_code_count; // 4-bit gray code counter
    localparam LIMIT = 100000000 ;


    always_ff @(posedge clk) begin 
        if(rst) begin
            binary_code_count <= 0;
            prescale_count <= 0;
        end else begin
          	prescale_count <= prescale_count + 1; // you forgot to implement the prescaler increment 
                                                 // plus blocking vs non-blocking 
            if (prescale_count == LIMIT) begin
                prescale_count <= 27'b0;
                if (up_down) begin
                    binary_code_count <= binary_code_count + 1;
                end else begin
                    binary_code_count <= binary_code_count - 1;
                end
            end
        end
    end
    
		assign gray_code_count[0] = binary_code_count[1] ^ binary_code_count[0];
		assign gray_code_count[1] = binary_code_count[2] ^ binary_code_count[1];
		assign gray_code_count[2] = binary_code_count[3] ^ binary_code_count[2];
		assign gray_code_count[3] = binary_code_count[3];
    assign gray_code = gray_code_count;    

endmodule

