uses
  xcrt, udisplay, ubitmap, ucanvas;

var
  ax, ay, aincx, aincy: integer;
  bx, by, bincx, bincy: integer;
  display: PVideoDisplay;
  canvas: PCanvas;

begin
  display := new(PVideoDisplay, initWithDriver(EVideoDriverVGA));  
  canvas := new(PCanvas, initWithBitmap(display));
  display^.start;

  ax := random(320); ay := random(200); aincx := random(7) - 3; aincy := random(7) - 3;
  bx := random(320); by := random(200); bincx := random(7) - 3; bincy := random(7) - 3;
  
  while not keypressed do
  begin

    ax := ax + aincx; if (ax <= 0) or (ax >= 319) then aincx := -aincx; 
    ay := ay + aincy; if (ay <= 0) or (ay >= 200) then aincy := -aincy; 
    bx := bx + bincx; if (bx <= 0) or (bx >= 319) then bincx := -bincx; 
    by := by + bincy; if (by <= 0) or (by >= 200) then bincy := -bincy; 

    canvas^.setStrokeColor(random(display^.getColorCount));
    canvas^.line(ax, ay, bx, by);
    delay(10); 
  end;

  display^.stop;
  canvas^.release;
  display^.release;
end.