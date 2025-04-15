@echo off
echo lpl 2025 (lean pascal library) build script
echo.

config -set "cpu cycles=max"

tpc -B base\build.pas -Ubase -Ebin

tpc -B debug\build.pas -Udebug -Ebin

tpc -B dos\build.pas -Udos -Ebin

tpc -B core\build.pas -Ucore -Ebin

tpc -B gr\build.pas -Ugr -Ebin

del bin\build.exe

config -set "cpu cycles=3000"