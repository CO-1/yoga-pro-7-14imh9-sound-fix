PACKAGE_NAME = yoga-pro-7-14imh9-sound-fix

ifeq ($(origin KERNELRELEASE), undefined)
  KERNELRELEASE := $(shell uname -r)
endif

KERNELVER := $(word 1, $(word 1, $(subst -, ,$(KERNELRELEASE))))
ifeq ($(word 3, $(subst ., ,$(KERNELVER))), 0)
  KERNELVER := $(KERNELVER:.0=)
endif

obj-m += snd-hda-codec-realtek.o

snd-hda-codec-realtek-objs := sound/pci/hda/patch_realtek.o

.PHONY: all download install uninstall
all:
	$(MAKE) -C /lib/modules/$(KERNELRELEASE)/build M=$(shell pwd) modules

clean:
	$(MAKE) -C /lib/modules/$(KERNELRELEASE)/build M=$(shell pwd) clean

download:
	@mkdir -p sound/pci/hda
	wget -q -O sound/pci/hda/patch_realtek.c "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/sound/pci/hda/patch_realtek.c?h=v$(KERNELVER)"
	wget -q -O sound/pci/hda/hda_local.h "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/sound/pci/hda/hda_local.h?h=v$(KERNELVER)"
	wget -q -O sound/pci/hda/hda_auto_parser.h "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/sound/pci/hda/hda_auto_parser.h?h=v$(KERNELVER)"
	wget -q -O sound/pci/hda/hda_jack.h "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/sound/pci/hda/hda_jack.h?h=v$(KERNELVER)"
	wget -q -O sound/pci/hda/hda_generic.h "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/sound/pci/hda/hda_generic.h?h=v$(KERNELVER)"
	wget -q -O sound/pci/hda/hda_component.h "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/sound/pci/hda/hda_component.h?h=v$(KERNELVER)"
	wget -q -O sound/pci/hda/thinkpad_helper.c "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/sound/pci/hda/thinkpad_helper.c?h=v$(KERNELVER)"
	wget -q -O sound/pci/hda/hp_x360_helper.c "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/sound/pci/hda/hp_x360_helper.c?h=v$(KERNELVER)"
	wget -q -O sound/pci/hda/ideapad_s740_helper.c "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/sound/pci/hda/ideapad_s740_helper.c?h=v$(KERNELVER)"

#	update dkms.conf to use proper patch for downloaded kernerl version
	patch --dry-run -s -p 1 -i patches/realtek-quirk-v6.8-for-lenovo-yoga-pro-7-14IMH9.patch && \
	 sed 's/realtek-quirk-v6\.[0-9]\+-/realtek-quirk-v6.8-/' -i dkms.conf || \
	 sed 's/realtek-quirk-v6\.[0-9]\+-/realtek-quirk-v6.9-/' -i dkms.conf

install:
	@test -f sound/pci/hda/patch_realtek.c || make download
	sudo dkms install .

uninstall:
	dkms remove $(PACKAGE_NAME)/1.0 && rm -rf /usr/src/$(PACKAGE_NAME)-1.0