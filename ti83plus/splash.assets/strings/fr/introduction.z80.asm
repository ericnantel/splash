
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
    .DB "de Eric Nantel", 0
SPress2nd:
    .DB "2nd = Continuer", 0
SPressDel:
    .DB "DEL = Quitter", 0
SIntroPage0Row0:
    .DB "Tu es Splash!", 0
SIntroPage0Row1:
    .DB "Un sorcier!", 0
SIntroPage0Row2:
    .DB "Petit bemol..", 0
SIntroPage0Row3:
    .DB "Faut du mana..", 0
SIntroPage0Row4:
    .DB "Courage !", 0
SCredits:
    .DB "Suis-moi sur GitHub.com/ericnantel", 0

.end
