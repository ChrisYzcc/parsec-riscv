PREFIX		:= ${PARSECDIR}/facesim/build/${PLATFORM}
BINARY		:= facesim

ifdef version
	ifeq "$(version)" "pthreads"
		CXXFLAGS+=-DENABLE_PTHREADS	
	endif

	ifeq "$(version)" "serial"
		CXXFLAGS+=-DNEW_SERIAL_IMPLEMENTATIOM	
	endif
endif

all:
	$(MAKE) -C TaskQ/lib all -j$(nproc)
	$(MAKE) -C Benchmarks/facesim -j$(nproc)

install:
	mkdir -p $(PREFIX)/bin
	cp -f Benchmarks/facesim/$(BINARY) $(PREFIX)/bin/$(BINARY)-$(VERSION)

