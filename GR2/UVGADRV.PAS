{
  uvgadrv unit
  Driver for the 256-color VGA 320x200 graphics mode
  2025 LRT
}
unit
  uvgadrv;

interface

  uses
    consts, utils, types, locale, 
    uobject, uexc, uviddrv;

  const
    C_VGAVideoDriver_CLASSNAME = 'TVGAVideoDriver';

  type
    PVGAVideoDriver = ^TVGAVideoDriver;
    TVGAVideoDriver = object (TVideoDriver)
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
      procedure setBlock(x, y, width, height: word; color: TColor8); virtual;
      function getPixel(x, y: word): byte; virtual;
      function getClassName: string; virtual;
    private
      _mode: byte;
    end;

implementation

  const
    C_VGA_VIDEO_MODE_COUNT = 2;

    C_VGA_VIDEO_MODES: array[0..C_VGA_VIDEO_MODE_COUNT-1] of TVideoModeInfo = (
      (xres:320; yres:200; colors:256; mode:$13),
      (xres:640; yres:480; colors:16; mode:$12)
    );  

  procedure putPlanarPixel(x, y: word; color: byte);
  const
    SEG_A000 = $A000;
  var
    byteOffset: Word;
    bitMask: Byte;
    plane: Byte;
    oldVal: Byte;
  begin
    { Calculate byte offset in video memory (40 bytes per scanline) }
    byteOffset := y * 80 + (x shr 3);   { x div 8 }
   
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

  { TVGAVideoDriver public }

  constructor TVGAVideoDriver.init;
  begin
    inherited init;
  end;

  destructor TVGAVideoDriver.done;
  begin
    inherited done;
  end;

  function TVGAVideoDriver.getWidth: word;
  begin
    getWidth := C_VGA_VIDEO_MODES[_mode].xres;
  end;

  function TVGAVideoDriver.getHeight: word; 
  begin
    getHeight := C_VGA_VIDEO_MODES[_mode].yres;
  end;
  
  function TVGAVideoDriver.getColorCount: longint;
  begin
    getColorCount := C_VGA_VIDEO_MODES[_mode].colors;
  end;

  function TVGAVideoDriver.detect: boolean; 
  begin
    detect := true;
  end;
  
  procedure TVGAVideoDriver.start(mode: byte);
  var
    VGAMode: byte;
  begin
    if mode >= C_VGA_VIDEO_MODE_COUNT then exit;
    _mode := mode;
    VGAMode := C_VGA_VIDEO_MODES[mode].mode;
    asm
      mov ah, 0    { BIOS video function: set mode }
      mov al, VGAMode  { VGA 320x200 256-color mode }
      int 10h      { BIOS video interrupt }
    end;
  end;
  
  procedure TVGAVideoDriver.stop; 
  begin
    asm
      mov ah, 0  { BIOS video function: set mode }
      mov al, 3  { 80x25 16 color text (CGA,EGA,MCGA,VGA) }
      int 10h    { BIOS video interrupt }
    end;
  end;
  
  procedure TVGAVideoDriver.clear(color: byte);
  begin
  end;
  
  procedure TVGAVideoDriver.putPixel(x, y: word; color: byte);
  var
    w, h: word;
  begin
    w := C_VGA_VIDEO_MODES[_mode].xres - 1;
    h := C_VGA_VIDEO_MODES[_mode].yres - 1;
    if (x>w) or (y>h) then exit;
    if _mode = 0 then
    begin
      mem[$A000 : y shl 8 + y shl 6 + x] := color;
    end else begin
      putPlanarPixel(x, y, color);
    end;
  end;  

  procedure TVGAVideoDriver.setBlock(x, y, width, height: word; color: TColor8);
  var 
    i, offset: word;
    p: ^byte;
  begin
    if _mode = 0 then
    begin
      for i := y+height-1 downto y do
      begin 
        offset := i shl 8 + i shl 6 + x;
        p := ptr($A000, offset);
        fillchar(p^, width-1 ,color);
      end;
    end else
      inherited setBlock(x, y, width, height, color);
  end;

  function TVGAVideoDriver.getPixel(x, y: word): byte;
  var
    w, h: word;
  begin
    w := C_VGA_VIDEO_MODES[_mode].xres - 1;
    h := C_VGA_VIDEO_MODES[_mode].yres - 1;
    if (x>w) or (y>h) then exit;
    if _mode = 0 then
    begin
      getPixel := mem[$A000 : y shl 8 + y shl 6 + x];
    end else begin
    end;
  end;

  function TVGAVideoDriver.getClassName: string;
  begin
    getClassName := C_VGAVideoDriver_CLASSNAME;
  end;

  { TVGAVideoDriver private }

  { Other }

end.
