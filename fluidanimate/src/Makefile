PREFIX=${PARSECDIR}/fluidanimate/build/${PLATFORM}/${USAGE}
TARGET=fluidanimate

CXXFLAGS += -Wno-invalid-offsetof

all:
	$(MAKE) -f Makefile.${version} all

clean:
	$(MAKE) -f Makefile.${version} clean

install:
	mkdir -p $(PREFIX)/bin
	cp -f $(TARGET) $(PREFIX)/bin/$(TARGET)-$(VERSION)
	cp -f fluidcmp $(PREFIX)/bin/fluidcmp-$(VERSION)
