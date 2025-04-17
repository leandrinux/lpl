@echo off
rem config -set "cpu cycles=max"
tpc %1\%2.pas -E\bin
if errorlevel 1 goto end
rem config -set "cpu cycles=240"
\bin\%2
del \bin\%2.exe
rem config -set "cpu cycles=3000"

:end