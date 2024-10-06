sim:
	xrun tb.sv \
	../rtl/movavg.sv \
	-access +rwc \
	-top tb

simgui:
	xrun tb.sv \
	../rtl/movavg.sv \
	-access +rwc \
	+gui \
	-top tb

clean:
	rm -rf trace.vcd  xcelium.d  xrun.history  xrun.log xrun.key *~ waves.shm
