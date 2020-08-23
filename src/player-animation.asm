RightAnimation:
    INC playerAnimationCounter
    LDA playerAnimationCounter
    CMP #$0A ; frames before updating animation
    BNE UpdateRightAnimation
    LDA #$00
    STA playerAnimationCounter
    INC playerFrame
    LDA playerFrame
    CMP #$03
    BNE UpdateRightAnimation
    LDA #$00
    STA playerFrame

UpdateRightAnimation:
  LDA playerFrame
  CMP #$00
  BEQ RightFrameOne
  CMP #$01
  BEQ RightFrameTwo
  CMP #$02
  BEQ RightFrameThree

RightFrameOne:
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

  JMP FinishRightFrame

RightFrameTwo:
  ; Change player sprite direction
  LDA #%00000000 ; Set to not flip horizontal
  STA $0202
  STA $0206
  STA $020A
  STA $020E

  ; Set correct sprite tiles
  LDA #$02
  STA $0201
  LDA #$03
  STA $0205
  LDA #$12
  STA $0209
  LDA #$13
  STA $020D

  JMP FinishRightFrame

RightFrameThree:
  ; Change player sprite direction
  LDA #%00000000 ; Set to not flip horizontal
  STA $0202
  STA $0206
  STA $020A
  STA $020E

  ; Set correct sprite tiles
  LDA #$04
  STA $0201
  LDA #$05
  STA $0205
  LDA #$14
  STA $0209
  LDA #$15
  STA $020D

FinishRightFrame:
    JMP InitRightLoop

LeftAnimation:
    INC playerAnimationCounter
    LDA playerAnimationCounter
    CMP #$0A ; frames before updating animation
    BNE UpdateLeftAnimation
    LDA #$00
    STA playerAnimationCounter
    INC playerFrame
    LDA playerFrame
    CMP #$03
    BNE UpdateLeftAnimation
    LDA #$00
    STA playerFrame

UpdateLeftAnimation:
  LDA playerFrame
  CMP #$00
  BEQ LeftFrameOne
  CMP #$01
  BEQ LeftFrameTwo
  CMP #$02
  BEQ LeftFrameThree

LeftFrameOne:
  ; Change player sprite direction
  LDA #%01000000 ; Set to not flip horizontal
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

  JMP FinishLeftFrame

LeftFrameTwo:
  ; Change player sprite direction
  LDA #%01000000 ; Set to not flip horizontal
  STA $0202
  STA $0206
  STA $020A
  STA $020E

  ; Set correct sprite tiles
  LDA #$03
  STA $0201
  LDA #$02
  STA $0205
  LDA #$13
  STA $0209
  LDA #$12
  STA $020D

  JMP FinishLeftFrame

LeftFrameThree:
  ; Change player sprite direction
  LDA #%01000000 ; Set to not flip horizontal
  STA $0202
  STA $0206
  STA $020A
  STA $020E

  ; Set correct sprite tiles
  LDA #$05
  STA $0201
  LDA #$04
  STA $0205
  LDA #$15
  STA $0209
  LDA #$14
  STA $020D

FinishLeftFrame:
    JMP InitLeftLoop