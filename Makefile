ifndef $(CAKE)
    CAKEML=cake
endif
ifndef $(BASIS)
    BASIS=$(HOME)/dev/cakeml-git/basis/basis_ffi.c
endif
ifndef $(TARGET)
    TARGET=arm8
endif

.PHONY: bootstrap

bootstrap: cakedep

cakedep: cakedep0
	$(shell $< main.cml)
	$(CAKEML) --target=$(TARGET) < output.cml > main.s
	$(CC) $(BASIS) main.s -o $@
	@-$(RM) main.s output.cml

cakedep0: $(wildcard *.cml)
	cat util.cml file.cml set.cml depgraph.cml main.cml | \
	    sed 's/^@include.*//' | \
	    $(CAKEML) --target=$(TARGET) > main.s
	$(CC) $(BASIS) main.s -o $@
	@-$(RM) main.s

clean:
	@- rm -rfv cakedep
