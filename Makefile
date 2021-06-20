ifndef $(CAKE)
    CAKEML=cake
endif
ifndef $(BASIS)
    BASIS=$(CAKEMLDIR)/basis/basis_ffi.c
endif
ifndef $(TARGET)
    TARGET=arm8
endif

OUTPUT=output.cml
ASMOUT=main.s

.PHONY: bootstrap clean tests

bootstrap: cakedep

cakedep: cakedep0
	./$< --verbose -o $(OUTPUT) main.cml
	$(CAKEML) --target=$(TARGET) < $(OUTPUT) > $(ASMOUT)
	$(CC) $(BASIS) $(ASMOUT) -o $@
	@-rm $(ASMOUT) $(OUTPUT)

cakedep0: $(wildcard *.cml)
	cat util.cml file.cml set.cml depgraph.cml main.cml | \
	    sed 's/^@include.*//' | \
	    $(CAKEML) --target=$(TARGET) > $(ASMOUT)
	$(CC) $(BASIS) $(ASMOUT) -o $@
	@-rm $(ASMOUT)

tests:
	$(MAKE) -C tests

clean:
	@-rm -rfv cakedep cakedep0 $(OUTPUT) $(ASMOUT)
