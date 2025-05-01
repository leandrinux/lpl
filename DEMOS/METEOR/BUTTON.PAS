uses
  ascii,
  types,
  xcrt,
  udisplay,
  uobject,
  umsgs,
  umsgbus,
  umouse,
  ubutton;

type
  PEventHandler = ^TEventHandler;
  TEventHandler = object (TButton)
    procedure receiveMessage(msg: PObjectMessage); virtual;
  end;

var 
  display: PVideoDisplay;
  mouse: PMouse;
  eventHandler: PEventHandler;
  buttonA, buttonB: PButton;
  bus: PMessageBus;
  point: TPoint;

procedure TEventHandler.receiveMessage(msg: PObjectMessage); 
begin
  if msg^.opcode = C_MSG_BUTTON_ONCLICK then
    if PButton(msg^.sender) = buttonA then
      beep
    else begin
      beep; beep;
    end;
end;

begin
  display := new(PVideoDisplay, initWithDriver(EVideoDriverEGA));
  display^.start(0);
  mouse := new(PMouse, init);
  mouse^.reset;
  mouse^.show;

  bus := new(PMessageBus, init);
  eventHandler := new(PEventHandler, init);

  buttonA := new(PButton, init);
  buttonA^.draw(display);
  bus^.subscribe(buttonA);

  buttonB := new(PButton, init);
  point.x := 100;
  point.y := 10;
  buttonB^.setPosition(@point);
  buttonB^.draw(display);
  bus^.subscribe(buttonB);

  mouse^.setDelegate(bus);
  buttonA^.setDelegate(eventHandler);
  buttonB^.setDelegate(eventHandler);
  while not keypressed or (readkey<>C_ESC) do
  begin
    mouse^.update;
  end;
  buttonA^.release;
  buttonB^.release;
  eventHandler^.release;

  bus^.release;
  mouse^.hide;
  mouse^.release;
  display^.stop;
  display^.release;
end.