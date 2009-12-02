
OUTFILE=input.dll
VIMP=vimp
VIMP_CODE=Input.Vimp.boo
INPV_DLL=Input.Vimp.dll
VIMP_DIR=src/main/import/
VIMP_HELPER=vimp.helper.dll
UNVIMP_DIR=../../..


all: vimp main test install

vimp:
	cd ${VIMP_DIR} && ${VIMP} "VoodooWarez.Systems.Input" ${VIMP_CODE} input.h
	#booc -keyfile:${SNK} -o:target/${INPV_DLL} ${VIMP_DIR}${VIMP_CODE}
	booc -keyfile:${SNK} -r:vimp.helper -o:target/${INPV_DLL} ${VIMP_DIR}${VIMP_CODE}

main:
	#booc -r:vimp -r:ExCathedra -r:Spring.Core -r:target/${INPV_DLL} -keyfile:${SNK} -o:target/${OUTFILE} src/main/boo/*boo  src/main/boo/Factory/*boo src/main/boo/EventDrivers/*boo
	#booc -r:vimp -r:ExCathedra -r:Spring.Core -r:target/${INPV_DLL} -keyfile:${SNK} -o:target/${OUTFILE} src/main/boo/*boo  
	booc -r:ExCathedra -r:Spring.Core -r:${VIMP_HELPER} -r:target/${INPV_DLL} -keyfile:${SNK} -o:target/${OUTFILE} src/main/boo/*boo  


test:
	booc -r:target/${OUTFILE} -r:${VIMP_HELPER} -keyfile:${SNK} -o:target/test/name-device-1.exe src/test/testcases/name-device-1.boo
	booc -r:target/${OUTFILE} -r:${VIMP_HELPER} -keyfile:${SNK} -o:target/test/name-device-2.exe src/test/testcases/name-device-2.boo


install: 
	sudo gacutil -i target/${OUTFILE}
	sudo gacutil -i target/${INPV_DLL}

clean:
	rm -f "target/${OUTFILE}" "target/${INPV_DLL}" "target/test/name-device.exe"
