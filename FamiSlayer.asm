;       ----------------------------------------------------
;       FAMISLAYER v6.66
;       Copyright 2014 Dan Vujeva
;       For more information, visit: http://www.heavyw8bit.com
;       Shoutouts: Warper Party, Outback Nexus, IO Chip Crew
;       Credits: CHR file and some variables & subroutines are from Vegaplay by No Carrier (http://www.no-carrier.com)
;
;       This program is free software: you can redistribute it and/or modify
;       it under the terms of the GNU General Public License as published by
;       the Free Software Foundation, either version 3 of the License, or
;       (at your option) any later version.
;
;       This program is distributed in the hope that it will be useful,
;       but WITHOUT ANY WARRANTY; without even the implied warranty of
;       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;       GNU General Public License for more details.
;
;       You should have received a copy of the GNU General Public License
;       along with this program.  If not, see http://www.gnu.org/licenses
;
;       ----------------------------------------------------

;VARIABLES-------------------------------------------------------------------------------------------------------
LoadAddy = $a05c        ;NSF VARIABLES  (SAME AS VEGAPLAY)
InitAddy = $aa55
PlayAddy = $aa58

var_frame = $213        ;FAMITRACKER VARIABLES. MAY NEED TO ADJUST +-2 if FDS_Wave is enabled or not in the NSF
var_pos = var_frame + 1
var_newframe = var_pos + 1

        include "FamiSlayer_startup.asm"
        LDA #0
        STA song_num
        STA play_mode

        LDA #1          ;ADJUST FOR YOUR NSF. LDA #X WHERE X = (# OF SONGS - 1) EXAMPLE: LDA #1 = 2 Songs
        STA song_max

;MAIN LOOP--------------------------------------------------------------------------------------------------------
main_loop:
        LDA play_mode   ;CHECK IF PLAYING OR PAUSED/STOPPED
        BEQ chk_joy     ;IF PAUSED OR STOPPED ONLY READ CONTROLLER 1 INPUT

;CHECK CONTROLLER 2 FOR INCOMING SYNC PULSE-----------------------------------------------------------
        LDA b_state2    ;GET BUTTON STATE OF CONTROLLER 2
        STA o_state2    ;SAVE AS OLD STATE

chk_loop2               ;CHECK CONTROLLERS UNTIL IT GETS THE SAME READING TWICE
        LDA b_state2
        STA l_state2
        JSR check_joy2
        LDA b_state2
        CMP l_state2
        bne chk_loop2

        LDA b_state2    ;GET BUTTON STATE OF CONTROLLER 2
        CMP o_state2    ;CHECK IF OLD BUTTON STILL PRESSED
        BEQ chk_joy     ;IF OLD BUTTON IS STILL PRESSED THEN SKIP AND READ CONTROLLER 1

        LDA b_state2    ;GET BUTTON STATE OF CONTROLLER 2
        AND #%00001000  ;CHECK IF TRIGGER BUTTON IS PRESSED
        BEQ chk_joy     ;IF TRIGGER BUTTON NOT PRESSED THEN SKIP AND READ CONTROLLER 1
        JSR PlayAddy    ;RUN NEXT STEP OF NSF

;CHECK CONTROLLER 1 FOR USER INPUT---------------------------------------------------------------------
chk_joy
        LDA b_state     ;GET BUTTON STATE OF CONTROLLER 1
        STA o_state     ;SAVE AS OLD STATE
chk_loop
        LDA b_state     ;CHECK CONTROLLERS UNTIL IT GETS THE SAME READING TWICE
        STA l_state
        JSR check_joy
        LDA b_state
        CMP l_state
        bne chk_loop

        LDA b_state     ;CHECK IF ANY BUTTONS ARE PRESSED
        BEQ main_loop   ;IF NO BUTTON PRESSED THEN SKIP
        CMP o_state     ;CHECK IF OLD BUTTON IS STILL PRESSED
        BEQ main_loop   ;IF OLD BUTTON IS STILL PRESSED THEN SKIP
chk_a
        LDA b_state     ;A = PAUSE/PLAY TOGGLE
        AND #%00000001
        BEQ chk_b
        LDA play_mode
        EOR #1
        STA play_mode
        JMP main_loop

chk_b
        LDA b_state     ;B = STOP PLAYING
        AND #%00000010
        BEQ chk_up
        LDA #0
        STA play_mode
        JSR InitMusic
        JMP main_loop

chk_up
        LDA b_state     ;UP = INCREASE SONG#
        AND #%00010000
        BEQ chk_down
        LDA song_num
        CMP song_max
        BEQ chk_over
        INC song_num
        JSR InitMusic
        JSR ChangeSprite
        JMP main_loop

chk_down
        LDA b_state     ;Down = DECREASE SONG#
        AND #%00100000
        BEQ chk_left
        LDA song_num
        BEQ chk_over
        DEC song_num
        JSR ChangeSprite
        JSR InitMusic
        JMP main_loop

chk_left
        LDA b_state     ;LEFT = REWIND - reset to the beginig of the current frame
        AND #%01000000
        BEQ chk_right
        LDA #1
        STA var_pos
        JMP main_loop

chk_right
        LDA b_state     ;RIGHT = FAST FWD - skip to the beginig of the next frame
        AND #%10000000
        BEQ chk_start
        INC var_frame
        LDA #1
        STA var_pos
        STA var_newframe
        JMP main_loop

chk_start               ;START = RESTART SONG FROM BEGINING
        LDA b_state
        AND #%00001000
        BEQ chk_over
        LDA #0
        STA var_frame
        LDA #1
        STA var_pos
        STA var_newframe
        JSR InitMusic
chk_over
        JMP main_loop

        include "FamiSlayer_Functions.asm"

NMI:    pha             ;PUSH A, X, Y ONTO THE STACK
        txa
        pha
        tya
        pha
        JSR UpdateSprites
        pla             ;PULL Y, X, A FROM THE STACK
        tay
        pla
        tax
        pla
IRQ:    RTI

text:   .db "FAMISLAYER V6.66                "
        .db "                                "
        .db "@2014 HEAVYW8BIT CHAMPIONCHIP   "
        .db "                                "
        .db "                                "
        .db "SONG #",$0D

palette:
        .byte $0F,$20,$10,$06,$31,$21,$11,$01,$32,$22,$12,$02,$33,$23,$13,$03
        .byte $0F,$20,$10,$00,$31,$21,$11,$01,$32,$22,$12,$02,$33,$23,$13,$03

	.ORG $fffa
	.DW NMI
	.DW Reset
	.DW IRQ