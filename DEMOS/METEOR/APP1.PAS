uses 
  usystem,
  uprocess;

type
  PMyProcess = ^TMyProcess;
  TMyProcess = object (TProcess) 
  end;

var
  process: PMyProcess;
  sys: PSystem;

begin
  sys := new(PSystem, init);

  process := new(PMyProcess, init);
  sys^.load(process);
  process^.release;

  sys^.start;
  sys^.release;
end.