;Variables------------------------------------------------------------------------
b_state   = $c1
o_state   = b_state + 1
l_state   = o_state + 1
b_state2   = l_state + 1
o_state2   = b_state2 + 1
l_state2   = o_state2 + 1
song_num  = l_state2 + 1
play_mode = song_num + 1
song_max = play_mode + 1

;HEADER----------------------------------------------------------------------------
          .ORG $7ff0
Header: .DB "NES", $1a
	.DB $02                 ; size of PRG ROM in 16kb units
	.DB $01			; size of CHR ROM in 8kb units
	.DB #%00000000		; mapper 0
	.DB #%00000000		; mapper 0
        .DB $00
        .DB $00
        .DB $00
        .DB $00
        .DB $00
        .DB $00
        .DB $00
        .DB $00
        
;NSF------------------------------------------------------------------------------
        .org LoadAddy
        .incbin "temp.nsf"

;RESET-----------------------------------------------------------------------------
        .org $fa00
Reset:
        SEI
        CLD
	LDX #$00
	STX $2000
	STX $2001
	DEX
	TXS
  	LDX #0
  	TXA
ClearMemory:
	STA 0, X
	STA $100, X
	STA $200, X
	STA $300, X
	STA $400, X
	STA $500, X
	STA $600, X
	STA $700, X
        STA $800, X
        STA $900, X
        INX
	BNE ClearMemory

;WARM UP----------------------------------------------------
	LDX #$02
WarmUp:
	BIT $2002
	BPL WarmUp
	DEX
	BNE WarmUp

       	LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
        TAX
LoadPal:                        ; load palette
        LDA palette, x
        STA $2007
        INX
        CPX #$20
        BNE LoadPal

	LDA #$20
	STA $2006
	LDA #$00
	STA $2006

	LDY #$04                ; clear nametables
ClearName:
	LDX #$00
	LDA #$00
PPULoop:
	STA $2007
	DEX
	BNE PPULoop
	DEY
	BNE ClearName

        lda #$20
        sta $2006
        lda #$82
        sta $2006
        ldx #$00
write_text:
        lda text,x
        cmp #$0d
        beq goto_vblank
        sta $2007
        INX
        JMP write_text
        
goto_vblank:
	JSR InitMusic
	JSR InitSprites
        JSR Vblank