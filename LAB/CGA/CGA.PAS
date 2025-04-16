uses
  xcrt;

type
  TColor = (
    Black,
    Cyan,
    Magenta,
    White
  );

  TFunction = procedure (x, y: word; c: TColor);


procedure setMode(mode: byte); assembler;
asm
  mov ah, 0  { BIOS video function: set mode }
  mov al, mode  
  int 10h    { BIOS video interrupt }
end;

procedure setPixel(x, y: word; c: TColor); far;
var
  pixelNro: longint;
  byteNro: longint;
  pixelOff: longint;
  value: byte;
  mask: byte;
  shloff: byte;
  color: byte;
  base: word;
begin
  pixelNro := (y shr 1) * 320 + x;      { which pixel number } 
  byteNro := pixelNro div 4;    { in which byte is the pixel stored }
  pixelOff := pixelNro mod 4;   { which offset inside the byte is the pixel stored }
  shloff := 2*(3 - pixelOff);
  mask := not (3 shl shloff);
  color := (ord(c) shl shloff);
  if (y and 1) = 0 then base := $B800 else base := $BA00;
  value := Mem[base:byteNro];
  value := value and mask or color;
  Mem[base:byteNro] := value;
end;

procedure GPTPixel(x, y: Word; color: TColor); far;
var
  offset: Word;
  bitShift: Byte;
  pixelMask: Byte;
  pixelValue: Byte;
  p: ^Byte;
  baseSegment: Word;
begin
  if (x > 319) or (y > 199) then Exit;

  { Interlaced memory handling }
  if (y and 1) = 0 then
    baseSegment := $B800  { Even lines }
  else
    baseSegment := $BA00; { Odd lines (starts 8KB after B800) }

  offset := (y shr 1) * 80 + (x div 4);

  { Calculate which bits to update }
  bitShift := (3 - (x mod 4)) * 2;
  pixelMask := not ($03 shl bitShift);
  pixelValue := (ord(color) and 3) shl bitShift;

  p := Ptr(baseSegment, offset);
  p^ := (p^ and pixelMask) or pixelValue;
end;

procedure plot(func: TFunction; x, y, w, h: word);
var 
  i: word;
begin

  for i:=y to y+h-1 do 
  begin
    func(x, i, Cyan);
    func(x+w-1, i, Cyan);
  end;
  for i:=x to x+w-1 do 
  begin
    func(i, y, Magenta);
    func(i, y+h-1, Magenta);
  end;
end;

function testfunc(func: TFunction): longint;    
var
  before, after: longint;
  i: byte;
begin
  before := C_TICKS^;
  setMode(5); { CGA 320x200 4-color mode }
  i := 0;
  while i<100 do
  begin
    plot(setPixel, i, i, 320-(i shl 1), 200-(i shl 1));
    i := i + 5;
  end;
  setMode(3); { 80x25 16 color text (CGA,EGA,MCGA,VGA) }
  after := C_TICKS^;
  testfunc := after - before;
end;

var 
  a, b: longint;
begin
  a := testfunc(setPixel);
  b := testfunc(GPTPixel);

  writeln('setpixel: ', a);
  writeln('GPTpixel: ', b);
  readkey;
end.