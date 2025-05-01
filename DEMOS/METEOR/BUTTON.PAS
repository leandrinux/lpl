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
  PMyButton = ^TMyButton;
  TMyButton = object (TButton)
    procedure receiveMessage(msg: PObjectMessage); virtual;
  end;

procedure TMyButton.receiveMessage(msg: PObjectMessage);
begin
  if (msg^.opcode = C_MSG_MOUSE_LEFT_DOWN) and (isPointOver(PPoint(msg^.payload))) then 
  begin    
    beep;
  end;
end;

var 
  display: PVideoDisplay;
  mouse: PMouse;
  button: PMyButton;

begin
  display := new(PVideoDisplay, initWithDriver(EVideoDriverEGA));
  display^.start(0);
  mouse := new(PMouse, init);
  mouse^.reset;
  mouse^.show;

  button := new(PMyButton, init);
  button^.draw(display);
  mouse^.setDelegate(button);
  while not keypressed or (readkey<>C_ESC) do
  begin
    mouse^.update;
  end;
  button^.release;

  mouse^.hide;
  mouse^.release;
  display^.stop;
  display^.release;
end.