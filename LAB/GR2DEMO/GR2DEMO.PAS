uses
  xcrt, udisplay;

var
  display: PVideoDisplay;

begin
  display := new(PVideoDisplay, initWithDriver(EVideoDriverVGA));
  display^.start;
  readkey;
  display^.stop;
  display^.release;
end.