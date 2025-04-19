{
  usystem unit
  Manages running apps
  2025 LRT
}
unit
  usystem;

interface

  uses
    ascii, consts, utils, types, locale,
    uobject, uexc, ulist, umsgbus,
    uapp, umouse, ukeybrd, udisplay, umsgs, ummsgs;

  const
    C_System_CLASSNAME = 'TSystem';

  type
    PSystem = ^TSystem;
    TSystem = object (TObject)
    public
      constructor init;
      destructor done; virtual;
      procedure start;
      procedure loadApp(app: PMeteorApp);
      procedure receiveMessage(msg: PObjectMessage); virtual;
      function getClassName: string; virtual;
    private
      _display: PVideoDisplay;
      _bus: PMessageBus;
      _apps: PList;
      _running: boolean;
    end;

implementation

  { TSystem public }

  constructor TSystem.init;
  begin
    inherited init;
    _apps := new(PList, init);
    _bus := new(PMessageBus, init);
    _bus^.subscribe(@self);
    _display := new(PVideoDisplay, initWithDriver(EVideoDriverEGA));
    Keyboard^.setDelegate(@self);   { send keyboard messages to the user interface }
    Mouse^.setDelegate(@self);      { send mouse messages to the user interface }
  end;

  destructor TSystem.done;
  begin
    _display^.release;
    _bus^.unsubscribe(@self);
    _bus^.release;
    _apps^.release;
    inherited done;
  end;

  procedure TSystem.start;
  begin
    _running := true;
    _display^.start(1);            { start the graphics mode }
    Mouse^.reset;                  { prepare the mouse after changing video mode }
    Mouse^.show;                   { show the mouse cursor }
    while _running do
    begin
      Mouse^.update;               { update mouse status }
      Keyboard^.update;            { update keyboard status }
    end;
    Mouse^.hide;                   { hide the mouse cursor }
    _display^.stop;                 { stops the graphics mode }
  end;

  procedure TSystem.loadApp(app: PMeteorApp);
  begin
    _apps^.addObject(app);
  end;

  procedure TSystem.receiveMessage(msg: PObjectMessage);
  begin
    case msg^.opcode of
      C_MSG_SYSTEM_SHUTDOWN: 
        _running := false;

      C_MSG_KEYBOARD_KEY_DOWN: 
        if PChar(msg^.payload)^ = C_ESC then
          sendMessage(C_MSG_SYSTEM_SHUTDOWN, _bus);
    end;
  end;

  function TSystem.getClassName: string;
  begin
    getClassName := C_System_CLASSNAME;
  end;

  { TSystem private }

  { Other }

end.
