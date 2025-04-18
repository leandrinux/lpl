{
  uffont Unit
  A 1KB font that uses 32 bit ints for each glyph
  2022 LRT
}
unit
  utfont;

interface

  uses
    consts, utils, types, locale,
    uexc, uobject, ufont, ucanvas, ustream;

  type
    PSymbolArray = ^TSymbolArray;
    TSymbolArray = array[0..255] of longint;

  type
    PTinyFont = ^TTinyFont;
    TTinyFont = object (TFont)
    public
      constructor init;
      constructor initWithData(fromChar, toChar: char; symbolArray: PSymbolArray);
      destructor done; virtual;
      procedure getCharSize(ch: char; scale: byte; var width, height: word); virtual;
      procedure drawChar(ch: char; scale: byte; x, y: word; canvas: PCanvas); virtual;
      function getSymbol(ch: char): longint;
      procedure setSymbol(ch: char; symbol: longint);
      procedure save(stream: PStream); virtual;
      procedure load(stream: PStream); virtual;
      function getClassName: string; virtual;
    private
      _name: string32;
      _fromChar, _toChar: char;
      _mustFreeMem: boolean;
      _symbolArray: PSymbolArray;
    end;

implementation

  type
    TFontFileSignature = array[0..1] of char;
    TFontFileType = word;

  const
    C_CHAR_WIDTH  = 5;
    C_CHAR_HEIGHT = 6;
    C_FONT_FILE_SIGNATURE: TFontFileSignature = 'FN';
    C_FONT_FILE_TYPE: TFontFileType = 1;

  { TTinyFont public }

  constructor TTinyFont.init;
  begin
    inherited init;
    _name := '';
    _fromChar := #0;
    _toChar := #255;
    _mustFreeMem := true;
    getMem(_symbolArray, sizeof(TSymbolArray));
    fillChar(_symbolArray^, sizeof(TSymbolArray), 0);
  end;

  constructor TTinyFont.initWithData(fromChar, toChar: char; symbolArray: PSymbolArray);
  begin
    inherited init;
    _name := '';
    _fromChar := fromChar;
    _toChar := toChar;
    _mustFreeMem := false;
    _symbolArray := symbolArray;
  end;

  destructor TTinyFont.done;
  begin
    if _mustFreeMem then freeMem(_symbolArray, sizeOf(TSymbolArray));
    inherited done;
  end;

  procedure TTinyFont.getCharSize(ch: char; scale: byte; var width, height: word);
  begin
    if (ch < _fromChar) or (ch > _toChar)  { out of bounds }
       or ( (ch <> ' ') and  (_symbolArray^[ord(ch)] = 0)) then { it's an empty char and it's not space }
    begin
      width := 0;
      height := 0;
    end else begin
      width := C_CHAR_WIDTH * scale;
      height := C_CHAR_HEIGHT * scale;
    end;
  end;

  procedure TTinyFont.drawChar(ch: char; scale: byte; x, y: word; canvas: PCanvas);
  var
    cx, cy: word;
    glyph: longint;
    color: TColor8;
  begin
    if (ch < _fromChar) or (ch > _toChar) then exit;
    glyph := _symbolArray^[ord(ch) - ord(_fromChar)] shr 2;
    if glyph <> 0 then
    begin
      color := canvas^.getStrokeColor;
      for cy := C_CHAR_HEIGHT - 1 downto 0 do
        for cx := C_CHAR_WIDTH - 1 downto 0 do
        begin
          if (glyph and 1) <> 0 then
            if scale = 1 then
              canvas^.setPixel(cx + x, cy + y, color)
            else
              canvas^.filledRect(x+(cx*scale), y+(cy*scale), scale, scale);
          glyph := glyph shr 1;
        end;
    end;
  end;

  procedure TTinyFont.setSymbol(ch: char; symbol: longint);
  begin
    if (ch >= _fromChar) or (ch <= _toChar) then
      _symbolArray^[ord(ch)] := symbol;
  end;

  function TTinyFont.getSymbol(ch: char): longint;
  begin
    if (ch < _fromChar) or (ch > _toChar) then
      getSymbol := 0
    else
      getSymbol := _symbolArray^[ord(ch)];
  end;

  procedure TTinyFont.save(stream: PStream);
  begin
    with stream^ do
    begin
      write(@C_FONT_FILE_SIGNATURE, sizeof(TFontFileSignature));
      write(@C_FONT_FILE_TYPE, 2);
      write(@_fromChar, sizeof(_fromChar));
      write(@_toChar, sizeof(_toChar));
      writepchar(_name);
      write(_symbolArray, sizeof(TSymbolArray));
    end;
  end;

  procedure TTinyFont.load(stream: PStream); 
  var
    signature: TFontFileSignature;
    fileType: TFontFileType;
  begin
    with stream^ do
    begin
      read(@signature, sizeof(TFontFileSignature));
      if signature <> C_FONT_FILE_SIGNATURE then exit;
      read(@fileType, sizeof(TFontFileType));
      if fileType <> C_FONT_FILE_TYPE then exit;
      read(@_fromChar, 1);
      read(@_toChar, 1);
      _name := readpchar;
      read(_symbolArray, sizeof(TSymbolArray));
    end;
  end;

  function TTinyFont.getClassName: string;
  begin
    getClassName := 'TTinyFont';
  end;

  { TTinyFont private }

  { Other }

end.