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
    uobject, uexc, ucontrol, ubitmap, ucanvas, umsgs, 
    ustring, utrender, ufcatusm, ucscheme;

  const
    C_Button_CLASSNAME = 'TButton';

    C_MSG_BUTTON_ONCLICK = 100;

  type
    EButtonState = (
      EButtonStateUp,
      EButtonStateDown
    );

    PButton = ^TButton;
    TButton = object (TControl)
    public
      constructor init;
      destructor done; virtual;
      procedure draw; virtual;
      procedure setCaption(const caption: string);
      function getClassName: string; virtual;
      procedure receiveMessage(msg: PObjectMessage); virtual;
    private
      _caption: PString;
      _state: EButtonState;
      procedure drawUp;
      procedure drawDown;
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
    _caption := nil;
    _state := EButtonStateUp;
  end;

  destructor TButton.done;
  begin
    if _caption <> nil then _caption^.release;
    inherited done;
  end;

  procedure TButton.draw;
  begin
    case _state of
      EButtonStateUp: drawUp;
      EButtonStateDown: drawDown;
    end;
  end;

  procedure TButton.setCaption(const caption: string);
  begin
    if _caption <> nil then _caption^.release;
    _caption := new(PString, initWithValue(caption));
  end;

  function TButton.getClassName: string;
  begin
    getClassName := C_Button_CLASSNAME;
  end;

  procedure TButton.receiveMessage(msg: PObjectMessage);
  begin
    if getDelegate = nil then exit;
    if (msg^.opcode = C_MSG_MOUSE_LEFT_DOWN) and (isPointOver(PPoint(msg^.payload))) then
    begin
      _state := EButtonStateDown;
      draw;
      sendMessage(C_MSG_BUTTON_ONCLICK, getDelegate);
    end else if (msg^.opcode = C_MSG_MOUSE_LEFT_UP) and (_state = EButtonStateDown) then
    begin
      _state := EButtonStateUp;
      draw;     
    end;
  end;

  { TButton private }

  procedure TButton.drawUp;
  var
    canvas: PCanvas;
    position: TPoint;
    size: TSize;
    tr: PTextRenderer;
  begin
    canvas := new(PCanvas, initWithBitmap(getBitmap));
    tr := new(PTextRenderer, init);
    tr^.setCanvas(canvas);
    tr^.setFont(CatusMono);
    position := getPosition^;
    size := getSize^;
    with canvas^, position, size do
    begin
      setFillColor(ColorScheme^.background);
      filledRect(x, y, width, height);
      setStrokeColor(ColorScheme^.highlight);
      hline(x, x+width-1, y);
      vline(y, y+height-1, x);
      setStrokeColor(ColorScheme^.shadow);
      hline(x, x+width-1, y+height-1);
      vline(y, y+height-1, x+width-1);
      setStrokeColor(ColorScheme^.activeText);
      if _caption <> nil then 
      begin
        tr^.setCursor(x+3, y+3);
        tr^.write(_caption^.getValue);
      end;
    end;
    tr^.release;
    canvas^.release;
  end;

  procedure TButton.drawDown;
  var
    canvas: PCanvas;
    position: TPoint;
    size: TSize;
    tr: PTextRenderer;
  begin
    canvas := new(PCanvas, initWithBitmap(getBitmap));
    tr := new(PTextRenderer, init);
    tr^.setCanvas(canvas);
    tr^.setFont(CatusMono);
    position := getPosition^;
    size := getSize^;
    with canvas^, position, size do
    begin
      setFillColor(ColorScheme^.background);
      filledRect(x, y, width, height);
      setStrokeColor(ColorScheme^.shadow);
      hline(x, x+width-1, y);
      vline(y, y+height-1, x);
      setStrokeColor(ColorScheme^.highlight);
      hline(x, x+width-1, y+height-1);
      vline(y, y+height-1, x+width-1);
      setStrokeColor(ColorScheme^.inactiveText);
      if _caption <> nil then 
      begin
        tr^.setCursor(x+3, y+3);
        tr^.write(_caption^.getValue);
      end;
    end;
    tr^.release;
    canvas^.release;
  end;

  { Other }

end.
