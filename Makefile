MOONC= moonc
RM= rm -f
SOURCES= $(wildcard *.moon */*.moon */*/*.moon)
TARGETS= $(SOURCES:.moon=.lua)

################################################################################
.PHONY: clean

all: $(TARGETS)

clean:
	$(RM) $(TARGETS)

%.lua: %.moon
	$(MOONC) $<
