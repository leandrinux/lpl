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
      constructor init;
      destructor done; virtual;
      function getWidth: word; virtual;
      function getHeight: word; virtual;
      function getColorCount: longint; virtual;
      procedure setPixel(x, y: word; color: TColor); virtual;
      function getClassName: string; virtual;
    private
    end;

implementation

  { TBitmap }

  constructor TBitmap.init;
  begin
    inherited init;
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

  procedure TBitmap.setPixel(x, y: word; color: TColor);
  begin
  end;

  function TBitmap.getClassName: string;
  begin
    getClassName := C_BITMAP_CLASS_NAME;
  end;

  { Other }

end.