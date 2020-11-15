Player1Animation:
  INC player_1_a_counter
  LDA player_1_a_counter
  CMP #$0A ; frames before updating animation
  BNE Player1AnimationUpdate
  LDA #$00
  STA player_1_a_counter
  INC player_1_a_frame
  LDA player_1_a_frame
  CMP #$04
  BNE Player1AnimationUpdate
  LDA #$00
  STA player_1_a_frame

Player1AnimationUpdate:
  LDA player_1_dir
  CMP #UP
  BEQ JumpToP1UpAnimation
  CMP #RIGHT
  BEQ JumpToP1RightAnimation
  CMP #DOWN
  BEQ JumpToP1DownAnimation
  CMP #LEFT
  BEQ JumpToP1LeftAnimation
  JMP Player1AnimationDone

; Branch instructions breaking because branch is "too far" away
JumpToP1UpAnimation:
  JMP Player1UpAnimationUpdate
JumpToP1RightAnimation:
  JMP Player1RightAnimationUpdate
JumpToP1DownAnimation:
  JMP Player1DownAnimationUpdate
JumpToP1LeftAnimation:
  JMP Player1LeftAnimationUpdate

Player1UpAnimationUpdate:
  LDA player_1_a_frame
  CMP #$00
  BEQ Player1UpFrame1
  CMP #$01
  BEQ Player1UpFrame2
  CMP #$02
  BEQ Player1UpFrame1
  CMP #$03
  BEQ Player1UpFrame3

Player1UpFrame1:
  ; Change player sprite direction
  LDA #%00000000 ; Set to not flip horizontal
  STA $0202
  STA $020A
  LDA #%01000000 ; Set to not flip horizontal
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

  JMP Player1AnimationDone
Player1UpFrame2:
  ;; Change player sprite direction
  LDA #%01000000 ; Set to flip horizontal
  STA $0202
  LDA #%00000000 ; Set to not flip horizontal
  STA $0206
  STA $020A
  STA $020E
;
  ; Set correct sprite tiles
  LDA #$23
  STA $0201
  LDA #$23
  STA $0205
  LDA #$32
  STA $0209
  LDA #$33
  STA $020D
  
  JMP Player1AnimationDone
Player1UpFrame3:
  ;UpFrameThree:
  ;; Change player sprite direction
  LDA #%01000000 ; Set to flip horizontal
  STA $0202
  STA $020A
  STA $020E
  LDA #%00000000 ; Set to not flip horizontal
  STA $0206
;
  ;; Set correct sprite tiles
  LDA #$23
  STA $0201
  LDA #$23
  STA $0205
  LDA #$33
  STA $0209
  LDA #$32
  STA $020D

  JMP Player1AnimationDone

Player1RightAnimationUpdate:
  LDA player_1_a_frame
  CMP #$00
  BEQ Player1RightFrame1
  CMP #$01
  BEQ Player1RightFrame2
  CMP #$02
  BEQ Player1RightFrame1
  CMP #$03
  BEQ Player1RightFrame3

Player1RightFrame1:
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

  JMP Player1AnimationDone
Player1RightFrame2:
  ; Change player sprite direction
  LDA #%00000000 ; Set to not flip horizontal
  STA $0202
  STA $0206
  STA $020A
  STA $020E
;
  ;; Set correct sprite tiles
  LDA #$02
  STA $0201
  LDA #$03
  STA $0205
  LDA #$12
  STA $0209
  LDA #$13
  STA $020D

  JMP Player1AnimationDone
Player1RightFrame3:
  ; Change player sprite direction
  LDA #%00000000 ; Set to not flip horizontal
  STA $0202
  STA $0206
  STA $020A
  STA $020E
;
  ;; Set correct sprite tiles
  LDA #$04
  STA $0201
  LDA #$05
  STA $0205
  LDA #$14
  STA $0209
  LDA #$15
  STA $020D

  JMP Player1AnimationDone
Player1DownAnimationUpdate:
  LDA player_1_a_frame
  CMP #$00
  BEQ Player1DownFrame1
  CMP #$01
  BEQ Player1DownFrame2
  CMP #$02
  BEQ Player1DownFrame1
  CMP #$03
  BEQ Player1DownFrame3

Player1DownFrame1:
  ; Change player sprite direction
  LDA #%00000000 ; Set to not flip horizontal
  STA $0202
  STA $020A
  LDA #%01000000 ; Set to not flip horizontal
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

  JMP Player1AnimationDone
Player1DownFrame2:
  ; Change player sprite direction
  LDA #%01000000 ; Set to flip horizontal
  STA $0202
  LDA #%00000000 ; Set to not flip horizontal
  STA $0206
  STA $020A
  STA $020E

  ; Set correct sprite tiles
  LDA #$22
  STA $0201
  LDA #$22
  STA $0205
  LDA #$24
  STA $0209
  LDA #$25
  STA $020D

  JMP Player1AnimationDone
Player1DownFrame3:
  ; Change player sprite direction
  LDA #%01000000 ; Set to flip horizontal
  STA $0202
  STA $020A
  STA $020E
  LDA #%00000000 ; Set to not flip horizontal
  STA $0206

  ; Set correct sprite tiles
  LDA #$22
  STA $0201
  LDA #$22
  STA $0205
  LDA #$25
  STA $0209
  LDA #$24
  STA $020D

  JMP Player1AnimationDone
Player1LeftAnimationUpdate:
  LDA player_1_a_frame
  CMP #$00
  BEQ Player1LeftFrame1
  CMP #$01
  BEQ Player1LeftFrame2
  CMP #$02
  BEQ Player1LeftFrame1
  CMP #$03
  BEQ Player1LeftFrame3

Player1LeftFrame1:
  ; Change player sprite direction
  LDA #%01000000 ; Set to flip horizontal
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

  JMP Player1AnimationDone
Player1LeftFrame2:
  ; Change player sprite direction
  LDA #%01000000 ; Set to flip horizontal
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

  JMP Player1AnimationDone
Player1LeftFrame3:
  ; Change player sprite direction
  LDA #%01000000 ; Set to flip horizontal
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

  JMP Player1AnimationDone

Player1AnimationDone:
  RTS


