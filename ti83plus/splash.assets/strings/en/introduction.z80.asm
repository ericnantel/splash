
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       STRINGS ASSEMBLY FILE			;
;       AUTHOR ERIC NANTEL              ;
;       COPYRIGHT 2023-2024             ;
;========================================

;========================================
;       NO LISTING                      ;
;========================================
.NOLIST
.LIST

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
    .DB "A wizard!", 0
SIntroPage0Row2:
    .DB "Issue is..", 0
SIntroPage0Row3:
    .DB "Need mana..", 0
SIntroPage0Row4:
    .DB "Courage !", 0
SCredits:
    .DB "Follow me on GitHub.com/ericnantel", 0

.end
