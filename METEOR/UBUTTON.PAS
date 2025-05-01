{
  ubutton unit
  Button control that can be pushed to trigger actions
  2025 LRT
}
unit
  ubutton;

interface

  uses
    consts, utils, types, locale,
    uobject, uexc, ucontrol, ubitmap, ucanvas;

  const
    C_Button_CLASSNAME = 'TButton';

  type
    PButton = ^TButton;
    TButton = object (TControl)
    public
      constructor init;
      destructor done; virtual;
      procedure draw(bitmap: PBitmap); virtual;
      function getClassName: string; virtual;
    private
    end;

implementation

  { TButton public }

  const
    C_DEFAULT_BUTTON_POSITION: TPoint = (x: 10; y: 10);
    C_DEFAULT_BUTTON_SIZE: TSize = (width: 60; height: 22);

  constructor TButton.init;
  begin
    inherited init;
    setPosition(@C_DEFAULT_BUTTON_POSITION);
    setSize(@C_DEFAULT_BUTTON_SIZE);
  end;

  destructor TButton.done;
  begin
    inherited done;
  end;

  procedure TButton.draw(bitmap: PBitmap);
  var
    canvas: PCanvas;
    position: TPoint;
    size: TSize;
  begin
    canvas := new (PCanvas, initWithBitmap(bitmap));
    position := getPosition^;
    size := getSize^;
    with canvas^, position, size do
    begin
      setStrokeColor(1);
      hline(x, x+width-1, y);
      vline(y, y+height-1, x);
      setStrokeColor(2);
      hline(x, x+width-1, y+height-1);
      vline(y, y+height-1, x+width-1);
    end;
    canvas^.release;
  end;

  function TButton.getClassName: string;
  begin
    getClassName := C_Button_CLASSNAME;
  end;

  { TButton private }

  { Other }

end.
