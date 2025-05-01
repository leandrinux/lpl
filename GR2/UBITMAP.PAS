{
  UBitmap Unit
  Abstract class representing bitmap graphics
  2022 LRT
}
unit
  ubitmap;

interface

  uses
    uexc, types, locale, math,
    uobject;

  const
    C_BITMAP_CLASS_NAME = 'TBitmap';

  type
    PBitmap = ^TBitmap;
    TBitmap = object (TObject)
    public
      constructor initWithSize(width, height: word);
      destructor done; virtual;
      function getWidth: word; virtual;
      function getHeight: word; virtual;
      function getColorCount: longint; virtual;
      function getBitsPerPixel: byte; virtual;
      procedure setPixel(x, y: word; color: TColor8); virtual;
      procedure setBlock(x, y, width, height: word; color: TColor8); virtual;
      function getPixel(x, y: word): TColor8; virtual;
      procedure clear(color: TColor8); virtual;
      function getClassName: string; virtual;
    private
      _width, _height: word;
    end;

implementation

  { TBitmap }

  constructor TBitmap.initWithSize(width, height: word);
  begin
    inherited init;
    _width := width;
    _height := height;
  end;

  destructor TBitmap.done;
  begin
    inherited done;
  end;

  function TBitmap.getWidth: word;
  begin
    getWidth := 0;
  end;

  function TBitmap.getHeight: word;
  begin
    getHeight := 0;
  end;

  function TBitmap.getColorCount: longint;
  begin
    getColorCount := 0;
  end;

  function TBitmap.getBitsPerPixel: byte;
  begin
    getBitsPerPixel := 0;
  end;

  procedure TBitmap.setPixel(x, y: word; color: TColor8);
  begin
  end;

  procedure TBitmap.setBlock(x, y, width, height: word; color: TColor8);
  var px, py: word;
  begin
    for px := x + width - 1 downto x do
      for py := y + height - 1 downto y do
        setPixel(px, py, color);
  end;

  function TBitmap.getPixel(x, y: word): TColor8;
  begin
  end;

  procedure TBitmap.clear(color: TColor8);
  begin
  end;

  function TBitmap.getClassName: string;
  begin
    getClassName := C_BITMAP_CLASS_NAME;
  end;

  { Other }

end.