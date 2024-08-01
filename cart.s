.segment "HEADER"
	.byte "NES"		;identification string
	.byte $1A
	.byte $02		;amount of PRG ROM in 16K units
	.byte $01		;amount of CHR ROM in 8K units
	.byte $00		;mapper and mirroing
	.byte $00, $00, $00, $00
	.byte $00, $00, $00, $00, $00

.segment "ZEROPAGE"
VAR:	.RES 1	;reserves 1 byte of memory for a variable named VAR
loading_count:	.RES 1	
loading_state:	.RES 1	

.segment "CODE"

RESET:
	SEI 		;disables interupts
	CLD			;turn off decimal mode
	
	LDX #%1000000	;disable sound IRQ
	STX $4017
	LDX #$00
	STX $4010		;disable PCM
	
	;initialize the stack register
	LDX #$FF
	TXS 		;transfer x to the stack
	
	; Clear PPU registers
	LDX #$00
	STX $2000
	STX $2001
	
	;WAIT FOR VBLANK
:
	BIT $2002
	BPL :-
	
	;CLEARING 2K MEMORY
	TXA
CLEARMEMORY:		;$0000 - $07FF
	STA $0000, X
	STA $0100, X
	STA $0300, X
	STA $0400, X
	STA $0500, X
	STA $0600, X
	STA $0700, X
		LDA #$FF
		STA $0200, X
		LDA #$00
	INX
	CPX #$00
	BNE CLEARMEMORY

	;WAIT FOR VBLANK
:
	BIT $2002
	BPL :-
	
	;SETTING SPRITE RANGE
	LDA #$00
	STA $4014
	NOP
	
	LDA #$3F	;$3F00
	STA $2006
	LDA #$00
	STA $2006
	
	LDX #$00
LOADPALETTES:
	LDA PALETTEDATA, X
	STA $2007
	INX
	CPX #$20
	BNE LOADPALETTES



;LOADING BACKGROUND
	
LOADBACKGROUND:
	LDA $2002		;read PPU status to reset high/low latch
	LDA #$20
	STA $2006
	LDA #$00
	STA $2006
	LDX #$00
LOADBACKGROUNDP1:
	LDA BACKGROUNDDATA, X
	STA $2007
	INX
	CPX #$00
	BNE LOADBACKGROUNDP1
LOADBACKGROUNDP2:
	LDA BACKGROUNDDATA+256, X
	STA $2007
	INX
	CPX #$00
	BNE LOADBACKGROUNDP2

LOADBACKGROUNDP3:
	LDA BACKGROUNDDATA+512, X
	STA $2007
	INX
	CPX #$00
	BNE LOADBACKGROUNDP3

LOADBACKGROUNDP4:
	LDA BACKGROUNDDATA+768, X
	STA $2007
	INX
	CPX #$00
	BNE LOADBACKGROUNDP4

	;RESET SCROLL
	LDA #$00
	STA $2005
	STA $2005	
	
;ENABLE INTERUPTS
	CLI
	
	LDA #%10010000
	STA $2000			;WHEN VBLANK OCCURS CALL NMI
	
	LDA #%00001010		
	STA $2001

;	LDA #%00011110
;  STA $2001

; initialize variables

	LDA #$01
	STA loading_count
	STA loading_state


	INFLOOP:
		JMP INFLOOP
NMI:

	LDX loading_count
	INX
	STX loading_count
	CPX #$1E ; looped 30 times
	BNE NOTDONE
	LDA #$00
	STA loading_count ; reset count
	LDX loading_state
	INX
	STX loading_state	
	CPX #$04 ; looped 4 times
	BNE NOTDONE
	LDX #$00
	STX loading_state ; reset state

NOTDONE:

	; changing loading state
	LDA #$22
	STA $2006
	LDA #$46
	STA $2006
	LDA loading_state
	CLC
	ADC #$84
	STA $2007

	;RESET SCROLL
	LDA #$00
	STA $2005
	STA $2005
	
	;LDA #$02	;LOAD SPRITE RANGE
	;STA $4014

	RTI

PALETTEDATA:
	.incbin "bg-palette.dat"
	.incbin "bg-palette.dat"

BACKGROUNDDATA:	;1024 BYTES
	.incbin "tileset.dat"

MICROCONTROLLER_DATA:
	.incbin "microcontroller.dat"

.segment "VECTORS"
	.word NMI
	.word RESET
	; specialized hardware interurpts

.segment "CHRROM"
  .incbin "rom.chr"
