;CHECK CONTROLLER 2-------------------------------------------------------
check_joy2:
        LDX #$08
	LDA #$01
	STA $4016
	LDA #$00
	STA $4016
joy_loop2:
	LDA $4017
	LSR
	ROR b_state2
        DEX
        BNE joy_loop2
        RTS

;CHECK CONTROLLER 1-------------------------------------------------------
check_joy
        LDX #$08
	LDA #$01
	STA $4016
	LDA #$00
	STA $4016

joy_loop:
	LDA $4016
	LSR
	ROR b_state
        DEX
        BNE joy_loop
        RTS

;-------------------------------------------------------------------------
;BELOW ARE ROUTINES FROM VEGAPLAY BY NO CARRIER
;SOME OF THE CODE HAS BEEN MODIFED FROM THE ORIGINAL
InitMusic:
	lda #$00
	ldx #$00
Clear_Sound:
	sta $4000,x
	inx
	cpx #$0F
	bne Clear_Sound

	lda #$10
	sta $4010
	lda #$00
	sta $4011
	sta $4012
	STA $4013

	lda #%00001111
	STA $4015

	lda #$C0
	STA $4017

	LDA song_num		; song number
	ldx #$00		; 00 for NTSC or $01 for PAL
	jsr InitAddy		; init address
        rts

;       ----------------------------------------------------
Vblank:
	BIT $2002
	BPL Vblank
        LDX #$00
        STX $2005
        STX $2005
	LDA #%10001000
	STA $2000
        LDA #%00011110
	STA $2001
        RTS
;       ----------------------------------------------------

InitSprites:
      LDA #$ff
      LDX #$00
ClearSprites:
      STA $500, x
      INX
      BNE ClearSprites

      LDA #$00
      STA $2003                 ; set the low byte (00) of the RAM address
      LDA #$05
      STA $4014                 ; set the high byte (05) of the RAM address

LoadSprites:
      LDX #$00
LoadSpritesLoop:
      LDA sprites, x            ; load data from address
      STA $0500, x              ; store into RAM address
      INX
      CPX #4
      BNE LoadSpritesLoop
      RTS

sprites:
           ;vert tile attr horiz
        .db $47, #49, $00, $40  ; sprite

;       ----------------------------------------------------

UpdateSprites:
        LDA #$00
        STA $2003
        LDA #$05
        STA $4014
        RTS

;       ----------------------------------------------------

ChangeSprite:
        LDA song_num
        ADC #48
        STA $0501
        RTS



