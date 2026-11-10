
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       CODE ASSEMBLY FILE              ;
;		FILENAME SPLASH.CODE.Z80.ASM	;
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
#include "ti83plus.inc"
_Start				EQU userMem - 2
_JForceCmd          EQU $402A
_HomeUp             EQU $4558
_FreeMemStart		EQU $9824
_FreeMemEnd			EQU $9828
_GraphBuffer        EQU plotSScreen
_SaveBuffer         EQU saveSScreen
_AppBuffer          EQU appBackUpScreen
_TmpBuffer          EQU tempSwapArea
_TxtBuffer			EQU textShadow
_StatBuffer			EQU statVars
_KeyPort            EQU $01
KEYGROUP_BF         EQU %10111111
KEYGROUP_DF         EQU %11011111
KEYGROUP_EF         EQU %11101111
KEYGROUP_F7         EQU %11110111
KEYGROUP_FB         EQU %11111011
KEYGROUP_FD         EQU %11111101
KEYGROUP_FE         EQU %11111110
KEYCODE_7F          EQU %01111111
KEYCODE_BF          EQU %10111111
KEYCODE_DF          EQU %11011111
KEYCODE_EF          EQU %11101111
KEYCODE_F7          EQU %11110111
KEYCODE_FB          EQU %11111011
KEYCODE_FD          EQU %11111101
KEYCODE_FE          EQU %11111110
SCREEN_LINE_LENGTH  EQU 12
SCREEN_WIDTH        EQU SCREEN_LINE_LENGTH*8
SCREEN_HEIGHT       EQU 64
GRAPH_BUFFER_LENGTH EQU 768
SAVE_BUFFER_LENGTH  EQU 768
APP_BUFFER_LENGTH   EQU 768
TMP_BUFFER_LENGTH   EQU 323
TXT_BUFFER_LENGTH	EQU 128
STAT_BUFFER_LENGTH	EQU 531
.LIST

#include "splash.runtimes/index.z80.asm"

;========================================
;       START ADDRESS                   ;
;========================================
.ORG _Start

;========================================
;		CODE SECTION					;
;========================================
;.CODE

;========================================
;       ASM COMPILE TOKENS              ;
;========================================
.DB t2ByteTok, tAsmCmp

LStart:
    bcall(_CursorOff)

LCheckMemory:
	CALL AssertEnoughFreeMemory
	JP C, LExit ;TODO: Perhaps print a message or something..

LInitRuntimes:
	CALL InitRuntimes

LInitInterrupts:
	;TODO: Investigate when to apply it
	;enable hardware
	LD A, %00001101
	OUT ($03), A

	CALL InitInterrupts

LMainMenu:
    bcall(_ClrLCDFull)
    bcall(_RunIndicOff)

    LD HL, ISplashScreen
    CALL PresentImageBuffer

LMainMenu_Loop:
    LD A, %11111111
    OUT (_KeyPort), A
    LD A, KEYGROUP_BF
    OUT (_KeyPort), A
    NOP
    NOP
    IN A, (_KeyPort)
    CP KEYCODE_DF
    JP Z, LMainIntro
    CP KEYCODE_7F
    JP Z, LExit

    JR LMainMenu_Loop

LMainIntro:
    bcall(_ClrLCDFull)
    bcall(_HomeUp)

    LD HL, SIntroPage0Row0
    bcall(_PutS)
    bcall(_NewLine)

    LD HL, SIntroPage0Row1
    bcall(_PutS)
    bcall(_NewLine)

    LD HL, SIntroPage0Row2
    bcall(_PutS)
    bcall(_NewLine)

    LD HL, SIntroPage0Row3
    bcall(_PutS)
    bcall(_NewLine)

    LD HL, SIntroPage0Row4
    bcall(_PutS)
    bcall(_NewLine)

    LD DE, 256*0+6
    LD (curRow), DE
    LD HL, SPress2nd
    bcall(_PutS)

    LD DE, 256*0+7
    LD (curRow), DE
    LD HL, SPressDel
    bcall(_PutS)

LMainIntro_Release2ndKeyLoop:
    LD A, %11111111
    OUT (_KeyPort), A
    LD A, KEYGROUP_BF
    OUT (_KeyPort), A
    NOP
    NOP
    IN A, (_KeyPort)
    CP KEYCODE_DF
    JP NZ, LLoadMainLevel
    JR LMainIntro_Release2ndKeyLoop
LLoadMainLevel:
    LD BC, 0
    CALL LoadLevel

LMainIntro_Loop:
    LD A, %11111111
    OUT (_KeyPort), A
    LD A, KEYGROUP_BF
    OUT (_KeyPort), A
    NOP
    NOP
    IN A, (_KeyPort)
    CP KEYCODE_DF
    JP Z, LMainIntro_End
    CP KEYCODE_7F
    JP Z, LExit

    JR LMainIntro_Loop
LMainIntro_End:

    bcall(_ClrLCDFull)

	EI
LMainLoop:
	CALL ReadGameplayInputFlags

	LD A, (GGameplayInputFlags)
	BIT GAMEPLAY_INPUT_KEY_DEL_FLAG, A
	JP NZ, LExit

	JP SKIP_DISP ;no time to debug..

	LD A, (GTEST)
	CP 0
	JP NZ, SKIP_DISP
    ;;DEBUG
	;LD HL, (GCacheLineAddressLow)
	;LD B, 0
	;LD C, CACHE_LINE_LENGTH-1
	;ADD HL, BC
	;LD A, (HL)
	;LD H, 0
	;LD L, A
	;LD DE, 256*0+0
	;LD (curRow), DE
	;bcall(_DispHL)
	;LD HL, (GCacheLineAddressLow)
	;LD B, 0
	;LD C, CACHE_LINE_LENGTH
	;ADD HL, BC
	;LD A, (HL)
	;LD H, 0
	;LD L, A
	;LD DE, 256*0+1
	;LD (curRow), DE
	;bcall(_DispHL)
	;LD HL, (GCacheLineAddressLow)
	;LD B, 0
	;LD C, CACHE_LINE_LENGTH+1
	;ADD HL, BC
	;LD A, (HL)
	;LD H, 0
	;LD L, A
	;LD DE, 256*0+2
	;LD (curRow), DE
	;bcall(_DispHL)
	;LD BC, (GCameraViewportSizeY)
	;LD H, 0
	;LD L, B
	;LD DE, 256*0+3
	;LD (curRow), DE
	;bcall(_DispHL)
	;LD H, 0
	;LD L, C
	;LD DE, 256*0+4
	;LD (curRow), DE
	;bcall(_DispHL)
	;LD BC, (GCameraWorldCoordY)
	;LD H, 0
	;LD L, B
	;LD DE, 256*0+5
	;LD (curRow), DE
	;bcall(_DispHL)
	;LD H, 0
	;LD L, C
	;LD DE, 256*0+6
	;LD (curRow), DE
	;bcall(_DispHL)
	;LD HL, GCameraBitDistance
	;LD L, (HL)
	;LD H, 0
	;LD DE, 256*0+7
	;LD (curRow), DE
	;bcall(_DispHL)
	LD HL, GTEST
	LD L, (HL)
	LD H, 0
	LD DE, 256*0+4
	LD (curRow), DE
	bcall(_DispHL)
	LD HL, GTEST+1
	LD L, (HL)
	LD H, 0
	LD DE, 256*0+5
	LD (curRow), DE
	bcall(_DispHL)
	LD BC, (GTEST+2)
	LD H, B
	LD L, C
	LD DE, 256*0+6
	LD (curRow), DE
	bcall(_DispHL)
	LD BC, (GTEST+4)
	LD H, B
	LD L, C
	LD DE, 256*0+7
	LD (curRow), DE
	bcall(_DispHL)

SKIP_DISP:
	;Turns out DISP HL quite slow, interrupts about 2-3 seconds for 255 interrupts! So about 80-100 hz in comparison to 25hz when disabling interrupts for drawing..
	;In we don't fill the screen last column,
	;then we don't need to copy to shift buffer
	;this can save us thousands of cycles
	;so perhaps we should add code to handle the
	;expensive case we need to fill all columns
	;the other solution is to take shift buffer
	;and copy what we need to screen
	;maybe we can use 15 bytes wide like the lcd memory..

	CALL Update
	; JP LMainLoop ;255 interrupts about 7-8 seconds (how long dispHL takes ??)
    CALL Render ;255 interrupts with Update 12-13 seconds (the reason is we disable interrupts when render)
	EI

    JP LMainLoop

LExit:
	DI
	CALL ResetKeypadState
	CALL SwitchInterruptMode1
	EI

	LD A, %00001011
	OUT ($03), A

	LD A, busyNormal
    LD (indicBusy), A

    bcall(_ClrLCDFull)
    bcall(_HomeUp)
    bcall(_CursorOn)
    bcall(_RunIndicOn)

LClean:
    LD (IY+textFlags), 0
    bcall(_SetTblGraphDraw)
    ;bcall($4C36);bcall(_ReloadAppEntryVecs)
    ;bjump(_JForceCmdNoChar)

LCredits:
    LD DE, 256*0+5
    LD (curRow), DE
    LD HL, SCredits
    bcall(_PutS)
    bcall(_NewLine)

    RET

#include "splash.routines/index.z80.asm"
GTEST: ;MOVE TO _AppBuffer ?
	.DB 255
	.DB 0
	.DW 0
	.DW 0

;========================================
;       ROUTINES                        ;
;========================================

;========================================
;       LOAD LEVEL                      ;
;   INPUT   BC (LEVEL ID)               ;
;   OUTPUT  NONE                        ;
;========================================
LoadLevel:
    LD A, busyPause
    LD (indicBusy), A
    EI
    bcall(_RunIndicOn)
LFindLevelByID:
	;remove code above and put into another routine..
;TODO: This is cool and we can do earthquake effect
	;however it would make more sense to do the lcd command in the int
	;so that it can work with gameplay not just an 'image'
	;of course we'll create flags and states for interrupts.
	;basically I want to tell the int to do x amount of shakes..
	;the other thing is I want to reduce while the anim is running
	;the viewport height but that needs to happens before we do the anim
	;scroll anim of the screen
	LD B, 64-1		;because we kind of do a do while. with djnz
	LD A, $40 + 1	;lcd command z-address
Scroll:
	OUT ($10), A
	INC A

	LD C, 5
Delay:
	HALT
	DEC C
	JR NZ, Delay

	DJNZ Scroll

	;back to normal
	LD A, $40
	OUT ($10), A

	LD A, LVL_THALASLAND_INDEX ;XOR A
	CALL LoadLevelTest
LLoadLevel_End:
    bcall(_RunIndicOff)
    RET

;========================================
;       DRAW GRAPH BUFFER               ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
DrawGraphBuffer:

	; NOTE: Reading camera viewport size to register pair BC
	LD BC, (GCameraViewportSizeY)

	; NOTE: Skip if camera viewport width is less than 8
	LD A, B
	SUB 8
	RET C

	; NOTE: Skip if camera viewport height is less than 1
	LD A, C
	SUB 1
	RET C

	; NOTE: We might want to clamp viewport size instead of skipping..

	; NOTE: Skip if camera viewport width is bigger than screen width
	; NOTE: However we shall perhaps clamp viewport width instead of skipping draw
	LD A, SCREEN_WIDTH
	SUB B
	RET C

	; NOTE: Skip if camera viewport height is bigger than screen height
	; NOTE: However we shall perhaps clamp viewport height instead of skipping draw
	LD A, SCREEN_HEIGHT
	SUB C
	RET C

	; NOTE: Reading camera world coords to register pair BC
	LD BC, (GCameraWorldCoordY)

	; NOTE: Skip if camera world coord x is bigger than data width
	LD A, DATA_WIDTH-1
	SUB B
	RET C

	; NOTE: Skip if camera world coord x is bigger than data height
	LD A, DATA_HEIGHT-1
	SUB C
	RET C

	; NOTE: Calculating cache start col and row indices
	; Result stored in (GRenderColIndex) and (GRenderRowIndex)
	LD BC, (GCameraWorldCoordY)
	LD A, B
	CALL ConvertWorld2CacheCoordX
	LD B, A
	LD A, C
	CALL ConvertWorld2CacheCoordY
	LD C, A
	LD (GRenderRowIndex), BC

	; NOTE: Calculating cache col count
	; NOTE: Expecting start col and row indices to be in register pair BC
	; Result stored in (GRenderColCount)
	LD A, (GCameraViewportSizeX)
	RRA
	RRA
	RRA
	AND %00011111
	LD D, A
	LD A, DATA_LINE_LENGTH
	SUB B
	SUB D
	JR C, LClampColCount
	LD A, D ;draw to end of viewport width (divisible by 8)
	JR LCalculateColCountDone
LClampColCount:
	LD A, DATA_LINE_LENGTH ;draw to end of data line
	SUB B
LCalculateColCountDone:
	LD (GRenderColCount), A

	; NOTE: Calculating cache stride byte offset (cache_line_length - start_cache_col_index)
	; NOTE: Expecting start col and row indices to be in register pair BC
	; NOTE: Expecting cache col count to be in register A
	; Result stored in (GCacheStrideOffset)
	LD D, A
	LD A, CACHE_LINE_LENGTH
	SUB D
	LD (GCacheStrideOffset), A

	; NOTE: Calculating graph stride byte offset (screen_line_length - start_cache_col_index)
	; NOTE: Expecting start col and row indices to be in register pair BC
	; NOTE: Expecting cache col count to be in register D
	; Result stored in (GGraphStrideOffset)
	LD A, SCREEN_LINE_LENGTH
	SUB D
	LD (GGraphStrideOffset), A

	; NOTE: Calculating cache row count
	; NOTE: Expecting start col and row indices to be in register pair BC
	; Result stored in (GRenderRowCount)
	LD A, (GCameraViewportSizeY)
	LD E, A
	LD A, DATA_HEIGHT
	SUB C
	SUB E
	JR C, LClampRowCount
	LD A, E ;draw to end of viewport height
	JR LCalculateRowCountDone
LClampRowCount:
	LD A, DATA_HEIGHT ;draw to end of data height
	SUB C
LCalculateRowCountDone:
	LD (GRenderRowCount), A

	; NOTE: Calculating cache start byte offset (start_cache_row_index * cache_line_length + start_cache_col_index)
	; NOTE: Expecting start col and row indices to be in register pair BC
	; Result stored in HL
	;LD D, 0
	;LD E, A ;row x12 (DATA_LINE_LENGTH)
	;LD H, D
	;LD L, E
	;ADD HL, DE
	;ADD HL, DE
	;ADD HL, HL
	;ADD HL, HL
	;ADD HL, DE ;extra byte (to match CACHE_LINE_LENGTH)
	;LD H, 0
	;LD L, A ;row x16 (DATA_LINE_LENGTH)
	;ADD HL, HL
	;ADD HL, HL
	;ADD HL, HL
	;ADD HL, HL
	;LD D, 0 ;extra byte (to match CACHE_LINE_LENGTH)
	;LD E, A
	;ADD HL, DE
	LD D, 0
	LD E, C ;row x24 (DATA_LINE_LENGTH)
	LD H, D
	LD L, E
	ADD HL, DE
	ADD HL, DE
	ADD HL, HL
	ADD HL, HL
	ADD HL, HL
	ADD HL, DE ;extra byte (to match CACHE_LINE_LENGTH)
	LD D, 0
	LD E, B ;col
	ADD HL, DE

	; NOTE: Calculating cache start address (cache_runtime_address + cache_start_byte_offset)
	; NOTE: Expecting cache start byte offset to be in register pair HL
	; Result stored in HL
	LD DE, (GCacheBufferAddressLow)
	ADD HL, DE

	; NOTE: Calculating graph start address (graph_address + 0)
	; Result stored in DE
	LD DE, _GraphBuffer

	; NOTE: Resetting row counter
	; Result stored in (GRenderRowCounter)
	LD A, (GRenderRowCount)
	LD (GRenderRowCounter), A

	; NOTE: Calculating jump address to proper shifting strategy
	; For instance, if bit distance is 0 then we skip shifting and
	; simply copy each data row from cache to graph buffer
	LD A, (GCameraBitDistance)
	LD B, A ;bitdist x3 because "JP nn" instruction takes 3 bytes
	ADD A, A 
	ADD A, B
	LD B, 0
	LD C, A
	LD IX, LShiftTable
	ADD IX, BC

	; NOTE: Jumping to proper shifting strategy in shift table below
	; NOTE: Expecting cache and graph start address to be in register pairs HL and DE
	JP (IX)

LShiftTable:
	JP LCopyCacheToGraphShift0
	JP LCopyCacheToGraphShift1
	JP LCopyCacheToGraphShift2
	JP LCopyCacheToGraphShift3
	JP LCopyCacheToGraphShift4
	JP LCopyCacheToGraphShift5
	JP LCopyCacheToGraphShift6
	JP LCopyCacheToGraphShift7

LCopyCacheToGraphShift0:
	; LD A, (GRenderRowCount)
	; LD (GRenderRowCounter), A
LCopyCacheRowToGraphShift0_Loop:
	LD A, (GRenderColCount)
	LD B, 0
	LD C, A
	LDIR

	; 20 + 4 + 4 + 11 + 4 + 4 + 4 + 11 + 4 = 68 ticks
	LD BC, (GCacheStrideOffset) ;b has graph stride and c has cache stride offset
	LD A, B
	LD B, 0
	ADD HL, BC

	; LD B, 0
	LD C, A
	EX DE, HL
	ADD HL, BC
	EX DE, HL

	; ; 13 + 4 + 4 + 11 + 13 + 4 + 4 + 4 + 11 + 4 = 72 ticks
	; LD A, (GCacheStrideOffset)
	; LD B, 0
	; LD C, A
	; ADD HL, BC

	; LD A, (GGraphStrideOffset)
	; LD B, 0
	; LD C, A
	; EX DE, HL
	; ADD HL, BC
	; EX DE, HL

	LD A, (GRenderRowCounter)
	DEC A
	LD (GRenderRowCounter), A

	JP NZ, LCopyCacheRowToGraphShift0_Loop

	JP LDrawGraphBufferDone

LCopyCacheToGraphShift1:
	; LD A, (GRenderRowCount)
	; LD (GRenderRowCounter), A
	LD B, D ;moving DE to BC
	LD C, E
LCopyCacheRowToGraphShift1_Loop:
	LD A, (GRenderColCount)
	LD (GRenderColCounter), A
LCopyCacheColToGraphShift1_Loop:

	; 7 + 6 + 7 + 4 + 11 + 4 + 4 + 7 + 6 = 56 + 34 = 90 ticks
	; LD D, (HL) ;7
	; INC HL ;6
	; LD E, (HL) ;7

	; EX DE, HL ;4

; LShiftLeft1: ;11ticks
	; ADD HL, HL

	; EX DE, HL ;4

	; LD A, D ;4
	; LD (BC), A ;7
	; INC BC ;6

	; LD A, (GRenderColCounter)
	; DEC A
	; LD (GRenderColCounter), A

	; 7 + 6 + 7 + 4 + 11 + 4 + 7 + 6 + 10 + 11 + 7 + 4 = 84ticks

	LD D, (HL)
	INC HL
	LD E, (HL)
	EX DE, HL

LShiftLeft1: ;11ticks
	ADD HL, HL

	LD A, H
	LD (BC), A
	INC BC
	LD HL, GRenderColCounter
	DEC (HL)
	LD A, (HL)
	EX DE, HL

	JP NZ, LCopyCacheColToGraphShift1_Loop

	; 20 + 4 + 4 + 11 + 4 + 4 + 4 + 11 + 4 + 4 + 4 = 74 ticks
	LD DE, (GCacheStrideOffset) ;d has graph stride and e has cache stride offset
	LD A, D
	LD D, 0
	ADD HL, DE

	;LD D, 0
	LD E, A
	EX DE, HL
	ADD HL, BC
	LD B, H
	LD C, L
	EX DE, HL

	; ; 13 + 4 + 4 + 11 + 13 + 4 + 4 + 4 + 11 + 4 + 4 + 4 = 80 ticks
	; LD A, (GCacheStrideOffset)
	; LD D, 0
	; LD E, A
	; ADD HL, DE

	; LD A, (GGraphStrideOffset)
	; LD D, 0
	; LD E, A
	; EX DE, HL
	; ADD HL, BC
	; EX DE, HL
	; LD B, D
	; LD C, E

	; 13 + 6 + 13 = 34ticks
	LD A, (GRenderRowCounter)
	DEC A
	LD (GRenderRowCounter), A

	JP NZ, LCopyCacheRowToGraphShift1_Loop

	JP LDrawGraphBufferDone
LCopyCacheToGraphShift2:
	; LD A, (GRenderRowCount)
	; LD (GRenderRowCounter), A
	LD B, D ;moving DE to BC
	LD C, E
LCopyCacheRowToGraphShift2_Loop:
	LD A, (GRenderColCount)
	LD (GRenderColCounter), A
LCopyCacheColToGraphShift2_Loop:

	; LD D, (HL) ;7
	; INC HL ;6
	; LD E, (HL) ;7

	; EX DE, HL ;4

; LShiftLeft2: ;22ticks
	; ADD HL, HL
	; ADD HL, HL

	; EX DE, HL ;4

	; LD A, D ;4
	; LD (BC), A ;7
	; INC BC ;6

	; LD A, (GRenderColCounter)
	; DEC A
	; LD (GRenderColCounter), A

	; 7 + 6 + 7 + 4 + 22 + 4 + 7 + 6 + 10 + 11 + 7 + 4 = 95ticks

	LD D, (HL)
	INC HL
	LD E, (HL)
	EX DE, HL

LShiftLeft2: ;22ticks
	ADD HL, HL
	ADD HL, HL

	LD A, H
	LD (BC), A
	INC BC
	LD HL, GRenderColCounter
	DEC (HL)
	LD A, (HL)
	EX DE, HL

	JP NZ, LCopyCacheColToGraphShift2_Loop

	; 20 + 4 + 4 + 11 + 4 + 4 + 4 + 11 + 4 + 4 + 4 = 74 ticks
	LD DE, (GCacheStrideOffset) ;d has graph stride and e has cache stride offset
	LD A, D
	LD D, 0
	ADD HL, DE

	;LD D, 0
	LD E, A
	EX DE, HL
	ADD HL, BC
	LD B, H
	LD C, L
	EX DE, HL

	; ; 13 + 4 + 4 + 11 + 13 + 4 + 4 + 4 + 11 + 4 + 4 + 4 = 80 ticks
	; LD A, (GCacheStrideOffset)
	; LD D, 0
	; LD E, A
	; ADD HL, DE

	; LD A, (GGraphStrideOffset)
	; LD D, 0
	; LD E, A
	; EX DE, HL
	; ADD HL, BC
	; EX DE, HL
	; LD B, D
	; LD C, E

	LD A, (GRenderRowCounter)
	DEC A
	LD (GRenderRowCounter), A

	JP NZ, LCopyCacheRowToGraphShift2_Loop

	JP LDrawGraphBufferDone
LCopyCacheToGraphShift3:
	; LD A, (GRenderRowCount)
	; LD (GRenderRowCounter), A
	LD B, D ;moving DE to BC
	LD C, E
LCopyCacheRowToGraphShift3_Loop:
	LD A, (GRenderColCount)
	LD (GRenderColCounter), A
LCopyCacheColToGraphShift3_Loop:

	; LD D, (HL) ;7
	; INC HL ;6
	; LD E, (HL) ;7

	; EX DE, HL ;4

; LShiftLeft3: ;33ticks
	; ADD HL, HL
	; ADD HL, HL
	; ADD HL, HL

	; EX DE, HL ;4

	; LD A, D ;4
	; LD (BC), A ;7
	; INC BC ;6

	; LD A, (GRenderColCounter)
	; DEC A
	; LD (GRenderColCounter), A

	; 7 + 6 + 7 + 4 + 33 + 4 + 7 + 6 + 10 + 11 + 7 + 4 = 106ticks

	LD D, (HL)
	INC HL
	LD E, (HL)
	EX DE, HL

LShiftLeft3: ;33ticks
	ADD HL, HL
	ADD HL, HL
	ADD HL, HL

	LD A, H
	LD (BC), A
	INC BC
	LD HL, GRenderColCounter
	DEC (HL)
	LD A, (HL)
	EX DE, HL

	JP NZ, LCopyCacheColToGraphShift3_Loop

	; 20 + 4 + 4 + 11 + 4 + 4 + 4 + 11 + 4 + 4 + 4 = 74 ticks
	LD DE, (GCacheStrideOffset) ;d has graph stride and e has cache stride offset
	LD A, D
	LD D, 0
	ADD HL, DE

	;LD D, 0
	LD E, A
	EX DE, HL
	ADD HL, BC
	LD B, H
	LD C, L
	EX DE, HL

	; ; 13 + 4 + 4 + 11 + 13 + 4 + 4 + 4 + 11 + 4 + 4 + 4 = 80 ticks
	; LD A, (GCacheStrideOffset)
	; LD D, 0
	; LD E, A
	; ADD HL, DE

	; LD A, (GGraphStrideOffset)
	; LD D, 0
	; LD E, A
	; EX DE, HL
	; ADD HL, BC
	; EX DE, HL
	; LD B, D
	; LD C, E

	LD A, (GRenderRowCounter)
	DEC A
	LD (GRenderRowCounter), A

	JP NZ, LCopyCacheRowToGraphShift3_Loop

	JP LDrawGraphBufferDone
LCopyCacheToGraphShift4:
	; LD A, (GRenderRowCount)
	; LD (GRenderRowCounter), A
	LD B, D ;moving DE to BC
	LD C, E
LCopyCacheRowToGraphShift4_Loop:
	LD A, (GRenderColCount)
	LD (GRenderColCounter), A
LCopyCacheColToGraphShift4_Loop:

	; LD D, (HL) ;7
	; INC HL ;6
	; LD E, (HL) ;7

	; EX DE, HL ;4

; LShiftLeft4: ;44ticks
	; ADD HL, HL
	; ADD HL, HL
	; ADD HL, HL
	; ADD HL, HL

	; EX DE, HL ;4

	; LD A, D ;4
	; LD (BC), A ;7
	; INC BC ;6

	; LD A, (GRenderColCounter)
	; DEC A
	; LD (GRenderColCounter), A

	; 7 + 6 + 7 + 4 + 44 + 4 + 7 + 6 + 10 + 11 + 7 + 4 = 117ticks

	LD D, (HL)
	INC HL
	LD E, (HL)
	EX DE, HL

LShiftLeft4: ;44ticks
	ADD HL, HL
	ADD HL, HL
	ADD HL, HL
	ADD HL, HL

	LD A, H
	LD (BC), A
	INC BC
	LD HL, GRenderColCounter
	DEC (HL)
	LD A, (HL)
	EX DE, HL

	JP NZ, LCopyCacheColToGraphShift4_Loop

	; 20 + 4 + 4 + 11 + 4 + 4 + 4 + 11 + 4 + 4 + 4 = 74 ticks
	LD DE, (GCacheStrideOffset) ;d has graph stride and e has cache stride offset
	LD A, D
	LD D, 0
	ADD HL, DE

	;LD D, 0
	LD E, A
	EX DE, HL
	ADD HL, BC
	LD B, H
	LD C, L
	EX DE, HL

	; ; 13 + 4 + 4 + 11 + 13 + 4 + 4 + 4 + 11 + 4 + 4 + 4 = 80 ticks
	; LD A, (GCacheStrideOffset)
	; LD D, 0
	; LD E, A
	; ADD HL, DE

	; LD A, (GGraphStrideOffset)
	; LD D, 0
	; LD E, A
	; EX DE, HL
	; ADD HL, BC
	; EX DE, HL
	; LD B, D
	; LD C, E

	LD A, (GRenderRowCounter)
	DEC A
	LD (GRenderRowCounter), A

	JP NZ, LCopyCacheRowToGraphShift4_Loop

	JP LDrawGraphBufferDone
LCopyCacheToGraphShift5:
	; LD A, (GRenderRowCount)
	; LD (GRenderRowCounter), A
	LD B, D ;moving DE to BC
	LD C, E
LCopyCacheRowToGraphShift5_Loop:
	LD A, (GRenderColCount)
	LD (GRenderColCounter), A
LCopyCacheColToGraphShift5_Loop:

	; LD D, (HL) ;7
	; INC HL ;6
	; LD E, (HL) ;7

	; EX DE, HL ;4

; LShiftLeft5: ;44ticks
	; LD A, H
	; RRCA
	; RR L
	; RRCA
	; RR L
	; RRCA
	; RR L
	; LD H, L

	; EX DE, HL ;4

	; LD A, D ;4
	; LD (BC), A ;7
	; INC BC ;6

	; LD A, (GRenderColCounter)
	; DEC A
	; LD (GRenderColCounter), A

	; 7 + 6 + 7 + 4 + 44 + 4 + 7 + 6 + 10 + 11 + 7 + 4 = 117ticks

	LD D, (HL)
	INC HL
	LD E, (HL)
	EX DE, HL

LShiftLeft5: ;44ticks
	LD A, H
	RRCA
	RR L
	RRCA
	RR L
	RRCA
	RR L
	LD H, L

	LD A, H
	LD (BC), A
	INC BC
	LD HL, GRenderColCounter
	DEC (HL)
	LD A, (HL)
	EX DE, HL

	JP NZ, LCopyCacheColToGraphShift5_Loop

	; 20 + 4 + 4 + 11 + 4 + 4 + 4 + 11 + 4 + 4 + 4 = 74 ticks
	LD DE, (GCacheStrideOffset) ;d has graph stride and e has cache stride offset
	LD A, D
	LD D, 0
	ADD HL, DE

	;LD D, 0
	LD E, A
	EX DE, HL
	ADD HL, BC
	LD B, H
	LD C, L
	EX DE, HL

	; ; 13 + 4 + 4 + 11 + 13 + 4 + 4 + 4 + 11 + 4 + 4 + 4 = 80 ticks
	; LD A, (GCacheStrideOffset)
	; LD D, 0
	; LD E, A
	; ADD HL, DE

	; LD A, (GGraphStrideOffset)
	; LD D, 0
	; LD E, A
	; EX DE, HL
	; ADD HL, BC
	; EX DE, HL
	; LD B, D
	; LD C, E

	LD A, (GRenderRowCounter)
	DEC A
	LD (GRenderRowCounter), A

	JP NZ, LCopyCacheRowToGraphShift5_Loop

	JP LDrawGraphBufferDone
LCopyCacheToGraphShift6:
	; LD A, (GRenderRowCount)
	; LD (GRenderRowCounter), A
	LD B, D ;moving DE to BC
	LD C, E
LCopyCacheRowToGraphShift6_Loop:
	LD A, (GRenderColCount)
	LD (GRenderColCounter), A
LCopyCacheColToGraphShift6_Loop:

	; LD D, (HL) ;7
	; INC HL ;6
	; LD E, (HL) ;7

	; EX DE, HL ;4

; LShiftLeft6: ;36ticks
	; SRL H
	; RR L
	; SRL H
	; RR L
	; LD H, L

	; EX DE, HL ;4

	; LD A, D ;4
	; LD (BC), A ;7
	; INC BC ;6

	; LD A, (GRenderColCounter)
	; DEC A
	; LD (GRenderColCounter), A

	; 7 + 6 + 7 + 4 + 36 + 4 + 7 + 6 + 10 + 11 + 7 + 4 = 109ticks

	LD D, (HL)
	INC HL
	LD E, (HL)
	EX DE, HL

LShiftLeft6: ;36ticks
	SRL H
	RR L
	SRL H
	RR L
	LD H, L

	LD A, H
	LD (BC), A
	INC BC
	LD HL, GRenderColCounter
	DEC (HL)
	LD A, (HL)
	EX DE, HL

	JP NZ, LCopyCacheColToGraphShift6_Loop

	; 20 + 4 + 4 + 11 + 4 + 4 + 4 + 11 + 4 + 4 + 4 = 74 ticks
	LD DE, (GCacheStrideOffset) ;d has graph stride and e has cache stride offset
	LD A, D
	LD D, 0
	ADD HL, DE

	;LD D, 0
	LD E, A
	EX DE, HL
	ADD HL, BC
	LD B, H
	LD C, L
	EX DE, HL

	; ; 13 + 4 + 4 + 11 + 13 + 4 + 4 + 4 + 11 + 4 + 4 + 4 = 80 ticks
	; LD A, (GCacheStrideOffset)
	; LD D, 0
	; LD E, A
	; ADD HL, DE

	; LD A, (GGraphStrideOffset)
	; LD D, 0
	; LD E, A
	; EX DE, HL
	; ADD HL, BC
	; EX DE, HL
	; LD B, D
	; LD C, E

	LD A, (GRenderRowCounter)
	DEC A
	LD (GRenderRowCounter), A

	JP NZ, LCopyCacheRowToGraphShift6_Loop

	JP LDrawGraphBufferDone
LCopyCacheToGraphShift7:
	; LD A, (GRenderRowCount)
	; LD (GRenderRowCounter), A
	LD B, D ;moving DE to BC
	LD C, E
LCopyCacheRowToGraphShift7_Loop:
	LD A, (GRenderColCount)
	LD (GRenderColCounter), A
LCopyCacheColToGraphShift7_Loop:

	;LD D, (HL) ;7
	;INC HL ;6
	;LD E, (HL) ;7

	;EX DE, HL ;4

;LShiftLeft7: ;20ticks
	;LD A, H
	;RRCA
	;LD A, L
	;RRA
	;LD H, A
	;; NOTE: another solution that takes less instructions
	;;SRL H
	;;RR L
	;;LD H, L

	;EX DE, HL ;4

	;LD A, D ;4
	;LD (BC), A ;7
	;INC BC ;6

	;LD A, (GRenderColCounter)
	;DEC A
	;LD (GRenderColCounter), A

	; 7 + 6 + 7 + 4 + 20 + 4 + 7  + 6 + 10 + 11 + 7 + 4 = 93ticks

	LD D, (HL)
	INC HL
	LD E, (HL)
	EX DE, HL

LShiftLeft7: ;20ticks
	LD A, H
	RRCA
	LD A, L
	RRA
	LD H, A
	; NOTE: another solution that takes less instructions
	;SRL H
	;RR L
	;LD H, L

	LD A, H
	LD (BC), A
	INC BC
	LD HL, GRenderColCounter
	DEC (HL)
	LD A, (HL)
	EX DE, HL

	JP NZ, LCopyCacheColToGraphShift7_Loop

	; 20 + 4 + 4 + 11 + 4 + 4 + 4 + 11 + 4 + 4 + 4 = 74 ticks
	LD DE, (GCacheStrideOffset) ;d has graph stride and e has cache stride offset
	LD A, D
	LD D, 0
	ADD HL, DE

	;LD D, 0
	LD E, A
	EX DE, HL
	ADD HL, BC
	LD B, H
	LD C, L
	EX DE, HL

	; ; 13 + 4 + 4 + 11 + 13 + 4 + 4 + 4 + 11 + 4 + 4 + 4 = 80 ticks
	; LD A, (GCacheStrideOffset)
	; LD D, 0
	; LD E, A
	; ADD HL, DE

	; LD A, (GGraphStrideOffset)
	; LD D, 0
	; LD E, A
	; EX DE, HL
	; ADD HL, BC
	; EX DE, HL
	; LD B, D
	; LD C, E

	LD A, (GRenderRowCounter)
	DEC A
	LD (GRenderRowCounter), A

	JP NZ, LCopyCacheRowToGraphShift7_Loop

	JP LDrawGraphBufferDone

LDrawGraphBufferDone:
	RET

;========================================
;       CAPTURE SCREENSHOT              ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
CaptureScreenshot:
    bcall(_SaveDisp)
    RET

;========================================
;       CLEAR IMAGE BUFFER              ;
;   INPUT   HL                          ;
;   OUTPUT  NONE                        ;
;========================================
ClearImageBuffer:
    bcall(_BufClr)
    RET

;========================================
;       PRESENT IMAGE BUFFER            ;
;   INPUT   HL                          ;
;   OUTPUT  NONE                        ;
;========================================
PresentImageBuffer:
    bcall(_BufCpy)
    ;bcall(_DisplayImage) Same thing??
    RET

;========================================
;       CONVERT WORLD TO GRID COORDS    ;
;   INPUT   BC (WORLD COORDS)           ;
;   OUTPUT  DE (GRID COORDS)            ;
;========================================
ConvertWorldToGridCoords:
    LD D, B
    LD E, C
    SRA D
    SRA D
    SRA D
    SRA D
    SRA E
    SRA E
    SRA E
    SRA E
    RET

;========================================
;       CONVERT GRID TO WORLD COORDS    ;
;   INPUT   BC (GRID COORDS)            ;
;   OUTPUT  DE (WORLD COORDS)           ;
;========================================
ConvertGridToWorldCoords:
    LD D, B
    LD E, C
    SLA D
    SLA D
    SLA D
    SLA D
    SLA E
    SLA E
    SLA E
    SLA E
    RET

;========================================
;       PACK MATRIX COORDS              ;       
;   INPUT   BC (MATRIX COORDS)          ;
;   OUTPUT  DE (0 | BYTE)               ;
;========================================
PackMatrixCoords:
    LD A, C
    SLA A
    SLA A
    SLA A
    SLA A
    ADD A, B
    LD D, 0
    LD E, A
    RET

;========================================
;       UNPACK MATRIX COORDS            ;
;   INPUT   BC (0 | BYTE)               ;
;   OUTPUT  DE (MATRIX COORDS)          ;
;========================================
UnpackMatrixCoords:
    LD A, C
    AND %00001111
    LD D, A
    LD A, C
    SRA A
    SRA A
    SRA A
    SRA A
    LD E, A
    RET

;========================================
;       UPDATE                          ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
MovePlayerLeft:
	LD A, B
	SUB 1
	JR C, LClampPlayerWorldCoordXMin
	LD B, A
	JR LMovePlayerLeftDone
LClampPlayerWorldCoordXMin:
	LD B, 0
LMovePlayerLeftDone:
	RET
MovePlayerRight:
	LD A, 24*8-96-1
	SUB B
	;ADD A, 1
	JR C, LClampPlayerWorldCoordXMax
	INC B
	JR LMovePlayerRightDone
LClampPlayerWorldCoordXMax:
	LD B, 24*8-96 ;
LMovePlayerRightDone:
	RET
MovePlayerUp:
	LD A, C
	SUB 1
	JR C, LClampPlayerWorldCoordYMin
	LD C, A
	JR LMovePlayerUpDone
LClampPlayerWorldCoordYMin:
	LD C, 0
LMovePlayerUpDone:
	RET
MovePlayerDown:
	LD A, 20*8-64-1 ;
	SUB C
	;ADD A, 1
	JR C, LClampPlayerWorldCoordYMax
	INC C
	JR LMovePlayerDownDone
LClampPlayerWorldCoordYMax:
	LD C, 20*8-64 ;
LMovePlayerDownDone:
	RET
Update:

	; NOTE: Player Pos Needs to be clamped with the level
	; But what we have to do is apply the offset to camera
	; and then do the clamping below.

	;BIT b, r 8ticks
	;LD A, (nn) 13ticks
	;LD BC, (nn) 20ticks

	LD A, (GGameplayInputFlags)

	CP 0
	JR Z, LCheckInput_Done1

	LD BC, (GCameraWorldCoordY)
	; LD BC, (GPlayerWorldCoordY)

	LD D, A

	BIT GAMEPLAY_INPUT_KEY_LEFT_FLAG, D
	CALL NZ, MovePlayerLeft

	BIT GAMEPLAY_INPUT_KEY_RIGHT_FLAG, D
	CALL NZ, MovePlayerRight

	BIT GAMEPLAY_INPUT_KEY_UP_FLAG, D
	CALL NZ, MovePlayerUp

	BIT GAMEPLAY_INPUT_KEY_DOWN_FLAG, D
	CALL NZ, MovePlayerDown

	; CALL UpdatePlayerWorldCoords
	CALL UpdateCameraWorldCoords
LCheckInput_Done1:
	RET
Update_old:
	; NOTE: Inputs
	; Move Camera -> Player
	LD A, (GGameplayInputFlags)

	CP 0
	JR Z, LCHECKINPUT_DONE

	LD BC, (GCameraWorldCoordY)
	LD DE, (GCameraViewportSizeY)

;NOTE: This moves the camera pos based on input the user pressed
;However we might want to move the player position at the beggining..
	BIT GAMEPLAY_INPUT_KEY_DOWN_FLAG, A
	JR Z, LA1
	INC C
LA1:
	BIT GAMEPLAY_INPUT_KEY_LEFT_FLAG, A
	JR Z, LA2
	DEC B
LA2:
	BIT GAMEPLAY_INPUT_KEY_RIGHT_FLAG, A
	JR Z, LA3
	INC B
LA3:
	BIT GAMEPLAY_INPUT_KEY_UP_FLAG, A
	JR Z, LA4
	DEC C
LA4:
	BIT GAMEPLAY_INPUT_KEY_ALPHA_FLAG, A
	JR Z, LA5
	DEC D
	;trigger event TEST: now we know how to trigger a timer; interrupt takes care of decrease the value
	; DI
	LD HL, GTEST+1
	LD (HL), 0
	LD HL, GTEST
	LD (HL), 255
	; EI
LA5:
	BIT GAMEPLAY_INPUT_KEY_2ND_FLAG, A
	JR Z, LA6
	; DEC E
LA6:
	BIT GAMEPLAY_INPUT_KEY_MODE_FLAG, A
	JR Z, LAD
LAD:
	; Perhaps check if BC has changed ?
	; Such as checking if A is 0
	; CP 0
	; JR ..
	CALL UpdateCameraWorldCoords
	LD B, D
	LD C, E
	CALL UpdateCameraViewportSizes
LCHECKINPUT_DONE:

	RET

;========================================
;       RENDER                          ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
Render:
	XOR A
    CALL ClearGraphBuffer
    
	CALL DrawGraphBuffer
	
	;DEBUG
	; LD BC, 12*28+6
	; LD IX, _GraphBuffer
	; ADD IX, BC
	; LD A, (IX)
	; AND %11000011
	; OR %00111100
	; LD (IX), A

	; LD BC, 12*28+6
	; LD IX, _GraphBuffer
	; ADD IX, BC
	; LD A, (IX)
	; AND %11100111
	; OR %00011000
	; LD (IX), A

	; LD BC, 12*29+6
	; LD IX, _GraphBuffer
	; ADD IX, BC
	; LD A, (IX)
	; AND %11000011
	; OR %00111100
	; LD (IX), A
    
	; LD BC, 12*30+6
	; LD IX, _GraphBuffer
	; ADD IX, BC
	; LD A, (IX)
	; AND %10000001
	; OR %01111110
	; LD (IX), A
	
	; LD BC, 12*31+6
	; LD IX, _GraphBuffer
	; ADD IX, BC
	; LD A, (IX)
	; AND %00000000
	; OR %11111111
	; LD (IX), A
	
	; LD BC, 12*32+6
	; LD IX, _GraphBuffer
	; ADD IX, BC
	; LD A, (IX)
	; AND %10000001
	; OR %01111110
	; LD (IX), A

	CALL PresentGraphBuffer
	;TESTING Drawing after certain amount of interrupt
	; LD A, (GTEST)
	; CP 0
	; JR NZ, P_DONE
	; CALL PresentGraphBuffer
	; LD A, 255
	; LD (GTEST), A
	LD BC, (GTEST+4) ;draw calls
	INC BC
	LD (GTEST+4), BC
P_DONE:
	; EI Because we will reenable interrupts after RET
    RET

;========================================
;		DATA SECTION					;
;========================================
;.DATA
#include "splash.assets/index.z80.asm"

.end
.END
