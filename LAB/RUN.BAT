@echo off
rem config -set "cpu cycles=max"
tpc %1\%1 -E\bin
if errorlevel 1 goto end
rem config -set "cpu cycles=240"
\bin\%1
rem config -set "cpu cycles=3000"

:end