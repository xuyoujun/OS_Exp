#主要建立栈
###

.text
.global _start
.global myMain
.code32
_start:
	movl $build_stack_msg,%esi
	movl $15*80,%edx
	call print_string
build_stack:
	#movl $_end,%eax
	#addl $stack_size,%eax   #第3次建立栈，给OS使用,栈的最低地址在bss段的末尾
	movl TASK_SIZE,%eax #为myMain 建立栈
	addl ts,  %eax
	mov  %eax,%esp
	movl %eax,%ebp
	movl ts, %eax    #把第一个task_struct置为已用
	addl $16,%eax
	movl $1,0(%eax)
zero_bss:
	movl $__bss_start,%edi  #目的地址
	movl $_end,%ecx
	subl %edi,%ecx          #rep 重复的次数
	cld
	movb $0,%al
	rep stosb
	
	call myMain         #进入C语言写的代码

forever:jmp forever         ##死循环
.global context_switch
context_switch:              #
	pushl %ebp
	movl %esp,%ebp
	pushl %eax
	movl 8(%ebp),%eax
	movl %ebp,%ds:0(%eax)
	popl %eax

	movl 12(%ebp),%esp   ##next_p 
	movl 0(%esp),%esp    #*next_p
	popl %ebp
	ret


print_string:
	movl $0xb8000,%ebx
	movb 0x07,%ah
print_loop:
	stosb
	orb %al,%al
	jz print_end
	movw %ax,%es:0(%ebx,%edx,2)
	incl %edx
	jmp print_loop
print_end:
	ret
.data
stack_size:
	.long 0x4000    #4k
build_stack_msg:
	.ascii "We are building stack!"
	.byte 0
