# synth.tcl is a synthesis script for Vivado
# 
# run "vivado -mode batch -source synth.tcl" to get a compiled vivado design
#
#set_part xc7a750tcsg324-1
set_part xc7a100tcsg324-1
read_verilog baud_rate_generator.sv
read_verilog transmitter_system.sv
read_verilog string_transmitter.sv
read_verilog uart_fsm.sv
read_xdc     design.xdc

# Run synthesis
synth_design -top string_transmitter
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
