OS=os
BOOT = boot16
BOOTOBJ= $(BOOT).o
OSOBJ=boot32.o main.o
OBJ=$(BOOTOBJ) $(OSOBJ)
BOOTLKFILE=boot.ld
OSLKFILE = os.ld

all:$(BOOT).elf $(OS).elf
	objcopy -O binary $(BOOT).elf $(BOOT).bin
	objcopy -O binary $(OS).elf $(OS).bin
	dd if=/dev/zero of=a.img bs=512 count=2880
	losetup /dev/loop4 a.img
	dd if=$(BOOT).bin of=/dev/loop4 bs=512 count=1
	dd if=$(OS).bin of=/dev/loop4 bs=512  seek=1

$(OS).elf: $(OSOBJ)
	ld -T $(OSLKFILE) -m elf_i386 $^ -o $@
$(BOOT).elf:$(BOOTOBJ)
	ld -T $(BOOTLKFILE) -m elf_i386 $^ -o $@

$(BOOTOBJ):
	gcc -c -m32 $(patsubst %.o,%.S,$@) -o $@
boot32.o:
	gcc -c -m32 $(patsubst %.o,%.S,$@) -o $@
main.o:
	gcc -c -m32 $(patsubst %.o,%.c,$@) -o $@
clean:
	rm *.o *.bin *.elf
	losetup -d /dev/loop4
	rm *.img
