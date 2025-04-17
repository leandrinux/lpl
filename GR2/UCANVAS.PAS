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
    for x := x2 downto x1 do setPixel(x, y, _strokeColor);
  end;

  procedure TCanvas.vline(y1, y2, x: word);
  var y: word;
  begin
    for y := y2 downto y1 do setPixel(x, y, _strokeColor);
  end;

  procedure TCanvas.rect(x, y, width, height: word);
  var i: word;
  begin
    for i := x + width - 1 downto x do
    begin
      setPixel(i, y, _strokeColor);
      setPixel(i, y+height-1, _strokeColor);
    end;
    for i := y + height - 1 downto y do
    begin
      setPixel(x, i, _strokeColor);
      setPixel(x+width-1, i, _strokeColor);
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
    setPixel(x, y-py, _strokeColor);
    setPixel(x, y+py, _strokeColor);
    setPixel(x+py, y-px, _strokeColor);
    setPixel(x-py, y+px, _strokeColor);
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
      setPixel(x+px, y-py, _strokeColor);
      setPixel(x-px, y+py, _strokeColor);
      setPixel(x-px, y-py, _strokeColor);
      setPixel(x+px, y+py, _strokeColor);
      setPixel(x+py, y-px, _strokeColor);
      setPixel(x-py, y+px, _strokeColor);
      setPixel(x-py, y-px, _strokeColor);
      setPixel(x+py, y+px, _strokeColor);
    end;
  end;

  function TCanvas.getClassName: string;
  begin
    getClassName := C_Canvas_CLASSNAME;
  end;

  { TCanvas private }

  { Other }

end.
