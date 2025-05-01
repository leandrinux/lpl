unit ucscheme;

interface

  uses
    types;

  type 
    PColorScheme = ^TColorScheme;
    TColorScheme = record
      highlight: byte;
      shadow: byte;
      background: byte;
      activeText: byte;
      inactiveText: byte;
    end;

  const 
    C_DEFAULT_COLOR_SCHEME: TColorScheme = (
      highlight: ord(EWhite);
      shadow: ord(EDarkGray);
      background: ord(ELightGray);
      activeText: ord(EBlack);
      inactiveText: ord(EDarkGray)
    );

  var
    colorScheme: PColorScheme;

implementation

begin
  colorScheme := @C_DEFAULT_COLOR_SCHEME;
end.