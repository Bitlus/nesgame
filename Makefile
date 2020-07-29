all:
	nesasm game.asm

run:
	fceux game.nes

clean:
	rm -f *.nes
	rm -f *.fns
