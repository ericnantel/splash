
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       ROUTINE ASSEMBLY FILE			;
;		FILENAME INTERRUPTS.Z80.ASM		;
;       AUTHOR ERIC NANTEL              ;
;		COUNTRY CANADA					;
;       COPYRIGHT 2023-2024             ;
;		SOURCE CODE AVAILABLE ON		;
;		GITHUB.COM/ERICNANTEL/SPLASH	;
;========================================

.NOLIST
;========================================
;       NO LISTING                      ;
;========================================
IVT_MSB							EQU $99
IVT_CONTENT						EQU $9A
IVT_LENGTH						EQU 257
.LIST

;========================================
;       COPY INTERRUPT HANDLER			;
;   INPUT   NONE            			;
;   OUTPUT  NONE            			;
;========================================
CopyInterruptHandler:
	;NOTE: It is possible to simply write JP $ADDR instruction bytes
	; Directly to GInterruptHandlerAddress without using LDIR
	; But let's keep it simple to understand for now .
	LD HL, InterruptHandler
	LD DE, GISRAddressStart			;$9A9A
	LD BC, ISR_LENGTH
	LDIR
	RET

;========================================
;       FILL INTERRUPT VECTOR TABLE		;
;   INPUT   NONE            			;
;   OUTPUT  NONE            			;
;========================================
FillInterruptVectorTable:
	LD A, IVT_CONTENT				;$9A
	LD HL, GIVTAddressStart			;$9900
	LD (HL), A
	LD DE, GIVTAddressStart+1
	LD BC, IVT_LENGTH-1				;257-1
	LDIR
	RET

;========================================
;       SWITCH INTERRUPT MODE 1			;
;   INPUT   NONE            			;
;   OUTPUT  NONE            			;
;========================================
SwitchInterruptMode1:
	XOR A
	LD I, A
	IM 1
	RET

;========================================
;       SWITCH INTERRUPT MODE 2			;
;   INPUT   NONE            			;
;   OUTPUT  NONE            			;
;========================================
SwitchInterruptMode2:
	LD A, IVT_MSB					;$99
	LD I, A
	IM 2
	RET

.NOLIST
;========================================
;       NO LISTING						;
;========================================
InterruptHandler:
	;NOTE: Do not use JR !
	JP InterruptHandler_Body
InterruptHandler_End:
.LIST

InterruptHandler_Body:
	;NOTE: No need to disable interrupts, they should be already
	;DI
	
	;NOTE: Swapping register pairs with shadow register pairs
	EX AF, AF'
	EXX
	;NOTE: Pushing index registers to stack
	;PUSH IX
	;PUSH IY

	;Acknowledge all interrupts
	LD A, %00001000
	OUT ($03), A

	;Enable Timer1
	LD A, %00001010
	OUT ($03), A

	;Disable Hardware ? is there a use for this ?
	;XOR A
	;OUT ($03), A

	;Set interrupt speed
	;%000 is fastest (~140Hz) %110 is normal (~100Hz) %110 is slowest (~100Hz)
	;But we don't want to call this every time.. TODO: make a routine to set it
	XOR A
	OUT ($04), A

	;What about port $20 for clock freq 6-15Mhz is it for this calc ?

	;CODE HERE
LCheck:
	LD BC, (GTEST)
	LD A, C
	CP 0
	JR Z, LCheck_End
	DEC A
	INC B
	LD C, A
	LD (GTEST), BC
	LD BC, (GTEST+2)
	INC BC
	LD (GTEST+2), BC
LCheck_End:

	;NOTE: Popping back index registers from stack
	;POP IY
	;POP IX
	;NOTE: Swapping back register pairs with shadow register pairs
	EX AF, AF'
	EXX

	;NOTE: Reenabling interrupts
	EI

	;NOTE: Returning from interrupts
	RETI
	;RET works too
	;JP $0038 works too
	;JP $003A works too but don't exchange shadow registers !
InterruptHandler_Body_End:

.NOLIST
;========================================
;       NO LISTING                      ;
;========================================
ISR_LENGTH						EQU InterruptHandler_End-InterruptHandler
ISR_BODY_LENGTH					EQU InterruptHandler_Body_End-InterruptHandler_Body
.LIST

.end

