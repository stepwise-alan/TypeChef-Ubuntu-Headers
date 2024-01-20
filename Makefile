OUT_DIR = out
IMAGE_NAME = typechef-ubuntu-headers

.DEFAULT: all
.PHONY: all clean build

all: ${OUT_DIR}/platform-ubuntu.h ${OUT_DIR}/includes-ubuntu.tar.bz2

build:
	docker build -t ${IMAGE_NAME} .

${OUT_DIR}:
	mkdir out

${OUT_DIR}/platform-ubuntu.h: | ${OUT_DIR}
	$(MAKE) build
	docker run --rm ${IMAGE_NAME} >> $@

${OUT_DIR}/includes-ubuntu.tar.bz2: | ${OUT_DIR}
	cd ${OUT_DIR}
	${RM} -r ${OUT_DIR}/usr
	mkdir -p ${OUT_DIR}/usr/include
	mkdir -p ${OUT_DIR}/usr/lib/gcc
	$(MAKE) build
	uuid=$$(docker create ${IMAGE_NAME});\
	docker cp "$$uuid":/usr/include ${OUT_DIR}/usr;\
	docker cp "$$uuid":/usr/lib/gcc ${OUT_DIR}/usr/lib;\
	docker rm -v "$$uuid"
	mv ${OUT_DIR}/usr/include/x86_64-linux-gnu/* ${OUT_DIR}/usr/include/
	${RM} -r ${OUT_DIR}/usr/include/x86_64-linux-gnu
	${RM} ${OUT_DIR}/usr/lib/gcc/x86_64-linux-gnu/4.6.3/c*
	${RM} ${OUT_DIR}/usr/lib/gcc/x86_64-linux-gnu/4.6.3/l*
	cd ${OUT_DIR} && tar cjf $(notdir $@) usr/*
	${RM} -r ${OUT_DIR}/usr

clean:
	${RM} -r out
