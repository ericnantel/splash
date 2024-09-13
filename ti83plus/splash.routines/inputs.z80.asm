
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       ROUTINE ASSEMBLY FILE			;
;		FILENAME INPUTS.Z80.ASM			;
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
.LIST

;========================================
;       CLEAR GAMEPLAY INPUT FLAGS   	;
;   INPUT   NONE            			;
;   OUTPUT  NONE            			;
;========================================
ClearGameplayInputFlags:
	XOR A
	LD (GGameplayInputFlags), A
	RET

;========================================
;       READ GAMEPLAY INPUT FLAGS    	;
;   INPUT   NONE            			;
;   OUTPUT  NONE            			;
;========================================
ReadGameplayInputFlags:
	LD A, 11111111b
	OUT (_KeyPort), A
	LD A, KEYGROUP_FE
	OUT (_KeyPort), A
	NOP
	NOP
	IN A, (_KeyPort)
	CPL
	AND 00001111b
	LD B, A

	LD A, 11111111b
	OUT (_KeyPort), A
	LD A, KEYGROUP_DF
	OUT (_KeyPort), A
	NOP
	NOP
	IN A, (_KeyPort)
	CPL
	RRA
	RRA
	RRA
	AND 00010000b
	OR B
	LD B, A

	LD A, 11111111b
	OUT (_KeyPort), A
	LD A, KEYGROUP_BF
	OUT (_KeyPort), A
	NOP
	NOP
	IN A, (_KeyPort)
	CPL
	AND 11100000b
	OR B

	; CPL

	LD (GGameplayInputFlags), A
	RET

.end

