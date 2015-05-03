@@
@@  Copyright (C) 2007-2015 Roman Pauer
@@
@@  Permission is hereby granted, free of charge, to any person obtaining a copy of
@@  this software and associated documentation files (the "Software"), to deal in
@@  the Software without restriction, including without limitation the rights to
@@  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
@@  of the Software, and to permit persons to whom the Software is furnished to do
@@  so, subject to the following conditions:
@@
@@  The above copyright notice and this permission notice shall be included in all
@@  copies or substantial portions of the Software.
@@
@@  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
@@  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
@@  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
@@  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
@@  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
@@  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
@@  SOFTWARE.
@@

.arm

.global _start

.section .text

.thumb
do_effect_T:
#	push {v1, v2, v3, v4}

	LDR r0, =buf
	LDR v3, =(320*240)
	LDR v4, =320
	add r1, v4, #1

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

	LDR r1, =(320*240 - 321)

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

do_effect2_T:
#	push {v1, v2, v3, v4}

	LDR r0, =buf
	LDR v3, =(320*240)
	LDR v4, =320

	mov r2, #2

do_effect2_T_loop0:
	mov r1, v4
	add r3, v4, v4
	sub r3, #1
	ldrb v1, [r0, r3]
	add r3, r3, v4
	ldrb r3, [r0, r3]

	add v1, v1, r3

do_effect2_T_loop01:

	ldrb v2, [r0]
	ldrb r3, [r0, v4]

	add v2, v2, r3

	add v1, v1, v2
	lsr v1, v1, #2
	sub v1, #1

	strb v1, [r0]		@write pixel
	strb v1, [r0, v3]	@write pixel copy

	mov v1, v2

	add r0, r0, #1
	sub r1, r1, #1
	bne do_effect2_T_loop01
	sub r2, r2, #1
	bne do_effect2_T_loop0

	mov r2, #238

do_effect2_T_loop1:
	mov r1, v4
	add r3, v4, v4
	sub r3, #1
	ldrb v1, [r0, r3]
	add r3, r3, v4
	ldrb r3, [r0, r3]

	add v1, v1, r3

do_effect2_T_loop11:

	ldrb v2, [r0]
	ldrb r3, [r0, v4]

	add v2, v2, r3

	add v1, v1, v2
	lsr v1, v1, #2
	sub v1, #1

	strb v1, [r0]		@write pixel

	mov v1, v2

	add r0, r0, #1
	sub r1, r1, #1
	bne do_effect2_T_loop11
	sub r2, r2, #1
	bne do_effect2_T_loop1

#	pop {v1, v2, v3, v4}

	bx lr

.balign 4
#end procedure do_effect2_T

do_effect3_T:
#	push {v1, v2, v3, v4}

	LDR r0, =(buf + 320*240 - 1)
	LDR v3, =(-(320*240))
	LDR v4, =(-320)
	neg r1, v4
	add r1, r1, #1

	ldrb r2, [r0]
	ldrb r3, [r0, v4]
	sub r0, #1

	add v1, r2, r3

do_effect3_T_loop0:

	ldrb r2, [r0]
	ldrb r3, [r0, v4]

	add v2, r2, r3

	add v1, v1, v2
	lsr v1, v1, #2
	sub v1, #1

	strb v1, [r0, #1]	@write pixel
	strb v1, [r0, v3]	@write pixel copy

	mov v1, v2

	sub r0, r0, #1
	sub r1, r1, #1
	bne do_effect3_T_loop0

	LDR r1, =(320*240 - 321)

do_effect3_T_loop1:

	ldrb r2, [r0]
	ldrb r3, [r0, v4]

	add v2, r2, r3

	add v1, v1, v2
	lsr v1, v1, #2
	sub v1, #1

	strb v1, [r0, #1]	@write pixel

	mov v1, v2

	sub r0, r0, #1
	sub r1, r1, #1
	bne do_effect3_T_loop1

#	pop {v1, v2, v3, v4}

	bx lr

.balign 4
#end procedure do_effect3_T

do_effect4_T:
#	push {v1, v2, v3, v4}

	LDR r0, =(buf + 320*240 - 1)
	LDR v3, =(-(320*240))
	LDR v4, =(-320)

	mov r2, #2

do_effect4_T_loop0:
	neg r1, v4
	add r3, v4, #1
	ldrb v1, [r0, r3]
	add r3, r3, v4
	ldrb r3, [r0, r3]

	add v1, v1, r3

do_effect4_T_loop01:

	ldrb v2, [r0]
	ldrb r3, [r0, v4]

	add v2, v2, r3

	add v1, v1, v2
	lsr v1, v1, #2
	sub v1, #1

	strb v1, [r0]		@write pixel
	strb v1, [r0, v3]	@write pixel copy

	mov v1, v2

	sub r0, r0, #1
	sub r1, r1, #1
	bne do_effect4_T_loop01
	sub r2, r2, #1
	bne do_effect4_T_loop0

	mov r2, #238

do_effect4_T_loop1:
	neg r1, v4
	add r3, v4, #1
	ldrb v1, [r0, r3]
	add r3, r3, v4
	ldrb r3, [r0, r3]

	add v1, v1, r3

do_effect4_T_loop11:

	ldrb v2, [r0]
	ldrb r3, [r0, v4]

	add v2, v2, r3

	add v1, v1, v2
	lsr v1, v1, #2
	sub v1, #1

	strb v1, [r0]		@write pixel

	mov v1, v2

	sub r0, r0, #1
	sub r1, r1, #1
	bne do_effect4_T_loop11
	sub r2, r2, #1
	bne do_effect4_T_loop1

#	pop {v1, v2, v3, v4}

	bx lr

.balign 4
#end procedure do_effect4_T

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

# red palette (full)
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

set_palette_T_loop2:
	str r1, [r0]
	add r0, #4
	sub r3, r3, #1
	beq set_palette_T_after_loop2
	add r1, #32
	b set_palette_T_loop2

set_palette_T_after_loop2:
	mov r3, #64

set_palette_T_loop3:
	str r1, [r0]
	str r1, [r0, #4]
	add r0, #8
	sub r3, r3, #2
	beq set_palette_T_after_loop3
	add r1, #1
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

# green palette (partial - 4th quarter is the same as in red and blue palette, 3d quarter is the same as in red palette)
set_paletteG_T:
	LDR r0, =pal
	mov r1, #0
	mov r3, #64
	lsl r2, r3, #5

set_paletteG_T_loop1:
	str r1, [r0]
	add r0, #4
	sub r3, r3, #1
	beq set_paletteG_T_after_loop1
	add r1, #32
	b set_paletteG_T_loop1

set_paletteG_T_after_loop1:
	mov r3, #64

set_paletteG_T_loop2:
	str r1, [r0]
	str r1, [r0, #4]
	add r0, #8
	sub r3, r3, #2
	beq set_paletteG_T_after_loop2
	add r1, r2
	b set_paletteG_T_loop2

set_paletteG_T_after_loop2:
#	mov r3, #64
#
#set_paletteG_T_loop3:
#	str r1, [r0]
#	str r1, [r0, #4]
#	add r0, #8
#	sub r3, r3, #2
#	beq set_paletteG_T_after_loop3
#	add r1, #1
#	b set_paletteG_T_loop3
#
#set_paletteG_T_after_loop3:
#	mov r3, #64
#
#set_paletteG_T_loop4:
#	str r1, [r0]
#	add r0, #4
#	sub r3, r3, #1
#	bne set_paletteG_T_loop4

	bx lr

.balign 4
#end procedure set_paletteG_T

# blue palette (partial - 4th quarter is the same as in red and green palette)
set_paletteB_T:
	LDR r0, =pal
	mov r1, #0
	mov r3, #64
	lsl r2, r3, #5

set_paletteB_T_loop1:
	str r1, [r0]
	str r1, [r0, #4]
	add r0, #8
	sub r3, r3, #2
	beq set_paletteB_T_after_loop1
	add r1, #1
	b set_paletteB_T_loop1

set_paletteB_T_after_loop1:
	mov r3, #64

set_paletteB_T_loop2:
	str r1, [r0]
	add r0, #4
	sub r3, r3, #1
	beq set_paletteB_T_after_loop2
	add r1, #32
	b set_paletteB_T_loop2

set_paletteB_T_after_loop2:
	mov r3, #64

set_paletteB_T_loop3:
	str r1, [r0]
	str r1, [r0, #4]
	add r0, #8
	sub r3, r3, #2
	beq set_paletteB_T_after_loop3
	add r1, r2
	b set_paletteB_T_loop3

set_paletteB_T_after_loop3:
#	mov r3, #64
#
#set_paletteB_T_loop4:
#	str r1, [r0]
#	add r0, #4
#	sub r3, r3, #1
#	bne set_paletteB_T_loop4

	bx lr

.balign 4
#end procedure set_paletteB_T

# gray palette (full)
set_paletteW_T:
	LDR r0, =pal
	mov r1, #0
	mov r3, #128
	lsl r2, r3, #4

set_paletteW_T_loop1:
	str r1, [r0]
	str r1, [r0, #4]
	add r1, #32
	str r1, [r0, #8]
	str r1, [r0, #12]
	add r0, #16
	sub r3, #4
	beq set_paletteW_T_after_loop1
	add r1, #33
	add r1, r2
	b set_paletteW_T_loop1

set_paletteW_T_after_loop1:
	mov r3, #128

set_paletteW_T_loop2:
	str r1, [r0]
	add r0, #4
	sub r3, r3, #1
	bne set_paletteW_T_loop2

	bx lr

.balign 4
#end procedure set_paletteW_T

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

.ltorg

effect_jump_table:
.int do_effect_T
.int do_effect2_T
.int do_effect3_T
.int do_effect4_T

palette_jump_table:
.int set_palette_T
.int set_paletteG_T
.int set_paletteB_T
.int set_paletteW_T

.arm
call_thumb:
	add ip, ip, #1
	bx ip
#end procedure call_thumb

draw_tail:
	LDR v1, =x_delta
	mov v4, #4

draw_tail_loop:
	ldrsb r0, [v1]
	ldrsh r1, [v1, #1]
	ldrsh r3, [v1, #3]
	ldrsb r2, [v1, #5]

	add r1, r1, r0
	add r3, r3, r2

	strh r1, [v1, #1]
	strh r3, [v1, #3]

	cmp r1, #40*16
	ble draw_tail_x_delta_change

	cmp r1, #280*16
	blt draw_tail_x_delta_no_change

draw_tail_x_delta_change:
	rsb r0, r0, #0
	strb r0, [v1]

draw_tail_x_delta_no_change:

	cmp r3, #40*16
	ble draw_tail_y_delta_change

	cmp r3, #200*16
	blt draw_tail_y_delta_no_change

draw_tail_y_delta_change:
	rsb r2, r2, #0
	strb r2, [v1, #5]

draw_tail_y_delta_no_change:

	mov r2, #320
	mov r3, r3, lsr #4
	mul r0, r2, r3
	add r0, r0, r1, lsr #4
	LDR v2, =buf
	add v2, v2, r0

	mov r0, #255
	strb r0, [v2]
	strb r0, [v2, #1]
	strb r0, [v2, #320]
	strb r0, [v2, #-1]
	strb r0, [v2, #-320]

	strb r0, [v2, #2]
	strb r0, [v2, #640]
	strb r0, [v2, #-2]
	strb r0, [v2, #-640]

	add v1, v1, #6
	subS v4, v4, #1
	bne draw_tail_loop

	mov pc, lr
#end procedure precompute_buffer_T

_start:
#initialization
#	ldmfd sp!, {r4-r6}

	LDR r0, =p_dev_mem
	mov r1, #2
	swi 0x900005
#	LDR r7, =dev_mem
#	str r0, [r7]

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
	LDR r7, =gp2x_memregs
	str r0, [r7]


	LDR r0, =p_dev_fb0
	mov r1, #2
	swi 0x900005
#	LDR r7, =dev_fb0
#	str r0, [r7]

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
	LDR r7, =frame_buf
	str r0, [r7]

#	stmfd sp!, {r4-r6}
#end initialization

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

	mov v5, #97	@
	mov v6, #0	@ effect jump table offset
	mov v7, #1	@
	mov v8, #0	@ palette jump table offset

main_loop:
	LDR ip, =effect_jump_table
	ldr ip, [ip, v6]
	bl call_thumb

	subS v7, v7, #1
	bne main_loop_after_pallette_change

	mov v7, #192
	LDR r0, =palette_jump_table

	ldr ip, [r0, v8]
	bl call_thumb

	add v8, v8, #4
	and v8, v8, #15

main_loop_after_pallette_change:

	subS v5, v5, #1
	bne main_loop_after_effect_change

	mov v5, #256

	add v6, v6, #4
	and v6, v6, #15

main_loop_after_effect_change:

	bl draw_tail

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
x_delta:
.byte 7+16
x_pos:
.hword 170*16
y_pos:
.hword 110*16
y_delta:
.byte -11-16

.byte -13-16
.hword 140*16
.hword 100*16
.byte -7-16

.byte -5-16
.hword 130*16
.hword 150*16
.byte 11+16

.byte 11+16
.hword 200*16
.hword 160*16
.byte 7+16

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

buf_temp_before:
.rept 640
.byte 0
.endr

buf:
.rept 320*240
.byte 0
.endr

buf_temp_after:
.rept 640
.byte 0
.endr
