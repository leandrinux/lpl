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

procedure nothing(x, y: word; c: TColor); far;
begin
end;

procedure v1Pixel(x, y: word; c: TColor); far;
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

procedure v2Pixel(x, y: word; c: TColor); far;
var
  pixelNro: word;
  byteNro: word;
  pixelOff: word;
  value: byte;
  mask: byte;
  shloff: byte;
  color: byte;
  base: word;
  p: ^byte;
begin
  pixelNro := (y shr 1);
  pixelNro := pixelNro shl 8 + pixelNro shl 6 + x;
  byteNro := pixelNro shr 2;    
  pixelOff := pixelNro and $3;   
  shloff := (3 - pixelOff) shl 1;
  mask := not (3 shl shloff);
  color := (ord(c) shl shloff);
  if (y and 1) = 0 then base := $B800 else base := $BA00;
  p := ptr(base, byteNro);
  p^ := p^ and mask or color;
end;

procedure v3Pixel(x, y: word; c: TColor); far;
var
  pixelNro: word;
  byteNro: word;
  pixelOff: word;
  base: word;
  value: byte;
  mask: byte;
  shloff: byte;
  color: byte;
  p: ^byte;
begin
  pixelNro := (y shr 1) shl 8 + (y shr 1) shl 6 + x;
  byteNro := pixelNro shr 2;    
  pixelOff := pixelNro and $3;   
  shloff := (3 - pixelOff) shl 1;
  mask := not (3 shl shloff);
  color := (byte(c) shl shloff);
  if boolean(y and 1) then p := ptr($BA00, byteNro) else p := ptr($B800, byteNro);
  p^ := p^ and mask or color;
end;

procedure v4Pixel(x, y: word; color: TColor); far; assembler;
label is_even, mask;
asm  
  { pixelNro := (y shr 1) shl 8 + (y shr 1) shl 6 + x; }
  mov ax, y
  shr ax, 1   
  mov bx, ax
  mov cl, 6
  shl bx, cl
  mov cl, 8
  shl ax, cl
  add ax, bx
  add ax, x   { ax = pixelNro }

  { byteNro := pixelNro shr 2; }
  mov di, ax
  mov cl, 2
  shr di, cl  { di = byteNro }

  { pixelOff := pixelNro and $3; }
  mov cx, ax
  and cx, $3  { cx = pixelOff }

  { shloff := (3 - pixelOff) shl 1; }
  mov ax, 3
  sub ax, cx
  shl ax, 1   { ax = shloff }

  { if boolean(y and 1) then p := ptr($BA00, byteNro) else p := ptr($B800, byteNro); }
  mov bx, y
  and bx, 1
  jnz is_even
  mov bx, $BA00
  jmp mask

  is_even:
  mov bx, $B800  

  mask:
  mov es, bx     { es = $BA00 or $B800}

  { mask := not (3 shl shloff); }
  mov bx, 3
  mov cl, al 
  shl bx, cl { bx = mask }

  { color := (byte(c) shl shloff) ; }
  xor dh, dh
  mov dl, color
  mov cl, al
  shl dx, cl { dx = color}

  mov ax, [es:di]
  and ax, bx
  or ax, dx
  mov [es:di], ax
  
  { p^ := p^ and mask or color; }
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
    plot(func, i, i, 320-(i shl 1), 200-(i shl 1));
    i := i + 5;
  end;

  setMode(3); { 80x25 16 color text (CGA,EGA,MCGA,VGA) }
  after := C_TICKS^;
  testfunc := after - before;
end;

var 
  a, b, c, d, baseline, gpt: longint;
begin
{
  baseline := testfunc(nothing);
  a := testfunc(v1Pixel);
  b := testfunc(v2Pixel);
  c := testfunc(v3Pixel);
  d := testfunc(v4Pixel);
  gpt := testfunc(GPTPixel);

  writeln('nothing: ', baseline);
  writeln('v1Pixel: ', a);
  writeln('v2Pixel: ', b);
  writeln('v3Pixel: ', c);
  writeln('v4Pixel: ', d);
}
  gpt := testfunc(GPTPixel);
  d := testfunc(v4Pixel);
  
  writeln('GPTpixel: ', gpt);
  writeln('v4Pixel: ', d);
end.