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
      function getPixel(x, y: word): byte; virtual;
      function getClassName: string; virtual;
    private
      _mode: byte;
    end;

implementation

  const
    C_VGA_VIDEO_MODE_COUNT = 1;

    C_VGA_VIDEO_MODES: array[0..C_VGA_VIDEO_MODE_COUNT-1] of TVideoModeInfo = (
      (xres:320; yres:200; colors:256; mode:$13)
    );  

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
  begin
    if (x>319) or (y>199) then exit;
    mem[$A000 : y shl 8 + y shl 6 + x] := color;
  end;  

  function TVGAVideoDriver.getPixel(x, y: word): byte;
  begin
    if (x>319) or (y>199) then exit;
    getPixel := mem[$A000 : y shl 8 + y shl 6 + x];
  end;

  function TVGAVideoDriver.getClassName: string;
  begin
    getClassName := C_VGAVideoDriver_CLASSNAME;
  end;

  { TVGAVideoDriver private }

  { Other }

end.
