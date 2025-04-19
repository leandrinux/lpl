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
    end;

implementation

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
    getWidth := 320;
  end;

  function TVGAVideoDriver.getHeight: word; 
  begin
    getHeight := 200;
  end;

  function TVGAVideoDriver.getColorCount: longint;
  begin
    getColorCount := 256;
  end;

  function TVGAVideoDriver.detect: boolean; 
  begin
    detect := true;
  end;
  
  procedure TVGAVideoDriver.start(mode: byte);
  begin
    asm
      mov ah, 0    { BIOS video function: set mode }
      mov al, $13  { VGA 320x200 256-color mode }
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
