@echo off
echo lpl 2025 (lean pascal library) build script
echo.

config -set "cpu cycles=max"

echo Building base units
tpc -B base\build.pas -Ubase -Ebin
echo.

echo Building debug tools
tpc -B debug\build.pas -Udebug -Ebin
echo.

echo Building DOS-specific units
tpc -B dos\build.pas -Udos -Ebin
echo.

echo Building core units
tpc -B core\build.pas -Ucore -Ebin
echo.

del bin\build.exe
config -set "cpu cycles=3000"