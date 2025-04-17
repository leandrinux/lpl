uses
  xcrt, udisplay, ubitmap, ucanvas;

procedure draw(bitmap: PBitmap);
var
  canvas: PCanvas;
  i: byte;
  w, h: word;
begin
  canvas := new(PCanvas, initWithBitmap(bitmap));
  w := bitmap^.getWidth;
  h := bitmap^.getHeight;
  randomize;
  for i:=1 to 100 do
  begin
    canvas^.setStrokeColor(random(bitmap^.getColorCount));
    canvas^.rect(random(w), random(h), random(100), random(100));
  end;
  canvas^.release;
end;

procedure runDemoWithDriver(driver: EVideoDriver);
var
  display: PVideoDisplay;
begin
  display := new(PVideoDisplay, initWithDriver(driver));
  display^.start;
  draw(display);
  readkey;
  display^.stop;
  display^.release;
end;

begin
  runDemoWithDriver(EVideoDriverCGA);
  runDemoWithDriver(EVideoDriverVGA);
end.