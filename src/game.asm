  .inesprg 1   ; 1x 16KB PRG code
  .ineschr 1   ; 1x  8KB CHR data
  .inesmap 0   ; mapper 0 = NROM, no bank swapping
  .inesmir 1   ; background mirroring
  

;;;;;;;;;;;;;;;

  .rsset $0000
isWalking .rs 1
animationCounter .rs 1
weedFrame .rs 1
playerAnimationCounter .rs 1
playerFrame .rs 1
    
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
  STA $0200, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0300, x
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
                          ; 1st time through loop it will load palette+0
                          ; 2nd time through loop it will load palette+1
                          ; 3rd time through loop it will load palette+2
                          ; etc
  STA $2007             ; write to PPU
  INX                   ; X = X + 1
  CPX #$20              ; Compare X to hex $10, decimal 16 - copying 16 bytes = 4 sprites
  BNE LoadPalettesLoop  ; Branch to LoadPalettesLoop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down

;LoadBackground:
;LDA $2002               ; read PPU status to reset the high/low latch
;LDA #$20
;STA $2006               ; write the high byte of $2000 address
;LDA #$00
;STA $2006               ; write the low byte of $2000 address
;LDX #$00                 ; starting loop counter at 0
;LoadBackgroundLoop:
;LDA background, x       ; load data from address background + value in x
;STA $2007               ; write data to PPU
;INX                     ; increment x
;CPX #$80                ; while x != $80, load the next background value
;BNE LoadBackgroundLoop

;LoadAttribute:
;LDA $2002               ; read PPU status to reset the high/low latch
;LDA #$23
;STA $2006               ; write write the high byte of $2300 addy
;LDA #$00
;STA $2006               ; write the lowe byte of $2300 addy
;LDX #$00                ; starting loop counter at 0
;LoadAttributeLoop:
;LDA attribute, x        ; load data from addy + x
;STA $2007               ; write data to PPU
;INX                     ; increment loop counter
;CPX #$08                ; while x != $08, load next value
;BNE LoadAttributeLoop

LoadSprites:
  LDX #$00              ; start at 0
LoadSpritesLoop:
  LDA sprites, x        ; load data from address (sprites +  x)
  STA $0200, x          ; store into RAM address ($0200 + x)
  INX                   ; X = X + 1
  CPX #$20              ; Compare X to hex $20, decimal 32
  BNE LoadSpritesLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down
              

  LDA #%10000000   ; enable NMI, sprites from Pattern Table 1
  STA $2000

  LDA #%00010000   ; enable sprites
  STA $2001

InitVariables:
  LDA #$00
  STA animationCounter
  STA weedFrame
  STA playerAnimationCounter
  STA playerFrame

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
  LDA #$21
  STA $0201
  LDA #$21
  STA $0205
  LDA #$31
  STA $0209
  LDA #$31
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
  LDA #$20
  STA $0201
  LDA #$20
  STA $0205
  LDA #$30
  STA $0209
  LDA #$30
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

  JMP LeftAnimation
  
InitLeftLoop:
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
  
  JMP RightAnimation

InitRightLoop:
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

AnimationFile:
  .include "animation.asm"


ReturnFromInterrupt:
  RTI             ; return from interrupt

PlayerAnimationFile:
  .include "player-animation.asm"
 
;;;;;;;;;;;;;;  
  
  
  
  .bank 1
  .org $E000
palette:
  .db $0F,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$0F
  .db $2D,$2C,$0C,$30,$31,$02,$38,$3C,$0F,$1C,$15,$14,$31,$02,$38,$3C

;background:
;  .db 

;attribute:
;  .db

sprites:
     ;vert tile attr horiz
  .db $80, $02, $00, $80   ;sprite 0
  .db $80, $03, $00, $88   ;sprite 1
  .db $88, $12, $00, $80   ;sprite 2
  .db $88, $13, $00, $88   ;sprite 3

cactus:
  .db $10, $06, $00, $10   ;sprite 0
  .db $10, $07, $00, $18   ;sprite 1
  .db $18, $08, $00, $10   ;sprite 2
  .db $18, $09, $00, $18   ;sprite 3

tumbleWeedFrame1:
  .db $06, $07, $08, $09

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

