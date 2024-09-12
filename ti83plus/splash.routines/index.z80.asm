
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       INDEX ASSEMBLY FILE             ;
;       AUTHOR ERIC NANTEL              ;
;       COPYRIGHT 2023-2024             ;
;========================================

;========================================
;       NO LISTING                      ;
;========================================
.NOLIST
; #define USE_BIT_DISTANCE_LOOP
.LIST

#include "splash.routines/conversions.z80.asm"

; CALCULATEDRAWCALLS:
; 	LD A, (GCameraWorldCoordY)
; 	LD B, A
; 	; register B has cache coord y
; 	LD A, (GCameraViewportSizeY)
; 	LD C, A
; 	; register C has max draw calls
; 	LD A, CACHE_HEIGHT-1
; 	SUB B
; 	SUB C
; 	JR C, LDrawCallClamp
; 	LD A, C ; We can draw all viewport size y
; 	JR LDrawCallDone
; LDrawCallClamp:
; 	; We cannot show all viewport size y
; 	LD A, CACHE_HEIGHT-1
; 	SUB B
; LDrawCallDone:
; 	LD B, 0
; 	LD C, A
	
; 	RET

ClearGraphBuffer:
	LD HL, _GraphBuffer
	LD (HL), A
	LD DE, _GraphBuffer+1
	LD BC, GRAPH_BUFFER_LENGTH-1
	LDIR
	RET

gbuf = $9340
gbufCopy:
	di
	ld a,$80
	out ($10),a
	ld hl,gbuf-12-(-(12*64)+1)-12
	ld a,$20
	ld c,a
mapaYOff = $+1
	ld b,0
	inc b
		ld de,12
		add hl,de
	 djnz $-4
gbufCopyAgain:
	ld b,64
	inc c
	ld de,-(12*64)+1
	out ($10),a
	add hl,de
	ld de,10
gbufCopyLoop:
	add hl,de
	inc hl
	inc hl
	inc de
	ld a,(hl)
	out ($11),a
	dec de
	djnz gbufCopyLoop
	ld a,c
	cp $26
	 jr nz,$+5
		ld hl,gbuf-12-(-(12*64)+1)+6
	cp $2B+1
	 jr nz,gbufCopyAgain
	ret

.end
