
OUTFILE=input.dll
VIMP=vimp
VIMP_CODE=Input.Vimp.boo
INPV_DLL=input.vimp.dll
VIMP_DIR=src/main/import/
VIMP_HELPER=vimp.helper.dll
UNVIMP_DIR=../../..
BOOC_OPTS=-debug


all: vimp main test

vimp:
	cd ${VIMP_DIR} && ${VIMP} "VoodooWarez.Systems.Input" ${VIMP_CODE} input.h
	#booc -keyfile:${SNK} -o:target/${INPV_DLL} ${VIMP_DIR}${VIMP_CODE}
	booc ${BOOC_OPTS} -keyfile:${SNK} -r:vimp.helper -o:target/${INPV_DLL} ${VIMP_DIR}${VIMP_CODE}

main:
	#booc -r:vimp -r:ExCathedra -r:Spring.Core -r:target/${INPV_DLL} -keyfile:${SNK} -o:target/${OUTFILE} src/main/boo/*boo  src/main/boo/Factory/*boo src/main/boo/EventDrivers/*boo
	#booc -r:vimp -r:ExCathedra -r:Spring.Core -r:target/${INPV_DLL} -keyfile:${SNK} -o:target/${OUTFILE} src/main/boo/*boo  
	booc ${BOOC_OPTS} -r:ExCathedra -r:Spring.Core -r:${VIMP_HELPER} -r:target/${INPV_DLL} -keyfile:${SNK} -o:target/${OUTFILE} src/main/boo/*boo  


test:
	booc ${BOOC_OPTS} -r:target/${OUTFILE} -r:${VIMP_HELPER} -keyfile:${SNK} -o:target/test/name-device-1.exe src/test/testcases/name-device-1.boo
	booc ${BOOC_OPTS} -r:target/${OUTFILE} -r:${VIMP_HELPER} -keyfile:${SNK} -o:target/test/name-device-2.exe src/test/testcases/name-device-2.boo
	booc ${BOOC_OPTS} -r:target/${OUTFILE} -r:${VIMP_HELPER} -keyfile:${SNK} -r:${INPV_DLL} -o:target/test/device-event-1.exe src/test/testcases/device-event-1.boo


install: all
	sudo gacutil -i target/${OUTFILE}
	sudo gacutil -i target/${INPV_DLL}

clean:
	rm -f "target/${OUTFILE}" "target/${INPV_DLL}" "target/test/name-device.exe"
