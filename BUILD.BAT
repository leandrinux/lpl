@echo off
echo lpl 2025 (lean pascal library) build script
echo.

config -set "cpu cycles=max"
del bin\*.tpu

tpc -B base\base.pas -Ubase -Ebin
tpc -B debug\debug.pas -Udebug -Ebin
tpc -B dos\dos.pas -Udos -Ebin
tpc -B core\core.pas -Ucore -Ebin
rem tpc -B gr\gr.pas -Ugr -Ebin
tpc -B gr2\gr2.pas -Ugr2 -Ebin

rem del bin\*.exe

config -set "cpu cycles=3000"