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
  for i:=1 to 200 do
  begin
    canvas^.setStrokeColor(random(bitmap^.getColorCount));
    canvas^.rect(random(w), random(h), random(100), random(100));
  end;
  for i:=1 to 200 do
  begin
    canvas^.setStrokeColor(random(bitmap^.getColorCount));
    canvas^.circle(random(w), random(h), random(100));
  end;
  for i:=1 to 200 do
  begin
    canvas^.setStrokeColor(random(bitmap^.getColorCount));
    canvas^.line(random(w), random(h), random(w), random(h));
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
  display^.stop;
  display^.release;
end;

begin
  runDemoWithDriver(EVideoDriverCGA);
  runDemoWithDriver(EVideoDriverVGA);
end.