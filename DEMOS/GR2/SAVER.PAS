uses
  xcrt, udisplay, ubitmap, ucanvas;

var
  w, h: word;
  ax, ay, aincx, aincy: integer;
  bx, by, bincx, bincy: integer;
  display: PVideoDisplay;
  canvas: PCanvas;

begin
  display := new(PVideoDisplay, initWithDriver(EVideoDriverEGA));  
  canvas := new(PCanvas, initWithBitmap(display));
  display^.start(1);
  w := display^.getWidth;
  h := display^.getHeight;  

  ax := random(w); ay := random(h); aincx := random(7) - 3; aincy := random(7) - 3;
  bx := random(w); by := random(h); bincx := random(7) - 3; bincy := random(7) - 3;
  
  while not keypressed do
  begin

    ax := ax + aincx; if (ax <= 0) or (ax >= w) then aincx := -aincx; 
    ay := ay + aincy; if (ay <= 0) or (ay >= h) then aincy := -aincy; 
    bx := bx + bincx; if (bx <= 0) or (bx >= w) then bincx := -bincx; 
    by := by + bincy; if (by <= 0) or (by >= h) then bincy := -bincy; 

    canvas^.setStrokeColor(random(display^.getColorCount));
    canvas^.line(ax, ay, bx, by);
    delay(10); 
  end;

  display^.stop;
  canvas^.release;
  display^.release;
end.