
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       DATA ASSEMBLY FILE              ;
;       AUTHOR ERIC NANTEL              ;
;       COPYRIGHT 2023-2024             ;
;========================================

;========================================
;       NO LISTING                      ;
;========================================
.NOLIST
.LIST

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

;========================================
;       IMAGES                          ;
;========================================
#include "splash.assets/images/splashscreen.z80.asm"

;========================================
;       SPRITES                         ;
;========================================

;========================================
;       LEVELS                          ;
;========================================

.end