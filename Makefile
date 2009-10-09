
OUTFILE=input.dll
VIMP=vimp
VIMP_CODE=Input.Vimp.boo
VIMP_DLL=Input.Vimp.dll
VIMP_DIR=src/main/import/
UNVIMP_DIR=../../..


all: vimp main test install

vimp:
	cd ${VIMP_DIR} && ${VIMP} "VoodooWarez.Systems.Input" ${VIMP_CODE} input.h
	booc -keyfile:${SNK} -o:target/${VIMP_DLL} ${VIMP_DIR}${VIMP_CODE}

main:
	#booc -r:vimp -r:ExCathedra -r:Spring.Core -r:target/${VIMP_DLL} -keyfile:${SNK} -o:target/${OUTFILE} src/main/boo/*boo  src/main/boo/Factory/*boo src/main/boo/EventDrivers/*boo
	booc -r:vimp -r:ExCathedra -r:Spring.Core -r:target/${VIMP_DLL} -keyfile:${SNK} -o:target/${OUTFILE} src/main/boo/*boo  


test:
	booc -r:target/${OUTFILE} -r:vimp -keyfile:${SNK} -o:target/test/name-device.exe src/test/testcases/*boo


install: 
	sudo gacutil -i target/${OUTFILE}
	sudo gacutil -i target/${VIMP_DLL}

clean:
	rm -f "target/${OUTFILE}" "target/${VIMP_DLL}" "target/test/name-device.exe"
