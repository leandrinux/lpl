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
      procedure draw(bitmap: PBitmap); virtual;
      function getClassName: string; virtual;
    private
    end;

implementation

  { TControl public }

  constructor TControl.init;
  begin
    inherited init;
  end;

  destructor TControl.done;
  begin
    inherited done;
  end;

  procedure TControl.draw(bitmap: PBitmap);
  begin  
  end;

  function TControl.getClassName: string;
  begin
    getClassName := C_Control_CLASSNAME;
  end;

  { TControl private }

  { Other }

end.
