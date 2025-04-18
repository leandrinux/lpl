{
  udisplay unit
  Bitmap device used to display graphics on screen
  2025 LRT
}
unit
  udisplay;

interface

  uses
    consts, utils, types, locale,
    uobject, uexc, ubitmap, uviddrv, ucgadrv, uvgadrv;

  const
    C_VideoDisplay_CLASSNAME = 'TVideoDisplay';

  type
    EVideoDriver = (
      EVideoDriverCGA,
      EVideoDriverVGA
    );

    PVideoDisplay = ^TVideoDisplay;
    TVideoDisplay = object (TBitmap)
    public
      constructor initWithDriver(driver: EVideoDriver);
      destructor done; virtual;
      procedure setDriver(driver: EVideoDriver);
      procedure start;
      procedure stop;

      function getWidth: word; virtual;
      function getHeight: word; virtual;
      function getColorCount: longint; virtual;
      procedure setPixel(x, y: word; color: TColor8); virtual;

      function getClassName: string; virtual;
    private
      _driver: PVideoDriver;
    end;

implementation

  { TVideoDisplay public }

  constructor TVideoDisplay.initWithDriver(driver: EVideoDriver);
  begin
    inherited init;
    setDriver(driver);
  end;

  destructor TVideoDisplay.done;
  begin
    if _driver <> nil then _driver^.release;
    inherited done;
  end;

  procedure TVideoDisplay.setDriver(driver: EVideoDriver);
  begin
    case driver of 
      EVideoDriverCGA: _driver := new(PCGAVideoDriver, init);
      EVideoDriverVGA: _driver := new(PVGAVideoDriver, init);
    end;
  end;

  procedure TVideoDisplay.start;
  begin
    _driver^.start;
  end;

  procedure TVideoDisplay.stop;
  begin
    _driver^.stop;
  end;

  function TVideoDisplay.getWidth: word;
  begin
    getWidth := _driver^.getWidth;
  end;

  function TVideoDisplay.getHeight: word;
  begin
    getHeight := _driver^.getHeight;
  end;

  function TVideoDisplay.getColorCount: longint;
  begin
    getColorCount := _driver^.getColorCount;
  end;

  procedure TVideoDisplay.setPixel(x, y: word; color: TColor8);
  begin
    _driver^.putPixel(x, y, color);
  end;

  function TVideoDisplay.getClassName: string;
  begin
    getClassName := C_VideoDisplay_CLASSNAME;
  end;

  { TVideoDisplay private }

  { Other }

end.
