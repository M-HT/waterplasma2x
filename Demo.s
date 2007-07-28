.arm

.global _start

.section .text

.thumb
do_effect_T:
#	push {v1, v2, v3, v4}

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

#	pop {v1, v2, v3, v4}

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
#	push {v1}

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

#	pop {v1}

	bx lr

.balign 4
#end procedure bufcopy_T

set_palette_T:
	LDR r0, =pal
	mov r1, #0
	mov r3, #64
	lsl r2, r3, #5

set_palette_T_loop1:
	str r1, [r0]
	str r1, [r0, #4]
	add r0, #8
	sub r3, r3, #2
	beq set_palette_T_after_loop1
	add r1, r2
	b set_palette_T_loop1

set_palette_T_after_loop1:
	mov r3, #64
	lsr r2, r2, #6

set_palette_T_loop2:
	str r1, [r0]
	add r0, #4
	sub r3, r3, #1
	beq set_palette_T_after_loop2
	add r1, r2
	b set_palette_T_loop2

set_palette_T_after_loop2:
	mov r3, #64
	lsr r2, r2, #5

set_palette_T_loop3:
	str r1, [r0]
	str r1, [r0, #4]
	add r0, #8
	sub r3, r3, #2
	beq set_palette_T_after_loop3
	add r1, r2
	b set_palette_T_loop3

set_palette_T_after_loop3:
	mov r3, #64

set_palette_T_loop4:
	str r1, [r0]
	add r0, #4
	sub r3, r3, #1
	bne set_palette_T_loop4

	bx lr

.balign 4
#end procedure set_palette_T

precompute_buffer_T:
	LDR r0, =buf
	mov r1, #240
	mov r3, #13
precompute_buffer_T_loop1:
	LDR r2, =320
precompute_buffer_T_loop2:
	mov v1, r1
	mul v1, r2
	mul v1, r3
	strb v1, [r0]
	add r0, r0, #1
	sub r2, r2, #1
	bne precompute_buffer_T_loop2
	sub r1, r1, #1
	bne precompute_buffer_T_loop1

	bx lr

.balign 4
#end procedure precompute_buffer_T

.arm
call_thumb:
	add ip, ip, #1
	bx ip
#end procedure call_thumb
	

_start:
#initialization
#	ldmfd sp!, {r4-r6}

	LDR r0, =p_dev_mem
	mov r1, #2
	swi 0x900005
#	LDR r1, =dev_mem
#	str r0, [r1]

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
#	LDR r1, =dev_fb0
#	str r0, [r1]

	mov r1, #0
	LDR r2, =(320*240*2)
	mov r3, #2
#	mov r4, #1
	mov r5, r0
	mov r6, #0
	stmfd sp!, {r1-r6}
	mov r0, sp
	swi 0x90005a
	add sp, sp, #0x18
	LDR r1, =frame_buf
	str r0, [r1]

#	stmfd sp!, {r4-r6}
#end initialization

#set palette
	ADR ip, set_palette_T
	bl call_thumb

#precompute buffer
	ADR ip, precompute_buffer_T
	bl call_thumb
	
	mov v5, #496
precompute_buffer_loop3:
	ADR ip, do_effect_T
	bl call_thumb
	subS v5, v5, #1
	bne precompute_buffer_loop3

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
#	LDR r0, =frame_buf
#	ldr r0, [r0]
#	LDR r1, =(320*240*2)
#	swi 0x90005b
#
#	LDR r0, =dev_fb0
#	ldr r0, [r0]
#	swi 0x900006
#	
#	LDR r0, =gp2x_memregs
#	ldr r0, [r0]
#	mov r1, #0x10000
#	swi 0x90005b
#
#	LDR r0, =dev_mem
#	ldr r0, [r0]
#	swi 0x900006
	
#end deinitialization

#exit
	mov r0, #0
	swi 0x900001
#end exit

.ltorg

.section .data
p_dev_mem:
.asciz "/dev/mem"
.balign 4
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
