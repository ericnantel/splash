
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       INDEX ASSEMBLY FILE             ;
;		FILENAME PORTS.Z80.ASM			;
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
LINK_PORT						EQU $00
LINK_D1HD0H_MASK				EQU $00
LINK_D1HD0L_MASK				EQU $01
LINK_D1LD0H_MASK				EQU $02
LINK_D1LD0L_MASK				EQU $03
LINK_IDLE_MASK					EQU $03
; I/O port to send and receive bytes of data
; Between 2 calculators; or between calculator and PC
; To transfer between 2 calculators use a unit-to-unit cable
; And there's available protocol routines on the calculator itself
; To transfer between calculator and PC, you'll need a SilverLink USB cable
; And an application on the PC, such as TI-Connect or Tilip or an Emulator
; You can, of course, implement yourself a data transfer routine.
; TI-83+ link port uses 2 data lines (D0 and D1) to communicate.
; This port is a 4-bit I/O port and is also named B-port in documentation.
; D0 may also be named as tip; D1 as ring in documentation.
; To write/read data to/from data line D0, use bit 0
; To write/read data to/from data line D1, use bit 1
; To set a data line low, set the corresponding bit then write to link port
; To set a data line high, reset the corresponding bit then write to link port
; Ex: Writing %00000010 ($02) to link port will tell it to set D0 high; and set D1 low.
; For TI-83+, to enable link receive assist, set bit 2 then write to link port.
; Then you may poll link port until bit 3 is set, at which point read
; from link assist port to get the byte.
; When reading from link port, bit 0 indicates state of D0 (0:high 1:low)
; When reading from link port, bit 1 indicates state of D1 (0:high 1:low)
; Usually when link port is idle (no transfer, no cable plugged in, etc.) both lines are high.
; For TI-83+, when reading from link port, bit 2 indicates if link receive assist if active (0:disabled 1:enabled)
; For TI-83+, when reading from link port, bit 3 is set when link assist port has received a complete byte. Only way to reset bit 3 is to read that byte from link assist port.
; When reading from link port, bit 4 indicates if your calculator is holding D0 low (0:not holding D0 low 1:is holding D0 low)
; When reading from link port, bit 5 indicates if your calculator is holding D1 low (0:not holding D1 low 1:is holding D1 low)
; For TI-83+, when reading from link port, bit 6 indicates if link assist port is currently receiving data.

KEYBOARD_PORT					EQU $01
KEYBOARD_FE_MASK				EQU $FE
KEYBOARD_FD_MASK				EQU $FD
KEYBOARD_FB_MASK				EQU $FB
KEYBOARD_F7_MASK				EQU $F7
KEYBOARD_EF_MASK				EQU $EF
KEYBOARD_DF_MASK				EQU $DF
KEYBOARD_BF_MASK				EQU $BF
KEYBOARD_7F_MASK				EQU $7F
KEYBOARD_RST_MASK				EQU $FF
; Keyboard port to read what keys are pressed from the keypad.
; To reset keypad state, write a reset mask ($FF) to keyboard port.
; To monitor group(s), write a group mask to keyboard port.
; When a bit is 0 in a group mask it means to add that corresponding group to list of monitored groups
; Ex: Writing a mask %10111101 to keyboard port will tell it to add group BF and FD to that list
; However, you may find hard to read keys from multiple monitored groups at once in some cases
; Ex: Writing a mask %10011111 (group BF and DF) to keyboard port in order to read keys DEL and ALPHA. Can you tell which one was pressed ?
; To verify if a key is pressed, first write a group mask to keyboard port, then read a code mask from keyboard port.
; Then if a bit is 0, it means that corresponding key (from a monitored group) is pressed.
; Ex: Writing a mask %11011111 (group DF) to keyboard port and then reading a code mask %01111111 (code 7F) means key ALPHA is pressed.
; You might have noticed there is no group 7F to monitor (For TI-83+).
; You will read a code mask %11111111 (code FF) if you read right after a keypad state reset.
; Add some delay between writing and reading to/from keyboard port (For TI-83+ 6Mhz, I add 2x NOP)
; You should know, that the system interrupt routine will reset keypad state to scans keys from time to time
; So if you notice garbage when reading from keyboard port, then disable interrupts (or use interrupt mode 2)
;|============================================================================|
;| TI-83+    GROUP BIT|7     |6     |5     |4     |3     |2     |1     |0     |
;| KEYMAP   GROUP MASK|7F    |BF    |DF    |EF    |F7    |FB    |FD    |FE    |
;|CODE BIT |CODE MASK |=======================================================|
;|7        |7F        |      |DEL   |ALPHA |X,T,0n|STAT  |      |      |      |
;|6        |BF        |      |MODE  |MATH  |APPS  |PRGM  |VARS  |CLEAR |      |
;|5        |DF        |      |2nd   |x⁻1   |SIN   |COS   |TAN   |^     |      |
;|4        |EF        |      |Y=    |x²    |,     |(     |)     |/     |      |
;|3        |F7        |      |WINDOW|LOG   |7     |8     |9     |*     |UP    |
;|2        |FB        |      |ZOOM  |LN    |4     |5     |6     |-     |RIGHT |
;|1        |FD        |      |TRACE |STO   |1     |2     |3     |+     |LEFT  |
;|0        |FE        |      |GRAPH |      |0     |.     |(-)   |ENTER |DOWN  |
;|============================================================================|

STATUS_PORT						EQU $02
; Status port to read battery strength, LCD driver status and calculator type.
; When reading from status port, bit 0 indicates battery strength (0: low, 1:good).
; Calculator will refuse to Garbage Collect or receive Flash App or OS when batteries are low.
; For TI-83+ SE, TI-84+ and TI-84+ SE only, bit 1 resets for a set delay after a command or data is sent to the LCD; otherwise this bit is always set.
; When reading from status port, bit 2 tells us if Flash is currently unlocked (0 locked, 1: unlocked).
; For TI-83+ only, bit 3 has last value written to port $05 bit 0 TOVERIFY..
; For TI-83+ only, bit 4 has last value written to port $05 bit 1 TOVERIFY..
; For TI-83+ only, bit 5 has last value written to port $05 bit 2 TOVERIFY..
; For TI-84+ and TI-84+ SE only, bit 5 is set; for TI-83+ and TI-83+ SE bit 5 is reset.
; When reading from status port, bit 6 indicates if link assist is available.
; When reading from status port, bit 7 is reset for TI-83+ BASIC and TI-73; bit 7 is set for everything else.

INT_ACK_PORT					EQU $02
; Interrupt Acknowledge port to acknowledge some interrupts.
; Not available for TI-83+.
; Only TI-83+ SE, TI-84+, TI-84+ SE, TI-84+ CSE
; To acknowledge the ON key interrupt, write 0 to bit 0.
; To leave status of the ON key interrupt alone, write 1 to bit 0.
; To acknowledge Hardware timer 1, set bit 1.
; To acknowledge Hardware timer 2, set bit 2.
; Bit 3 is ignored.
; To acknowledge link port, set bit 4.
; Bit 5 is ignored.
; Bit 6 is ignored.
; Bit 7 is ignored.

INT_MASK_PORT					EQU $03
; Interrupt masking port to control what devices are allowed to trigger interrupts.
; When reading from interrupt masking port, bit 0 is set if the ON key will generate an interrupt.
; When reading from interrupt masking port, bit 1 is set if the hardware timer 1 will generate an interrupt (108hz-512hz).
; When reading from interrupt masking port, bit 2 is set if the hardware timer 2 will generate an interrupt (216hz-1024hz).
; When reading from interrupt masking port, bit 4 is set if the link port will generate an interrupt.
; Write 1 to bit 0 to enable the ON key; write 0 to bit 0 to acknowledge the interrupt request and/or disable it.
; Write 1 to bit 1 to enable hardware timer 1; write 0 to bit 1 to acknowledge the interrupt request and/or disable it.
; Write 1 to bit 2 to enable hardware timer 2; write 0 to bit 2 to acknowledge the interrupt request and/or disable it.
; Write 0 to bit 3 to put calculator in low-power mode if and only if Z80 cpu enters HALT state (during the execution of the HALT instruction).
; Write 1 to bit 3 to keep the calculator powered.
; Write 1 to bit 4 to enable the link port interrupt; write 0 to bit 4 to acknowledge the interrupt request and/or disable it (Doesn't completely disable the linkport).
; Usually, you can write %00001011 to the interrupt masking port, for normal operation.
; Usually, in low-power mode the LCD driver enters standby mode and timer hardware has been disabled.

INT_DEV_PORT					EQU $04
; Interrupting device identification port.
; When an interrupt is triggered, it should be cleared by reseting the corresponding bit in port $03; otherwise it will continuously call the interrupt code once interrupts are reenabled with EI.
; When reading from this port, bit 0 is set if the ON key triggered the interrupt.
; When reading from this port, bit 1 is set if the hardware timer 1 triggered the interrupt.
; When reading from this port, bit 2 is set if the hardware timer 2 triggered the interrupt.
; When reading from this port, bit 3 is set if the ON key is NOT being pressed.
; When reading from this port, bit 4 is set if link activity generated an interrupt.
; For TI-83+ SE and TI-84+ only, when reading from this port, bit 5 is set if crystal timer 1 has expired.
; For TI-83+ SE and TI-84+ only, when reading from this port, bit 6 is set if crystal timer 2 has expired.
; For TI-83+ SE and TI-84+ only, when reading from this port, bit 7 is set if crystal timer 3 has expired.
; Control hardware timer frequency speed by writing to bit 1 and bit 2 as follow:
;|==================================================================================|
;| For TI-83+ BASIC																	|
;|==================================================================================|
;| value | hardware timer 1 freq	| hardware timer 2 freq		| both enabled		|				|
;|==================================================================================|
;|	00	|	560	hz					|	1120 hz					|	1680 hz			|
;|	01	|	248	hz					|	497	hz					|	746	hz			|
;|	10	|	170	hz					|	344	hz					|	517	hz			|
;|	11	|	118	hz					|	236	hz					|	353	hz			|
;|==================================================================================|
;| For TI-83+ SE, TI-84+, TI-84+ SE and TI-84+ CSE									|
;|==================================================================================|
;| value | hardware timer 1 freq	| hardware timer 2 freq		| both enabled		|				|
;|==================================================================================|
;|	00	|	512	hz					|	1024 hz					|	1536 hz			|
;|	01	|	227.55 hz				|	455.11 hz				|	682.66 hz		|
;|	10	|	146.29 hz				|	292.57 hz				|	438.86 hz		|
;|	11	|	107.79 hz				|	215.58 hz				|	323.37 hz		|
;|==================================================================================|
; When writing to this port, bit 3 is unused.
; When writing to this port, bit 4 is unused.
; When writing to this port, bit 5 is unused.
; When writing to this port, bit 6 and bit 7 are used to configure voltage cutoff
; for bit 0 of port $02 and to determine battery state; unless you need to, keep those
; 2 bits to zero, and let the OS do this job (it has a routine to check batteries).
;|======================================================|
;| For TI-83+ BASIC										|
;|======================================================|
;|	00	|	No function									|
;|	01	|	No function									|
;|	10	|	No function									|
;|	11	|	No function									|
;|======================================================|
;| For TI-83+ SE (Only uses bit 7)						|
;|======================================================|
;|	00	|	Not sure..									|
;|	01	|	Not sure..									|
;|	10	|	Not sure..									|
;|	11	|	Not sure..									|
;|======================================================|
;| For TI-84+ and TI-84+ SE								|
;|======================================================|
;|	00	|	Not used									|
;|	01	|	Measures if batteries are removed (0v)		|
;|	10	|	Not used									|
;|	11	|	Measures if batteries are present but 'low'	|
;|======================================================|
;| For TI-84+ CSE 										|
;|======================================================|
;|	00	|	Not sure..									|
;|	01	|	Not sure..									|
;|	10	|	Not sure..									|
;|	11	|	Not sure..									|
;|======================================================|

MEM_MAP_PORT					EQU $04
; Memory map control port.
; Reset bit 0 to select memory map mode 0.
; Set bit 0 to select memory map mode 1.
; In mode 0, RAM and ROM is mapped to CPU memory as follow:
;|==============================================================|
;| For TI-83+ BASIC												|
;|==============================================================|
;| 0000h ~ 3FFFh | ROM Page 0									|
;| 4000h ~ 7FFFh | Memory Bank A (Page selected in port $06)	|
;| 8000h ~ BFFFh | Memory Bank B (Page selected in port $07)	|
;| C000h ~ FFFFh | RAM Page 0									|
;|==============================================================|
;| For TI-83+ SE, TI-84+, TI-84+ SE and TI-84+ CSE				|
;|==============================================================|
;| 0000h ~ 3FFFh | ROM Page 0									|
;| 4000h ~ 7FFFh | Memory Bank A (Page selected in port $06)	|
;| 8000h ~ BFFFh | Memory Bank B (Page selected in port $07)	|
;| C000h ~ FFFFh | (Page selected in port $05)					|
;|==============================================================|
; In mode 1, RAM and ROM is mapped to CPU memory as follow:
;|==============================================================================|
;| For TI-83+ BASIC																|
;|==============================================================================|
;| 0000h ~ 3FFFh | ROM Page 0													|
;| 4000h ~ 7FFFh | Memory Bank A, even page (value of port $06 ANDed with FEh)	|
;| 8000h ~ BFFFh | Memory Bank A (Page selected in port $06)					|
;| C000h ~ FFFFh | Memory Bank B (Page selected in port $07)					|
;|==============================================================================|
;| For TI-83+ SE, TI-84+, TI-84+ SE and TI-84+ CSE								|
;|==============================================================================|
;| 0000h ~ 3FFFh | ROM Page 0													|
;| 4000h ~ 7FFFh | Memory Bank A, even page (value of port $06 ANDed with FEh)	|
;| 8000h ~ BFFFh | Memory Bank A, odd page (value of port $06 ORed with 1)		|
;| C000h ~ FFFFh | Memory Bank B (Page selected in port $07)					|
;|==============================================================================|
; For TI-83+, switching to memory map mode 1 is a way to execute code beyond C000h

LINK_AST_PORT					EQU $05
; For TI-83+ only, this port is used to read the last byte the link assist received.
; When link assist is active (you can enable it using link port $00)
; Your calculator can receive byte(s) from another calculator or a PC
; This port is used to read bytes from link assist
; However, use link port $00 to know if link assist is currently receiving data or that it has a complete byte for this port

RAM_PAGING_PORT					EQU $05
; This port can be use to control what RAM page is paged into the C000h-FFFFh memory bank.
; It can only map RAM pages, not Flash pages.
; For TI-83+ SE and TI-84+ Family, reading from this port, it returns the current RAM page.
; For TI-83+ SE and TI-84+ Family, writing to this port, sets the current RAM page, by giving a value in 00h-07h, inclusive.
; For TI-83+ BASIC, writing to this port, affects which bits of port $16 are acted on.
; For TI-83+ BASIC, only bit 0, bit 1 and bit 2 are considered for port $16.
; For TI-83+ BASIC, this port configures which memory pages are locked or unlocked (whether or not the PC register allowed to point within the page)
; In the table below, 'X' indicates the bit is ignored:
;|======================================================================================|
;| For TI-83+ BASIC																		|
;|======================================================================================|
;| Port $05 Bit			| Port $16 Bit													|
;|	2	|	1	|	0	|	7	|	6	|	5	|	4	|	3	|	2	|	1	|	0	|
;|======================================================================================|
;|	0	|	0	|	0	|ROM 0F	|ROM 0E	|ROM 0D	|ROM 0C	|ROM 0B	|ROM 0A	|ROM 09	|ROM 08	| 
;|	0	|	0	|	1	|ROM 17	|ROM 16	|ROM 15	|ROM 14	|ROM 13	|ROM 12	|ROM 11	|ROM 10	| 
;|	0	|	1	|	0	|	X	|	X	|	X	|	X	|ROM 1B	|ROM 1A	|ROM 19	|ROM 18	| 
;|	1	|	1	|	1	|	X	|	X	|RAM 01	|	X	|	X	|	X	|	X	|RAM 00	| 
;|======================================================================================|

MEM_PAGE_A_PORT					EQU $06
; This port controls what page is swapped into memory bank A.
; Note: For TI-84+ CSE, port $0E also affect MemA.
; For TI-83+ BASIC, when reading from this port, if a RAM page is swapped in, it returns the RAM page number with bit 6 set.
; For TI-83+ BASIC, when reading from this port, if a ROM page is swapped in, it returns the ROM page number with bit 6 reset.
; For TI-83+ SE and TI-84+ Family, when reading from this port, if a RAM page is swapped in, it returns the RAM page number with bit 7 set.
; For TI-83+ SE and TI-84+ Family, when reading from this port, if a ROM page is swapped in, it returns the ROM page number with bit 7 reset.
; For TI-83+ BASIC, writing to this port with bit 6 set, bit 0 will choose between the two RAM pages (40h or 41h).
; For TI-83+ BASIC, writing to this port with bit 6 reset, bits 0 ~ 4 select a page from ROM (00h through 1Fh).
; For TI-83+ SE and TI-84+ Family, writing to this port with bit 7 set, bits 0 ~ 2 will chose any of the 8 RAM pages (80h through 87h).
; For TI-83+ SE, writing to this port with bit 7 reset, bits 0 ~ 6 will select a page from ROM (00h through 7Fh).
; For TI-84+ Family, writing to this port with bit 7 reset, bits 0 ~ 5 will select a page from ROM (00h through 3Fh).

MEM_PAGE_B_PORT					EQU $07
; This port controls what page is swapped into memory bank B.
; Note: For TI-84+ CSE, port $0F also affects MemB.
; For TI-83+ BASIC, when reading from this port, if a RAM page is swapped in, it returns the RAM page number with bit 6 set.
; For TI-83+ BASIC, when reading from this port, if a ROM page is swapped in, it returns the ROM page number with bit 6 reset.
; For TI-83+ SE and TI-84+ Family, when reading from this port, if a RAM page is swapped in, it returns the RAM page number with bit 7 set.
; For TI-83+ SE and TI-84+ Family, when reading from this port, if a ROM page is swapped in, it returns the ROM page number with bit 7 reset.
; For TI-83+ BASIC, writing to this port with bit 6 set, bit 0 will choose between the two RAM pages (40h or 41h).
; For TI-83+ BASIC, writing to this port with bit 6 reset, bits 0 ~ 4 select a page from ROM (00h through 1Fh).
; For TI-83+ SE and TI-84+ Family, writing to this port with bit 7 set, bits 0 ~ 2 will chose any of the 8 RAM pages (80h through 87h).
; For TI-83+ SE, writing to this port with bit 7 reset, bits 0 ~ 6 will select a page from ROM (00h through 7Fh).
; For TI-84+ Family, writing to this port with bit 7 reset, bits 0 ~ 5 will select a page from ROM (00h through 3Fh).

;LINK_AST_PORT					EQU $08
; This port controls whether the hardware link assist is enabled.
; This port also controls what interrupts the link assist will generate.
; Note: For TI-83+ SE and TI-84+ only.
; TODO: COMPLETE..

;link assist enable ? $08
;link assist status ? or cpu speed 0 signaling rate ? $09
;link assist input buffer ? or cpu speed 1 signaling rate ? $0A
;cpu speed 2 signaling rate $0B
;cpu speed 3 signaling rate $0C
;link assist output buffer $0D
;memA high flash address $0E
;memB high flash address $0F
LCD_CMD_PORT					EQU $10
LCD_DATA_PORT					EQU $11
LCD_CMD_MIRR_PORT				EQU $12
LCD_DATA_MIRR_PORT				EQU $13
;flash control $14
;asic version $15
;flash page exclusion $16
;nothing ? $17
;md5 calculation $18 - $1F
CPU_SPEED_PORT					EQU $20
;flash size / ram size $21
;flash lower limit $22
;flash upper limit $23
;flash execution limits high bit $24
;ram execution lower limit $25
;ram execution upper limit $26
;block memory mapping C000h $27
;block memory mapping 8000h $28
;lcd delay 6mhz $29
;lcd delay 15mhz $2A
;lcd delay 15mhz(2) $2B
;lcd delay 15mhz(3) $2C
;32768hz crystal control $2D
;memory access delay $2E
;lcd wait delay $2F
;timers $30 - $38
;GPIO configuration $39
;GPIO read/write $3A
;clock control $40
;clock set $41 - $44
;clock read $45 - $48
;D-Control $4A
;USB controller status $4C
;USB line state $4D
;USB controller control $54
;USB interrupt state $55
;USB line events $56
;USB line event mask $57
;USB presentation link port mirroring enable $5A
;USB protocol interrupt enable $5B
;$40 - $5F mirrors $60 - $7F
;USB device address $80
;nothing ? $81
;USB write-pipe events $82
;USB write-pipe events (continued) $83
;USB read-pipe events $84
;USB read-pipe events (continued) $85
;USB misc events $86
;USB output-enabled pipes $87
;USB output-enabled pipes (continued) $88
;USB input-enabled pipes $89
;USB input-enabled pipes (continued) $8A
;USB events mask $8B
;USB frame counter $8C - $8D
;USB pipe number $8E
;VBus control $8F
;USB write packet size $90
;USB write command/status $91
;nothing ? $92
;USB read packet size $93
;nothing ? $94
;nothing ? $95
;USB data-received counter $96
;nothing ? $97
;USB write endpoint type/address $98
;nothing ? $99
;USB read endpoint type/address $9A
.LIST

;========================================
;       RESET KEYPAD STATE				;
;   INPUT   NONE            			;
;   OUTPUT  NONE            			;
;========================================
ResetKeypadState:
	LD A, KEYBOARD_RST_MASK
	OUT (KEYBOARD_PORT), A
	RET

.end
