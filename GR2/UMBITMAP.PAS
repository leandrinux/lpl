{
  umbitmap Unit
  A bitmap that is the result of applying a mask to another bitmap
  2022 LRT
}
unit
  umbitmap;

interface

  uses
    consts, utils, types, locale, 
    uexc, uobject, ubitmap;

  type
    PMaskBitmap = ^TMaskBitmap;
    TMaskBitmap = object (TBitmap)
    public
      constructor initWithBitmap(bitmap, mask: PBitmap);
      destructor done; virtual;
      function getPixel(x, y: word): TColor8; virtual;
      function getColorCount: longint; virtual;
      function getBitsPerPixel: byte; virtual;
      procedure setMaskColor(color: TColor8);
      procedure setTransparenTColor8(color: TColor8);
      function getClassName: string; virtual;
    private
      _bitmap: PBitmap;
      _mask: PBitmap;
      _maskColor, _transparenTColor8: TColor8;
    end;

implementation

  { TMaskBitmap public }

  constructor TMaskBitmap.initWithBitmap(bitmap, mask: PBitmap);
  begin
    _bitmap := bitmap;
    _bitmap^.retain;
    _mask := mask;
    _mask^.retain;
    _maskColor := 1;
    _transparenTColor8 := $FF;
    inherited initWithSize(_bitmap^.getWidth, _bitmap^.getHeight);
  end;

  destructor TMaskBitmap.done;
  begin
    _bitmap^.release;
    _mask^.release;
    inherited done;
  end;

  function TMaskBitmap.getPixel(x, y: word): TColor8;
  begin
    if _mask^.getPixel(x, y) = _maskColor then
      getPixel := _bitmap^.getPixel(x, y)
    else
      getPixel := _transparenTColor8;
  end;

  function TMaskBitmap.getColorCount: longint;
  begin
    getColorCount := _bitmap^.getColorCount;
  end;

  function TMaskBitmap.getBitsPerPixel: byte;
  begin
    getBitsPerPixel := _bitmap^.getBitsPerPixel;
  end;

  procedure TMaskBitmap.setMaskColor(color: TColor8);
  begin
    _maskColor := color;
  end;

  procedure TMaskBitmap.setTransparenTColor8(color: TColor8);
  begin
    _transparenTColor8 := color;
  end;

  function TMaskBitmap.getClassName: string;
  begin
    getClassName := 'TMaskBitmap';
  end;

  { TMaskBitmap private }

  { Other }

end.