all:
	cd src && nesasm game.asm
	[ -d "bin" ] || mkdir bin
	mv src/*.nes bin
	mv src/*.fns bin

run:
	fceux bin/game.nes

clean:
	rm -rf bin/
