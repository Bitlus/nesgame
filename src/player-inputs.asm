; Title Screen Inputs
HandleTitleScreenInputs:
  RTS

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
  LDA #$FF
  STA testing
P1ReadUpDone:
  
HandleGameInputsDone:
  RTS

; End Screen Inputs
HandleEndScreenInputs:
  RTS