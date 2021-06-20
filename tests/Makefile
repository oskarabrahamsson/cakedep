CAKEDEP=../cakedep
ifndef $(POLYC)
    POLY=polyc
endif

.PHONY: clean tests

all: tests

runtests: runtests.sml
	$(POLY) $< -o $@

tests: runtests
	./runtests

clean:
	@-rm -rfv runtests
