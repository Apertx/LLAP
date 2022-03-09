; Author: Apertx
; Compile: AVR-GCC
; Output: UART 9600

reset:
	jmp main
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp wdt
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset
	jmp reset

main:
	eor r16,r16
	out 0x3F,r16
	ldi r16,0x08
	out 0x3E,r16
	ldi r16,0xFF
	out 0x3D,r16
	ldi r16,0xED
	sts 0x64,r16

	; UART init
	ldi r16,0x67
	sts 0xC4,r16
	ldi r16,0x08
	sts 0xC1,r16
	ldi r16,0x86
	sts 0xC2,r16

	; BOD/WDT init
	ldi r16,0x60
	sts 0x35,r16
	ldi r16,0x40
	sts 0x35,r16
	wdr
	ldi r16,0x18
	sts 0x60,r16
	ldi r16,0x4A
	sts 0x60,r16
	sei
	sbi 0x04,0x05
	ldi r18,0x0F

loop:
	ldi r16,0x01
	out 0x33,r16
	sleep
	rjmp loop

wdt:
	cbi 0x05,0x05
	dec r18
	brne wdt_skip
	ldi r18,0x0F
	sbi 0x05,0x05
	ldi r19,'H'
	rcall uart_send
	ldi r19,'e'
	rcall uart_send
	ldi r19,'l'
	rcall uart_send
	ldi r19,'l'
	rcall uart_send
	ldi r19,'o'
	rcall uart_send
	ldi r19,'!'
	rcall uart_send
	ldi r19,'\n'
	rcall uart_send
wdt_skip:
	ldi r16,0x4A
	sts 0x60,r16
	reti

uart_send:
	lds r16,0xC0
	sbrs r16,0x05
	rjmp uart_send
	mov r16,r19
	lsr r16
	lsr r16
	lsr r16
	lsr r16
	cpi r16,0x0A
	brlo uart_num0
	ldi r17,0x07
	add r16,r17
uart_num0:
	ldi r17,0x30
	add r16,r17
	sts 0xC6,r16
uart_wait:
	lds r16,0xC0
	sbrs r16,0x05
	rjmp uart_wait
	mov r16,r19
	andi r16,0x0F
	cpi r16,0x0A
	brlo uart_num1
	ldi r17,0x07
	add r16,r17
uart_num1:
	ldi r17,0x30
	add r16,r17
	sts 0xC6,r16
	ret
