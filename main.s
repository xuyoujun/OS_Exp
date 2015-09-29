	.file	"main.c"
	.globl	TASK_SIZE
	.data
	.align 4
	.type	TASK_SIZE, @object
	.size	TASK_SIZE, 4
TASK_SIZE:
	.long	4124
	.globl	ts
	.bss
	.align 64
	.type	ts, @object
	.size	ts, 41240
ts:
	.zero	41240
	.text
	.globl	clear_screen
	.type	clear_screen, @function
clear_screen:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$753664, -4(%ebp)
	movl	$0, -12(%ebp)
	jmp	.L2
.L5:
	movl	$0, -8(%ebp)
	jmp	.L3
.L4:
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	leal	0(,%eax,4), %edx
	addl	%eax, %edx
	movl	-8(%ebp), %eax
	addl	%edx, %eax
	leal	(%eax,%eax), %edx
	movl	-4(%ebp), %eax
	addl	%edx, %eax
	movw	$0, (%eax)
	addl	$1, -8(%ebp)
.L3:
	cmpl	$79, -8(%ebp)
	jle	.L4
	addl	$1, -12(%ebp)
.L2:
	cmpl	$24, -12(%ebp)
	jle	.L5
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	clear_screen, .-clear_screen
	.globl	put_char
	.type	put_char, @function
put_char:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	movb	%dl, -20(%ebp)
	movb	%al, -24(%ebp)
	movl	$753664, -4(%ebp)
	movl	16(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	20(%ebp), %eax
	addl	%edx, %eax
	leal	(%eax,%eax), %edx
	movl	-4(%ebp), %eax
	addl	%edx, %eax
	movsbw	-24(%ebp), %dx
	movzwl	%dx, %edx
	sall	$8, %edx
	movl	%edx, %ecx
	movsbw	-20(%ebp), %dx
	orl	%ecx, %edx
	movw	%dx, (%eax)
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	put_char, .-put_char
	.globl	put_str
	.type	put_str, @function
put_str:
.LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$4, %esp
	.cfi_offset 3, -12
	movl	12(%ebp), %eax
	movb	%al, -8(%ebp)
	jmp	.L8
.L11:
	cmpl	$25, 16(%ebp)
	jne	.L9
	movl	$0, 16(%ebp)
.L9:
	cmpl	$80, 20(%ebp)
	jne	.L10
	movl	$0, 20(%ebp)
	addl	$1, 16(%ebp)
.L10:
	movl	20(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, 20(%ebp)
	movsbl	-8(%ebp), %ecx
	movl	8(%ebp), %edx
	leal	1(%edx), %ebx
	movl	%ebx, 8(%ebp)
	movzbl	(%edx), %edx
	movsbl	%dl, %edx
	pushl	%eax
	pushl	16(%ebp)
	pushl	%ecx
	pushl	%edx
	call	put_char
	addl	$16, %esp
.L8:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L11
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	put_str, .-put_str
	.globl	task_create
	.type	task_create, @function
task_create:
.LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$0, -4(%ebp)
	movl	$ts+4124, -8(%ebp)
	jmp	.L13
.L16:
	movl	-8(%ebp), %eax
	movl	16(%eax), %eax
	testl	%eax, %eax
	jne	.L14
	movl	-8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	-4(%ebp), %eax
	leal	4124(%eax), %edx
	movl	-4(%ebp), %eax
	movl	%edx, (%eax)
	movl	-4(%ebp), %eax
	movl	(%eax), %eax
	leal	-4(%eax), %edx
	movl	-4(%ebp), %eax
	movl	%edx, (%eax)
	movl	-4(%ebp), %eax
	movl	(%eax), %eax
	movl	$8, (%eax)
	movl	-4(%ebp), %eax
	movl	(%eax), %eax
	leal	-4(%eax), %edx
	movl	-4(%ebp), %eax
	movl	%edx, (%eax)
	movl	-4(%ebp), %eax
	movl	(%eax), %eax
	movl	8(%ebp), %edx
	movl	%edx, (%eax)
	movl	-4(%ebp), %eax
	movl	(%eax), %eax
	leal	-4(%eax), %edx
	movl	-4(%ebp), %eax
	movl	%edx, (%eax)
	movl	-4(%ebp), %eax
	movl	(%eax), %eax
	movl	-4(%ebp), %edx
	addl	$4120, %edx
	movl	%edx, (%eax)
	jmp	.L15
.L14:
	addl	$4124, -8(%ebp)
.L13:
	cmpl	$ts+45364, -8(%ebp)
	jb	.L16
.L15:
	movl	-4(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	task_create, .-task_create
	.comm	next_p,4,4
	.comm	current_p,4,4
	.section	.rodata
.LC0:
	.string	">>>>>>>>>>>>>>>>>>>"
.LC1:
	.string	"   Hello World !   "
	.text
	.globl	myMain
	.type	myMain, @function
myMain:
.LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	$.LC0, -16(%ebp)
	movl	$.LC1, -12(%ebp)
	call	clear_screen
	pushl	$4
	pushl	$0
	pushl	$7
	pushl	-16(%ebp)
	call	put_str
	addl	$16, %esp
	pushl	$4
	pushl	$1
	pushl	$7
	pushl	-12(%ebp)
	call	put_str
	addl	$16, %esp
	pushl	$4
	pushl	$2
	pushl	$7
	pushl	-16(%ebp)
	call	put_str
	addl	$16, %esp
	movl	$ts, current_p
	pushl	$next_task
	call	task_create
	addl	$4, %esp
	movl	%eax, next_p
	movl	next_p, %edx
	movl	current_p, %eax
	subl	$8, %esp
	pushl	%edx
	pushl	%eax
	call	context_switch
	addl	$16, %esp
	pushl	$4
	pushl	$6
	pushl	$7
	pushl	-16(%ebp)
	call	put_str
	addl	$16, %esp
	pushl	$4
	pushl	$7
	pushl	$7
	pushl	-12(%ebp)
	call	put_str
	addl	$16, %esp
	pushl	$4
	pushl	$8
	pushl	$7
	pushl	-16(%ebp)
	call	put_str
	addl	$16, %esp
.L19:
	jmp	.L19
	.cfi_endproc
.LFE4:
	.size	myMain, .-myMain
	.section	.rodata
.LC2:
	.string	"<<<<<<<<<<<<<<<<<<<"
.LC3:
	.string	"In next_task"
	.text
	.globl	next_task
	.type	next_task, @function
next_task:
.LFB5:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$.LC2, -8(%ebp)
	movl	$.LC3, -4(%ebp)
	pushl	$4
	pushl	$3
	pushl	$7
	pushl	-8(%ebp)
	call	put_str
	addl	$16, %esp
	pushl	$4
	pushl	$4
	pushl	$7
	pushl	-4(%ebp)
	call	put_str
	addl	$16, %esp
	pushl	$4
	pushl	$5
	pushl	$7
	pushl	-8(%ebp)
	call	put_str
	addl	$16, %esp
.L21:
	jmp	.L21
	.cfi_endproc
.LFE5:
	.size	next_task, .-next_task
	.ident	"GCC: (Ubuntu 4.9.2-10ubuntu13) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
