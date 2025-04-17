{
  uviddrv unit
  Abstract model for video graphics drivers
  2025 LRT
}
unit
  uviddrv;

interface

  uses
    consts, utils, types, locale,
    uobject, uexc;

  const
    C_VideoDriver_CLASSNAME = 'TVideoDriver';

  type
    PVideoDriver = ^TVideoDriver;
    TVideoDriver = object (TObject)
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

  { TVideoDriver public }

  constructor TVideoDriver.init;
  begin
    inherited init;
  end;

  destructor TVideoDriver.done;
  begin
    inherited done;
  end;

  function TVideoDriver.getWidth: word;
  begin
    getWidth := 0;
  end;

  function TVideoDriver.getHeight: word; 
  begin
    getHeight := 0;
  end;

  function TVideoDriver.getColorCount: longint;
  begin
    getColorCount := 0;
  end;
  
  function TVideoDriver.detect: boolean; 
  begin
    detect := false;
  end;
  
  procedure TVideoDriver.start; 
  begin
  end;
  
  procedure TVideoDriver.stop; 
  begin
  end;
  
  procedure TVideoDriver.clear(color: byte);
  begin
  end;
  
  procedure TVideoDriver.putPixel(x, y: word; color: byte);
  begin
  end;  

  function TVideoDriver.getClassName: string;
  begin
    getClassName := C_VideoDriver_CLASSNAME;
  end;

  { TVideoDriver private }

  { Other }

end.
