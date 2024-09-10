
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       CODE ASSEMBLY FILE              ;
;       AUTHOR ERIC NANTEL              ;
;       COPYRIGHT 2023-2024             ;
;========================================

;========================================
;       NO LISTING                      ;
;========================================
.NOLIST
#include "ti83plus.inc"
_Start				EQU userMem - 2
_JForceCmd          EQU 402Ah
_HomeUp             EQU 4558h
_GraphBuffer        EQU plotSScreen
_SaveBuffer         EQU saveSScreen
_AppBuffer          EQU appBackUpScreen
_TmpBuffer          EQU tempSwapArea
_KeyPort            EQU 01h
KEYGROUP_BF         EQU 10111111b
KEYGROUP_DF         EQU 11011111b
KEYGROUP_EF         EQU 11101111b
KEYGROUP_F7         EQU 11110111b
KEYGROUP_FB         EQU 11111011b
KEYGROUP_FD         EQU 11111101b
KEYGROUP_FE         EQU 11111110b
KEYCODE_7F          EQU 01111111b
KEYCODE_BF          EQU 10111111b
KEYCODE_DF          EQU 11011111b
KEYCODE_EF          EQU 11101111b
KEYCODE_F7          EQU 11110111b
KEYCODE_FB          EQU 11111011b
KEYCODE_FD          EQU 11111101b
KEYCODE_FE          EQU 11111110b
SCREEN_LINE_LENGTH  EQU 12
SCREEN_WIDTH        EQU SCREEN_LINE_LENGTH*8
SCREEN_HEIGHT       EQU 64
GRAPH_BUFFER_LENGTH EQU 768
SAVE_BUFFER_LENGTH  EQU 768
APP_BUFFER_LENGTH   EQU 768
TMP_BUFFER_LENGTH   EQU 323
CACHE_LINE_LENGTH   EQU 12;16
CACHE_WIDTH         EQU CACHE_LINE_LENGTH*8
CACHE_HEIGHT        EQU 128
CACHE_BUFFER_LENGTH EQU 2048
.LIST
    
;========================================
;       START ADDRESS                   ;
;========================================
.ORG _Start

;========================================
;       ASM COMPILE TOKENS              ;
;========================================
.DB t2ByteTok, tAsmCmp

LStart:
    bcall(_CursorOff)

LMainMenu:
    bcall(_ClrLCDFull)
    bcall(_RunIndicOff)

    LD HL, ISplashScreen
    CALL PresentImageBuffer

LMainMenu_Loop:
    LD A, 11111111b
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
    LD A, 11111111b
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
    LD A, 11111111b
    OUT (_KeyPort), A
    LD A, KEYGROUP_BF
    OUT (_KeyPort), A
    NOP
    NOP
    IN A, (_KeyPort)
    CP KEYCODE_DF
    JP Z, LMainLoop
    CP KEYCODE_7F
    JP Z, LExit

    JR LMainIntro_Loop

    bcall(_ClrLCDFull)

LMainLoop:
    CALL UpdateInputs

    LD HL, GInputs
    LD C, (HL)
    BIT 7, C
    JP Z, LExit

    ;DEBUG
    ;LD HL, GInputs
    ;LD C, (HL)
LCheckCameraDown:
    BIT 0, C
    JR Z, LMoveCameraDown
LCheckCameraLeft:
    BIT 1, C
    JR Z, LMoveCameraLeft
LCheckCameraRight:
    BIT 2, C
    JR Z, LMoveCameraRight
LCheckCameraUp:
    BIT 3, C
    JR Z, LMoveCameraUp
LCheckCameraViewportX:
    BIT 4, C
    JR Z, LDecViewportX
LCheckCameraViewportY:
    BIT 5, C
    JR Z, LDecViewportY

    JR LCheckCameraDone

LMoveCameraDown:
    LD HL, GCameraWorldCoordY
    LD A, (HL)
    INC A
    LD (HL), A
    JR LCheckCameraLeft
LMoveCameraLeft:
    LD HL, GCameraWorldCoordX
    LD A, (HL)
    DEC A
    LD (HL), A
    JR LCheckCameraRight
LMoveCameraRight:
    LD HL, GCameraWorldCoordX
    LD A, (HL)
    INC A
    LD (HL), A
    JR LCheckCameraUp
LMoveCameraUp:
    LD HL, GCameraWorldCoordY
    LD A, (HL)
    DEC A
    LD (HL), A
    JR LCheckCameraViewportX
LDecViewportX:
    LD HL, GCameraViewportSizeX
    LD A, (HL)
    ;CP 1
    ;JR Z, LCheckCameraViewportY
    DEC (HL)
    JR LCheckCameraViewportY
LDecViewportY:
    LD HL, GCameraViewportSizeY
    LD A, (HL)
    ;CP 1
    ;JR Z, LCheckCameraDone
    DEC (HL)

LCheckCameraDone:

    ;;DEBUG
	;LD BC, (GCameraWorldCoordY)
	;;LD BC, (GCameraViewportSizeY)
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
	;LD HL, GBitDistance
	;LD L, (HL)
	;LD H, 0
	;LD DE, 256*0+7
	;LD (curRow), DE
	;bcall(_DispHL)
	
    CALL Render

    JP LMainLoop

LExit:
    LD A, busyNormal
    LD (indicBusy), A
    EI
    bcall(_ClrLCDFull)
    bcall(_HomeUp)
    bcall(_CursorOn)
    bcall(_RunIndicOn)
    LD A, 11111111b
    OUT (_KeyPort), A

LClean:
    LD (IY+textFlags), 0
    bcall(_SetTblGraphDraw)
    ;bcall(4C36h);bcall(_ReloadAppEntryVecs)
    ;bjump(_JForceCmdNoChar)

LCredits:
    LD DE, 256*0+5
    LD (curRow), DE
    LD HL, SCredits
    bcall(_PutS)
    bcall(_NewLine)

    RET

#include "splash.routines/index.z80.asm"

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
    ;DEBUG..
    LD HL, ISplashScreen
    LD DE, GCacheBuffer
    LD BC, GRAPH_BUFFER_LENGTH
    LDIR

LLoadLevel_End:
    bcall(_RunIndicOff)
    RET

;========================================
;       UPDATE INPUTS                   ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
UpdateInputs:
    LD C, 0
LReadKeyGroupFE:
    LD A, 11111111b
    OUT (_KeyPort), A
    LD A, KEYGROUP_FE
    OUT (_KeyPort), A
    NOP
    NOP
    IN A, (_KeyPort)
LTestKeyPressedDown:
    BIT 0, A
    JR Z, LTestKeyPressedLeft
    SET 0, C
LTestKeyPressedLeft:
    BIT 1, A
    JR Z, LTestKeyPressedRight
    SET 1, C
LTestKeyPressedRight:
    BIT 2, A
    JR Z, LTestKeyPressedUp
    SET 2, C
LTestKeyPressedUp:
    BIT 3, A
    JR Z, LReadKeyGroupDF
    SET 3, C
LReadKeyGroupDF:
    LD A, 11111111b
    OUT (_KeyPort), A
    LD A, KEYGROUP_DF
    OUT (_KeyPort), A
    NOP
    NOP
    IN A, (_KeyPort)
LTestKeyPressedAlpha:
    BIT 7, A
    JR Z, LReadKeyGroupBF
    SET 4, C
LReadKeyGroupBF:
    LD A, 11111111b
    OUT (_KeyPort), A
    LD A, KEYGROUP_BF
    OUT (_KeyPort), A
    NOP
    NOP
    IN A, (_KeyPort)
LTestKeyPressed2nd:
    BIT 5, A
    JR Z, LTestKeyPressedMode
    SET 5, C
LTestKeyPressedMode:
    BIT 6, A
    JR Z, LTestKeyPressedDel
    SET 6, C
LTestKeyPressedDel:
    BIT 7, A
    JR Z, LWriteInputs
    SET 7, C
LWriteInputs:
    LD HL, GInputs
    LD (HL), C
    RET

;========================================
;       UPDATE PLAYER WORLD COORD       ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
UpdatePlayerWorldCoord:
    RET

;========================================
;       UPDATE CAMERA WORLD COORD       ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
UpdateCameraWorldCoord:
	; NOTE: not good..
	; possibly but need to verify
	; LD HL, (GPlayerWorldCoordY)
	; LD (GCameraWorldCoordY), HL
    ; LD HL, GPlayerWorldCoords
    ; LD DE, GCameraWorldCoords
    ; LD BC, 2
    ; LDIR
    RET

;========================================
;       UPDATE CAMERA VIEWPORT SIZE     ;
;   INPUT   BC (VIEWPORT SIZES)         ;
;   OUTPUT  NONE                        ;
;========================================
UpdateCameraViewportSize:
	; NOTE: HL is a bit faster
    LD (GCameraViewportSizeY), BC
    RET

;========================================
;       CLEAR GRAPH BUFFER              ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
ClearGraphBuffer:
    bcall(_GrBufClr)
    RET

;========================================
;       DRAW GRAPH BUFFER               ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
DrawGraphBuffer:
	; NOTE: Read Camera Viewport Size 16bits into reg. pair BC
	LD BC, (GCameraViewportSizeY)

	; NOTE: Skip if Camera Viewport Width is less than 8
	LD A, B
	SUB 8
	RET C

	; NOTE: Skip if Camera Viewport Height is less than 1
	LD A, C
	SUB 1
	RET C

	; NOTE: Skip if Camera Viewport Width is bigger than Screen Width
	LD A, SCREEN_WIDTH
	SUB B
	RET C

	; NOTE: Skip if Camera Viewport Height is bigger than Screen Height
	LD A, SCREEN_HEIGHT
	SUB C
	RET C

	; NOTE: Read Camera World Coord 16bits into reg. pair BC
	LD BC, (GCameraWorldCoordY)

	; NOTE: Skip if Camera World Coord X is bigger than Cache Width
	LD A, CACHE_WIDTH-1
	SUB B
	RET C

	; NOTE: Skip if Camera World Coord Y is bigger than Cache Height
	LD A, CACHE_HEIGHT-1
	SUB C
	RET C

	; NOTE: Calculate bit distance from Camera World Coord X
	LD D, 8
	LD E, B
	LD A, E
LBitDistance_Loop_R:
	AND 11111000b
	JR Z, LBitDistance_End_R
	LD A, E
	SUB D
	LD E, A
	JR LBitDistance_Loop_R
LBitDistance_End_R:
	LD D, 0
	;Register E has bit distance

	LD A, E
	LD (GBitDistance), A

	; NOTE: Calculate fast bit shift jump address and store in IX
	; Beware this works because ADD HL, HL is 1 byte instruction
	LD A, 7
	SUB E ; bit distance
	LD D, 0
	LD E, A
	LD IX, LFastBitShift
	ADD IX, DE

	; NOTE: Calculating cache line draw calls
	LD HL, GCameraWorldCoordY
	LD DE, GCameraViewportSizeY
	LD A, (HL)
	EX DE, HL
	ADD A, (HL)
	SUB CACHE_HEIGHT-1
	JR C, LCDC
	EX DE, HL
	LD E, (HL)
	LD A, CACHE_HEIGHT-1
	SUB E
	LD D, 0
	LD E, A
	JR LCDE
LCDC:
	LD D, 0
	LD E, (HL)
LCDE:

	LD B, E
	LD C, 0

LDrawScreenRow_Loop_R:

	PUSH BC

	; NOTE: Read Camera World Coord Y into register A
	; NOTE: Convert Camera World Coord Y to Cache Coord Y in A
	LD A, (GCameraWorldCoordY)
	ADD A, C

	; NOTE: Load Cache Line from Cache Coord Y
	LD B, 0
	LD C, A
	; register C has cache coord y
	LD H, B
	LD L, C
	;x12
	ADD HL, BC
	ADD HL, BC
	ADD HL, HL
	ADD HL, HL
	;x16
	;ADD HL, HL
	;ADD HL, HL
	;ADD HL, HL
	;ADD HL, HL

	LD DE, GCacheBuffer
	ADD HL, DE
	LD DE, GCacheLine
	LD BC, CACHE_LINE_LENGTH
	LDIR

	; NOTE: Read Camera World Coord X into register A
	; NOTE: Convert Camera World Coord X to Cache Coord X in A
	LD A, (GCameraWorldCoordX)
	SRA A
	SRA A
	SRA A

	; NOTE: Shift Cache Line
	; TODO: Put Bit distance in C or discard if no need to shift
	; LD HL, GBitDistance
	; LD B, 0
	; LD C, (HL)
	LD D, 0
	LD E, A
	; register E has cache coord x
	CALL ShiftCacheLine

	POP BC
	PUSH BC

	; NOTE: Read Camera World Coord Y into register A
	; NOTE: Convert Camera World Coord Y to Cache Coord Y in A
	LD A, (GCameraWorldCoordY)
	ADD A, C
	LD A, C

	; NOTE: Calculate Graph Start Address and store in DE
	LD B, 0
	LD C, A
	; register C has cache coord y
	LD H, B
	LD L, C
	;x12
	ADD HL, BC
	ADD HL, BC
	ADD HL, HL
	ADD HL, HL
	;x16
	;ADD HL, HL
	;ADD HL, HL
	;ADD HL, HL
	;ADD HL, HL

	LD DE, _GraphBuffer
	ADD HL, DE
	EX DE, HL

	; NOTE: Read Camera World Coord X into register A
	; NOTE: Convert Camera World Coord X to Cache Coord X in A
	LD A, (GCameraWorldCoordX)
	SRA A
	SRA A
	SRA A

	; NOTE: Calculate Cache Line Start Address and store in HL
	LD B, 0
	LD C, A
	; register C has cache coord x
	LD HL, GCacheLine
	ADD HL, BC
	
	; NOTE: Calculate Cache Line Copy Size
	; This is not good but we need to not use HL or DE !!
	; But why are we calculating this here everytime
	; When this should not change once we know the coord x
	; and we should use this value as well during copycacheline..
	LD B, A
	; register B has cache coord x
	LD A, (GCameraViewportSizeX)
	SRA A
	SRA A
	SRA A
	LD C, A
	; register C has max copy size
	LD A, CACHE_LINE_LENGTH
	SUB B
	SUB C
	JR C, LCopySizeClamp
	LD A, C ; We can show all viewport size x
	JR LCopySizeDone
LCopySizeClamp:
	; We cannot show all viewport size x
	LD A, CACHE_LINE_LENGTH
	SUB B
LCopySizeDone:
	LD B, 0
	LD C, A

	LDIR

	POP BC
	INC C
	DJNZ LDrawScreenRow_Loop_R

	RET

;========================================
;       PRESENT GRAPH BUFFER            ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
PresentGraphBuffer:
    bcall(_GrBufCpy)
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
;       CLEAR CACHE BUFFER              ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
ClearCacheBuffer:
    LD HL, GCacheBuffer
    LD DE, GCacheBuffer+1
    LD BC, CACHE_BUFFER_LENGTH-1
    LD (HL), 0
    LDIR
    RET

;========================================
;       LOAD CACHE LINE                 ;
;   INPUT   BC (CACHE Y_COORD)          ;
;   OUTPUT  NONE                        ;
;========================================
LoadCacheLine:
    LD H, B
    LD L, C
    ;x12 (CACHE_LINE_LENGTH)
    ADD HL, BC
    ADD HL, BC
    ADD HL, HL
    ADD HL, HL
    ;x16 (CACHE_LINE_LENGTH)
    ;ADD HL, HL
    ;ADD HL, HL
    ;ADD HL, HL
    ;ADD HL, HL

    LD DE, GCacheBuffer
    ADD HL, DE

    LD DE, GCacheLine
    LD BC, CACHE_LINE_LENGTH
    LDIR
    RET

;========================================
;       SHIFT CACHE LINE                ;
;   INPUT   BC (0 | BIT DISTANCE)       ;
;           DE (0 | CACHE X_COORD)      ;
;			IX (JP ADDRESS)				;
;   OUTPUT  NONE                        ;
;========================================
ShiftCacheLine:
	; NOTE: Skip if bit distance is 0
	; LD A, C
	; CP 0
	; RET Z

	; NOTE: Debug
	; LD A, 255
	; LD (GCacheLineExtraByte), A

	; THIS WORKS BUT WE SHIFT ALL CACHELINE
	; ; NOTE: Load B with Byte Count
	; LD A, CACHE_LINE_LENGTH
	; LD B, A
	;
	; ; NOTE: Store CacheLine Address in DE
	; LD DE, GCacheLine
	
	; NOTE: Load B with Byte Count
	LD A, CACHE_LINE_LENGTH
	SUB E
	LD B, A

	; NOTE: Store CacheLine Start Address in DE
	LD HL, GCacheLine
	ADD HL, DE
	EX DE, HL

	; NOTE: Loop with Counter in register B
LShiftCacheLine_ShiftLoop:

	; NOTE: Read 2 bytes from addresses DE and DE+1
	; And store them in HL register pair
	LD A, (DE)		;7ticks
	LD H, A			;4ticks
	INC DE			;6ticks
	LD A, (DE)		;7ticks
	LD L, A			;4ticks
	DEC DE			;6ticks = 34ticks 
	
	; NOTE: Jump to address in IX
    JP (IX)			;8ticks
LFastBitShift:
LFastBitShift7:
    ADD HL, HL		;11ticks
LFastBitShift6:
    ADD HL, HL		;11ticks
LFastBitShift5:
    ADD HL, HL		;11ticks
LFastBitShift4:
    ADD HL, HL		;11ticks
LFastBitShift3:
    ADD HL, HL		;11ticks
LFastBitShift2:
    ADD HL, HL		;11ticks
LFastBitShift1:
    ADD HL, HL		;11ticks
LFastBitShift0:

	; NOTE: Write register H content to address in DE
	LD A, H			;4ticks
	LD (DE), A		;7ticks

	; NOTE: Increment address in DE
	INC DE			;6ticks

	; NOTE: Repeat instructions above if B Counter is Non-Zero
	DJNZ LShiftCacheLine_ShiftLoop
	
	RET

;========================================
;       CALCULATE CACHE LINE DRAW CALLS ;
;   INPUT   NONE                        ;
;   OUTPUT  DE (0 | DRAW CALLS)         ;
;========================================
CalculateCacheLineDrawCalls:
    LD HL, GCameraWorldCoordY
	LD DE, GCameraViewportSizeY
    LD A, (HL)
    EX DE, HL
    ADD A, (HL)
    SUB CACHE_HEIGHT-1

    JR C, LCalculateMaxDrawCalls
    EX DE, HL
    LD E, (HL)
    LD A, CACHE_HEIGHT-1
    SUB E
    LD D, 0
    LD E, A
    JR LCalculateCLDrawCalls_End
LCalculateMaxDrawCalls:
    LD D, 0
    LD E, (HL)
LCalculateCLDrawCalls_End:
    RET

;========================================
;       CALCULATE CACHE LINE COPY SIZE  ;
;   INPUT   BC (0 | CACHE X_COORD)      ;
;   OUTPUT  DE (COPY SIZE)              ;
;========================================
CalculateCacheLineCopySize:
	LD A, (GCameraViewportSizeX)
    SRA A
    SRA A
    SRA A
	LD B, A ;max copy size
    ADD A, C
    SUB CACHE_LINE_LENGTH
    JR C, LCalculateMaxCopySize
    LD A, CACHE_LINE_LENGTH
    SUB C
    JR LCalculateCLCopySize_End
LCalculateMaxCopySize:
	LD A, B ; ok
LCalculateCLCopySize_End:
	LD D, 0
	LD E, A
    RET

;========================================
;       COPY CACHE LINE                 ;
;   INPUT   BC (COPY SIZE)              ;
;           HL (CACHE LINE OFFSET)      ;
;           DE (GRAPH OFFSET)           ;
;   OUTPUT  NONE                        ;
;========================================
CopyCacheLine:
	; NOTE: I don't like this..
    PUSH BC
    LD BC, GCacheLine
    ADD HL, BC
    EX DE, HL
    LD BC, _GraphBuffer
    ADD HL, BC
    EX DE, HL
    POP BC
    LDIR
    RET

;========================================
;       CONVERT WORLD TO SCREEN COORDS  ;
;   INPUT   BC (WORLD COORDS)           ;
;   OUTPUT  DE (SCREEN COORDS)          ;
;========================================
ConvertWorldToScreenCoords:
    ; LD HL, GCameraWorldCoords
    ; LD A, B
    ; SUB (HL)
    ; LD D, A
    ; INC HL
    ; LD A, C
    ; SUB (HL)
    ; LD E, A
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
;       CONVERT WORLD TO CACHE COORDS   ;
;   INPUT   BC (WORLD COORDS)           ;
;   OUTPUT  DE (CACHE COORDS)           ;
;========================================
ConvertWorldToCacheCoords:
    LD D, B
    LD E, C
    SRA D
    SRA D
    SRA D
    RET

;========================================
;       CONVERT WORLD TO MATRIX COORDS  ;
;   INPUT   BC (WORLD COORDS)           ;
;   OUTPUT  DE (MATRIX COORDS)          ;
;========================================
ConvertWorldToMatrixCoords:
    PUSH BC
    CALL ConvertWorldToGridCoords
    LD B, D
    LD C, E
    CALL ConvertGridToWorldCoords
    POP BC
    LD A, B
    SUB D
    LD D, A
    LD A, C
    SUB E
    LD E, A
    RET

;========================================
;       CONVERT WORLD TO BIT DISTANCE   ;
;   INPUT   BC (X_COORD | 0)            ;
;   OUTPUT  DE (0 | BIT DISTANCE)       ;
;========================================
ConvertWorldToBitDistance:
    LD A, B
    LD C, 8
LBitDistance_Loop:
    AND 11111000b
    JR Z, LBitDistance_End
    LD A, B
    SUB C
    LD B, A
    JR LBitDistance_Loop
LBitDistance_End:
    LD D, 0
    LD E, B
    RET

;========================================
;       CONVERT SCREEN TO WORLD COORDS  ;
;   INPUT   BC (SCREEN COORDS)          ;
;   OUTPUT  DE (WORLD COORDS)           ;
;========================================
ConvertScreenToWorldCoords:
    ; LD HL, GCameraWorldCoords
    ; LD A, B
    ; ADD A, (HL)
    ; LD D, A
    ; INC HL
    ; LD A, C
    ; ADD A, (HL)
    ; LD E, A
    RET

;========================================
;       CONVERT SCREEN TO GRID COORDS   ;
;   INPUT   BC (SCREEN COORDS)          ;
;   OUTPUT  DE (GRID COORDS)            ;
;========================================
ConvertScreenToGridCoords:
    CALL ConvertScreenToWorldCoords
    LD B, D
    LD C, E
    CALL ConvertWorldToGridCoords
    RET

;========================================
;       CONVERT SCREEN TO CACHE COORDS  ;
;   INPUT   BC (SCREEN COORDS)          ;
;   OUTPUT  DE (CACHE COORDS)           ;
;========================================
ConvertScreenToCacheCoords:
    CALL ConvertScreenToWorldCoords
    LD B, D
    LD C, E
    CALL ConvertWorldToCacheCoords
    RET

;========================================
;       CONVERT SCREEN TO MATRIX COORDS ;
;   INPUT   BC (SCREEN COORDS)          ;
;   OUTPUT  DE (MATRIX COORDS)          ;
;========================================
ConvertScreenToMatrixCoords:
    CALL ConvertScreenToWorldCoords
    LD B, D
    LD C, E
    CALL ConvertWorldToMatrixCoords
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
;       CONVERT GRID TO SCREEN  COORDS  ;
;   INPUT   BC (GRID COORDS)            ;
;   OUTPUT  DE (SCREEN COORDS)          ;
;========================================
ConvertGridToScreenCoords:
    CALL ConvertGridToWorldCoords
    LD B, D
    LD C, E
    CALL ConvertWorldToScreenCoords
    RET

;========================================
;       CONVERT CACHE TO WORLD COORDS   ;
;   INPUT   BC (CACHE COORDS)           ;
;   OUTPUT  DE (WORLD COORDS)           ;
;========================================
ConvertCacheToWorldCoords:
    LD D, B
    LD E, C
    SLA D
    SLA D
    SLA D
    RET

;========================================
;       CONVERT CACHE TO SCREEN COORDS  ;
;   INPUT   BC (CACHE COORDS)           ;
;   OUTPUT  DE (SCREEN COORDS)          ;
;========================================
ConvertCacheToScreenCoords:
    CALL ConvertCacheToWorldCoords
    LD B, D
    LD C, E
    CALL ConvertWorldToScreenCoords
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
    AND 00001111b
    LD D, A
    LD A, C
    SRA A
    SRA A
    SRA A
    SRA A
    LD E, A
    RET

;========================================
;       RENDER                          ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
Render:
    CALL ClearGraphBuffer
    CALL DrawGraphBuffer
    CALL PresentGraphBuffer
    RET

;========================================
;       DATA                            ;
;========================================

;========================================
;       INPUTS                          ;
;   BIT0    KEY_PRESSED_DOWN            ;
;   BIT1    KEY_PRESSED_LEFT            ;
;   BIT2    KEY_PRESSED_RIGHT           ;
;   BIT3    KEY_PRESSED_UP              ;
;   BIT4    KEY_PRESSED_ALPHA           ;
;   BIT5    KEY_PRESSED_2ND             ;
;   BIT6    KEY_PRESSED_MODE            ;
;   BIT7    KEY_PRESSED_DEL             ;
;========================================
GInputs:
    .DB 00000000b

;========================================
;       PLAYER WORLD COORD              ;
;   BYTE0   Y_COORD                     ;
;   BYTE1   X_COORD                     ;
;========================================
GPlayerWorldCoordY:
    .DB 0
GPlayerWorldCoordX:
    .DB 0

;========================================
;       CAMERA WORLD COORD              ;
;   BYTE0   Y_COORD                     ;
;   BYTE1   X_COORD                     ;
;========================================
GCameraWorldCoordY:
	.DB 0
GCameraWorldCoordX:
	.DB 0

;========================================
;       CAMERA VIEWPORT SIZE            ;
;   BYTE0   Y_SIZE                      ;
;   BYTE1   X_SIZE                      ;
;========================================
GCameraViewportSizeY:
	.DB SCREEN_HEIGHT
GCameraViewportSizeX:
	.DB SCREEN_WIDTH

GRowCount:
	.DB 0
GBitDistance:
	.DB 0

;========================================
;       CACHE LINE                      ;
;   16B     RESERVED SPACE              ;
;========================================
GCacheLine:
;    .DB CACHE_LINE_LENGTH DUP(0)
    .FILL CACHE_LINE_LENGTH, (0)

;========================================
;       CACHE LINE EXTRA BYTE           ;
;   1B      RESERVED SPACE              ;
;========================================
GCacheLineExtraByte:
    .DB 0

;========================================
;       CACHE BUFFER                    ;
;   2KB     RESERVED SPACE              ;
;========================================
GCacheBuffer:
;    .DB CACHE_BUFFER_LENGTH DUP(0)
    .FILL CACHE_BUFFER_LENGTH, (0)

#include "splash.assets/index.z80.asm"

.end
.END
