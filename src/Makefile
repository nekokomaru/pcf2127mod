CFILES := rtc-pcf2127.c

obj-m += rtc-pcf2127-11.o
rtc-pcf2127-11-objs := $(CFILES:.c=.o)

ccflags-y += -std=gnu99 -Wall -Wno-declaration-after-statement

version=$(shell uname -r)

.PHONY: all
all:
	make -C /lib/modules/$(version)/build M=$(shell pwd) modules

.PHONY: clean
clean:
	make -C /lib/modules/$(version)/build M=$(shell pwd) clean

.PHONY: install
install:
	cp rtc-pcf2127-11.ko /lib/modules/$(version)/kernel/drivers/rtc/
	depmod -a $(version)
	cp del_pcf2127_11 /etc/initramfs-tools/hooks/del_pcf2127_11
	
