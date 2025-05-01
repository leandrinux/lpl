uses
  ascii,
  types,
  xcrt,
  udisplay,
  uobject,
  umsgs,
  umouse,
  ubutton;

type
  PEventHandler = ^TEventHandler;
  TEventHandler = object (TButton)
    procedure receiveMessage(msg: PObjectMessage); virtual;
  end;

procedure TEventHandler.receiveMessage(msg: PObjectMessage); 
begin
  if msg^.opcode = C_MSG_BUTTON_ONCLICK then beep;
end;

var 
  display: PVideoDisplay;
  mouse: PMouse;
  eventHandler: PEventHandler;
  button: PButton;

begin
  display := new(PVideoDisplay, initWithDriver(EVideoDriverEGA));
  display^.start(0);
  mouse := new(PMouse, init);
  mouse^.reset;
  mouse^.show;

  eventHandler := new(PEventHandler, init);
  button := new(PButton, init);
  button^.draw(display);
  mouse^.setDelegate(button);
  button^.setDelegate(eventHandler);
  while not keypressed or (readkey<>C_ESC) do
  begin
    mouse^.update;
  end;
  button^.release;
  eventHandler^.release;

  mouse^.hide;
  mouse^.release;
  display^.stop;
  display^.release;
end.