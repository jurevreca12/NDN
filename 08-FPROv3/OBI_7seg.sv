
`define CONFIG_REG  7'h00
`define DIGITS_REG  7'h04

module OBI_7seg #(
    parameter OBI_ADDR_WIDTH = 32,
    parameter OBI_DATA_WIDTH = 32

) (
    input logic clk_i,
    input logic rstn_i,

    // ADDRESS CHANNEL
    input logic                         obi_req_i,
    output  logic                       obi_gnt_o,
    input logic [OBI_ADDR_WIDTH-1:0]    obi_addr_i,
    input logic                         obi_we_i,
    input logic [OBI_DATA_WIDTH-1:0]    obi_wdata_i,
    input logic [               3:0]    obi_be_i,

    // RESPONSE CHANNEL
    input  logic                        obi_rready_i,
    output logic                        obi_rvalid_o,
    output logic [OBI_DATA_WIDTH-1:0]   obi_rdata_o,
    output logic                        obi_err_o,

	output logic [7:0]                  anode_select,
	output logic [6:0]                  segs
);

    logic [31:0] digits;
	logic        enable_7seg;

 	logic latch_addr;
    logic [OBI_ADDR_WIDTH-1:0] latched_addr;
    logic [OBI_DATA_WIDTH-1:0] latched_wdata;
    logic                      latched_we;

	logic wr_en_cfg;
	logic wr_en_digit;

	logic addr2resp, resp2addr;
    typedef enum logic {
       ADDR,
       RESP
    } state_t;
    state_t state, next_state;


	SevSegDisplay SevSegDisplay_inst (
	    .clock        (clk_i),
	    .reset        (!rstn_i),
	    .enable_7seg  (enable_7seg),
	    .digit1       (digits[3:0]),
	    .digit2       (digits[7:4]),
	    .digit3       (digits[11:8]),
	    .digit4       (digits[15:12]),
	    .digit5       (digits[19:16]),
	    .digit6       (digits[23:20]),
	    .digit7       (digits[27:24]),
	    .digit8       (digits[31:28]),
	    .anode_select (anode_select),
	    .segs         (segs)
	);

	// OBI handshake signals — do not modify
	assign obi_gnt_o    = (state == ADDR);
    assign obi_rvalid_o = (state == RESP);
    assign obi_err_o    = 1'b0;

    always_ff @(posedge clk_i) begin
        if (!rstn_i || resp2addr) begin
          latched_addr  <= '0;
          latched_wdata <= '0;
          latched_we    <= 1'b0;
        end else if (latch_addr) begin
          latched_addr  <= obi_addr_i;
          latched_wdata <= obi_wdata_i;
          latched_we    <= obi_we_i;
        end
    end


	// WRITE LOGIC
	assign wr_en_cfg = (state == RESP) && latched_we && latched_addr[6:0] == `CONFIG_REG; 
	always_ff @(posedge clk_i) begin
		if (!rstn_i)
			enable_7seg <= 1'b0;
		else if (wr_en_cfg)
			enable_7seg <= latched_wdata[0];		
	end


    assign wr_en_digit = ((state == RESP) && latched_we && (latched_addr[6:0]  == `DIGITS_REG));
    always_ff @(posedge clk_i) begin
        if (!rstn_i)
            digits <= '0;
        else if (wr_en_digit)
            digits <= latched_wdata;
    end
	
    // READ LOGIC
    always_comb begin
        obi_rdata_o = 32'b0; // default
        if (state == RESP && !latched_we) begin
            case (latched_addr[6:0])
                `CONFIG_REG: obi_rdata_o = {31'b0, enable_7seg};
                `DIGITS_REG: obi_rdata_o = digits;
                default:    obi_rdata_o = 32'b0;
            endcase
        end
    end

  // State register
  always_ff @(posedge clk_i) begin
      if (!rstn_i) begin
          state <= ADDR;
      end else begin
          state <= next_state;
      end
  end

	always_comb begin : state_trans
		addr2resp = obi_gnt_o    && obi_req_i    && (state == ADDR);
		resp2addr = obi_rvalid_o && obi_rready_i && (state == RESP);
	end
	assign latch_addr = addr2resp;
  always_comb begin : OBI_SLAVE_next_state
        next_state = addr2resp ? RESP : state;
        next_state = resp2addr ? ADDR : next_state;
  end
  

endmodule



