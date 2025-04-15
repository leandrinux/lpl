{
  UBitmap Unit
  Abstract class representing bitmap graphics
  2022 LRT
}
unit
  ubitmap;

interface

  uses
    uexc, types, locale, palette, math,
    uobject;

  const
    C_BITMAP_CLASS_NAME = 'TBitmap';

  type
    PBitmap = ^TBitmap;
    TBitmap = object (TObject)
    public
      constructor initWithSize(width, height: word);
      destructor done; virtual;
      procedure setPixel(x, y: word; color: TColor); virtual;
      procedure setPixelBlock(x1, y1, x2, y2: word; color: TColor); virtual;
      procedure clear(color: TColor); virtual;
      procedure merge(src: PBitmap; x, y: word); virtual;
      procedure mergeT(src: PBitmap; x, y: word; transparent:TColor);
      function getPixel(x, y: word): TColor; virtual;
      function getWidth: word;
      function getHeight: word;
      function getPresetColor(color: EColor): TColor;
      function getColorCount: longint; virtual;
      function getBitsPerPixel: byte; virtual;
      function getRawPixels: pointer; virtual;
      function getClassName: string; virtual;
    private
      _width, _height: word;
    end;

implementation

  { TBitmap }

  constructor TBitmap.initWithSize(width, height: word);
  begin
    inherited init;
    iassert(getClassName<>C_BITMAP_CLASS_NAME, @self, 0, S_ERR_ABSTRACT_CLASS);
    _width := width;
    _height := height;
  end;

  destructor TBitmap.done;
  begin
    inherited done;
  end;

  procedure TBitmap.setPixel(x, y: word; color: TColor); begin end;

  procedure TBitmap.setPixelBlock(x1, y1, x2, y2: word; color: TColor);
  var x, y: word;
  begin
    for y := y2 downto y1 do
      for x := x2 downto x1 do
        setPixel(x, y, color);
  end;

  procedure TBitmap.clear(color: TColor); begin end;

  procedure TBitmap.merge(src: PBitmap; x, y: word);
  var
    w, h: word;
    px, py: word;
  begin
    if (x >= _width) or (y >= _height) then exit;
    w := minword(_width - x, src^.getWidth) - 1;
    h := minword(_height - y, src^.getHeight) - 1;
    for py := h downto 0 do
      for px := w downto 0 do
        setPixel(x+px, y+py, src^.getPixel(px, py));
  end;

  procedure TBitmap.mergeT(src: PBitmap; x, y: word; transparent:TColor);
  var
    w, h: word;
    px, py: word;
    color: longint;
  begin
    if (x >= _width) or (y >= _height) then exit;
    w := minword(_width - x, src^.getWidth) - 1;
    h := minword(_height - y, src^.getHeight) - 1;
    for py := h downto 0 do
      for px := w downto 0 do
      begin
        color := src^.getPixel(px, py);
        if color <> transparent then setPixel(x+px, y+py, color);
      end;
  end;

  function TBitmap.getPixel(x, y: word): TColor;
  begin
    getPixel := 0;
  end;

  function TBitmap.getWidth: word;
  begin
    getWidth := _width;
  end;

  function TBitmap.getHeight: word;
  begin
    getHeight := _height;
  end;

  function TBitmap.getPresetColor(color: EColor): TColor;
  begin
    getPresetColor := palette.getColor(color, getBitsPerPixel);
  end;

  function TBitmap.getColorCount: longint;
  begin
    getColorCount := 0;
  end;

  function TBitmap.getBitsPerPixel: byte;
  begin
    getBitsPerPixel := 0;
  end;

  function TBitmap.getRawPixels: pointer;
  begin
    getRawPixels := nil;
  end;

  function TBitmap.getClassName: string;
  begin
    getClassName := C_BITMAP_CLASS_NAME;
  end;

  { Other }

end.