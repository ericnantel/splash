
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       LEVEL ASSEMBLY FILE				;
;		FILENAME THALASHOME.Z80.ASM		;
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

	;THALASHOME HEADER
	.DB LVL_THALASHOME_TD_COL_OFF
	.DB LVL_THALASHOME_TD_ROW_OFF
	.DB LVL_THALASHOME_TD_COLS
	.DB LVL_THALASHOME_TD_ROWS

	;THALASHOME TILEDATA
	.DB 00

.end
