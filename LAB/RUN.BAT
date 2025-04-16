@echo off
config -set "cpu cycles=max"
tpc %1\%1 -E\bin
if errorlevel 1 goto end
config -set "cpu cycles=240"
\bin\%1
config -set "cpu cycles=3000"

:end