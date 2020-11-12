;RightAnimation:
    ;INC playerAnimationCounter
    ;LDA playerAnimationCounter
    ;CMP #$0A ; frames before updating animation
    ;BNE UpdateRightAnimation
    ;LDA #$00
    ;STA playerAnimationCounter
    ;INC playerFrame
    ;LDA playerFrame
    ;CMP #$04
    ;BNE UpdateRightAnimation
    ;LDA #$00
    ;STA playerFrame
;
;; Goes to frame based on playerFrames value
;UpdateRightAnimation:
  ;LDA playerFrame
  ;CMP #$00
  ;BEQ RightFrameOne
  ;CMP #$01
  ;BEQ RightFrameTwo
  ;CMP #$02
  ;BEQ RightFrameOne
  ;CMP #$03
  ;BEQ RightFrameThree
;
;RightFrameOne:
  ;; Change player sprite direction
  ;LDA #%00000000 ; Set to not flip horizontal
  ;STA $0202
  ;STA $0206
  ;STA $020A
  ;STA $020E
;
  ;; Set correct sprite tiles
  ;LDA #$00
  ;STA $0201
  ;LDA #$01
  ;STA $0205
  ;LDA #$10
  ;STA $0209
  ;LDA #$11
  ;STA $020D
;
  ;JMP FinishRightFrame
;
;RightFrameTwo:
  ;; Change player sprite direction
  ;LDA #%00000000 ; Set to not flip horizontal
  ;STA $0202
  ;STA $0206
  ;STA $020A
  ;STA $020E
;
  ;; Set correct sprite tiles
  ;LDA #$02
  ;STA $0201
  ;LDA #$03
  ;STA $0205
  ;LDA #$12
  ;STA $0209
  ;LDA #$13
  ;STA $020D
;
  ;JMP FinishRightFrame
;
;RightFrameThree:
  ;; Change player sprite direction
  ;LDA #%00000000 ; Set to not flip horizontal
  ;STA $0202
  ;STA $0206
  ;STA $020A
  ;STA $020E
;
  ;; Set correct sprite tiles
  ;LDA #$04
  ;STA $0201
  ;LDA #$05
  ;STA $0205
  ;LDA #$14
  ;STA $0209
  ;LDA #$15
  ;STA $020D
;
;FinishRightFrame:
    ;JMP InitRightLoop
;
;LeftAnimation:
    ;INC playerAnimationCounter
    ;LDA playerAnimationCounter
    ;CMP #$0A ; frames before updating animation
    ;BNE UpdateLeftAnimation
    ;LDA #$00
    ;STA playerAnimationCounter
    ;INC playerFrame
    ;LDA playerFrame
    ;CMP #$04
    ;BNE UpdateLeftAnimation
    ;LDA #$00
    ;STA playerFrame
;
;UpdateLeftAnimation:
  ;LDA playerFrame
  ;CMP #$00
  ;BEQ LeftFrameOne
  ;CMP #$01
  ;BEQ LeftFrameTwo
  ;CMP #$02
  ;BEQ LeftFrameOne
  ;CMP #$03
  ;BEQ LeftFrameThree
;
;LeftFrameOne:
  ;; Change player sprite direction
  ;LDA #%01000000 ; Set to flip horizontal
  ;STA $0202
  ;STA $0206
  ;STA $020A
  ;STA $020E
;
  ;; Set correct sprite tiles
  ;LDA #$01
  ;STA $0201
  ;LDA #$00
  ;STA $0205
  ;LDA #$11
  ;STA $0209
  ;LDA #$10
  ;STA $020D
;
  ;JMP FinishLeftFrame
;
;LeftFrameTwo:
  ;; Change player sprite direction
  ;LDA #%01000000 ; Set to flip horizontal
  ;STA $0202
  ;STA $0206
  ;STA $020A
  ;STA $020E
;
  ;; Set correct sprite tiles
  ;LDA #$03
  ;STA $0201
  ;LDA #$02
  ;STA $0205
  ;LDA #$13
  ;STA $0209
  ;LDA #$12
  ;STA $020D
;
  ;JMP FinishLeftFrame
;
;LeftFrameThree:
  ;; Change player sprite direction
  ;LDA #%01000000 ; Set to flip horizontal
  ;STA $0202
  ;STA $0206
  ;STA $020A
  ;STA $020E
;
  ;; Set correct sprite tiles
  ;LDA #$05
  ;STA $0201
  ;LDA #$04
  ;STA $0205
  ;LDA #$15
  ;STA $0209
  ;LDA #$14
  ;STA $020D
;
;FinishLeftFrame:
    ;JMP InitLeftLoop
;
;UpAnimation:
    ;INC playerAnimationCounter
    ;LDA playerAnimationCounter
    ;CMP #$0A ; frames before updating animation
    ;BNE UpdateUpAnimation
    ;LDA #$00
    ;STA playerAnimationCounter
    ;INC playerFrame
    ;LDA playerFrame
    ;CMP #$04
    ;BNE UpdateUpAnimation
    ;LDA #$00
    ;STA playerFrame
;
;UpdateUpAnimation:
  ;LDA playerFrame
  ;CMP #$00
  ;BEQ UpFrameOne
  ;CMP #$01
  ;BEQ UpFrameTwo
  ;CMP #$02
  ;BEQ UpFrameOne
  ;CMP #$03
  ;BEQ UpFrameThree
;
;UpFrameOne:
  ;; Change player sprite direction
  ;LDA #%00000000 ; Set to not flip horizontal
  ;STA $0202
  ;STA $020A
  ;LDA #%01000000 ; Set to not flip horizontal
  ;STA $0206
  ;STA $020E
;
  ;; Set correct sprite tiles
  ;LDA #$21
  ;STA $0201
  ;LDA #$21
  ;STA $0205
  ;LDA #$31
  ;STA $0209
  ;LDA #$31
  ;STA $020D
;
  ;JMP FinishUpFrame
;
;UpFrameTwo:
  ;; Change player sprite direction
  ;LDA #%01000000 ; Set to flip horizontal
  ;STA $0202
  ;LDA #%00000000 ; Set to not flip horizontal
  ;STA $0206
  ;STA $020A
  ;STA $020E
;
  ;; Set correct sprite tiles
  ;LDA #$23
  ;STA $0201
  ;LDA #$23
  ;STA $0205
  ;LDA #$32
  ;STA $0209
  ;LDA #$33
  ;STA $020D
;
  ;JMP FinishUpFrame
;
;UpFrameThree:
  ;; Change player sprite direction
  ;LDA #%01000000 ; Set to flip horizontal
  ;STA $0202
  ;STA $020A
  ;STA $020E
  ;LDA #%00000000 ; Set to not flip horizontal
  ;STA $0206
;
  ;; Set correct sprite tiles
  ;LDA #$23
  ;STA $0201
  ;LDA #$23
  ;STA $0205
  ;LDA #$33
  ;STA $0209
  ;LDA #$32
  ;STA $020D
;
;FinishUpFrame:
    ;JMP InitUpLoop
;
;DownAnimation:
  ;INC playerAnimationCounter
  ;LDA playerAnimationCounter
  ;CMP #$0A ; frames before updating animation
  ;BNE UpdateDownAnimation
  ;LDA #$00
  ;STA playerAnimationCounter
  ;INC playerFrame
  ;LDA playerFrame
  ;CMP #$04
  ;BNE UpdateDownAnimation
  ;LDA #$00
  ;STA playerFrame
;
;UpdateDownAnimation:
  ;LDA playerFrame
  ;CMP #$00
  ;BEQ DownFrameOne
  ;CMP #$01
  ;BEQ DownFrameTwo
  ;CMP #$02
  ;BEQ DownFrameOne
  ;CMP #$03
  ;BEQ DownFrameThree
;
;DownFrameOne:
  ;; Change player sprite direction
  ;LDA #%00000000 ; Set to not flip horizontal
  ;STA $0202
  ;STA $020A
  ;LDA #%01000000 ; Set to not flip horizontal
  ;STA $0206
  ;STA $020E
;
  ;; Set correct sprite tiles
  ;LDA #$20
  ;STA $0201
  ;LDA #$20
  ;STA $0205
  ;LDA #$30
  ;STA $0209
  ;LDA #$30
  ;STA $020D
;
  ;JMP FinishDownFrame
;
;DownFrameTwo:
  ;; Change player sprite direction
  ;LDA #%01000000 ; Set to flip horizontal
  ;STA $0202
  ;LDA #%00000000 ; Set to not flip horizontal
  ;STA $0206
  ;STA $020A
  ;STA $020E
;
  ;; Set correct sprite tiles
  ;LDA #$22
  ;STA $0201
  ;LDA #$22
  ;STA $0205
  ;LDA #$24
  ;STA $0209
  ;LDA #$25
  ;STA $020D
;
  ;JMP FinishDownFrame
;
;DownFrameThree:
  ;; Change player sprite direction
  ;LDA #%01000000 ; Set to flip horizontal
  ;STA $0202
  ;STA $020A
  ;STA $020E
  ;LDA #%00000000 ; Set to not flip horizontal
  ;STA $0206
;
  ;; Set correct sprite tiles
  ;LDA #$22
  ;STA $0201
  ;LDA #$22
  ;STA $0205
  ;LDA #$25
  ;STA $0209
  ;LDA #$24
  ;STA $020D
;
;FinishDownFrame:
    ;JMP InitDownLoop