all:
	@echo clean: removes intermediate results

clean:
	cd ref; make clean; cd ..
	cd fast1; make clean; cd ..
	cd fast2; make clean; cd ..
	cd small1; make clean; cd ..
	cd small2; make clean; cd ..

export CPGLOBAL=2

syn:
	cd ref/syn; make syn; cd ../..
	cd fast1/syn; make syn; cd ../..
	cd fast2/syn; make syn; cd ../..
	cd small1/syn; make syn; cd ../..
	cd small2/syn; make syn; cd ../..

sta:
	cd ref/sta; make sta; cd ../..
	cd fast1/sta; make sta; cd ../..
	cd fast2/sta; make sta; cd ../..
	cd small1/sta; make sta; cd ../..
	cd small2/sta; make sta; cd ../..

layout:
	cd ref/layout; make syn layout; cd ../..
	cd fast1/layout; make syn layout; cd ../..
	cd fast2/layout; make syn layout; cd ../..
	cd small1/layout; make syn layout; cd ../..
	cd small2/layout; make syn layout; cd ../..
