unit _vga;

interface

  procedure setGraphicsMode; 
  procedure setTextMode;
  procedure putPixel(x, y: word; color: byte);

implementation

  procedure setGraphicsMode; assembler;
  asm
    mov ah, 0    { BIOS video function: set mode }
    mov al, $13  { VGA 320x200 256-color mode }
    int 10h      { BIOS video interrupt }
  end;

  procedure setTextMode; assembler;
  asm
    mov ah, 0  { BIOS video function: set mode }
    mov al, 3  { 80x25 16 color text (CGA,EGA,MCGA,VGA) }
    int 10h    { BIOS video interrupt }
  end;

  procedure putPixel(x, y: word; color: byte);
  begin
    mem[$A000 : y shl 8 + y shl 6 + x] := color;    
  end;

end.