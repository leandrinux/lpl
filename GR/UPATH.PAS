{
  UPath Unit
  Represents a fixed size path of points (x, y)
  2022 LRT
}
unit
  UPath;

interface

  uses
    consts, utils, types, locale,
    uobject, uexc, math;

  type
    PPath = ^TPath;
    TPath = object (TObject)
    public
      constructor initWithSize(size: word);
      destructor done; virtual;
      function getClassName: string; virtual;
      procedure add(x, y: integer);
      procedure get(var first: PPoint; var length: word);
    private
      _size: word;
      _length: word;
      _path: PPoint;
    end;

implementation

  { TPath public }

  constructor TPath.initWithSize(size: word);
  begin
    inherited init;
    _size := size;
    _length := 0;
    getMem(_path, sizeof(TPoint) * _size);
  end;

  destructor TPath.done;
  begin
    freeMem(_path, sizeof(TPoint) * _size);
    inherited done;
  end;

  procedure TPath.add(x, y: integer);
  var
    p: PPoint;
  begin
    if _length = _size then exit;
    p := _Path;
    inc(p, _length);
    p^.x := x;
    p^.y := y;
    inc(_length);
  end;

  procedure TPath.get(var first: PPoint; var length: word);
  begin
    first := _Path;
    length := _length;
  end;

  function TPath.getClassName: string;
  begin
    getClassName := 'TPath';
  end;

  { TPath private }

  { Other }

end.
