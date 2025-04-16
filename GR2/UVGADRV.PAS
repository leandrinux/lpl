{
  uvgadrv unit
  Driver for the 256-color VGA 320x200 graphics mode
  2025 LRT
}
unit
  uvgadrv;

interface

  uses
    consts, utils, types, locale, _vga, 
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
      function detect: boolean; virtual;
      procedure start; virtual;
      procedure stop; virtual;
      procedure clear(color: byte); virtual;
      procedure putPixel(x, y: word; color: byte); virtual;
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
  
  function TVGAVideoDriver.detect: boolean; 
  begin
    detect := true;
  end;
  
  procedure TVGAVideoDriver.start; 
  begin
    _vga.setGraphicsMode;
  end;
  
  procedure TVGAVideoDriver.stop; 
  begin
    _vga.setTextMode;
  end;
  
  procedure TVGAVideoDriver.clear(color: byte);
  begin
  end;
  
  procedure TVGAVideoDriver.putPixel(x, y: word; color: byte);
  begin
    if (x>319) or (y>199) then exit;
    _vga.putpixel(x, y, color);
  end;  

  function TVGAVideoDriver.getClassName: string;
  begin
    getClassName := C_VGAVideoDriver_CLASSNAME;
  end;

  { TVGAVideoDriver private }

  { Other }

end.
