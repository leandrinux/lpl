{
  ubmstack Unit
  A bitmap that is composed by stack of bitmap layers
  2022 LRT
}
unit
  ubmstack;

interface

  uses
    consts, utils, types, locale, 
    uexc, ubmlayer, ubitmap, uobject, ulist;

  const
    C_MAX_LAYERS = 4;
    C_DEFAULT_BACKGROUND_COLOR = 0;

  type
    TLayerIndex = 0..C_MAX_LAYERS-1;
    TBitmapLayers = array[TLayerIndex] of PBitmapLayer;

    PBitmapStack = ^TBitmapStack;
    TBitmapStack = object (TBitmap)
    public
      constructor initWithSize(width, height: word);
      destructor done; virtual;
      procedure setPixel(x, y: word; color: TColor8); virtual;
      procedure clear(color: TColor8); virtual;
      function getPixel(x, y: word): TColor8; virtual;
      function getColorCount: longint; virtual;
      function getBitsPerPixel: byte; virtual;
      procedure setBackground(color: TColor8);
      procedure setLayer(index:TLayerIndex; layer:PBitmapLayer);
      function getBackgroundColor: TColor8;
      function getLayer(index:TLayerIndex): PBitmapLayer;
      function getClassName: string; virtual;
    private
      _layers: TBitmapLayers;
      _backgroundColor: TColor8;
      w, h: word;
    end;

implementation

  { TBitmapStack public }

  constructor TBitmapStack.initWithSize(width, height: word);
  begin
    inherited initWithSize(width, height);
    w := width;
    h := height;
    fillChar(_layers, sizeof(TBitmapLayers), 0);
    _backgroundColor := C_DEFAULT_BACKGROUND_COLOR;
  end;

  destructor TBitmapStack.done;
  var
    i: TLayerIndex;
  begin
    for i := C_MAX_LAYERS-1 to 0 do
      if _layers[i] <> nil then _layers[i]^.release;
    inherited done;
  end;

  procedure TBitmapStack.setPixel(x, y: word; color: TColor8); begin end;

  procedure TBitmapStack.clear(color: TColor8); begin end;

  function TBitmapStack.getPixel(x, y: word): TColor8;
  var
    i: TLayerIndex;
    layer: PBitmapLayer;
  begin
    getPixel := _backgroundColor;
    if (x > w) or (y> h) then exit;
    for i := C_MAX_LAYERS-1 downto 0 do
    begin
      layer := _layers[i];
      if (layer <> nil) and layer^.isValidPixel(x,y) then
      begin
        getPixel := layer^.getPixel(x, y);
        break;
      end;
    end;
  end;

  function TBitmapStack.getColorCount: longint;
  begin
    getColorCount := 0;
  end;

  function TBitmapStack.getBitsPerPixel: byte;
  begin
    getBitsPerPixel := 0;
  end;

  procedure TBitmapStack.setLayer(index:TLayerIndex; layer:PBitmapLayer);
  begin
    if _layers[index] <> nil then _layers[index]^.release;
    _layers[index] := layer;
    if layer <> nil then layer^.retain;
  end;

  procedure TBitmapStack.setBackground(color: TColor8);
  begin
    _backgroundColor := color;
  end;

  function TBitmapStack.getBackgroundColor: TColor8;
  begin
    getBackgroundColor := _backgroundColor;
  end;

  function TBitmapStack.getLayer(index:TLayerIndex): PBitmapLayer;
  begin
    getLayer := _layers[index];
  end;

  function TBitmapStack.getClassName: string;
  begin
    getClassName := 'TBitmapStack';
  end;

  { TBitmapStack private }

  { Other }

end.