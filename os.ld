/*
 * myOS.ld
 *
 * Linker script for the i386 _start code
 */
OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(_start)
SECTIONS
{
	. = 0x7e00;
	_text_start = .;
	.text	: {*(.text*)}
	. = ALIGN(16);
	.data : {*(.data*)}
	. = ALIGN(16);

	.bss :{
		__bss_start = .;	
		*(.bss)
		__bss_end = .;
	}
	. = ALIGN(16);
	_end = .;
	. = ALIGN(512);
}
