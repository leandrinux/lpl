{
  UVidDrv Unit
  An abstract video driver for a display adapter
  2022 LRT
}
unit
  uviddrv;

interface

  uses
    uexc, types, locale, uobject, ubitmap, upalette;

  type
    PVideoDriver = ^TVideoDriver;
    TVideoDriver = object (TObject)
    public
      constructor init;
      destructor done; virtual;
      function isAvailable: boolean; virtual;
      function supportsPalette: boolean; virtual;
      function getCurrentVideoMode: PVideoMode; virtual;
      function getBitmap: PBitmap; virtual;
      procedure getVideoModes(var list:PVideoMode; var count: word); virtual;
      procedure setVideoMode(index: word); virtual;
      procedure setTextMode; virtual;
      procedure setPalette(palette: PColorPalette); virtual;
      function getDriverName: string; virtual;
      function getClassName: string; virtual;
    private
    end;

implementation

  { TVideoDriver }

  constructor TVideoDriver.init;
  begin
    inherited init;
  end;

  destructor TVideoDriver.done;
  begin
    inherited done;
  end;

  function TVideoDriver.isAvailable: boolean;
  begin
    isAvailable := false;
  end;

  function TVideoDriver.supportsPalette: boolean;
  begin
    supportsPalette := false;
  end;

  function TVideoDriver.getCurrentVideoMode: PVideoMode;
  begin
    getCurrentVideoMode := nil;
  end;

  function TVideoDriver.getBitmap: PBitmap;
  begin
    getBitmap := nil;
  end;

  procedure TVideoDriver.getVideoModes(var list:PVideoMode; var count: word); begin end;

  procedure TVideoDriver.setVideoMode(index: word); begin end;

  procedure TVideoDriver.setTextMode; begin end;

  procedure TVideoDriver.setPalette(palette: PColorPalette); begin end;

  function TVideoDriver.getDriverName: string;
  begin
    getDriverName := '';
  end;

  function TVideoDriver.getClassName: string;
  begin
    getClassName := 'TVideoDriver';
  end;

  { Other }

end.