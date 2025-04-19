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

  const
    C_EGA_VIDEO_MODE_COUNT = 2;

    C_EGA_VIDEO_MODES: array[0..C_EGA_VIDEO_MODE_COUNT-1] of TVideoModeInfo = (
      (xres:320; yres:200; colors:16; mode:$0D),
      (xres:640; yres:350; colors:16; mode:$10)
    );

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
    getWidth := C_EGA_VIDEO_MODES[_mode].xres;
  end;

  function TEGAVideoDriver.getHeight: word; 
  begin
    getHeight := C_EGA_VIDEO_MODES[_mode].yres;
  end;
  
  function TEGAVideoDriver.getColorCount: longint;
  begin
    getColorCount := C_EGA_VIDEO_MODES[_mode].colors;
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
    EGAMode := C_EGA_VIDEO_MODES[_mode].mode;
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
  var
    w, h: word;
  begin
    w := C_EGA_VIDEO_MODES[_mode].xres - 1;
    h := C_EGA_VIDEO_MODES[_mode].yres - 1;
    if (x>w) or (y>h) then exit;

    { Calculate byte offset in video memory (40 bytes per scanline) }
    case _mode of
      0: byteOffset := y * 40 + (x shr 3);   { x div 8 }
      1: byteOffset := y * 80 + (x shr 3);   { x div 8 }
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
  var
    w, h: word;
  begin
    w := C_EGA_VIDEO_MODES[_mode].xres - 1;
    h := C_EGA_VIDEO_MODES[_mode].yres - 1;
    if (x>w) or (y>h) then exit;
    getPixel := 0; 
  end;  

  function TEGAVideoDriver.getClassName: string;
  begin
    getClassName := C_EGAVideoDriver_CLASSNAME;
  end;

  { TEGAVideoDriver private }

  { Other }

end.
