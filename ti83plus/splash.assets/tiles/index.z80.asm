
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       INDEX ASSEMBLY FILE             ;
;		FILENAME INDEX.Z80.ASM			;
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

GTileImages:
	#include "splash.assets/tiles/blank.z80.asm"
	#include "splash.assets/tiles/brickcenter.z80.asm"
	#include "splash.assets/tiles/brickleft.z80.asm"
	#include "splash.assets/tiles/brickright.z80.asm"
	#include "splash.assets/tiles/bricktopcenter.z80.asm"
	#include "splash.assets/tiles/bricktopleft.z80.asm"
	#include "splash.assets/tiles/bricktopright.z80.asm"
	#include "splash.assets/tiles/grass.z80.asm"
	#include "splash.assets/tiles/bush.z80.asm"
	#include "splash.assets/tiles/hole.z80.asm"
	#include "splash.assets/tiles/heart.z80.asm"
	#include "splash.assets/tiles/gemstone.z80.asm"
	#include "splash.assets/tiles/paving1.z80.asm"
	#include "splash.assets/tiles/plank1.z80.asm"
	#include "splash.assets/tiles/chest1.z80.asm"
	#include "splash.assets/tiles/window.z80.asm"
	#include "splash.assets/tiles/eggshell.z80.asm"
	#include "splash.assets/tiles/pattern1.z80.asm"
	#include "splash.assets/tiles/pattern2.z80.asm"

.end
