# Makefile for use with ECE748 Project 1A
#
comp_decode_in_pkg:
	vlog -sv +incdir+../../../verification_ip/interface_packages/decode_in_pkg \
../../../verification_ip/interface_packages/decode_in_pkg/decode_in_pkg.sv \
../../../verification_ip/interface_packages/decode_in_pkg/src/decode_in_if.sv \
../../../verification_ip/interface_packages/decode_in_pkg/src/decode_in_driver_bfm.sv \
../../../verification_ip/interface_packages/decode_in_pkg/src/decode_in_monitor_bfm.sv 

comp_decode_out_pkg:
	vlog -sv +incdir+../../../verification_ip/interface_packages/decode_out_pkg \
../../../verification_ip/interface_packages/decode_out_pkg/decode_out_pkg.sv \
../../../verification_ip/interface_packages/decode_out_pkg/src/decode_out_if.sv \
../../../verification_ip/interface_packages/decode_out_pkg/src/decode_out_monitor_bfm.sv 

comp_decode_test_pkg:
	vlog -sv +incdir+../tb/tests ../tb/tests/decode_test_pkg/decode_test_pkg.sv

comp_decode_env_pkg:
	vlog -sv +incdir+../../../verification_ip/environment_packages/decode_env_pkg \
../../../verification_ip/environment_packages/decode_env_pkg/decode_env_pkg.sv \

comp_decode_LC3_pkg:
	vlog -sv +incdir+../../../verification_ip/environment_packages/lc3_prediction_pkg \
../../../verification_ip/environment_packages/lc3_prediction_pkg/lc3_prediction_pkg.sv \

comp_para_types_pkg:
	vlog -sv +incdir+../../../verification_ip/para_type_pkg ../../../verification_ip/para_type_pkg/para_type_pkg.sv

comp_decode_dut: 
	vlog -sv +incdir+../rtl/verilog ../rtl/verilog/Decode_Pipelined.v

comp_test_bench:
	vlog -sv ../tb/testbench/hdl_top.sv ../tb/testbench/hvl_top.sv 

comp_opt:
	vopt hdl_top hvl_top -o hvl_top_opt +designfile=design.bin -debug,livesim

clean:
	rm -rf work
	rm -rf *.xml
	rm -rf *.ucdb
	rm design.bin
	rm qwave.db
	rm *.log
	
# p1_debug:comp_para_types_pkg comp_decode_in_pkg comp_decode_test_pkg comp_test_bench 
# 	vsim -sv_seed 1 +UVM_TESTNAME=test_top +UVM_VERBOSITY=UVM_HIGH +notimingchecks -suppress 8887 -classdebug -uvmcontrol=all -do " coverage save -onexit test_top.ucdb; set IterationLimit 140000; set NoQuitOnFinish 1; onbreak {resume}; run 0; do wave.do; " hdl_top hvl_top

p2_debug:comp_decode_dut comp_para_types_pkg comp_decode_LC3_pkg   comp_decode_in_pkg comp_decode_out_pkg comp_decode_env_pkg comp_decode_test_pkg comp_test_bench comp_opt
	     vsim hvl_top_opt -sv_seed 1 +UVM_TESTNAME=test_top +UVM_VERBOSITY=UVM_HIGH +notimingchecks -suppress 8887 -visualizer=design.bin -qwavedb=+signal+memory+class+transaction -classdebug -uvmcontrol=all -do "set NoQuitOnFinish 1;onbreak {resume}; run -all; do wave.do; coverage save test_top.ucdb;" 