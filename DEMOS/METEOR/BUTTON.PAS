uses
  ascii, types, xcrt,
  udisplay, uobject, umsgs, umsgbus, umouse, ubutton;

{ Example app class }

type
  PExampleApp = ^TExampleApp;
  TExampleApp = object (TButton)
    constructor init;
    destructor done; virtual;
    procedure run;
    procedure receiveMessage(msg: PObjectMessage); virtual;
  private
    display: PVideoDisplay;
    mouse: PMouse;
    buttonA, buttonB: PButton;
    bus: PMessageBus;
  end;

constructor TExampleApp.init;
var
  point: TPoint;
begin
  inherited init;
  display := new(PVideoDisplay, initWithDriver(EVideoDriverEGA));
  mouse := new(PMouse, init);
  bus := new(PMessageBus, init);  
  buttonA := new(PButton, init);
  buttonB := new(PButton, init);

  display^.start(0);
  mouse^.reset;
  mouse^.show;
  mouse^.setDelegate(bus);

  buttonA^.draw(display);
  bus^.subscribe(buttonA);
  buttonA^.setDelegate(@self);

  point.x := 100;
  point.y := 10;
  buttonB^.setPosition(@point);
  buttonB^.draw(display);
  bus^.subscribe(buttonB);
  buttonB^.setDelegate(@self);
end;

destructor TExampleApp.done;
begin
  display^.stop;
  display^.release;
  mouse^.hide;
  mouse^.release;
  bus^.release;
  buttonA^.release;
  buttonB^.release;
end;

procedure TExampleApp.receiveMessage(msg: PObjectMessage); 
begin
  if msg^.opcode = C_MSG_BUTTON_ONCLICK then
    if PButton(msg^.sender) = buttonA then
      beep
    else if PButton(msg^.sender) = buttonB then begin
      beep; beep;
    end;
end;

procedure TExampleApp.run;
begin
  while not keypressed or (readkey<>C_ESC) do mouse^.update;
end;

{ Main program }

var
  app: PExampleApp;

begin
  app := new(PExampleApp, init);
  app^.run;
  app^.release;
end.