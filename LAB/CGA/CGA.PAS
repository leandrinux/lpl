uses
  xcrt;

type
  TColor = (
    Black,
    Cyan,
    Magenta,
    White
  );

procedure setMode(mode: byte); assembler;
asm
  mov ah, 0  { BIOS video function: set mode }
  mov al, mode  
  int 10h    { BIOS video interrupt }
end;

procedure setPixel(x, y: word; c: TColor);
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

procedure PutPixel(x, y: Word; color: TColor);
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

procedure plot(x, y, w, h: word);
var 
  i: word;
begin
  for i:=y to y+w-1 do 
  begin
    setpixel(x, i, Cyan);
    setpixel(x+h-1, i, Cyan);
  end;
  for i:=x to x+h-1 do 
  begin
    setpixel(i, y, Magenta);
    setpixel(i, y+w-1, Magenta);
  end;
end;

begin

  setMode(5); { CGA 320x200 4-color mode }
 
  plot(10,10, 50, 50);
  readkey;

  setMode(3); { 80x25 16 color text (CGA,EGA,MCGA,VGA) }

end.