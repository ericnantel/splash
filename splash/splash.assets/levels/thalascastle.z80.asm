
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       LEVEL ASSEMBLY FILE				;
;		FILENAME THALASCASTLE.Z80.ASM		;
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
.LIST

	;THALASCASTLE HEADER
	.DB LVL_THALASCASTLE_TD_COL_OFF
	.DB LVL_THALASCASTLE_TD_ROW_OFF
	.DB LVL_THALASCASTLE_TD_COLS
	.DB LVL_THALASCASTLE_TD_ROWS

	;THALASCASTLE TILEDATA
	.DB 00

.end
