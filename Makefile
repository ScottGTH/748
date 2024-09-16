
run:
	qrun -64 -gui -visualizer -onfinish stop -classdebug -uvmcontrol=all -msgmode both -l run.log top.sv -do "set IterationLimit 140000; set NoQuitOnFinish 1; " +UVM_TESTNAME=test_base -debug,livesim -qwavedb=+signal+memory=1024+report+parameter+class+assertion+uvm_schematic+msg+classmemory=1024+statictaskfunc -top top


clean:
	rm certe_dump.xml
	rm design.bin
	rm -rf qrun.out
	rm -rf .visualizer
	rm qwave.db
	rm run.log
