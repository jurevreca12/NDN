.PHONY: all program sim clean
all: ./output/impl.bit
sim: ./output/tb.vcd
REPORTS = ./output/post_synth_power.rpt \
				  ./output/post_synth.dcp \
					./output/post_synth_clock_interaction.rpt \
					./output/post_synth_high_fanout_nets.rpt
NETLISTS = ./output/impl_netlist.v ./output/impl_netlist.edif
BITFILES = ./output/impl.bin ./output/impl.bit

SVFILES   = rgb_controller.sv rgb_controller_tb.sv pwm_controller.sv prescaler.sv #$(shell find -name "*.sv" -exec basename \{} \;)
SDBFILESX = $(SVFILES:%=./xsim.dir/work/%)
SDBFILES  = $(SDBFILESX:.sv=.sdb)
MODULES   = $(SVFILES:.sv=)

$(REPORTS) $(NETLISTS) $(BITFILES): $(SVFILES) synth.tcl design.xdc ./output/
	vivado -mode batch -source synth.tcl -log ./output/vivado.log -nojournal

./output/:
	mkdir output

program: 
	vivado -mode batch -source prog.tcl

./output/tb.vcd: ./xsim.dir/rgb_controller_tb.simsnap/ ./output/
	xsim -R rgb_controller_tb.simsnap -nolog --wdb ./output/rgb_controller_tb.simsnap.wdb 
 
./xsim.dir/rgb_controller_tb.simsnap/: $(SDBFILES)
	xelab --nolog -debug typical $(MODULES) -s rgb_controller_tb.simsnap 

./xsim.dir/work/%.sdb: %.sv
	xvlog -sv -nolog $<

clean:
	rm -rf output/
	rm -f clockInfo.txt xvlog*.log xvlog*.pb
	rm -rf xsim.dir
	rm -f xelab.pb
	rm -f *simsnap.wdb
	rm -f xsim*.jou vivado*.log vivado*.jou
