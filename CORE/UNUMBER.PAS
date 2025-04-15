{
  unumber Unit
  TObject wrapper for 32-bit signed int (longint)
  2022 LRT
}
unit
  unumber;

interface

  uses
    types, locale, 
    uobject, uexc;

  const
    C_NUMBER_CLASS_NAME = 'TNumber';

  type
    PNumber = ^TNumber;
    TNumber = object (TObject)
    public
      constructor init;
      destructor done; virtual;
      procedure setValue(value: longint);
      function getValue: longint;
      function getBoolValue: boolean;
      function getClassName: string; virtual;
    private
      _value: longint;
    end;

implementation

  { TNumber public }

  constructor TNumber.init;
  begin
    inherited init;
  end;

  destructor TNumber.done;
  begin
    inherited done;
  end;

  procedure TNumber.setValue(value: longint);
  begin
    _value := value;
  end;

  function TNumber.getValue: longint;
  begin
    getValue := _value;
  end;

  function TNumber.getBoolValue: boolean;
  begin
    getBoolValue := _value <> 0;
  end;

  function TNumber.getClassName: string;
  begin
    getClassName := C_NUMBER_CLASS_NAME;
  end;

  { TNumber private }

  { Other }

end.