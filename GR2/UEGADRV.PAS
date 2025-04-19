{
  uegadrv unit
  Driver for the 16-color EGA 320x200 graphics mode
  2025 LRT
}
unit
  uegadrv;

interface

  uses
    consts, utils, types, locale, _ega,
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
      procedure start; virtual;
      procedure stop; virtual;
      procedure clear(color: byte); virtual;
      procedure putPixel(x, y: word; color: byte); virtual;
      function getPixel(x, y: word): byte; virtual;
      function getClassName: string; virtual;
    private
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
    getWidth := 320;
  end;

  function TEGAVideoDriver.getHeight: word; 
  begin
    getHeight := 200;
  end;
  
  function TEGAVideoDriver.getColorCount: longint;
  begin
    getColorCount := 16;
  end;

  function TEGAVideoDriver.detect: boolean; 
  begin
    detect := true;
  end;
  
  procedure TEGAVideoDriver.start; 
  begin
    _ega.setGraphicsMode;
  end;
  
  procedure TEGAVideoDriver.stop; 
  begin
    _ega.setTextMode;
  end;
  
  procedure TEGAVideoDriver.clear(color: byte);
  begin
  end;
  
  procedure TEGAVideoDriver.putPixel(x, y: word; color: byte);
  begin
    if (x>319) or (y>199) then exit;
    _ega.putpixel(x, y, color);
  end;  

  function TEGAVideoDriver.getPixel(x, y: word): byte;
  begin
    if (x>319) or (y>199) then exit;
    getPixel := 0; { _cga.getPixel(x, y); }
  end;  

  function TEGAVideoDriver.getClassName: string;
  begin
    getClassName := C_EGAVideoDriver_CLASSNAME;
  end;

  { TEGAVideoDriver private }

  { Other }

end.
