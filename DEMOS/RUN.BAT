@echo off
cd ..
call build
cd demos
config -set "cpu cycles=max"
tpc %1\%2.pas -E\bin
if errorlevel 1 goto end
config -set "cpu cycles=240"
\bin\%2
rem del \bin\%2.exe
config -set "cpu cycles=3000"

:end
