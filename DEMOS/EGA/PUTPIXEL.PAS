uses
  xcrt;

type
  TFunction = procedure (x, y: word; color: byte);

procedure setMode(mode: byte); assembler;
asm
  mov ah, 0  { BIOS video function: set mode }
  mov al, mode  
  int 10h    { BIOS video interrupt }
end;

procedure plot(func: TFunction; x, y, w, h: word; color: byte);
var 
  i: word;
begin
  for i:=y to y+h-1 do 
  begin
    func(x, i, color);
    func(x+w-1, i, color);
  end;
  for i:=x to x+w-1 do 
  begin
    func(i, y, color);
    func(i, y+h-1, color);
  end;
end;

function testfunc(func: TFunction): longint;    
var
  before, after: longint;
  i, c: byte;
begin
  before := C_TICKS^;
  i := 0; c :=0 ;
  while i<100 do
  begin
    inc(c); 
    plot(func, i, i, 320 - (i*2), 200-  i*2, c mod 16);
    i := i + 2;
  end;
  after := C_TICKS^;
  testfunc := after - before;
end;

procedure putpixelv1(x, y: word; color: byte); far;
var
  pixelNumber: word;
  pixelByte: word;
  bitShift: byte;
  p: ^byte;
  mask: byte;
  value: byte;
  plane: byte;
begin
  pixelNumber := y * 320 + x;
  pixelByte := pixelNumber div 8;
  bitShift := pixelNumber mod 8;
  p := ptr($A000, pixelByte);
  mask := not(1 shl (7 - bitShift));
  Port[$3C4] := 2; { Select only this plane via Map Mask (Sequencer index 2) }
  Port[$3C5] := 1;
  value := (color shr 3) and 1;
  value := value shl (7 - bitShift);
  p^ := p^ and mask or value;   
end;

procedure PutPixelGPT(x, y: Word; color: Byte); far;
const
  SEG_A000 = $A000;
var
  byteOffset: Word;
  bitMask: Byte;
  plane: Byte;
  oldVal: Byte;
begin
  { Calculate byte offset in video memory (40 bytes per scanline) }
  byteOffset := y * 40 + (x shr 3);   { x div 8 }

  { Calculate bit mask: pixel bit in byte }
  bitMask := $80 shr (x and 7);       { 1 shl (7 - (x mod 8)) }

  { Set Bit Mask Register (Graphics Controller index 8) }
  Port[$3CE] := 8;
  Port[$3CF] := bitMask;

  for plane := 0 to 3 do
  begin
    { Select only this plane via Map Mask (Sequencer index 2) }
    Port[$3C4] := 2;
    Port[$3C5] := 1 shl plane;

    { Determine if this plane should store a 1 or 0 for this pixel }
    if (color and (1 shl plane)) <> 0 then
    begin
      { Set bit in video memory — write 1 at selected bit via logic OR }
      oldVal := Mem[SEG_A000:byteOffset];
      Mem[SEG_A000:byteOffset] := oldVal or bitMask;
    end
    else
    begin
      { Clear bit — write 0 at selected bit via logic AND NOT }
      oldVal := Mem[SEG_A000:byteOffset];
      Mem[SEG_A000:byteOffset] := oldVal and not bitMask;
    end;
  end;
end;


var 
  a: longint;
begin
  setMode($D);
  testfunc(PutPixelGPT);
  readkey;
  setMode(3);
{
  setMode($D);
  testfunc(putpixelv1);
  readkey;
}
  setMode(3);
end.