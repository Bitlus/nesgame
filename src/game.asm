  .inesprg 1   ; 1x 16KB PRG code
  .ineschr 1   ; 1x  8KB CHR data
  .inesmap 0   ; mapper 0 = NROM, no bank swapping
  .inesmir 1   ; background mirroring
  

;;;;;;;;;;;;;;;

  .rsset $0000
isWalking .rs 1
bg_ptr_lo .rs 1 ; bg pointer low byte
bg_ptr_hi .rs 1 ; bg pointer high byte
    
  .bank 0
  .org $C000 
RESET:
  SEI          ; disable IRQs
  CLD          ; disable decimal mode
  LDX #$40
  STX $4017    ; disable APU frame IRQ
  LDX #$FF
  TXS          ; Set up stack
  INX          ; now X = 0
  STX $2000    ; disable NMI
  STX $2001    ; disable rendering
  STX $4010    ; disable DMC IRQs

vblankwait1:       ; First wait for vblank to make sure PPU is ready
  BIT $2002
  BPL vblankwait1

clrmem:
  LDA #$00
  STA $0000, x
  STA $0100, x
  STA $0300, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0200, x    ;move all sprites off screen
  INX
  BNE clrmem
   
vblankwait2:      ; Second wait for vblank, PPU is ready after this
  BIT $2002
  BPL vblankwait2


LoadPalettes:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006             ; write the high byte of $3F00 address
  LDA #$00
  STA $2006             ; write the low byte of $3F00 address
  LDX #$00              ; start out at 0
LoadPalettesLoop:
  LDA palette, x        ; load data from address (palette + the value in x)
  STA $2007             ; write to PPU
  INX                   ; X = X + 1
  CPX #$20              ; Compare X to hex $10, decimal 16 - copying 16 bytes = 4 sprites
  BNE LoadPalettesLoop  ; Branch to LoadPalettesLoop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down

LoadSprites:
  LDX #$00              ; start at 0
LoadSpritesLoop:
  LDA sprites, x        ; load data from address (sprites +  x)
  STA $0200, x          ; store into RAM address ($0200 + x)
  INX                   ; X = X + 1
  CPX #$20              ; Compare X to hex $20, decimal 32
  BNE LoadSpritesLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down

LoadBackground:
  LDA $2002       ; reset high/low latch
  LDA #$20
  STA $2006       ; write high byte
  LDA #$00
  STA $2006       ; write low byte

  ; set up pointer to bg
  LDA #LOW(background) ; #$00
  STA bg_ptr_lo  ; put low byte of bg into pointer
  LDA #HIGH(background)
  STA bg_ptr_hi   ; put high byte into pointer

  LDX #$04
  LDY #$00
LoadBackgroundLoop:
  LDA [bg_ptr_lo], y ; one byte from address + y
  STA $2007
  INY                 ; increment inner loop counter
  BNE LoadBackgroundLoop 
  INC bg_ptr_hi
  DEX 
  BNE LoadBackgroundLoop
      
LoadAttribute:
 CLC
 LDA $2002              ; read PPU status to reset the high/low latch
 LDA #$23
 STA $2006              ; write the high byte of $23C0 address
 LDA #$C0
 STA $2006              ; write the low byte of $23C0 address
 LDX #$00               ; start out at 0
LoadAttributeLoop:
 LDA attribute, x       ; load data from address (attribute + the value in x)
 STA $2007              ; write to PPU
 INX                    ; X = X + 1
 CPX #$40               ; Compare X to hex $40, decimal 64
 BNE LoadAttributeLoop  ; Branch to LoadAttributeLoop if compare was Not Equal to zero
                        ; if compare was equal to 64, keep going down

						
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000

  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001

  LDA #$00         ; set PPUSCROLL x and y coords
  STA $2005        ; x
  STA $2005        ; y

Forever:
  JMP Forever     ;jump back to Forever, infinite loop
  
 

NMI:
  LDA #$00
  STA $2003       ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014       ; set the high byte (02) of the RAM address, start the transfer


  ; Set is walking flag
  LDA #$00
  STA isWalking

LatchController:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016       ; tell both the controllers to latch buttons


ReadA: 
  LDA $4016       ; player 1 - A
  AND #%00000001  ; only look at bit 0
  BEQ ReadADone   ; branch to ReadADone if button is NOT pressed (0)
                  ; add instructions here to do something when button IS pressed (1)
ReadADone:        ; handling this button is done
  

ReadB: 
  LDA $4016       ; player 1 - B
  AND #%00000001  ; only look at bit 0
  BEQ ReadBDone   ; branch to ReadBDone if button is NOT pressed (0)
ReadBDone:        ; handling this button is done

ReadSelect:
  LDA $4016
  AND #%00000001       ; only look at bit 0
  BEQ ReadSelectDone   ; branch to ReadBDone if button is NOT pressed (0)
ReadSelectDone:

ReadStart:
  LDA $4016
  AND #%00000001      ; only look at bit 0
  BEQ ReadStartDone   ; branch to ReadBDone if button is NOT pressed (0)
ReadStartDone:

ReadUp:
  LDA $4016
  AND #%00000001   ; only look at bit 0
  BEQ ReadUpDone   ; branch to ReadBDone if button is NOT pressed (0)

  ; Set isWalking flag
  LDA #$01
  STA isWalking

  ; Change player sprite direction
  LDA #%00000000 ; Set to not flip horizontal
  STA $0202
  STA $020A
  LDA #%01000000 ; Set to flip horizontal
  STA $0206
  STA $020E

  ; Set correct sprite tiles
  LDA #$23
  STA $0201
  LDA #$23
  STA $0205
  LDA #$33
  STA $0209
  LDA #$33
  STA $020D

  ; Update player sprites Y positions
  LDX #$00
MoveUpLoop:
  LDA $0200, X
  SEC
  SBC #$01
  STA $0200, X
  TXA
  CLC
  ADC #$04
  TAX
  CPX #$10 ; compare X to 16
  BNE MoveUpLoop

ReadUpDone:

ReadDown:
  LDA $4016
  AND #%00000001     ; only look at bit 0
  BEQ ReadDownDone   ; branch to ReadBDone if button is NOT pressed (0)

  ; Set isWalking flag
  LDA #$01
  STA isWalking

  ; Change player sprite direction
  LDA #%00000000 ; Set to not flip horizontal
  STA $0202
  STA $020A
  LDA #%01000000 ; Set to flip horizontal
  STA $0206
  STA $020E

  ; Set correct sprite tiles
  LDA #$22
  STA $0201
  LDA #$22
  STA $0205
  LDA #$32
  STA $0209
  LDA #$32
  STA $020D

  LDX #$00
MoveDownLoop:
  LDA $0200, X
  CLC
  ADC #$01
  STA $0200, X
  TXA
  CLC
  ADC #$04
  TAX
  CPX #$10 ; compare X to 16
  BNE MoveDownLoop

ReadDownDone:

ReadLeft:
  LDA $4016
  AND #%00000001     ; only look at bit 0
  BEQ ReadLeftDone   ; branch to ReadBDone if button is NOT pressed (0)

  ; Set isWalking flag
  LDA #$01
  STA isWalking

  ; Change player sprite direction
  LDA #%01000000 ; Set flip horizontal
  STA $0202
  STA $0206
  STA $020A
  STA $020E

  ; Set correct sprite tiles
  LDA #$01
  STA $0201
  LDA #$00
  STA $0205
  LDA #$11
  STA $0209
  LDA #$10
  STA $020D
  

  LDX #$00
MoveLeftLoop:
  LDA $0203, X
  SEC
  SBC #$01
  STA $0203, X
  TXA
  CLC
  ADC #$04
  TAX
  CPX #$10 ; compare X to 16
  BNE MoveLeftLoop

ReadLeftDone:

ReadRight:
  LDA $4016
  AND #%00000001      ; only look at bit 0
  BEQ ReadRightDone   ; branch to ReadBDone if button is NOT pressed (0)

  ; Set isWalking flag
  LDA #$01
  STA isWalking
  
  ; Change player sprite direction
  LDA #%00000000 ; Set to not flip horizontal
  STA $0202
  STA $0206
  STA $020A
  STA $020E

  ; Set correct sprite tiles
  LDA #$00
  STA $0201
  LDA #$01
  STA $0205
  LDA #$10
  STA $0209
  LDA #$11
  STA $020D

  LDX #$00
MoveRightLoop:
  LDA $0203, X
  CLC
  ADC #$01
  STA $0203, X
  TXA
  CLC
  ADC #$04
  TAX
  CPX #$10 ; compare X to 16
  BNE MoveRightLoop

ReadRightDone:

IdleSprite:
  LDA isWalking
  CMP #$00
  JMP IdleSpriteDone

  ; Change player sprite direction
  LDA #%00000000 ; Set to not flip horizontal
  STA $0202
  STA $020A
  LDA #%01000000 ; Set to flip horizontal
  STA $0206
  STA $020E

  ; Set correct sprite tiles
  LDA #$22
  STA $0201
  STA $0205
  LDA #$32
  STA $0209
  STA $020D

IdleSpriteDone:
  
  RTI             ; return from interrupt
 
;;;;;;;;;;;;;;  
  

  .bank 1
  .org $E000
palette:
  ; background palettes
  .db $0F,$07,$17,$37 ; 00
  .db $01,$0F,$17,$37 ; 01
  .db $0F,$1A,$1C,$3A ; 10
  .db $3C,$3D,$3E,$0F ; 11
  
  ; sprite palettes
  .db $0C,$1c,$15,$14 ; 00
  .db $31,$02,$38,$3c ; 01
  .db $22,$29,$1A,$0F ; 10
  .db $22,$36,$17,$0F ; 11

background:

  .db $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF  ;  0 not seen
  .db $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF  ;  1
  .db $FF,$0C,$0E,$0D, $04,$18,$FF,$24, $1E,$1C,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF  ;  2
  .db $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF  ;  3

  .db $FF,$25,$26,$26, $26,$26,$26,$26, $26,$26,$26,$26, $26,$2D,$3D,$2D, $3D,$2D,$3D,$26, $26,$26,$26,$26, $26,$26,$26,$26, $26,$26,$25,$FF  ;  4
  .db $FF,$27,$28,$29, $2A,$2B,$2A,$2B, $2A,$2B,$2A,$2B, $2A,$2B,$2A,$2C, $3C,$3A,$3B,$3A, $3B,$3A,$3B,$3A, $3B,$3A,$3B,$3A, $29,$38,$27,$FF  ;  5
  .db $FF,$27,$2F,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$41,$27,$FF  ;  6
  .db $FF,$27,$30,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$3A,$27,$FF  ;  7
                                                                                                                                 
  .db $FF,$27,$2F,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$41,$27,$FF  ;  8
  .db $FF,$27,$30,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$43,$27,$FF  ;  9
  .db $FF,$27,$2F,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$41,$27,$FF  ; 10
  .db $FF,$27,$30,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$43,$27,$FF  ; 11
                                                                                                                                 
  .db $FF,$2E,$2F,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$41,$2E,$FF  ; 12
  .db $FF,$3E,$2F,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$41,$3E,$FF  ; 13
  .db $FF,$2E,$2F,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$41,$2E,$FF  ; 14
  .db $FF,$3E,$3F,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$42,$3E,$FF  ; 15
                                                                                                                                 
  .db $FF,$2E,$2F,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$41,$2E,$FF  ; 16
  .db $FF,$3E,$2F,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$41,$3E,$FF  ; 17
  .db $FF,$2E,$2F,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$41,$2E,$FF  ; 18
  .db $FF,$3E,$3F,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$42,$3E,$FF  ; 19
                                                                                                                                 
  .db $FF,$27,$46,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$48,$27,$FF  ; 20
  .db $FF,$27,$2F,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$41,$27,$FF  ; 21
  .db $FF,$27,$40,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$44,$27,$FF  ; 22
  .db $FF,$27,$2F,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$41,$27,$FF  ; 23
                                                                                                                                 
  .db $FF,$27,$40,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$44,$27,$FF  ; 24
  .db $FF,$27,$2F,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$32,$33,$31, $32,$33,$31,$32, $33,$31,$32,$33, $31,$41,$27,$FF  ; 25
  .db $FF,$27,$38,$45, $46,$47,$46,$47, $46,$47,$46,$47, $46,$45,$45,$45, $45,$45,$46,$45, $49,$48,$49,$48, $49,$48,$49,$48, $45,$28,$27,$FF  ; 26
  .db $FF,$25,$26,$26, $26,$26,$26,$26, $26,$26,$26,$26, $26,$2D,$3D,$2D, $3D,$2D,$3D,$26, $26,$26,$26,$26, $26,$26,$26,$26, $26,$26,$25,$FF  ; 27

  .db $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF  ; 28 last row
  .db $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF  ; 29
  .db $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF  ; 30
  .db $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF, $FF,$FF,$FF,$FF  ; 31

attribute:
; Burbl Turtl
;      BRBLTRTL   BRBLTRTL   BRBLTRTL   BRBLTRTL   BRBLTRTL   BRBLTRTL   BRBLTRTL   BRBLTRTL
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000 ;  0-3
  .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ;  4-7
  .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ;  8-11
  .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ; 12-15
  .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ; 16-19
  .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ; 20-23
  .db %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101, %01010101 ; 24-27
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000 ; 28-31
;      BRBLTRTL   BRBLTRTL   BRBLTRTL   BRBLTRTL   BRBLTRTL   BRBLTRTL   BRBLTRTL   BRBLTRTL

sprites:
     ;vert tile attr horiz
  .db $80, $02, $00, $80   ;sprite 0
  .db $80, $03, $00, $88   ;sprite 1
  .db $88, $12, $00, $80   ;sprite 2
  .db $88, $13, $00, $88   ;sprite 3

  .org $FFFA     ;first of the three vectors starts here
  .dw NMI        ;when an NMI happens (once per frame if enabled) the 
                   ;processor will jump to the label NMI:
  .dw RESET      ;when the processor first turns on or is reset, it will jump
                   ;to the label RESET:
  .dw 0          ;external interrupt IRQ is not used in this tutorial
  
  
;;;;;;;;;;;;;;  
  
  
  .bank 2
  .org $0000
  .incbin "cowboy.chr"   ;includes 8KB graphics file from SMB1
