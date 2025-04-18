uses
  xcrt, udisplay, ubitmap, ucanvas, utrender, usysfont;

var
  display: PVideoDisplay;
  canvas: PCanvas;
  tr: PTextRenderer;

begin
  display := new(PVideoDisplay, initWithDriver(EVideoDriverVGA));
  display^.start;

  canvas := new(PCanvas, initWithBitmap(display));
  tr := new(PTextRenderer, init);
  tr^.setCanvas(canvas);
  tr^.setFont(SystemFont);
  tr^.writeln('Hello World!');
  tr^.release;
  canvas^.release;

  readkey;

  display^.stop;
  display^.release;
end.
