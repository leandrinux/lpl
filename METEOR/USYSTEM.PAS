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
    uprocess, umouse, ukeybrd, udisplay, umsgs, ummsgs;

  const
    C_System_CLASSNAME = 'TSystem';

  type
    TSystemConfig = record
      displayDriver: EVideoDriver;
      displayMode: byte;
      mouseSupport: boolean;
    end;

  const
    C_DEFAULT_SYSTEM_CONFIG : TSystemConfig = (
      displayDriver: EVideoDriverVGA;
      displayMode: 0;
      mouseSupport: true
    );

  type

    PSystem = ^TSystem;
    TSystem = object (TObject)
    public
      constructor init;
      destructor done; virtual;
      procedure start;
      procedure startWithConfig(const config: TSystemConfig);
      procedure load(process: PProcess);
      procedure receiveMessage(msg: PObjectMessage); virtual;
      function getClassName: string; virtual;
    private
      _display: PVideoDisplay;
      _bus: PMessageBus;
      _running: boolean;
      _pendingList: PList;
      _runningList: PList;
      procedure startPendingProcesses;
      procedure executeRunningProcesses;
      procedure killRunningProcesses;
    end;

implementation

  { TSystem public }

  constructor TSystem.init;
  begin
    inherited init;
    _pendingList := new(PList, init);
    _runningList := new(PList, init);
    _bus := new(PMessageBus, init);
    _bus^.subscribe(@self);
    Keyboard^.setDelegate(_bus);   { send keyboard messages to the message bus }
    Mouse^.setDelegate(_bus);      { send mouse messages to the message bus }
  end;

  destructor TSystem.done;
  begin
    _bus^.unsubscribe(@self);
    _bus^.release;
    _pendingList^.release;
    _runningList^.release;
    inherited done;
  end;

  procedure TSystem.start;
  begin
    startWithConfig(C_DEFAULT_SYSTEM_CONFIG);
  end;

  procedure TSystem.startWithConfig(const config: TSystemConfig);
  begin
    _running := true;
    _display := new(PVideoDisplay, initWithDriver(config.displayDriver));
    _display^.start(config.displayMode); { start the graphics mode }
    if config.mouseSupport then
    begin
      Mouse^.reset;                  { prepare the mouse after changing video mode }
      Mouse^.show;                   { show the mouse cursor }
    end;
    while _running do
    begin
      Mouse^.update;               { update mouse status }
      Keyboard^.update;            { update keyboard status }
      startPendingProcesses;
      executeRunningProcesses;
    end;
    killRunningProcesses;
    if config.mouseSupport then Mouse^.hide; { hide the mouse cursor }
    _display^.stop;                 { stops the graphics mode }
    _display^.release;
  end;

  procedure TSystem.load(process: PProcess);
  begin
    if process = nil then exit;
    _pendingList^.addObject(process);
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

  procedure TSystem.startPendingProcesses;
  var
    process: PProcess;
  begin
    process := PProcess(_pendingList^.getFirst);
    while process <> nil do
    begin
      process^.start;
      _runningList^.addObject(process);
      _pendingList^.removeFirst;
      process := PProcess(_pendingList^.getFirst);
    end;
  end;

  procedure TSystem.executeRunningProcesses;
  var
    process: PProcess;
  begin
    _runningList^.moveToStart;
    process := PProcess(_runningList^.getObjectAtCursor);
    while process <> nil do
    begin
      process^.run;
      _runningList^.moveForward;
      process := PProcess(_runningList^.getObjectAtCursor);
    end;
  end;

  procedure TSystem.killRunningProcesses;
  var
    process: PProcess;
  begin
    process := PProcess(_runningList^.getFirst);
    while process <> nil do
    begin
      process^.kill;
      _runningList^.removeFirst;
      process := PProcess(_runningList^.getFirst);
    end;
  end;

  { Other }

end.
