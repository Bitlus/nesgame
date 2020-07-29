all:
	nesasm game.asm
	[ -d bin ] || mkdir bin
	mv *.nes bin
	mv *.fns bin

run:
	fceux bin/game.nes

clean:
	rm -rf bin/
