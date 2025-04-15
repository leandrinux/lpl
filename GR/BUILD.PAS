uses
  { Bitmaps }
  ubitmap    { Abstract class representing bitmap graphics }
  ,ubitmap1  { 1-bit color (monochrome) bitmap implementation }
  ,ubitmap8  { An 8-bit indexed color implementation of a bitmap } 
  ,ubmlayer  { A layer is used to represent a bitmap within the context of a composition }
  ,ubmstack  { A bitmap that is composed by stack of bitmap layers }

  { Bitmap file format support }
  ,upalette  { Color palette of up to 256 entries, usually included with 256-color bitmaps }
  ,ubmpfile  { 8-bit palettized BMP file read-only implementation }
  ,upath     { Represents a fixed size path of points (x, y) }

  { Drawing lines, shapes and text }
  ,ucanvas   { Implements drawing primitives over a bitmap }
  ,ufont     { Abstract class representing graphic fonts that are later used to write text to a canvas }

  { Display adapters support }
  ,uviddrv   { An abstract video driver for a display adapter }
  ,uvgadrv   { VGA graphics adapter driver }
  ,udisplay  { An interface to the video adapter used to get info, set video modes and draw to the display } 
  ;

begin
end.