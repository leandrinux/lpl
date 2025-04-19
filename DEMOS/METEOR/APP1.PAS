uses 
  usystem;

var
  sys: PSystem;

begin
  sys := new (PSystem, init);
  sys^.start;
  sys^.release;
end.