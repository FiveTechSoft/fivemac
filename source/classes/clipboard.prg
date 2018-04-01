#include "Fivemac.ch"

#define CF_TEXT              1
#define CF_PNG               2
//#define CF_SOUND            12
/*

#define CF_METAFILEPICT      3
#define CF_SYLK              4
#define CF_DIF               5
#define CF_TIFF              6
#define CF_OEMTEXT           7
#define CF_DIB               8
#define CF_PALETTE           9
#define CF_PENDATA          10
#define CF_RIFF             11
#define CF_WAVE             12
#define CF_UNICODETEXT      13
#define CF_ENHMETAFILE      14
#define CF_HDROP            15
*/

//----------------------------------------------------------------------------//

CLASS TClipBoard

    DATA hClip

    METHOD New() CONSTRUCTOR

    METHOD SetText( cText ) INLINE ClipBoardCopyString( ::hClip, cText )
    METHOD GetText()        INLINE ClipBoardPasteString ( ::hClip )
    METHOD GetName()        INLINE ClipBoardGetName ( ::hClip )
    METHOD Clear()          INLINE ClipBoardClear ( ::hClip )
    METHOD SetPNGImage( hImg )   INLINE CLIPBOARDCOPYPNG ( ::hClip, hImg )
    METHOD ScreenShot()     INLINE ( ::Clear(), SCREENTOPASTEBOARD( ::hClip ) )
    METHOD SetPNG( oBitmap )
    
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS TClipBoard

::hClip := ClipBoardNew()

return Self

//----------------------------------------------------------------------------//
METHOD SetPNG ( oBitmap ) CLASS TClipBoard
    
    local lResult := .f.
    SetClipBoardData( ::hClip, 2 )
    ::GetPng( NSIMAGEFROMIMAGEVIEW( oBitMap:hWnd ) )
        
return

