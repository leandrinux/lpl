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
    uobject, uexc, ubitmap, ubitmap1;

  const
    C_Canvas_CLASSNAME = 'TCanvas';

  type
    PCanvas = ^TCanvas;
    TCanvas = object (TObject)
    public
      constructor initWithBitmap(bitmap: PBitmap);
      destructor done; virtual;
      procedure setStrokeColor(color: TColor8);
      procedure setFillColor(color: TColor8);
      procedure setPixel(x, y: word; color: TColor8);
      procedure hline(x1, x2, y: word);
      procedure vline(y1, y2, x: word);
      procedure rect(x, y, width, height: word);
      procedure filledRect(x, y, width, height: word);
      procedure grid(x, y, columns, rows, colWidth, rowHeight: word);      
      procedure floodFill(x, y: word);
      procedure circle(x, y, radius: word);
      procedure line(x1, y1, x2, y2: integer);
      procedure clear;
      function getBitmap: PBitmap;
      function getStrokeColor: TColor8;
      function getFillColor: TColor8;
      function getClassName: string; virtual;
    private
      _bitmap: PBitmap;
      _strokeColor: TColor8;
      _fillColor: TColor8;
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

  procedure TCanvas.setStrokeColor(color: TColor8);
  begin
    _strokeColor := color;
  end;

  procedure TCanvas.setFillColor(color: TColor8);
  begin
    _fillColor := color;
  end;

  procedure TCanvas.setPixel(x, y: word; color: TColor8);
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

  procedure TCanvas.filledRect(x, y, width, height: word);
  begin
    _bitmap^.setBlock(x, y, width, height, _fillColor);
  end;

  procedure TCanvas.grid(x, y, columns, rows, colWidth, rowHeight: word);
  var
    w, h: word;
    i: byte;
  begin
    w := (columns*colWidth) + columns;
    h := (rows*rowHeight) + rows;
    for i:=1 to rows-1 do
      hline(x+1, x+w-2, y+i*(rowHeight+1));
    for i:=1 to columns-1 do
      vline(y+1, y+h-2, x+i*(colWidth+1));
  end;

  procedure TCanvas.floodFill(x, y: word);
  var
    mask: PBitmap;   { the control mask of painted pixels }
    base: TColor8;    { the color that will be replaced by the flood fill }
    w, h: word;      { size of the bitmap in pixels }
    bw, bh: word;    { size of the bitmap in blocks }
      procedure fillBlock(x, y: word);
      var
        bx, by: word; { coordinates of the current block }
        x1, y1, x2, y2: word; { bounds of the current block }
        i: word; { needed to iterate over borders }
        procedure fillPixel(x, y: word);
        begin
          if (mask^.getPixel(x,y)>0) or (x<x1) or (x>x2) or (y<y1) or (y>y2) then exit;
          setPixel(x, y, _fillColor);
          mask^.setPixel(x, y, 1);
          if _bitmap^.getPixel(x+1, y) = base then fillPixel(x+1, y);
          if _bitmap^.getPixel(x-1, y) = base then fillPixel(x-1, y);
          if _bitmap^.getPixel(x, y+1) = base then fillPixel(x, y+1);
          if _bitmap^.getPixel(x, y-1) = base then fillPixel(x, y-1);
        end;
      begin
        bx := x shr 4;
        by := y shr 4;
        x1 := bx shl 4;
        y1 := by shl 4;
        x2 := x1 + 15;
        y2 := y1 + 15;
        fillPixel(x, y);
        if (bx>0) then
          for i := y2 downto y1 do
            if (mask^.getPixel(x1, i) > 0) and (_bitmap^.getPixel(x1-1, i) = base) then
              fillBlock(x1-1, i);
        if (bx<bw) then
          for i := y2 downto y1 do
            if (mask^.getPixel(x2, i) > 0) and (_bitmap^.getPixel(x2+1, i) = base) then
              fillBlock(x2+1, i);
        if (by>0) then
          for i := x2 downto x1 do
            if (mask^.getPixel(i, y1) > 0) and (_bitmap^.getPixel(i, y1-1) = base) then
              fillBlock(i, y1-1);
        if (by<bh) then
          for i := x2 downto x1 do
            if (mask^.getPixel(i, y2) > 0) and (_bitmap^.getPixel(i, y2+1) = base) then
              fillBlock(i, y2+1);
      end;
  begin
    base := _bitmap^.getPixel(x, y);
    if base = _fillColor then exit;
    w := _bitmap^.getWidth;
    h := _bitmap^.getHeight;
    bw := w shr 4;
    bh := h shr 4;
    mask := new(PBitmap1, initWithSize(w, h));
    fillBlock(x, y);
    mask^.release;
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

  procedure TCanvas.clear;
  begin
    _bitmap^.clear(_fillColor);
  end;

  function TCanvas.getBitmap: PBitmap;
  begin
    getBitmap := _bitmap;
  end;

  function TCanvas.getStrokeColor: TColor8;
  begin
    getStrokeColor := _strokeColor;
  end;

  function TCanvas.getFillColor: TColor8;
  begin
    getFillColor := _fillColor;
  end;

  function TCanvas.getClassName: string;
  begin
    getClassName := C_Canvas_CLASSNAME;
  end;

  { TCanvas private }

  { Other }

end.
