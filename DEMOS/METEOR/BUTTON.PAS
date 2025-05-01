uses
  ascii,
  xcrt,
  udisplay,
  umouse,
  ubutton;

var 
  display: PVideoDisplay;
  mouse: PMouse;

  button: PButton;

begin
  display := new(PVideoDisplay, initWithDriver(EVideoDriverEGA));
  display^.start(0);
  mouse := new(PMouse, init);
  mouse^.reset;
  mouse^.show;

  button := new(PButton, init);
  button^.draw(display);
  while (not keypressed) and (readkey<>C_ESC) do
  begin
    
  end;
  button^.release;

  mouse^.hide;
  mouse^.release;
  display^.stop;
  display^.release;
end.