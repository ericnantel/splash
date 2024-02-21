
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
;TESTING.
Image1_Layer1:
.db $FF,$FF,$FF,$FF,$FF,$FF,$FC,$FF,$FC,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.db $FF,$3C,$FC,$FF,$FC,$FF,$FF,$FF,$FF,$80,$FF,$FF,$FF,$3C,$FC,$87
.db $FC,$FF,$FF,$FF,$FF,$80,$7F,$F0,$FF,$3C,$FC,$01,$F9,$FF,$FF,$FF
.db $FF,$80,$1F,$E0,$7F,$3C,$FC,$31,$F9,$FF,$FF,$FF,$FF,$9F,$0F,$CF
.db $3F,$3C,$FC,$79,$F9,$FE,$0F,$FF,$FF,$9F,$8F,$CF,$3F,$3C,$FC,$79
.db $F9,$FC,$07,$FF,$FF,$9F,$8F,$CF,$3F,$3C,$FC,$79,$F9,$F8,$E7,$FF
.db $FF,$9F,$8F,$CF,$3F,$38,$FC,$31,$F9,$F8,$E7,$FF,$FF,$9F,$8F,$CF
.db $3F,$00,$7C,$03,$F1,$F8,$07,$FF,$FF,$9F,$8F,$E0,$7F,$80,$7C,$87
.db $F3,$F9,$FF,$FF,$FF,$9F,$0F,$F0,$FF,$FF,$FF,$FF,$F3,$F9,$FF,$FF
.db $FF,$80,$1F,$FF,$FF,$FF,$FF,$FF,$F3,$F8,$FF,$FF,$FF,$80,$30,$3F
.db $FF,$FF,$FF,$FF,$FF,$FC,$0F,$FF,$FF,$80,$70,$1F,$FF,$FF,$FF,$FF
.db $FF,$FE,$0F,$FF,$FF,$FF,$F3,$CF,$8F,$87,$E3,$F8,$FC,$0F,$FF,$FF
.db $FF,$FF,$F3,$E7,$87,$07,$C1,$F0,$38,$0F,$FF,$FF,$FF,$FF,$F3,$E7
.db $9F,$E7,$99,$E7,$39,$CF,$FF,$FF,$FF,$FF,$F3,$E7,$9F,$87,$99,$E7
.db $39,$CF,$FF,$FF,$FF,$FF,$F3,$E7,$9F,$07,$99,$E7,$39,$CF,$FF,$FF
.db $FF,$FF,$F3,$CF,$9F,$27,$C1,$F0,$79,$CF,$FF,$FF,$FF,$FF,$F0,$1F
.db $9F,$07,$F9,$F8,$F9,$CF,$FF,$FF,$FF,$FF,$F0,$3F,$FF,$FF,$99,$FF
.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$83,$FF,$FF,$FF,$FF,$FF
.db $FF,$FD,$FF,$FD,$D0,$5D,$C6,$38,$DD,$07,$FF,$FF,$FF,$F9,$FF,$FD
.db $D7,$DD,$FD,$D7,$49,$7F,$FF,$FF,$FF,$FD,$FF,$FC,$D7,$DD,$FD,$F7
.db $55,$7F,$FF,$FF,$FF,$FD,$FF,$FD,$50,$D5,$FD,$10,$5D,$0F,$FF,$FF
.db $FF,$FD,$FF,$FD,$97,$D5,$FD,$D7,$5D,$7F,$FF,$FF,$FF,$FD,$E7,$FD
.db $D7,$D5,$FD,$D7,$5D,$7F,$FF,$FF,$FF,$F0,$E7,$FD,$D0,$6B,$FE,$17
.db $5D,$07,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.db $FF,$F8,$FF,$FE,$38,$DD,$06,$37,$5D,$07,$FF,$FF,$FF,$FF,$7F,$FD
.db $D7,$5D,$DF,$77,$5D,$7F,$FF,$FF,$FF,$FF,$7F,$FD,$F7,$4D,$DF,$73
.db $5D,$7F,$FF,$FF,$FF,$FE,$FF,$FD,$F7,$55,$DF,$75,$5D,$0F,$FF,$FF
.db $FF,$FD,$FF,$FD,$F7,$59,$DF,$76,$5D,$7F,$FF,$FF,$FF,$FB,$E7,$FD
.db $D7,$5D,$DF,$77,$5D,$7F,$FF,$FF,$FF,$F8,$67,$FE,$38,$DD,$DE,$37
.db $63,$07,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.db $FF,$F0,$7F,$FD,$D8,$E3,$76,$18,$E3,$0C,$18,$7F,$FF,$FE,$FF,$FD
.db $DD,$DD,$75,$F7,$5D,$75,$F7,$FF,$FF,$FD,$FF,$FD,$DD,$DF,$75,$F7
.db $DD,$75,$F7,$FF,$FF,$FE,$FF,$FC,$1D,$D1,$06,$37,$DD,$0C,$18,$FF
.db $FF,$FF,$7F,$FD,$DD,$DD,$77,$D7,$DD,$5D,$FF,$7F,$FF,$FF,$67,$FD
.db $DD,$DD,$77,$D7,$5D,$6D,$FF,$7F,$FF,$F0,$E7,$FD,$D8,$E1,$74,$38
.db $E3,$74,$10,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.db $FF,$FE,$FF,$FE,$38,$DD,$04,$38,$DF,$87,$FF,$FF,$FF,$FC,$FF,$FD
.db $D7,$5D,$DD,$D7,$5F,$7F,$FF,$FF,$FF,$FA,$FF,$FD,$F7,$4D,$DD,$D7
.db $5F,$7F,$FF,$FF,$FF,$F6,$FF,$FD,$F7,$55,$DC,$37,$5F,$8F,$FF,$FF
.db $FF,$F0,$7F,$FD,$F7,$59,$DD,$77,$5F,$F7,$FF,$FF,$FF,$FE,$E7,$FD
.db $D7,$5D,$DD,$B7,$5F,$F7,$FF,$FF,$FF,$FE,$E7,$FE,$38,$DD,$DD,$D8
.db $C1,$0F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.db $FF,$F0,$7F,$FE,$37,$63,$07,$FF,$FF,$FF,$FF,$FF,$FF,$F7,$FF,$FD
.db $D7,$77,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$FF,$FD,$D7,$77,$DF,$FF
.db $FF,$FF,$FF,$FF,$FF,$FF,$7F,$FD,$D7,$77,$DF,$FF,$FF,$FF,$FF,$FF
.db $FF,$FF,$7F,$FD,$57,$77,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$67,$FD
.db $B7,$77,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$E7,$FE,$58,$E3,$DF,$FF
.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

;========================================
;       SPRITES                         ;
;========================================

;========================================
;       LEVELS                          ;
;========================================

.end