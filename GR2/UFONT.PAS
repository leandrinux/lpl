{
  ufont Unit
  Abstract class representing graphic fonts used to write text to a canvas
  2022 LRT
}
unit
  ufont;

interface

  uses
    consts, utils, types, locale,
    uexc, uobject, ucanvas, ustream;

  type
    TFontName = string32;

    PFont = ^TFont;
    TFont = object (TObject)
    public
      constructor init;
      destructor done; virtual;
      procedure getCharSize(ch: char; scale: byte; var width, height: word); virtual;
      procedure drawChar(ch: char; scale: byte; x, y: word; canvas: PCanvas); virtual;
      procedure setName(name: TFontName);
      function getName: TFontName;
      function getClassName: string; virtual;
      procedure save(stream: PStream); virtual;
      procedure load(stream: PStream); virtual;
    private
      _name: TFontName;
    end;

implementation

  { TFont public }

  constructor TFont.init;
  begin
    inherited init;
    _name := '';
  end;

  destructor TFont.done;
  begin
    inherited done;
  end;

  procedure TFont.getCharSize(ch: char; scale: byte; var width, height: word);
  begin
    width := 0;
    height := 0;
  end;

  procedure TFont.drawChar(ch: char; scale: byte; x, y: word; canvas: PCanvas);
  begin
  end;

  procedure TFont.setName(name: TFontName);
  begin
    _name := name;
  end;

  function TFont.getName: TFontName;
  begin
    getName := _name;
  end;

  procedure TFont.save(stream: PStream);
  begin
  end;

  procedure TFont.load(stream: PStream);  
  begin
  end;

  function TFont.getClassName: string;
  begin
    getClassName := 'TFont';
  end;

  { TFont private }

  { Other }

end.