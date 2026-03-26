.PHONY: all program sim clean
all: ./output/gray_counter.bit
sim: ./output/gray_counter_tb.vcd
REPORTS = ./output/post_synth_power.rpt \
				  ./output/post_synth.dcp \
					./output/post_synth_clock_interaction.rpt \
					./output/post_synth_high_fanout_nets.rpt
NETLISTS = ./output/impl_netlist.v ./output/impl_netlist.edif
BITFILES = ./output/gray_counter.bin ./output/gray_counter.bit

$(REPORTS) $(NETLISTS) $(BITFILES): gray_counter.sv synth.tcl design.xdc ./output/
	vivado -mode batch -source synth.tcl -log ./output/vivado.log -nojournal

./output/:
	mkdir output

program: $(BITFILES)
	vivado -mode batch -source prog.tcl

./output/gray_counter_tb.vcd: ./xsim.dir/gray_counter_tb.simsnap/ ./output/
	xsim -R gray_counter_tb.simsnap -nolog --wdb ./output/gray_counter_tb.simsnap.wdb 
 
./xsim.dir/gray_counter_tb.simsnap/: ./xsim.dir/work/gray_counter_tb.sdb ./xsim.dir/work/gray_counter.sdb
	xelab --nolog -debug typical gray_counter gray_counter_tb -s gray_counter_tb.simsnap 

./xsim.dir/work/gray_counter_tb.sdb: gray_counter_tb.sv
	xvlog -sv -nolog gray_counter_tb.sv

./xsim.dir/work/gray_counter.sdb: gray_counter.sv
	xvlog -sv -nolog gray_counter.sv


clean:
	rm -rf output/
	rm -f clockInfo.txt xvlog*.log xvlog*.pb
	rm -rf xsim.dir
	rm -f xelab.pb
	rm -f gray_counter_tb.simsnap.wdb
	rm -f xsim*.jou
