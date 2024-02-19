
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       AUTHOR ERIC NANTEL              ;
;       COPYRIGHT 2023-2024             ;
;========================================

;========================================
;       NO LISTING                      ;
;========================================
.NOLIST
#include "ti83plus.inc"
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
SCREEN_WIDTH        EQU 96
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
.ORG userMem - 2

;========================================
;       ASM COMPILE TOKENS              ;
;========================================
.DB t2ByteTok, tAsmCmp

LStart:
    bcall(_CursorOff)

LMainMenu:
    bcall(_ClrLCDFull)

    LD DE, 256*5+0
    LD (curRow), DE
    LD HL, STitle
    bcall(_PutS)
    
    LD DE, 256*1+3
    LD (curRow), DE
    LD HL, SVersion
    bcall(_PutS)

    LD DE, 256*1+4
    LD (curRow), DE
    LD HL, SAuthor
    bcall(_PutS)

    LD DE, 256*0+6
    LD (curRow), DE
    LD HL, SPress2nd
    bcall(_PutS)

    LD DE, 256*0+7
    LD (curRow), DE
    LD HL, SPressDel
    bcall(_PutS)

LMainMenu_Loop:
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

    JR LCheckCameraDone

LMoveCameraDown:
    LD HL, GCameraWorldCoords
    INC HL
    LD A, (HL)
    INC A
    LD (HL), A
    JR LCheckCameraLeft
LMoveCameraLeft:
    LD HL, GCameraWorldCoords
    LD A, (HL)
    DEC A
    LD (HL), A
    JR LCheckCameraRight
LMoveCameraRight:
    LD HL, GCameraWorldCoords
    LD A, (HL)
    INC A
    LD (HL), A
    JR LCheckCameraUp
LMoveCameraUp:
    LD HL, GCameraWorldCoords
    INC HL
    LD A, (HL)
    DEC A
    LD (HL), A

LCheckCameraDone:

    ;DEBUG
    ; LD IX, GCameraWorldCoords
    ; LD DE, 256*0+5
    ; LD (curRow), DE
    ; LD H, 0
    ; LD L, (IX+0)
    ; bcall(_DispHL)
    ; LD DE, 256*0+6
    ; LD (curRow), DE
    ; LD H, 0
    ; LD L, (IX+1)
    ; bcall(_DispHL)

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
    LD HL, GCacheBuffer
    LD (HL), 255
    INC HL
    LD (HL), 255
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 255
    INC HL
    LD (HL), 255
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 255
    INC HL
    LD (HL), 255
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 255
    INC HL
    LD (HL), 255
    INC HL
    LD (HL), 255
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 1
    INC HL
    LD (HL), 1
    
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
;       UPDATE PLAYER WORLD COORDS      ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
UpdatePlayerWorldCoords:
    RET

;========================================
;       UPDATE CAMERA WORLD COORDS      ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
UpdateCameraWorldCoords:
    LD HL, GPlayerWorldCoords
    LD DE, GCameraWorldCoords
    LD BC, 2
    LDIR
    RET

;========================================
;       UPDATE CAMERA VIEWPORT SIZE     ;
;   INPUT   BC (VIEWPORT SIZES)         ;
;   OUTPUT  NONE                        ;
;========================================
UpdateCameraViewportSize:
    LD (GCameraViewportSize), BC
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

LDrawCacheLayer:
    LD HL, GCameraWorldCoords
    LD B, (HL)
    INC HL
    LD C, (HL)

    LD A, CACHE_WIDTH-1
    SUB B
    JP C, LDrawGraphBuffer_End

    LD A, CACHE_HEIGHT-1
    SUB C
    JP C, LDrawGraphBuffer_End

    CALL CalculateCacheLineDrawCalls
    LD B, E
    LD C, 0

LDrawScreenRow_Loop:
    PUSH BC

    LD HL, GCameraWorldCoords
    LD B, (HL)
    INC HL

    LD A, (HL)
    ADD A, C
    LD C, A
    
    CALL ConvertWorldToCacheCoords
    PUSH DE

    LD B, 0
    LD C, E
    CALL LoadCacheLine

    LD HL, GCameraWorldCoords
    LD B, (HL)
    LD C, 0
    CALL ConvertWorldToBitDistance

    EX DE, HL
    POP DE
    PUSH DE

    LD B, 0
    LD C, L
    LD E, D
    LD D, 0
    CALL ShiftCacheLine
    ;CALL ShiftCacheLine_Optimized

    POP IX
    POP BC
    PUSH BC
    PUSH IX

    LD B, C
    LD HL, 0
    LD A, B
    CP 0
    JR Z, LCalculateGraphOffset_End

    LD A, (GCameraViewportSize)
    SRA A
    SRA A
    SRA A
    LD D, 0
    LD E, A
LCalculateGraphOffset_Loop:
    ADD HL, DE
    DJNZ LCalculateGraphOffset_Loop
LCalculateGraphOffset_End:
    POP DE
    PUSH DE
    PUSH HL

    LD B, 0
    LD C, D
    PUSH BC
    CALL CalculateCacheLineCopySize

    LD B, D
    LD C, E
    POP HL
    POP DE
    CALL CopyCacheLine

    POP IX
    POP BC
    INC C
    DJNZ LDrawScreenRow_Loop

LDrawGraphBuffer_End:
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
    RET

;========================================
;       SHIFT CACHE LINE                ;
;   INPUT   BC (0 | BIT DISTANCE)       ;
;           DE (0 | CACHE X_COORD)      ;
;   OUTPUT  NONE                        ;
;========================================
ShiftCacheLine:
    LD A, C
    CP 0
    JR Z, LShiftCacheLine_End
    
    LD HL, GCacheLine
    ADD HL, DE
    LD A, CACHE_LINE_LENGTH
    SUB E
    LD B, A
LShiftCacheLine_Loop1:
    LD D, (HL)
    INC HL
    LD E, (HL)
    
    EX DE, HL
    LD A, B;PUSH BC

    LD B, C
LShiftCacheLine_Loop2:
    ADD HL, HL
    DJNZ LShiftCacheLine_Loop2

    LD B, A;POP BC
    EX DE, HL
    
    DEC HL
    LD (HL), D
    INC HL
    
    DJNZ LShiftCacheLine_Loop1
LShiftCacheLine_End:
    RET

;========================================
;       SHIFT CACHE LINE OPTIMIZED      ;
;   INPUT   BC (0 | BIT DISTANCE)       ;
;           DE (0 | CACHE X_COORD)      ;
;   OUTPUT  NONE                        ;
;========================================
ShiftCacheLine_Optimized:
    LD A, C
    CP 0
    JR Z, LShiftCacheLine_Optimized_End
    
    EX DE, HL

    LD A, 7
    SUB C
    LD D, 0
    LD E, A
    LD IX, LFastBitShift
    ADD IX, DE

    EX DE, HL

    LD HL, GCacheLine
    ADD HL, DE
    LD A, CACHE_LINE_LENGTH
    SUB E
    LD B, A

LShiftCacheLine_Optimized_Loop1:
    LD D, (HL)
    INC HL
    LD E, (HL)
    
    EX DE, HL

    JP (IX)
LFastBitShift:
LFastBitShift_7:
    ADD HL, HL
LFastBitShift_6:
    ADD HL, HL
LFastBitShift_5:
    ADD HL, HL
LFastBitShift_4:
    ADD HL, HL
LFastBitShift_3:
    ADD HL, HL
LFastBitShift_2:
    ADD HL, HL
LFastBitShift_1:
    ADD HL, HL

    EX DE, HL
    
    DEC HL
    LD (HL), D
    INC HL
    
    DJNZ LShiftCacheLine_Optimized_Loop1
LShiftCacheLine_Optimized_End:
    RET

;========================================
;       CALCULATE CACHE LINE DRAW CALLS ;
;   INPUT   NONE                        ;
;   OUTPUT  DE (0 | DRAW CALLS)         ;
;========================================
CalculateCacheLineDrawCalls:
    LD HL, GCameraWorldCoords+1
    LD DE, GCameraViewportSize+1
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
    LD A, (GCameraWorldCoords)
    LD D, A
    LD A, (GCameraViewportSize)
    LD E, A

    LD A, D
    ADD A, E
    LD D, A

    LD A, CACHE_WIDTH
    SUB D
    JR C, LUseShiftCopySize
LUseViewportCopySize:
    LD A, E
    SRA A
    SRA A
    SRA A
    JR LCalculateCacheLineCopySize_End
LUseShiftCopySize:
    LD A, CACHE_LINE_LENGTH
    SUB C
LCalculateCacheLineCopySize_End:
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
    LD HL, GCameraWorldCoords
    LD A, B
    SUB (HL)
    LD D, A
    INC HL
    LD A, C
    SUB (HL)
    LD E, A
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
    LD HL, GCameraWorldCoords
    LD A, B
    ADD A, (HL)
    LD D, A
    INC HL
    LD A, C
    ADD A, (HL)
    LD E, A
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
;       PLAYER WORLD COORDS             ;
;   BYTE0   X_COORD                     ;
;   BYTE1   Y_COORD                     ;
;========================================
GPlayerWorldCoords:
    .DB 0
    .DB 0

;========================================
;       CAMERA WORLD COORDS             ;
;   BYTE0   X_COORD                     ;
;   BYTE1   Y_COORD                     ;
;========================================
GCameraWorldCoords:
    .DB 0
    .DB 0

;========================================
;       CAMERA VIEWPORT SIZE            ;
;   BYTE0   X_SIZE                      ;
;   BYTE1   Y_SIZE                      ;
;========================================
GCameraViewportSize:
    .DB SCREEN_WIDTH
    .DB SCREEN_HEIGHT

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

;========================================
;       STRINGS                         ;
;========================================
STitle:
    .DB "SPLASH", 0
SVersion:
    .DB "version 1.0.0", 0
SAuthor:
    .DB "by Eric Nantel", 0
SPress2nd:
    .DB "2nd To Continue", 0
SPressDel:
    .DB "DEL To Quit", 0
SIntroPage0Row0:
    .DB "You are Splash!", 0
SIntroPage0Row1:
    .DB "A young wizard!", 0
SIntroPage0Row2:
    .DB "Only issue is..", 0
SIntroPage0Row3:
    .DB "You need mana..", 0
SIntroPage0Row4:
    .DB "Good luck mate.", 0
SCredits:
    .DB "Credits: Follow me on GitHub.com/ericnantel", 0

.end
.END
