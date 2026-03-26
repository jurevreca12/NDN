module alu (
  input logic [5:0] a,
  input  logic [5:0] b,
  input logic [2:0] alu_control,
  output logic [5:0] c
  );

  logic [5:0] sum, sub, eq, and_gate, or_gate, xor_gate;

  assign sum = a + b;
  assign sub = a - b;
  assign eq = a == b;
  assign and_gate = a & b;
  assign or_gate = a | b;
  assign xor_gate = a ^ b ;

  assign c =  (alu_control == 3'b000) ? sum :
              (alu_control == 3'b001) ? sub :
              (alu_control == 3'b010) ? eq :
              (alu_control == 3'b011) ? and_gate :
              (alu_control == 3'b100) ? or_gate :
              (alu_control == 3'b101) ? xor_gate :
              (alu_control == 3'b110) ? b :
              (alu_control == 3'b111) ? a :
              6'b000000; // Default case 
      
endmodule