{
  udisplay unit
  Device used to display graphics on screen
  2025 LRT
}
unit
  udisplay;

interface

  uses
    consts, utils, types, locale,
    uobject, uexc, uviddrv, ucgadrv, uvgadrv;

  const
    C_VideoDisplay_CLASSNAME = 'TVideoDisplay';

  type
    EVideoDriver = (
      EVideoDriverCGA,
      EVideoDriverVGA
    );

    PVideoDisplay = ^TVideoDisplay;
    TVideoDisplay = object (TObject)
    public
      constructor init;
      constructor initWithDriver(driver: EVideoDriver);
      destructor done; virtual;
      procedure setDriver(driver: EVideoDriver);
      procedure start;
      procedure stop;
      function getClassName: string; virtual;
    private
      _driver: PVideoDriver;
    end;

implementation

  { TVideoDisplay public }

  constructor TVideoDisplay.init;
  begin
    inherited init;
    _driver := nil;
  end;

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
    if _driver = nil then exit;
    _driver^.start;
  end;

  procedure TVideoDisplay.stop;
  begin
    if _driver = nil then exit;
    _driver^.stop;
  end;

  function TVideoDisplay.getClassName: string;
  begin
    getClassName := C_VideoDisplay_CLASSNAME;
  end;

  { TVideoDisplay private }

  { Other }

end.
