.PHONY: all program clean
all: alu.bit
REPORTS = post_synth_power.rpt post_synth.dcp post_synth_clock_interaction.rpt post_synth_high_fanout_nets.rpt
NETLISTS = impl_netlist.v impl_netlist.edif
BITFILES = alu.bin alu.bit

$(REPORTS) $(NETLISTS) $(BITFILES): alu.sv synth.tcl design.xdc
	vivado -mode batch -source synth.tcl

program:
	vivado -mode batch -source prog.tcl

clean:
	rm -f $(REPORTS) $(NETLISTS) $(BITFILES)
	rm -f vivado*.jou vivado*.log
	rm -f clockInfo.txt
