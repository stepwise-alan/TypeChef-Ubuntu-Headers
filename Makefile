OUT_DIR = out

.PHONY: all clean

all: ${OUT_DIR}/platform-ubuntu.h

${OUT_DIR}:
	mkdir out

${OUT_DIR}/platform-ubuntu.h: ${OUT_DIR}
	docker build -t typechef-ubuntu-headers .
	docker run --rm typechef-ubuntu-headers >> $@

clean:
	${RM} -r out
