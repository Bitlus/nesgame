Player1Sprite:
  LDA player_1_y
  STA $0200 ; top left sprite vert
  STA $0204 ; top right sprite vert
  CLC
  ADC #$08 ; 8 pixel sprite offset
  STA $0208 ; bottom left sprite vert
  STA $020C ; bottom right sprite vert

  LDA player_1_x
  STA $0203 ; top left sprite horz
  STA $020B ; bottom left sprite horz
  CLC
  ADC #$08
  STA $0207 ; top right sprite horz
  STA $020F ; bottom right sprite horz

Player1SpriteDone:
    RTS