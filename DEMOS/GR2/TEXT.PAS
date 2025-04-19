uses
  ascii, xcrt, udisplay, ubitmap, ucanvas, utrender, ufcatusm;

var
  display: PVideoDisplay;
  canvas: PCanvas;
  tr: PTextRenderer;

begin
  display := new(PVideoDisplay, initWithDriver(EVideoDriverEGA));
  display^.start(1);
  canvas := new(PCanvas, initWithBitmap(display));
  tr := new(PTextRenderer, init);

  tr^.setCanvas(canvas);
  tr^.setFont(CatusMono);
  canvas^.setStrokeColor(2);
  canvas^.setfillColor(2);
  tr^.setScale(5);
  tr^.writeln('HELLO WORLD');

  canvas^.setStrokeColor(1);
  tr^.setScale(2);
  tr^.writeln('Hello, World!');
  tr^.setScale(1);
  tr^.writeln('');
  tr^.writeln('This font name is ' + CatusMono^.getName );
  tr^.writeln('');
  tr^.writeln('The quick brown fox jumps over the lazy dog');
  tr^.writeln('THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG');
  tr^.writeln('');
  tr^.setScale(2);
  tr^.writeln('0 1 2 3 4 5 6 7 8 9');

  canvas^.setStrokeColor(15);
  tr^.write(C_CHR_FACE_HAPPY+' ');
  tr^.write(C_CHR_FACE_SAD+' ');
  tr^.write(C_CHR_FACE+' ');
  tr^.write(C_CHR_EXCLAMATION+' ');
  tr^.write(C_CHR_CLOSE+' ');
  tr^.write(C_CHR_TICK+' ');
  tr^.write(C_CHR_ARROW_RIGHT+' ');
  tr^.write(C_CHR_ARROW_LEFT+' ');
  tr^.write(C_CHR_ARROW_UP+' ');
  tr^.write(C_CHR_ARROW_DOWN+' ');

  readkey;

  tr^.release;
  canvas^.release;
  display^.stop;
  display^.release;
end.
