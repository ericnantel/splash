
;================================
;       PROGRAM SPLASH          ;
;       VERSION 1.0.0           ;
;       AUTHOR ERIC NANTEL      ;
;       COPYRIGHT 2023-2024     ;
;================================

;================================
;       NO LISTING              ;
;================================
.NOLIST
#include "ti83plus.inc"
_JForceCmd          EQU 402Ah
_HomeUp             EQU 4558h
_KeyPort            EQU 01h
KEYGROUP_BF         EQU 10111111b
KEYGROUP_DF         EQU 11011111b
KEYGROUP_EF         EQU 11101111b
KEYGROUP_F7         EQU 11110111b
KEYGROUP_FB         EQU 11111011b
KEYGROUP_FD         EQU 11111101b
KEYGROUP_FE         EQU 11111110b
KEYCODE_7F	        EQU 01111111b
KEYCODE_BF	        EQU 10111111b
KEYCODE_DF	        EQU 11011111b
KEYCODE_EF	        EQU 11101111b
KEYCODE_F7	        EQU 11110111b
KEYCODE_FB	        EQU 11111011b
KEYCODE_FD	        EQU 11111101b
KEYCODE_FE	        EQU 11111110b
.LIST
    
;================================
;       START ADDRESS           ;
;================================
.ORG userMem - 2

;================================
;       ASM COMPILE TOKENS      ;
;================================
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
    JP NZ, LMainIntro_Loop
    JR LMainIntro_Release2ndKeyLoop

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

LMainLoop:
    bcall(_ClrLCDFull)

    CALL UpdateInputs

    LD HL, GInputs
    LD B, (HL)
    BIT 7, B
    JP Z, LExit

    JP LMainLoop

LExit:
    bcall(_ClrLCDFull)
    bcall(_HomeUp)
    bcall(_CursorOn)
    LD A, FFh
    OUT (_KeyPort), A
    RET

;================================
;       ROUTINES                ;
;================================
UpdateInputs:
    PUSH AF
    PUSH BC
    LD C, 0
LReadKeyGroupFE:
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
    POP BC
    POP AF
    RET

;================================
;       INPUTS                  ;
;   BIT0    KEY_PRESSED_DOWN    ;
;   BIT1    KEY_PRESSED_LEFT    ;
;   BIT2    KEY_PRESSED_RIGHT   ;
;   BIT3    KEY_PRESSED_UP      ;
;   BIT4    KEY_PRESSED_ALPHA   ;
;   BIT5    KEY_PRESSED_2ND     ;
;   BIT6    KEY_PRESSED_MODE    ;
;   BIT7    KEY_PRESSED_DEL     ;
;================================
GInputs:
    .DB 00000000b

;================================
;       STRINGS                 ;
;================================
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
    
.end
.END
