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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Player 2
Player2Animation:
  INC player_2_a_counter
  LDA player_2_a_counter
  CMP #$0A ; frames before updating animation
  BNE Player2AnimationUpdate
  LDA #$00
  STA player_2_a_counter
  INC player_2_a_frame
  LDA player_2_a_frame
  CMP #$04
  BNE Player2AnimationUpdate
  LDA #$00
  STA player_2_a_frame

Player2AnimationUpdate:
  LDA player_2_dir
  CMP #UP
  BEQ JumpToP2UpAnimation
  CMP #RIGHT
  BEQ JumpToP2RightAnimation
  CMP #DOWN
  BEQ JumpToP2DownAnimation
  CMP #LEFT
  BEQ JumpToP2LeftAnimation
  JMP Player2AnimationDone

; Branch instructions breaking because branch is "too far" away
JumpToP2UpAnimation:
  JMP Player2UpAnimationUpdate
JumpToP2RightAnimation:
  JMP Player2RightAnimationUpdate
JumpToP2DownAnimation:
  JMP Player2DownAnimationUpdate
JumpToP2LeftAnimation:
  JMP Player2LeftAnimationUpdate

Player2UpAnimationUpdate:
  LDA player_2_a_frame
  CMP #$00
  BEQ Player2UpFrame1
  CMP #$01
  BEQ Player2UpFrame2
  CMP #$02
  BEQ Player2UpFrame1
  CMP #$03
  BEQ Player2UpFrame3

Player2UpFrame1:
  ; Change player sprite direction
  LDA #%00000001 ; Set to not flip horizontal
  STA $0216
  STA $021E
  LDA #%01000001 ; Set to not flip horizontal
  STA $021A
  STA $0222

  ; Set correct sprite tiles
  LDA #$21
  STA $0215
  LDA #$21
  STA $0219
  LDA #$31
  STA $021D
  LDA #$31
  STA $0221

  JMP Player2AnimationDone
Player2UpFrame2:
  ;; Change player sprite direction
  LDA #%01000001 ; Set to flip horizontal
  STA $0216
  LDA #%00000001 ; Set to not flip horizontal
  STA $021A
  STA $021E
  STA $0222
;
  ; Set correct sprite tiles
  LDA #$23
  STA $0215
  LDA #$23
  STA $0219
  LDA #$32
  STA $021D
  LDA #$33
  STA $0221
  
  JMP Player2AnimationDone
Player2UpFrame3:
  ;UpFrameThree:
  ;; Change player sprite direction
  LDA #%01000001 ; Set to flip horizontal
  STA $0216
  STA $021E
  STA $0222
  LDA #%00000001 ; Set to not flip horizontal
  STA $021A
;
  ;; Set correct sprite tiles
  LDA #$23
  STA $0215
  LDA #$23
  STA $0219
  LDA #$33
  STA $021D
  LDA #$32
  STA $0221

  JMP Player2AnimationDone

Player2RightAnimationUpdate:
  LDA player_2_a_frame
  CMP #$00
  BEQ Player2RightFrame1
  CMP #$01
  BEQ Player2RightFrame2
  CMP #$02
  BEQ Player2RightFrame1
  CMP #$03
  BEQ Player2RightFrame3

Player2RightFrame1:
  ; Change player sprite direction
  LDA #%00000001 ; Set to not flip horizontal
  STA $0216
  STA $021A
  STA $021E
  STA $0222

  ; Set correct sprite tiles
  LDA #$00
  STA $0215
  LDA #$01
  STA $0219
  LDA #$10
  STA $021D
  LDA #$11
  STA $0221

  JMP Player2AnimationDone
Player2RightFrame2:
  ; Change player sprite direction
  LDA #%00000001 ; Set to not flip horizontal
  STA $0216
  STA $021A
  STA $021E
  STA $0222
;
  ;; Set correct sprite tiles
  LDA #$02
  STA $0215
  LDA #$03
  STA $0219
  LDA #$12
  STA $021D
  LDA #$13
  STA $0221

  JMP Player2AnimationDone
Player2RightFrame3:
  ; Change player sprite direction
  LDA #%00000001 ; Set to not flip horizontal
  STA $0216
  STA $021A
  STA $021E
  STA $0222
;
  ;; Set correct sprite tiles
  LDA #$04
  STA $0215
  LDA #$05
  STA $0219
  LDA #$14
  STA $021D
  LDA #$15
  STA $0221

  JMP Player2AnimationDone
Player2DownAnimationUpdate:
  LDA player_2_a_frame
  CMP #$00
  BEQ Player2DownFrame1
  CMP #$01
  BEQ Player2DownFrame2
  CMP #$02
  BEQ Player2DownFrame1
  CMP #$03
  BEQ Player2DownFrame3

Player2DownFrame1:
  ; Change player sprite direction
  LDA #%00000001 ; Set to not flip horizontal
  STA $0216
  STA $021E
  LDA #%01000001 ; Set to not flip horizontal
  STA $021A
  STA $0222

  ; Set correct sprite tiles
  LDA #$20
  STA $0215
  LDA #$20
  STA $0219
  LDA #$30
  STA $021D
  LDA #$30
  STA $0221

  JMP Player2AnimationDone
Player2DownFrame2:
  ; Change player sprite direction
  LDA #%01000001 ; Set to flip horizontal
  STA $0216
  LDA #%00000001 ; Set to not flip horizontal
  STA $021A
  STA $021E
  STA $0222

  ; Set correct sprite tiles
  LDA #$22
  STA $0215
  LDA #$22
  STA $0219
  LDA #$24
  STA $021D
  LDA #$25
  STA $0221

  JMP Player2AnimationDone
Player2DownFrame3:
  ; Change player sprite direction
  LDA #%01000001 ; Set to flip horizontal
  STA $0216
  STA $021E
  STA $0222
  LDA #%00000001 ; Set to not flip horizontal
  STA $021A

  ; Set correct sprite tiles
  LDA #$22
  STA $0215
  LDA #$22
  STA $0219
  LDA #$25
  STA $021D
  LDA #$24
  STA $0221

  JMP Player2AnimationDone
Player2LeftAnimationUpdate:
  LDA player_2_a_frame
  CMP #$00
  BEQ Player2LeftFrame1
  CMP #$01
  BEQ Player2LeftFrame2
  CMP #$02
  BEQ Player2LeftFrame1
  CMP #$03
  BEQ Player2LeftFrame3

Player2LeftFrame1:
  ; Change player sprite direction
  LDA #%01000001 ; Set to flip horizontal
  STA $0216
  STA $021A
  STA $021E
  STA $0222

  ; Set correct sprite tiles
  LDA #$01
  STA $0215
  LDA #$00
  STA $0219
  LDA #$11
  STA $021D
  LDA #$10
  STA $0221

  JMP Player2AnimationDone
Player2LeftFrame2:
  ; Change player sprite direction
  LDA #%01000001 ; Set to flip horizontal
  STA $0216
  STA $021A
  STA $021E
  STA $0222

  ; Set correct sprite tiles
  LDA #$03
  STA $0215
  LDA #$02
  STA $0219
  LDA #$13
  STA $021D
  LDA #$12
  STA $0221

  JMP Player2AnimationDone
Player2LeftFrame3:
  ; Change player sprite direction
  LDA #%01000001 ; Set to flip horizontal
  STA $0216
  STA $021A
  STA $021E
  STA $0222

  ; Set correct sprite tiles
  LDA #$05
  STA $0215
  LDA #$04
  STA $0219
  LDA #$15
  STA $021D
  LDA #$14
  STA $0221

  JMP Player2AnimationDone

Player2AnimationDone:
  RTS