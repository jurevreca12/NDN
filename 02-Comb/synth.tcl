# synth.tcl is a synthesis script for Vivado
# 
# run "vivado -mode batch -source synth.tcl" to get a compiled vivado design
#
#set_part xc7a750tcsg324-1
set_part xc7a100tcsg324-1
read_verilog alu.sv
read_xdc     design.xdc

# Run synthesis
synth_design -top alu 
write_checkpoint -force ./post_synth
report_timing_summary 
report_power -file      post_synth_power.rpt
report_clock_interaction	-file post_synth_clock_interaction.rpt -delay_type min_max
report_high_fanout_nets		-file post_synth_high_fanout_nets.rpt  \
												  -fanout_greater_than 200 \
												  -max_nets 5
write_verilog -force impl_netlist.v
write_edif    -force impl_netlist.edif

opt_design
place_design
route_design

write_bitstream -force alu.bit -bin_file
