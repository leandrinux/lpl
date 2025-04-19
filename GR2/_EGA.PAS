unit _ega;

interface

  procedure setGraphicsMode; 
  procedure setTextMode;
  procedure putPixel(x, y: word; color: byte);
  function getPixel(x, y: word): byte;

implementation

  procedure setGraphicsMode; assembler;
  asm
    mov ah, 0    { BIOS video function: set mode }
    mov al, $0D  { EGA 320x200 16-color mode }
    int 10h      { BIOS video interrupt }
  end;

  procedure setTextMode; assembler;
  asm
    mov ah, 0  { BIOS video function: set mode }
    mov al, 3  { 80x25 16 color text (CGA,EGA,MCGA,VGA) }
    int 10h    { BIOS video interrupt }
  end;

  procedure putPixel(x, y: word; color: byte); 
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

  function getPixel(x, y: word): byte;
  begin
  end;    

end.