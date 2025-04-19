@echo off
echo lpl 2025 (lean pascal library) build script
echo.

config -set "cpu cycles=max"
del bin\*.tpu

tpc -B base\base.pas -Ubase -Ebin
tpc -B debug\debug.pas -Udebug -Ebin
tpc -B dos\dos.pas -Udos -Ebin
tpc -B core\core.pas -Ucore -Ebin
tpc -B gr2\gr2.pas -Ugr2 -Ebin

del bin\*.exe

config -set "cpu cycles=3000"