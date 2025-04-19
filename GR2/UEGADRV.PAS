{
  uegadrv unit
  Driver for the 16-color EGA 320x200 graphics mode
  2025 LRT
}
unit
  uegadrv;

interface

  uses
    consts, utils, types, locale,
    uobject, uexc, uviddrv;

  const
    C_EGAVideoDriver_CLASSNAME = 'TEGAVideoDriver';

  type
    PEGAVideoDriver = ^TEGAVideoDriver;
    TEGAVideoDriver = object (TVideoDriver)
    public
      constructor init;
      destructor done; virtual;
      function getWidth: word; virtual;
      function getHeight: word; virtual;
      function getColorCount: longint; virtual;
      function detect: boolean; virtual;
      procedure start(mode: byte); virtual;
      procedure stop; virtual;
      procedure clear(color: byte); virtual;
      procedure putPixel(x, y: word; color: byte); virtual;
      function getPixel(x, y: word): byte; virtual;
      function getClassName: string; virtual;
    private
      _mode: byte;
    end;

implementation

  { TEGAVideoDriver public }

  constructor TEGAVideoDriver.init;
  begin
    inherited init;
  end;

  destructor TEGAVideoDriver.done;
  begin
    inherited done;
  end;

  function TEGAVideoDriver.getWidth: word;
  begin
    case _mode of 
      0: getWidth := 320;
      1: getWidth := 640;
    end;
  end;

  function TEGAVideoDriver.getHeight: word; 
  begin
    case _mode of 
      0: getHeight := 200;
      1: getHeight := 350;
    end;
  end;
  
  function TEGAVideoDriver.getColorCount: longint;
  begin
    getColorCount := 16;
  end;

  function TEGAVideoDriver.detect: boolean; 
  begin
    detect := true;
  end;
  
  procedure TEGAVideoDriver.start(mode: byte); 
  var 
    EGAMode: byte;  
  begin
    _mode := mode;
    case mode of
      0: EGAMode := $0D; {320x200x16}
      1: EGAMode := $10; {640x350x16}
    end;
    asm
      mov ah, 0    { BIOS video function: set mode }
      mov al, EGAMode  
      int 10h      { BIOS video interrupt }
    end;
  end;
  
  procedure TEGAVideoDriver.stop; 
  begin
    asm
      mov ah, 0  { BIOS video function: set mode }
      mov al, 3  { 80x25 16 color text (CGA,EGA,MCGA,VGA) }
      int 10h    { BIOS video interrupt }
    end;
  end;
  
  procedure TEGAVideoDriver.clear(color: byte);
  begin
  end;
  
  procedure TEGAVideoDriver.putPixel(x, y: word; color: byte);
  const
    SEG_A000 = $A000;
  var
    byteOffset: Word;
    bitMask: Byte;
    plane: Byte;
    oldVal: Byte;
  begin
    { Calculate byte offset in video memory (40 bytes per scanline) }
    case _mode of
      0: 
      begin
        if (x>319) or (y>199) then exit;
        byteOffset := y * 40 + (x shr 3);   { x div 8 }
      end;

      1:
      begin
        if (x>639) or (y>349) then exit;
        byteOffset := y * 80 + (x shr 3);   { x div 8 }
      end;
    end;
   
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

  function TEGAVideoDriver.getPixel(x, y: word): byte;
  begin
    case _mode of
      0: if (x>319) or (y>199) then exit;
      1: if (x>639) or (y>349) then exit;
    end;
    getPixel := 0; 
  end;  

  function TEGAVideoDriver.getClassName: string;
  begin
    getClassName := C_EGAVideoDriver_CLASSNAME;
  end;

  { TEGAVideoDriver private }

  { Other }

end.
