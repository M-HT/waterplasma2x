.arm

.global _start

.section .text

.thumb
do_effect_T:
	push {v1, v2, v3, v4}

	LDR r0, =buf
	LDR v3, =(320*240)
	LDR v4, =320
	add r1, v4, #4

	ldrb r2, [r0]
	ldrb r3, [r0, v4]
	add v4, #1

	add v1, r2, r3

do_effect_T_loop0:

	ldrb r2, [r0, #1]
	ldrb r3, [r0, v4]

	add v2, r2, r3

	add v1, v1, v2
	lsr v1, v1, #2
	sub v1, #1

	strb v1, [r0]		@write pixel
	strb v1, [r0, v3]	@write pixel copy

	mov v1, v2

	add r0, r0, #1
	sub r1, r1, #1
	bne do_effect_T_loop0

	LDR r1, =(320*240 - 324)

do_effect_T_loop1:

	ldrb r2, [r0, #1]
	ldrb r3, [r0, v4]

	add v2, r2, r3

	add v1, v1, v2
	lsr v1, v1, #2
	sub v1, #1

	strb v1, [r0]		@write pixel

	mov v1, v2

	add r0, r0, #1
	sub r1, r1, #1
	bne do_effect_T_loop1

	pop {v1, v2, v3, v4}

	bx lr

.balign 4
#end procedure do_effect_T

wait_vsync_T:
	LDR r0, =gp2x_memregs
	LDR r1, =0x1182
	ldr r0, [r0]
	mov r3, #0x10

#wait_vsync_T_loop1:
#	ldr r2, [r0, r1]
#	tst r2, r3
#	bne wait_vsync_T_loop1

wait_vsync_T_loop2:
	ldr r2, [r0, r1]
	tst r2, r3
	beq wait_vsync_T_loop2

	bx lr

.balign 4
#end procedure wait_vsync_T

bufcopy_T:
	push {v1}

	LDR r0, =buf
	LDR r1, =frame_buf
	ldr r1, [r1]
	LDR r2, =pal
	LDR r3, =(320*240)

bufcopy_loop_T:
	ldrb v1, [r0]
	lsl v1, #2
	ldr v1, [r2, v1]
	strh v1, [r1]

	add r0, r0, #1
	add r1, r1, #2


	sub r3, r3, #1
	bne bufcopy_loop_T

	pop {v1}

	bx lr

.balign 4
#end procedure bufcopy_T

.arm
call_thumb:
	add ip, ip, #1
	bx ip
#end procedure call_thumb
	

_start:
#initialization
	ldmfd sp!, {r4-r6}

	LDR r0, =p_dev_mem
	mov r1, #2
	swi 0x900005
	LDR r1, =dev_mem
	str r0, [r1]

	mov r1, #0
	mov r2, #0x10000
	mov r3, #3
	mov r4, #1
	mov r5, r0
	mov r6, #0xc0000000
	stmfd sp!, {r1-r6}
	mov r0, sp
	swi 0x90005a
	add sp, sp, #0x18
	LDR r1, =gp2x_memregs
	str r0, [r1]


	LDR r0, =p_dev_fb0
	mov r1, #2
	swi 0x900005
	LDR r1, =dev_fb0
	str r0, [r1]

	mov r1, #0
	LDR r2, =(320*240*2)
	mov r3, #2
	mov r4, #1
	mov r5, r0
	mov r6, #0
	stmfd sp!, {r1-r6}
	mov r0, sp
	swi 0x90005a
	add sp, sp, #0x18
	LDR r1, =frame_buf
	str r0, [r1]

	stmfd sp!, {r4-r6}
#end initialization

#set palette
	LDR r0, =pal
	LDR r1, =0
	LDR r3, =64

set_palette_loop1:
	stmia r0!, {r1}
	stmia r0!, {r1}
	subS r3, r3, #2
	addne r1, r1, #0x0800
	bne set_palette_loop1

	LDR r3, =64

set_palette_loop2:
	stmia r0!, {r1}
	subS r3, r3, #1
	addne r1, r1, #0x0020
	bne set_palette_loop2

	LDR r3, =64

set_palette_loop3:
	stmia r0!, {r1}
	stmia r0!, {r1}
	subS r3, r3, #2
	addne r1, r1, #0x0001
	bne set_palette_loop3

	LDR r3, =64

set_palette_loop4:
	stmia r0!, {r1}
	subS r3, r3, #1
	bne set_palette_loop4

#end set palette

#precompute buffer
#	stmfd sp!, {v1}

	LDR r0, =buf
	LDR r1, =240
	LDR r3, =13
precompute_buffer_loop1:
	LDR r2, =320
precompute_buffer_loop2:
	mul v1, r1, r2
	mul v1, r3, v1
	strb v1, [r0]
	add r0, r0, #1
	subS r2, r2, #1
	bne precompute_buffer_loop2
	subS r1, r1, #1
	bne precompute_buffer_loop1

	LDR v1, =500
precompute_buffer_loop3:
	ADR ip, do_effect_T
	bl call_thumb
	subS v1, v1, #1
	bne precompute_buffer_loop3

#	ldmfd sp!, {v1}
#end precompute buffer


main_loop:
	ADR ip, do_effect_T
	bl call_thumb
	ADR ip, wait_vsync_T
	bl call_thumb
	ADR ip, bufcopy_T
	bl call_thumb

	LDR r0, =gp2x_memregs
	LDR r1, =0x1184
	ldr r0, [r0]
	ldr r2, [r0, r1]
	tst r2, #0x100
	bne main_loop


#deinitialization
	LDR r0, =frame_buf
	ldr r0, [r0]
	LDR r1, =(320*240*2)
	swi 0x90005b

	LDR r0, =dev_fb0
	ldr r0, [r0]
	swi 0x900006
	
	LDR r0, =gp2x_memregs
	ldr r0, [r0]
	mov r1, #0x10000
	swi 0x90005b

	LDR r0, =dev_mem
	ldr r0, [r0]
	swi 0x900006
	
#end deinitialization

#exit
	mov r0, #0
	swi 0x900001
#end exit

.ltorg

.section .data
p_dev_mem:
.asciz "/dev/mem"
.align 4
p_dev_fb0:
.asciz "/dev/fb0"

.section .bss
dev_mem:
.int 0

dev_fb0:
.int 0

gp2x_memregs:
.int 0

frame_buf:
.int 0

pal:
.rept 256
.int 0
.endr

buf:
.rept 320*240+324
.byte 0
.endr
