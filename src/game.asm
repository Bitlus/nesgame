  .inesprg 1   ; 1x 16KB PRG code
  .ineschr 1   ; 1x  8KB CHR data
  .inesmap 0   ; mapper 0 = NROM, no bank swapping
  .inesmir 1   ; background mirroring
  

;;;;;;;;;;;;;;;

  .rsset $0000
testing .rs 1
buttonsP1 .rs 1 ; player 1 controller data
buttonsP2 .rs 1 ; player 2 controller data
animationCounter .rs 1
playerAnimationCounter .rs 1
playerFrame .rs 1
bg_ptr_lo .rs 1 ; bg pointer low byte
bg_ptr_hi .rs 1 ; bg pointer high byte

bg_money_offset .rs 1 ; offset to money
money_thousands .rs 1 ; money counter for thousands
money_hundreds  .rs 1 ; money counter for hundreds
money_tens      .rs 1 ; money counter for tens
money_ones      .rs 1 ; money counter for ones

cam_x .rs 1 ; x camera PPUSCROLL
cam_y .rs 1 ; y camera PPUSCROLL

; Players
player_1_dir      .rs 1 ; player 1 direction
player_1_x        .rs 1 ; player 1 x
player_1_y        .rs 1 ; player 1 y
player_1_a_frame  .rs 1 ; player 1 animation frame
player_1_health   .rs 1 ; player 1 health
player_1_score    .rs 1 ; player 1 score
player_1_walking  .rs 1 ; player 1 is walking

player_2_dir      .rs 1 ; player 2 direction
player_2_x        .rs 1 ; player 2 x
player_2_y        .rs 1 ; player 2 y
player_2_a_frame  .rs 1 ; player 2 animation frame
player_2_health   .rs 1 ; player 2 health
player_2_score    .rs 1 ; player 2 score
player_2_walking  .rs 1

; Bullets
bullet_1_dir      .rs 1 ; bullet 1 direction
bullet_1_x        .rs 1 ; bullet 1 x coord
bullet_1_y        .rs 1 ; bullet 1 y coord

bullet_2_dir      .rs 1 ; bullet 2 direction
bullet_2_x        .rs 1 ; bullet 2 x coord
bullet_2_y        .rs 1 ; bullet 2 y coord

; misc constants
TRUE = $01
FALSE = $00

; Bullet constants
BULLET_VEL = $05
BULLET_OFFSET = $10

; Direction Enum
DEAD  = $0
UP    = $1
RIGHT = $2
DOWN  = $3
LEFT  = $4

ROOM_UP    = $22
ROOM_RIGHT = $F7
ROOM_DOWN  = $DF
ROOM_LEFT  = $08

BUTTON_A = $80
BUTTON_B = $40
BUTTON_SELECT = $20
BUTTON_START = $10
BUTTON_UP = $08
BUTTON_DOWN = $04
BUTTON_LEFT = $02
BUTTON_RIGHT = $01

P1_START_X = $29
P1_START_Y = $70
P2_START_X = $C7
P2_START_Y = $8D

PLAYER_TOP_BOUND = $20
PLAYER_BOT_BOUND = $D8
PLAYER1_LEFT_BOUND = $06
PLAYER1_RIGHT_BOUND = $59
PLAYER2_LEFT_BOUND = $97
PLAYER2_RIGHT_BOUND = $E9

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
  CPX #$28              ; Compare X to hex $28, decimal 40 to load 10 sprites
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

InitVariables:
  LDA #$00
  STA animationCounter
  STA playerAnimationCounter
  STA playerFrame
  STA cam_x
  STA cam_y
  STA money_thousands
  STA money_hundreds
  STA money_tens
  STA money_ones
  STA bullet_1_dir
  STA bullet_1_x
  STA bullet_1_y
  STA bullet_2_dir
  STA bullet_2_x
  STA bullet_2_y
  LDA #$88          ; 132 tiles from bg offset
  STA bg_money_offset
  LDA #RIGHT
  STA player_1_dir
  LDA #LEFT
  STA player_2_dir
  ; player positions
  LDA #P1_START_X
  STA player_1_x
  LDA #P2_START_X
  STA player_2_x
  LDA #P1_START_Y
  STA player_1_y
  LDA #P2_START_Y
  STA player_2_y

Forever:
  NOP
  JMP Forever     ;jump back to Forever, infinite loop
  
Subroutines:

IncrementMoney:
  CLC

  ; ones
;  LDA money_ones
;  ADC #$01
;  CMP #$0A                      ; if acc > 9, set to 0 and set the carry flag
;  BNE IM_ones_done
;  LDA #$00
;  SEC
;IM_ones_done:
;  STA money_ones

  ; tens
  LDA money_tens
;  BCC IM_tens_done
;  CLC
  ADC #$01
  CMP #$0A                      ; if acc > 9, set to 0 and set the carry flag
  BNE IM_tens_done
  LDA #$00
  SEC
IM_tens_done:
  STA money_tens                ; store acc in tens variable

  ; hundreds
  LDA money_hundreds
  BCC IM_hundreds_done          ; if carry flag is not clear, increment acc and clear the carry flag
  CLC
  ADC #$01
  CMP #$0A                      ; if acc > 9, set to 0 and set the carry flag
  BNE IM_hundreds_done
  LDA #$00
  SEC
IM_hundreds_done:
  STA money_hundreds

  ; thousands
  LDA money_thousands
  BCC IM_thousands_done         ; if carry flag is not clear, increment acc and clear the carry flag
  CLC
  ADC #$01
  CMP #$0A                      ; if acc > 9, set to 0 and write to tens and hundreds slots
  BNE IM_thousands_done
  LDA #$09
  STA money_ones
  STA money_tens
  STA money_hundreds
IM_thousands_done:
  STA money_thousands           ; store acc in thousands slot
  RTS


; draws money values into VRAM tile memory
DrawMoney:
  ; set initial address to $20xx
  LDX #$20
  LDY bg_money_offset

  STX $2006
  STY $2006

  LDA money_thousands
  STA $2007

  LDA money_hundreds
  STA $2007
  
  LDA money_tens
  STA $2007

  LDA money_ones
  STA $2007

  RTS

; loads cam values and writes PPUSCROLL with them
CameraScroll:
  LDX cam_x
  LDY cam_y
  STX $2005
  STY $2005
  RTS

; Moves bullet in the correct direction if it is not dead.
HandleBullet:
  LDA bullet_1_y
  CMP #ROOM_UP
  BCC set_bullet_dead
  CMP #ROOM_DOWN
  BCS set_bullet_dead
  LDA bullet_1_x
  CMP #ROOM_LEFT
  BCC set_bullet_dead
  CMP #ROOM_RIGHT
  BCS set_bullet_dead
  JMP chk_dead
set_bullet_dead:  
  LDA #DEAD
  STA bullet_1_dir
  ; if the bullet is dead, set x and y to 0 and end the subroutine
chk_dead:
  LDA bullet_1_dir
  CMP #DEAD
  BNE chk_dir
  LDA #$00
  STA bullet_1_x
  STA bullet_1_y
  JMP HandleBulletDone
chk_dir:
  ; if the bullet is not dead, increment its x or y coords based on the bullet's direction
  CMP #UP
  BNE HandleBullet_chk_r
  LDA bullet_1_y
  SEC
  SBC #BULLET_VEL
  STA bullet_1_y
  JMP HandleBulletDone
HandleBullet_chk_r:
  CMP #RIGHT
  BNE HandleBullet_chk_d
  LDA bullet_1_x
  CLC
  ADC #BULLET_VEL
  STA bullet_1_x
  JMP HandleBulletDone
HandleBullet_chk_d:
  CMP #DOWN
  BNE HandleBullet_chk_l
  LDA bullet_1_y
  CLC
  ADC #BULLET_VEL
  STA bullet_1_y
  JMP HandleBulletDone
HandleBullet_chk_l:
  LDA bullet_1_x
  SEC
  SBC #BULLET_VEL
  STA bullet_1_x
HandleBulletDone:
  ; store bullet x, y in sprite memory addresses
  LDA bullet_1_y
  STA $0210
  LDA bullet_1_x
  STA $0213
  RTS

; Totally DRY code here....
HandleBullet2:
  LDA bullet_2_y
  CMP #ROOM_UP
  BCC set_bullet2_dead
  CMP #ROOM_DOWN
  BCS set_bullet2_dead
  LDA bullet_2_x
  CMP #ROOM_LEFT
  BCC set_bullet2_dead
  CMP #ROOM_RIGHT
  BCS set_bullet2_dead
  JMP chk_dead2
set_bullet2_dead:  
  LDA #DEAD
  STA bullet_2_dir
  ; if the bullet is dead, set x and y to 0 and end the subroutine
chk_dead2:
  LDA bullet_2_dir
  CMP #DEAD
  BNE chk_dir2
  LDA #$00
  STA bullet_2_x
  STA bullet_2_y
  JMP HandleBullet2Done
chk_dir2:
  ; if the bullet is not dead, increment its x or y coords based on the bullet's direction
  CMP #UP
  BNE HandleBullet2_chk_r
  LDA bullet_2_y
  SEC
  SBC #BULLET_VEL
  STA bullet_2_y
  JMP HandleBullet2Done
HandleBullet2_chk_r:
  CMP #RIGHT
  BNE HandleBullet2_chk_d
  LDA bullet_2_x
  CLC
  ADC #BULLET_VEL
  STA bullet_2_x
  JMP HandleBullet2Done
HandleBullet2_chk_d:
  CMP #DOWN
  BNE HandleBullet2_chk_l
  LDA bullet_2_y
  CLC
  ADC #BULLET_VEL
  STA bullet_2_y
  JMP HandleBullet2Done
HandleBullet2_chk_l:
  LDA bullet_2_x
  SEC
  SBC #BULLET_VEL
  STA bullet_2_x
HandleBullet2Done:
  ; store bullet x, y in sprite memory addresses
  LDA bullet_2_y
  STA $0224
  LDA bullet_2_x
  STA $0227
  RTS

IdleSprite:
  LDA player_1_walking
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
  RTS 

SubroutinesDone:
 
NMI:
  ; player stuff?
  LDA #$00
  STA $2003       ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014       ; set the high byte (02) of the RAM address, start the transfer

  ; GAME STATE STRUCTURE
  ;
  ; NMI
  ;
  ; // start screen 
  ; if (game state is start screen) {
  ;
  ;     if (the game state only just changed to start screen) {
  ;         load start screen to nametable;
  ;     }
  ;
  ;     set ppuscroll to the nametable with the start screen;
  ;
  ;     check for start button press;
  ;
  ;     if (start button pressed) {
  ;         set gamestate to playing;
  ;     }
  ; }
  ;
  ; // playing 
  ; else if (game state is playing) {
  ;
  ;     if (the game state only just changed to playing) {
  ;         load the level to the name table;
  ;     }
  ;
  ;     set ppuscroll to the nametable of the level;
  ;
  ;     player(s) input;
  ;
  ;     game logic;
  ;
  ;     sprite stuffs;
  ;
  ;     if (game ended) {
  ;         set gamestate to game over;
  ;     }
  ; }
  ;
  ; // game over screen
  ; else if (game state is game over) {
  ;
  ;     if (the game state only just changed to game over) {
  ;         load start screen to nametable;
  ;         draw player info to game over screen;
  ;     }
  ;
  ;     set ppuscroll to the nametable with the start screen;
  ;
  ;     check for start button press;
  ;
  ;     if (start button pressed) {
  ;         set gamestate to start screen;
  ;     }
  ; }
  ;
  ; RTI

  ; Set is walking flag
  LDA #FALSE
  STA player_1_walking
  STA player_2_walking

  ;LDA $0200
  ;STA player_1_y
  ;LDA $0203
  ;STA player_1_x

  JSR ReadControllers ; do the controller thing
  JSR HandleGameInputs   
  JSR HandleBullet       ; handle player bullet
  JSR HandleBullet2
  JSR Player1Sprite
  ;JSR IncrementMoney     ; increment money counter
  ;JSR DrawMoney          ; draw money to screen
  JSR CameraScroll       ; set camera scroll

ReturnFromInterrupt:
  RTI             ; return from interrupt

  ; external files
  .include "player-animation.asm"
  .include "read-controllers.asm"
  .include "player-inputs.asm"
  .include "sprite-handler.asm"

 
;;;;;;;;;;;;;;  
  

  .bank 1
  .org $E000
palette:
  ; background palettes
  .db $0F,$0F,$08,$37 ; 00
  .db $01,$0F,$17,$37 ; 01
  .db $0F,$00,$10,$30 ; 10
  .db $0F,$00,$10,$30 ; 11
  
  ; sprite palettes
  .db $0C,$11,$0F,$30 ; 00
  .db $0C,$05,$1D,$30 ; 01
  .db $22,$29,$1A,$0F ; 10
  .db $22,$36,$17,$0F ; 11


  .include "background.asm"

sprites:
     ;vert tile attr horiz
  .db $00, $02, $00, $00   ;sprite 0
  .db $00, $03, $00, $08   ;sprite 1
  .db $08, $12, $00, $00   ;sprite 2
  .db $08, $13, $00, $08   ;sprite 3

bullet:
  .db $88, $08, $00, $88   ;sprite 3

p2sprite
  .db $00, $02, $01, $00   ;sprite 0
  .db $00, $03, $01, $08   ;sprite 1
  .db $08, $12, $01, $00   ;sprite 2
  .db $08, $13, $01, $08   ;sprite 3

bullet2:
  .db $88, $08, $00, $88   ;sprite 3

endsprites:

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
