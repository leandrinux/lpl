{
  ucgadrv unit
  Driver for the 4-color CGA 320x200 graphics mode
  2025 LRT
}
unit
  ucgadrv;

interface

  uses
    consts, utils, types, locale, _cga,
    uobject, uexc, uviddrv;

  const
    C_CGAVideoDriver_CLASSNAME = 'TCGAVideoDriver';

  type
    PCGAVideoDriver = ^TCGAVideoDriver;
    TCGAVideoDriver = object (TVideoDriver)
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
      function getClassName: string; virtual;
    private
    end;

implementation

  { TCGAVideoDriver public }

  constructor TCGAVideoDriver.init;
  begin
    inherited init;
  end;

  destructor TCGAVideoDriver.done;
  begin
    inherited done;
  end;

  function TCGAVideoDriver.getWidth: word;
  begin
    getWidth := 320;
  end;

  function TCGAVideoDriver.getHeight: word; 
  begin
    getHeight := 200;
  end;
  
  function TCGAVideoDriver.getColorCount: longint;
  begin
    getColorCount := 4;
  end;

  function TCGAVideoDriver.detect: boolean; 
  begin
    detect := true;
  end;
  
  procedure TCGAVideoDriver.start; 
  begin
    _cga.setGraphicsMode;
  end;
  
  procedure TCGAVideoDriver.stop; 
  begin
    _cga.setTextMode;
  end;
  
  procedure TCGAVideoDriver.clear(color: byte);
  begin
  end;
  
  procedure TCGAVideoDriver.putPixel(x, y: word; color: byte);
  begin
    if (x>319) or (y>199) then exit;
    _cga.putpixel(x, y, color);
  end;  

  function TCGAVideoDriver.getClassName: string;
  begin
    getClassName := C_CGAVideoDriver_CLASSNAME;
  end;

  { TCGAVideoDriver private }

  { Other }

end.
