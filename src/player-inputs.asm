; Game Playing State Inputs
HandleGameInputs:
; Check A Button
  LDA #BUTTON_A
  BIT buttonsP1 
  BEQ P1ReadADone
  LDA bullet_1_dir
  CMP #DEAD
  BNE P1ReadADone
  ; set bullet enum
  LDA player_1_dir
  STA bullet_1_dir
  ; set bullet x, y coords
  LDA player_1_x
  CLC
  ADC #$06
  STA bullet_1_x
  LDA player_1_y
  CLC
  ADC #$06
  STA bullet_1_y
P1ReadADone:

P1ReadUp:
  LDA #BUTTON_UP
  BIT buttonsP1
  BEQ P1ReadUpDone

  ; move player
  DEC player_1_y

  ; set player direction
  LDA #UP
  STA player_1_dir
P1ReadUpDone:

P1ReadRight:
  LDA #BUTTON_RIGHT
  BIT buttonsP1
  BEQ P1ReadRightDone
  
  ; move player
  INC player_1_x

  ; set player direction
  LDA #RIGHT
  STA player_1_dir
P1ReadRightDone:

P1ReadDown:
  LDA #BUTTON_DOWN
  BIT buttonsP1
  BEQ P1ReadDownDone

  ; move player
  INC player_1_y

  ; set player direction
  LDA #DOWN
  STA player_1_dir
P1ReadDownDone:

P1ReadLeft:
  LDA #BUTTON_LEFT
  BIT buttonsP1
  BEQ P1ReadLeftDone

  ; move player
  DEC player_1_x

  ; set player direction
  LDA #LEFT
  STA player_1_dir
P1ReadLeftDone:
  
HandleGameInputsDone:
  RTS