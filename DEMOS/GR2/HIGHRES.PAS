uses
  xcrt, udisplay, ubitmap, ucanvas;

var
  display: PVideoDisplay;
  canvas: PCanvas;

begin
  display := new(PVideoDisplay, initWithDriver(EVideoDriverEGA));
  display^.start(1);

  canvas := new(PCanvas, initWithBitmap(display));
  canvas^.circle(320, 175, 100);
  canvas^.release;

  readkey;
  display^.stop;
  display^.release;
end.
