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
      procedure rect(x, y, width, height: word);
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

  function TCanvas.getClassName: string;
  begin
    getClassName := C_Canvas_CLASSNAME;
  end;

  { TCanvas private }

  { Other }

end.
