HandleAnimation:
  INC animationCounter
  LDA animationCounter
  CMP #$08 ; Speed of animation (Framerate... sorta)
  BNE UpdateCactus
  LDA #$00
  STA animationCounter
  INC weedFrame
  LDA weedFrame
  CMP #$04
  BNE UpdateCactus
  LDA #$00
  STA weedFrame

UpdateCactus:
  LDA weedFrame
  CMP #$00
  BEQ Frame1
  CMP #$01
  BEQ Frame2
  CMP #$02
  BEQ Frame3
  CMP #$03
  BEQ Frame4


Frame1:
  LDA #%00000000 ; Set no flips
  STA $0212
  STA $0216
  STA $021A
  STA $021E

  LDA #$06
  STA $0211
  LDA #$07
  STA $0215
  LDA #$08
  STA $0219
  LDA #$09
  STA $021D
  JMP ReturnFromInterrupt
Frame2:
  LDA #%10000000 ; Flip vertical
  STA $0212
  STA $021E

  LDA #%01000000 ; Flip horizontal
  STA $0216
  STA $021A


  LDA #$08
  STA $0211
  LDA #$06
  STA $0215
  LDA #$09
  STA $0219
  LDA #$07
  STA $021D
  JMP ReturnFromInterrupt
Frame3:
  LDA #%11000000 ; Set both flips
  STA $0212
  STA $0216
  STA $021A
  STA $021E

  LDA #$09
  STA $0211
  LDA #$08
  STA $0215
  LDA #$07
  STA $0219
  LDA #$06
  STA $021D
  JMP ReturnFromInterrupt
Frame4:
  LDA #%10000000 ; Set vertical flips
  STA $0212
  STA $0216
  STA $021A
  STA $021E

  LDA #$08
  STA $0211
  LDA #$09
  STA $0215
  LDA #$06
  STA $0219
  LDA #$07
  STA $021D
  JMP ReturnFromInterrupt