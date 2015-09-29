STACK_SEG   = 0x400
STACK_START = 0x4000
VGA_SEG     = 0xb800   ## 显存的首地址是0xb8000,但是16位模式下不能直接处理，需要放到段寄存器中,右移4位得到0xb800。在问时会把段寄存器中的地址左移4位。
VGA_START   = 0xb8000  ## 显存的首地址
SCREEN_SIZE = 4000
color       = 0x07
PROTECT_DS  = 0x10     #保护模式时，数据段在gdt中的索引
PROTECT_CS  = 0x08
OS_START    = 0x7e00   #OS加载到内存中的地址
OS_SEG      = 0x7e0
SEC_NUM     = 0x07
SEC_START   = 0x02
.code16
.section ".bstext","ax"
.global bootsect_start
	.p2align 4 #对其到2的4次方字节

bootsect_start:
	cli
	movw %cs,%ax  #cs 初始化是0
	movw %ax,%ds
	movw %ax,%es
	movw $STACK_SEG,%ax
	movw %ax,%ss        #第一次建立栈 栈的地址为%ss << 4 + %sp 即0x400<<4 + 0x00
	xorw %sp,%sp

	call clear_screen

	movw $hello_message,%si #字符串的地址 ds:si
	xorw %ax,%ax
	movw %ax,%ds

	movw $VGA_SEG, %ax      #在屏幕上打印的位置 es:dx
	movw %ax,%es            #实模式下，需要把显存地址放到段寄存器中，在访问时，段寄存器右移4位刚好得到0xb8000
	movw $0x00,%dx



	call rm_print_string
	movw $switch_message,%si
	movl $(3*80),%edx
	call rm_print_string
#load os 加载操作系统
	call load_OS
switch_to_protect_model:

	lgdt gdt_addr #把gdt_addr 所指的数据加载到gdt中， 设置gdt

	movw $0x01,%ax
	lmsw %ax     #设置cr0寄存器的第一位为1，也就是切换到保护模式

	movw $PROTECT_DS, %ax  #gdt 中数据段描述符的偏移量
	movw %ax,%ds     #ds数据段描述符的段选择子 前13位为偏移量(实际使用还要右移3位)  后3位为选择gdt ldt  和特权级别
	movw %ax,%es
	movw %ax,%fs
	movw %ax,%ss
	movw %ax,%fs
	movl $STACK_START,%esp      #第二次建立栈，在保护模式下，由堆栈段寄存器作为段选择子去选择gdt中的项，选择段地址
	movl $STACK_START,%ebp      #%esp作为偏移地址

#	movl $PROTECT_CS,%eax     #设置段描述符选择子
#	movw %ax,%cs

	ljmp $PROTECT_CS,$start32              #代码段描述符选择子已设置 是调到CS:IP     不是直接使用cs，而是使用cs去索引段描述符表，获得段基$址
dead:   jmp dead

clear_screen:
	movw $VGA_SEG,%ax   #es:di目的地址
	movw %ax,%es
	xorw %di,%di
	movw $0x0000,%ax
	movw $SCREEN_SIZE,%cx  #计数
	cld                    #di 增加

	rep stosb
	ret


rm_print_string:
	movb $color,%ah
print_begin:
	lodsb
	orb %al,%al
	jz print_end
	movw %ax,%es:0(,%edx,2) #实模式下，段寄存器es的值是显存首地址左移4位，在cpu访问时，把cs<<4得到了源地址0xb8000
	incl %edx
	jmp print_begin
print_end:
	ret
load_OS:
	xorw %ax,%ax
	xorw %dx,%dx
	int  $0x13

	xorl %edi,%edi
	movb $0x02,%ah      #功能号
	movb $SEC_NUM,%al   #扇区数目
	movb $0x00,%ch      #柱面
	movb $SEC_START,%cl #扇区起始地址
	movb $0x00,%dh      #磁头
	movb $0x00,%dl      #驱动器
	movw $OS_SEG,%bx    ##es:bx 目的地址
	movw %bx,%es
	xorw %bx,%bx

	int $0x13

	ret
	.code32
start32:
	movl $(4*80),%edx
	movl $switch_ok,%esi
	call pm_print_string
	ljmp $PROTECT_CS,$0x7e00

forever:jmp forever    ##在这里停止

pm_print_string:
	movb $color,%ah
	movl $VGA_START,%ebx
pm_print_begin:
	lodsb
	orb %al,%al
	jz pm_print_end
	movw %ax,%es:0(%ebx,%edx,2)   ##和实模式不同在于，cpu访问时不是es<<4 然后加上一些东西
	incl %edx
	jmp pm_print_begin
pm_print_end:
	ret


	.section ".bsdata","a"
hello_message:
	.ascii "Hello,OS world!"
	.byte 0
switch_message:
	.ascii "We are switching to protect model!"
	.byte 0
switch_ok:
	.ascii "We are in protect model!"
	.byte 0

	.p2align 4    #对齐到2的4次方字节
gdt_addr:
	.word 0x0018-1
	.long gdt

	.p2align 4    #对齐到2的4次方字节
gdt:     #GDT描述符表的内容，每项8个字节
	.word 0,0,0,0   #第一项规定设置为全0

	#code segment
	.word 0xffff         #limit
	.word 0x0000        #base 0~15
	.byte 0x00         #base 16~23
	.byte 0x9a
	.byte 0xcf
	.byte 0x00         #base 24~31
	#data segment
	.word 0xffff         #limit
	.word 0x0000        #base 0~15
	.byte 0x00         #base 16~23
	.byte 0x92
	.byte 0xcf
	.byte 0x00         #base 24~31

	.word 0,0,0,0

	.section ".signature","a"
	.global sig
sig: .word 0xAA55



