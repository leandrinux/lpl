{
  ucanvas unit
  Used to draw on a bitmap
  2025 LRT
}
unit
  ucanvas;

interface

  uses
    consts, utils, types, locale,
    uobject, uexc, ubitmap;

  const
    C_Canvas_CLASSNAME = 'TCanvas';

  type
    PCanvas = ^TCanvas;
    TCanvas = object (TObject)
    public
      constructor initWithBitmap(bitmap: PBitmap);
      destructor done; virtual;
      procedure setStrokeColor(color: TColor);
      procedure setFillColor(color: TColor);
      procedure setPixel(x, y: word; color: TColor);
      procedure hline(x1, x2, y: word);
      procedure vline(y1, y2, x: word);
      procedure rect(x, y, width, height: word);
      procedure circle(x, y, radius: word);
      procedure line(x1, y1, x2, y2: integer);
      function getClassName: string; virtual;
    private
      _bitmap: PBitmap;
      _strokeColor: TColor;
      _fillColor: TColor;
    end;

implementation

  { TCanvas public }

  constructor TCanvas.initWithBitmap(bitmap: PBitmap);
  begin
    inherited init;
    _bitmap := bitmap;
    _bitmap^.retain;
    _strokeColor := 1;
    _fillColor := 0;
  end;

  destructor TCanvas.done;
  begin
    _bitmap^.release;
    inherited done;
  end;

  procedure TCanvas.setStrokeColor(color: TColor);
  begin
    _strokeColor := color;
  end;

  procedure TCanvas.setFillColor(color: TColor);
  begin
    _fillColor := color;
  end;

  procedure TCanvas.setPixel(x, y: word; color: TColor);
  begin
    _bitmap^.setPixel(x, y, color);
  end;

  procedure TCanvas.hline(x1, x2, y: word);
  var x: word;
  begin
    for x := x2 downto x1 do _bitmap^.setPixel(x, y, _strokeColor);
  end;

  procedure TCanvas.vline(y1, y2, x: word);
  var y: word;
  begin
    for y := y2 downto y1 do _bitmap^.setPixel(x, y, _strokeColor);
  end;

  procedure TCanvas.rect(x, y, width, height: word);
  var i: word;
  begin
    for i := x + width - 1 downto x do
    begin
      _bitmap^.setPixel(i, y, _strokeColor);
      _bitmap^.setPixel(i, y+height-1, _strokeColor);
    end;
    for i := y + height - 1 downto y do
    begin
      _bitmap^.setPixel(x, i, _strokeColor);
      _bitmap^.setPixel(x+width-1, i, _strokeColor);
    end;
  end;

  procedure TCanvas.circle(x, y, radius: word);
  var
    px, py, d: integer;
    dE, dSE: integer;
  begin    
    px := 0;
    py := radius;
    d := 1 - radius;
    dE := 3;
    dSE := -(radius shl 1) + 5;
    _bitmap^.setPixel(x, y-py, _strokeColor);
    _bitmap^.setPixel(x, y+py, _strokeColor);
    _bitmap^.setPixel(x+py, y-px, _strokeColor);
    _bitmap^.setPixel(x-py, y+px, _strokeColor);
    while py>px do
    begin
      if d<0 then
      begin
        d := d + dE;
        dE := dE + 2;
        dSE := dSE + 2;
        px := px + 1;
      end else
      begin
        d := d + dSE;
        dE := dE + 2;
        dSE := dSE + 4;
        px := px + 1;
        py := py - 1;
      end;
      _bitmap^.setPixel(x+px, y-py, _strokeColor);
      _bitmap^.setPixel(x-px, y+py, _strokeColor);
      _bitmap^.setPixel(x-px, y-py, _strokeColor);
      _bitmap^.setPixel(x+px, y+py, _strokeColor);
      _bitmap^.setPixel(x+py, y-px, _strokeColor);
      _bitmap^.setPixel(x-py, y+px, _strokeColor);
      _bitmap^.setPixel(x-py, y-px, _strokeColor);
      _bitmap^.setPixel(x+py, y+px, _strokeColor);
    end;
  end;

  procedure TCanvas.line(x1, y1, x2, y2: integer);

    function sign(a:integer): integer;
    begin
      if a>0 then sign:=+1 else if a<0 then sign:=-1 else sign:=0;
    end;

  var
    d1x, d1y, d2x, d2y: integer;
    u, v, m, n, s, i: integer;

  begin
     u:= x2 - x1;
     v:= y2 - y1;
     d1x:= sign(u);
     d1y:= sign(v);
     d2x:= sign(u);
     d2y:= 0;
     m := abs(u);
     n := abs(v);
     if not (m>n) then
     begin
       d2x := 0 ;
       d2y := sign(v);
       m := abs(v);
       n := abs(u);
     end;
     s := m shr 1;
     for i := 0 to m do
     begin
       _bitmap^.setPixel(x1, y1, _strokeColor);
       s := s + n;
       if not (s<m) then
       begin
         s := s - m;
         x1 := x1 + round(d1x);
         y1 := y1 + round(d1y);
       end else
       begin
         x1 := x1 + round(d2x);
         y1 := y1 + round(d2y);
       end;
     end;
  end;

  function TCanvas.getClassName: string;
  begin
    getClassName := C_Canvas_CLASSNAME;
  end;

  { TCanvas private }

  { Other }

end.
