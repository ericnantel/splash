
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
;#define ENGLISH_LANG
#define FRENCH_LANG
.LIST

;========================================
;       STRINGS                         ;
;========================================
#ifdef ENGLISH_LANG
#include "splash.assets/strings/en/introduction.z80.asm"
#endif
#ifdef FRENCH_LANG
#include "splash.assets/strings/fr/introduction.z80.asm"
#endif

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
