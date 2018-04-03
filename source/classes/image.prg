#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TImage FROM TControl

   DATA   __cFileName, cResName
   
   CLASSDATA aProps INIT { "nTop", "nLeft", "nWidth", "nHeight", "cFileName",;
   	                       "nAutoResize" }

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cFileName, cResName,;
               cToolTip, cVarName )
   
   METHOD cGenPrg()
   
   METHOD cFileName() INLINE ::__cFileName
   
   METHOD _cFileName( cFileName ) INLINE ::__cFileName := cFileName, ImgSetFile( ::hWnd, cFileName )
   
   METHOD SetFile( cFileName ) INLINE ImgSetFile( ::hWnd, cFileName )
   
   METHOD GetFile() INLINE ImgGetFile( ::hWnd )
   
   METHOD SetFrame( nStyle ) INLINE ImgSetFrame( ::hWnd, If( Empty( nStyle ), 2, nStyle ) )
   
   METHOD SetScaling( nScaling ) INLINE ImgSetScaling( ::hWnd, nScaling ) 
   
   METHOD SetResfile( cResName ) INLINE ( ::cResName:= cResName,;
                                          ImgSetResFile( ::hWnd , ::cResName ) )

   METHOD Redefine( nId, oWnd, cFileName, cResName )
    
   METHOD Initiate()
   
   METHOD OpenSheet() INLINE ChooseSheetImage( ::hWnd )
   
   METHOD setImage( hImage ) INLINE ImgSetNSImage( ::hwnd, hImage )

   METHOD GetWidth() INLINE ImgGetWidth( ::hWnd )

   METHOD GetHeight() INLINE ImgGetHeight( ::hWnd )

   METHOD SetSize( nWidth, nHeight ) INLINE RESIZEIMAGE( ::hWnd, nWidth, nHeight )

ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cFileName, cResName, cToolTip,;
            cVarName ) CLASS TImage

local aSize

   DEFAULT nWidth := 100, nHeight := 100

   ::hWnd = ImgCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
   ::oWnd  = oWnd

   aSize := ParseSize( @cFilename, aSize )

   if ! Empty( cFileName ) .and. File( cFileName )
       ::cFileName = cFileName
       if empty( aSize)
         ImgSetFile( ::hWnd, cFileName )
       else
         ImgSetFile( ::hWnd, cFileName, asize[1], asize[2] )
       endif
   endif   

   if ! Empty( cResName ) .and. File( ResPath() + "/" + cResName )
        ::cResname := cResName
        ::SetResFile( cResName )
   endif  
    
	 if !Empty( cToolTip )
      ::SetToolTip( cToolTip )
   endif

   oWnd:AddControl( Self )

   DEFAULT cVarName := "oImg" + ::GetCtrlIndex()
   
   ::cVarName = cVarName
   
return Self   

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, cFileName, cResName ) CLASS TImage

   DEFAULT oWnd := GetWndDefault()

   ::nId       = nId
   ::oWnd      = oWnd
   ::cFileName = cFileName
   ::cResName  = cResName

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TImage

   local hWnd := WndGetControl( ::oWnd:hWnd, ::nId )   

   ? ::cFilename+ "ini"

   if hWnd != 0
      ::hWnd = hWnd
   else
      MsgAlert( "Non defined TImage ID" + ;
                AllTrim( Str( ::nId ) ) + ;
                " in resource " + ::oWnd:cNibName )
   endif

   if ! Empty( ::cFileName ) .and. File( ::cFileName )
      ::SetFile( ::cFileName )
   endif   

   if ! Empty( ::cResName ) .and. File( ResPath() + "/" + ::cResName )
      ::SetResFile( ::cResName )
   endif  

return nil

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TImage

   local cCode := CRLF + CRLF + "   @ " + ;
                  AllTrim( Str( ::nTop ) ) + ", " + ;
                  AllTrim( Str( ::nLeft ) ) + " IMAGE " + ::cVarName + ;
                  " OF " + ::oWnd:cVarName + " ;" + CRLF + ;
                  '      FILENAME "' + If( ! Empty( ::cFileName ), ::cFileName,;
                                           ::cResName ) + '" ;' + CRLF + ;
                  "      SIZE " + AllTrim( Str( ::nWidth ) ) + ", " + ;
                                  AllTrim( Str( ::nHeight ) )
            if ::nAutoResize != 0                  
   						   cCode += " AUTORESIZE " + AllTrim( Str( ::nAutoResize ) )               
   					endif   
   					                    
return cCode                                

//----------------------------------------------------------------------------//

static function ParseSize( cName, aSize )

local w,h,cSize,nAt

if Right( cName, 1 ) == ")" .and. ( nAt := At( "(", cName ) ) > 0
cSize    := Lower( SubStr( cName, nAt + 1 ) )
cName    := Trim( Left( cName, nAt - 1 ) )
w        := Val( cSize )
if ( nAt := At( "x", cSize ) ) > 0
h     := Val( SubStr( cSize, nAt + 1 ) )
else
h     := w
endif
aSize     := { w, h }
endif

return aSize

