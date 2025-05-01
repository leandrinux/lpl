{
  uprocess unit
  Represents a Meteor process
  2025 LRT
}
unit
  uprocess;

interface

  uses
    consts, utils, types, locale,
    uobject, uexc;

  const
    C_Process_CLASSNAME = 'TProcess';

  type
    PProcess = ^TProcess;
    TProcess = object (TObject)
    public
      constructor init;
      destructor done; virtual;
      procedure start; virtual;
      procedure run; virtual;
      procedure kill; virtual;
      function getClassName: string; virtual;
    private
    end;

implementation

  { TProcess public }

  constructor TProcess.init;
  begin
    inherited init;
  end;

  destructor TProcess.done;
  begin
    inherited done;
  end;

  procedure TProcess.start;
  begin
  end;

  procedure TProcess.run;
  begin
  end;

  procedure TProcess.kill;
  begin
  end;

  function TProcess.getClassName: string;
  begin
    getClassName := C_Process_CLASSNAME;
  end;

  { TProcess private }

  { Other }

end.
