DEFS := $(wildcard *.def)
IMAGES := $(DEFS:%.def=images/%.sif)
MKS := $(DEFS:%.def=%.mk)

all : downloads/checked
all : $(IMAGES)

-include $(MKS)

images/%.sif : %.def
	if [[ "$<" == remote-* ]] ; \
	then singularity build --force --remote $@ $< ; \
	else singularity build --force --no-cleanup --fakeroot $@ $< ; \
	fi

$(IMAGES) : | images

images :
	mkdir -p images

downloads/checked : links.txt fetchlinks
	./fetchlinks
	touch $@

%.mk : %.def Makefile
	sed -n -e 's#^From: \(images/.*\.sif\)#$(@:%.mk=images/%.sif) : \1#p' $< > $@
