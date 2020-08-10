@ECHO OFF

CD .\src
NESASM3 game.asm

CD ..

IF NOT EXIST bin (
    mkdir bin
)

MOVE src\*.nes .\bin
MOVE src\*.fns .\bin
