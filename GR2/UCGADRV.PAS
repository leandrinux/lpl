{
  ucgadrv unit
  Driver for the 4-color CGA 320x200 graphics mode
  2025 LRT
}
unit
  ucgadrv;

interface

  uses
    consts, utils, types, locale,
    uobject, uexc, uviddrv;

  const
    C_CGAVideoDriver_CLASSNAME = 'TCGAVideoDriver';

  type
    PCGAVideoDriver = ^TCGAVideoDriver;
    TCGAVideoDriver = object (TVideoDriver)
    public
      constructor init;
      destructor done; virtual;
      function getWidth: word; virtual;
      function getHeight: word; virtual;
      function getColorCount: longint; virtual;
      function detect: boolean; virtual;
      procedure start(mode: byte); virtual;
      procedure stop; virtual;
      procedure clear(color: byte); virtual;
      procedure putPixel(x, y: word; color: byte); virtual;
      function getPixel(x, y: word): byte; virtual;
      function getClassName: string; virtual;
    private
    end;

implementation

  { TCGAVideoDriver public }

  constructor TCGAVideoDriver.init;
  begin
    inherited init;
  end;

  destructor TCGAVideoDriver.done;
  begin
    inherited done;
  end;

  function TCGAVideoDriver.getWidth: word;
  begin
    getWidth := 320;
  end;

  function TCGAVideoDriver.getHeight: word; 
  begin
    getHeight := 200;
  end;
  
  function TCGAVideoDriver.getColorCount: longint;
  begin
    getColorCount := 4;
  end;

  function TCGAVideoDriver.detect: boolean; 
  begin
    detect := true;
  end;
  
  procedure TCGAVideoDriver.start(mode: byte);
  begin
    asm
      mov ah, 0    { BIOS video function: set mode }
      mov al, 5    { CGA 320x200 4-color mode }
      int 10h      { BIOS video interrupt }
    end;
  end;
  
  procedure TCGAVideoDriver.stop; 
  begin
    asm
      mov ah, 0  { BIOS video function: set mode }
      mov al, 3  { 80x25 16 color text (CGA,EGA,MCGA,VGA) }
      int 10h    { BIOS video interrupt }
    end;
  end;
  
  procedure TCGAVideoDriver.clear(color: byte);
  begin
  end;
  
  procedure TCGAVideoDriver.putPixel(x, y: word; color: byte);
  label is_even, mask;
  begin
    if (x>319) or (y>199) then exit;
    asm  
      { pixelNro := (y shr 1) shl 8 + (y shr 1) shl 6 + x; }
      mov ax, y
      shr ax, 1   
      mov bx, ax
      mov cl, 6
      shl bx, cl
      mov cl, 8
      shl ax, cl
      add ax, bx
      add ax, x   { ax = pixelNro }

      { byteNro := pixelNro shr 2; }
      mov di, ax
      mov cl, 2
      shr di, cl  { di = byteNro }

      { pixelOff := pixelNro and $3; }
      mov cx, ax
      and cx, $3  { cx = pixelOff }

      { bitShift := (3 - pixelOff) shl 1; }
      mov ax, 3
      sub ax, cx
      shl ax, 1   { ax = bitShift }

      { if boolean(y and 1) then p := ptr($BA00, byteNro) else p := ptr($B800, byteNro); }
      mov bx, y
      and bx, 1
      jnz is_even
      mov bx, $B800
      jmp mask

      is_even:
      mov bx, $BA00  

      mask:
      mov es, bx     { es = $BA00 or $B800}

      { mask := not (3 shl bitShift); }
      mov bx, 3
      mov cl, al 
      shl bx, cl
      not bx     { bx = mask }

      { color := (byte(c) shl bitShift) ; }
      xor dx, dx
      mov dl, color
      mov cl, al
      shl dx, cl { dx = color}

      { p^ := p^ and mask or color; }
      mov ax, [es:di]
      and ax, bx
      or ax, dx
      mov [es:di], ax
    end;
  end;

  function TCGAVideoDriver.getPixel(x, y: word): byte;
  var
    pixelNro: word;
    byteNro: word;
    pixelOff: word;
    base: word;
    mask: byte;
    shloff: byte;
    p: ^byte;
  begin
    getPixel := 0;
    if (x>319) or (y>199) then exit;
    pixelNro := (y shr 1) shl 8 + (y shr 1) shl 6 + x;
    byteNro := pixelNro shr 2;    
    if boolean(y and 1) then p := ptr($BA00, byteNro) else p := ptr($B800, byteNro);
    pixelOff := pixelNro and $3;   
    shloff := (3 - pixelOff) shl 1;
    mask := 3 shl shloff;
    getPixel := p^ and mask shr shloff;
  end;    


  function TCGAVideoDriver.getClassName: string;
  begin
    getClassName := C_CGAVideoDriver_CLASSNAME;
  end;

  { TCGAVideoDriver private }

  { Other }

end.
