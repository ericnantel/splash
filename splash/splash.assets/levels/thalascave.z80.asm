
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       LEVEL ASSEMBLY FILE				;
;		FILENAME THALASCAVE.Z80.ASM		;
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

	;THALASCAVE HEADER
	.DB LVL_THALASCAVE_TD_COL_OFF
	.DB LVL_THALASCAVE_TD_ROW_OFF
	.DB LVL_THALASCAVE_TD_COLS
	.DB LVL_THALASCAVE_TD_ROWS

	;THALASCAVE TILEDATA
	.DB 00

.end
