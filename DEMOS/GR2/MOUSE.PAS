uses
  xcrt, 
  udisplay,
  umouse;

var
  display: PVideoDisplay;
  mouse: PMouse;

begin
  display := new(PVideoDisplay, initWithDriver(EVideoDriverVGA));
  display^.start(1);
  mouse := new(PMouse, init);
  mouse^.show;

  readkey;

  mouse^.hide;
  mouse^.release;
  display^.stop;
  display^.release;
end.