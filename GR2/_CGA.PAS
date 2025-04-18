unit _cga;

interface

  procedure setGraphicsMode; 
  procedure setTextMode;
  procedure putPixel(x, y: word; color: byte);
  function getPixel(x, y: word): byte;

implementation

  procedure setGraphicsMode; assembler;
  asm
    mov ah, 0    { BIOS video function: set mode }
    mov al, 5    { CGA 320x200 4-color mode }
    int 10h      { BIOS video interrupt }
  end;

  procedure setTextMode; assembler;
  asm
    mov ah, 0  { BIOS video function: set mode }
    mov al, 3  { 80x25 16 color text (CGA,EGA,MCGA,VGA) }
    int 10h    { BIOS video interrupt }
  end;

  procedure putPixel(x, y: word; color: byte); assembler;
  label is_even, mask;
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

  function getPixel(x, y: word): byte;
  var
    pixelNro: word;
    byteNro: word;
    pixelOff: word;
    base: word;
    value: byte;
    mask: byte;
    shloff: byte;
    p: ^byte;
  begin
    pixelNro := (y shr 1) shl 8 + (y shr 1) shl 6 + x;
    byteNro := pixelNro shr 2;    
    if boolean(y and 1) then p := ptr($BA00, byteNro) else p := ptr($B800, byteNro);
    pixelOff := pixelNro and $3;   
    shloff := (3 - pixelOff) shl 1;
    mask := 3 shl shloff;
    getPixel := p^ and mask shr shloff;
  end;    

end.