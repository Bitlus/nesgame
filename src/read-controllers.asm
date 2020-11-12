ReadControllers:
	LDA #$01
	STA $4016
	LDA #$00
	STA $4016
	LDX #$08
ReadControllersLoop:
	LDA $4016
	LSR A
	ROL buttonsP1
	LDA $4017
	LSR A
	ROL buttonsP2
	DEX
	BNE ReadControllersLoop
	RTS