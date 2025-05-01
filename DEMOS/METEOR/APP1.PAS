uses 
  usystem,
  uprocess;

type
  PMyProcess = ^TMyProcess;
  TMyProcess = object (TProcess) 
    procedure start; virtual;
    procedure run; virtual;
    procedure kill; virtual;
  end;

procedure TMyProcess.start;
begin
  writeln('start');
end;

procedure TMyProcess.run;
begin
  writeln('run');
end;

procedure TMyProcess.kill;
begin
  writeln('killed');
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