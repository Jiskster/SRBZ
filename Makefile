.PHONY: build run buildrun dualrun builddualrun

build:
	rm -f ../build.pk3
	cd src; zip -r9 ../build.pk3 *

run:
	cd ~/.srb2/; ./lsdl2srb2 $(SRB2OPT) -file $(CURDIR)/build.pk3

buildrun: build run

dualrun:
	cd ~/.srb2/; ./lsdl2srb2 $(SRB2OPT) -server -file $(CURDIR)/build.pk3 & ./lsdl2srb2 $(SRB2OPT) -connect localhost -file $(CURDIR)/build.pk3

builddualrun: build dualrun