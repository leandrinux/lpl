{
  ucontrol unit
  Abstract representation of a visual control such as buttons or text fields
  2025 LRT
}
unit
  ucontrol;

interface

  uses
    consts, utils, types, locale,
    uobject, uexc, ubitmap;

  const
    C_Control_CLASSNAME = 'TControl';

  type
    PControl = ^TControl;
    TControl = object (TObject)
    public
      constructor init;
      destructor done; virtual;
      procedure draw; virtual;
      procedure setPosition(position: PPoint);
      procedure setSize(size: PSize);
      procedure setParent(parent: PControl);
      procedure setBitmap(bitmap: PBitmap);
      procedure getAbsolutePosition(var point: TPoint);
      function isPointOver(coordinate: PPoint): boolean;
      function getPosition: PPoint;
      function getSize: PSize;
      function getParent: PControl;
      function getBitmap: PBitmap;
      function getClassName: string; virtual;
    private
      _position: TPoint;
      _size: TSize;
      _parent: PControl;
      _bitmap: PBitmap;
    end;

implementation

  { TControl public }

  constructor TControl.init;
  begin
    inherited init;
    _position := C_POINT_ZERO;
    _size := C_SIZE_ZERO;
    _parent := nil;
    _bitmap := nil;
  end;

  destructor TControl.done;
  begin
    inherited done;
  end;

  procedure TControl.draw;
  begin  
  end;

  procedure TControl.setPosition(position: PPoint);
  begin
    _position := position^;
  end;

  procedure TControl.setSize(size: PSize);
  begin
    _size := size^;
  end;

  procedure TControl.setParent(parent: PControl);
  begin
    _parent := parent;
  end;

  procedure TControl.setBitmap(bitmap: PBitmap);
  begin
    _bitmap := bitmap;
  end;

  procedure TControl.getAbsolutePosition(var point: TPoint);
  begin
    if _parent = nil then 
      point := _position
    else begin
      _parent^.getAbsolutePosition(point);
      point.x := point.x + _position.x;
      point.y := point.y + _position.y;
    end;
  end;

  function TControl.isPointOver(coordinate: PPoint): boolean;
  var
    absolutePosition: TPoint;
    x1, y1, x2, y2: word;
  begin
    getAbsolutePosition(absolutePosition);
    x1 := absolutePosition.x;
    x2 := x1 + _size.width - 1;
    y1 := absolutePosition.y;
    y2 := y1 + _size.height - 1;
    with coordinate^ do
      isPointOver := (x >= x1) and (x <= x2) and (y >= y1) and (y <= y2);
  end;

  function TControl.getPosition: PPoint;
  begin
    getPosition := @_position;
  end;

  function TControl.getSize: PSize;
  begin
    getSize := @_size;
  end;

  function TControl.getParent: PControl;
  begin
    getParent := _parent;
  end;

  function TControl.getBitmap: PBitmap;
  begin
    getBitmap := _bitmap;
  end;
  
  function TControl.getClassName: string;
  begin
    getClassName := C_Control_CLASSNAME;
  end;

  { TControl private }

  { Other }

end.
