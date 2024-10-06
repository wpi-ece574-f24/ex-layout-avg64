sim:
	xrun tb.v \
	../rtl/sp.v \
	../rtl/ps.v \
	../rtl/serialadd.v \
	../rtl/movavg.v \
	-access +rwc \
	-top tb

clean:
	rm -rf trace.vcd  xcelium.d  xrun.history  xrun.log xrun.key *~ waves.shm
