# synth.tcl is a synthesis script for Vivado
# 
# run "vivado -mode batch -source synth.tcl" to get a compiled vivado design
#
#set_part xc7a750tcsg324-1
set_part xc7a100tcsg324-1
read_verilog anode_assert.sv
read_verilog counter_1s.sv
read_verilog digits_to_segments.sv
read_verilog SevSegDisplay.sv
read_verilog timer_002s.sv
read_verilog top.sv
read_verilog value_to_digit.sv
read_xdc     design.xdc

# Run synthesis
synth_design -top top
report_timing_summary    -file ./output/post_synth_timing_summary.rpt
report_power             -file ./output/post_synth_power.rpt
report_clock_interaction -file ./output/post_synth_clock_interaction.rpt -delay_type min_max
report_high_fanout_nets	 -file ./output/post_synth_high_fanout_nets.rpt -fanout_greater_than 200 -max_nets 5
write_verilog -force ./output/impl_netlist.v
write_edif    -force ./output/impl_netlist.edif

opt_design
place_design
route_design

write_bitstream -force ./output/impl.bit -bin_file
