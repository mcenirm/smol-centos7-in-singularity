DEFS := $(wildcard *.def)
IMAGES := $(DEFS:%.def=images/%.sif)
MKS := $(DEFS:%.def=%.mk)

all : $(IMAGES) README.md

-include $(MKS)

images/%.sif : %.def
	if [[ "$<" == remote-* ]] ; \
	then singularity build --force --remote $@ $< ; \
	else singularity build --force --fakeroot $@ $< ; \
	fi

$(IMAGES) : | images

images :
	mkdir -p images

%.mk : %.def Makefile
	sed -n -e 's#^From: \(images/.*\.sif\)#$(@:%.mk=images/%.sif) : \1#p' $< > $@

README.md : $(DEFS)
	echo '```' > $@
	du -hs images/centos-7-*.sif >> $@
	echo '```' >> $@
