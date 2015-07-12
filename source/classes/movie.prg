#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TMovie FROM TControl

   DATA cFile, nStyle

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cPrompt, nStyle, nAutoResize )

   METHOD Redefine( nId, oWnd, cMovie )
   METHOD Initiate()

   METHOD Open( cMovie ) INLINE ( ::cFile:= cMovie , AVOPEN( ::hWnd, ::cFile )   )

   METHOD DlgOpen() INLINE  AVOPENPANEL ( ::hWnd )

   METHOD PLAY() INLINE AVPLAY( ::hWnd )
   
   METHOD ControlStyle()
   
   METHOD GOTIME( nSecond ) INLINE AVSEEKTIME ( ::hWnd, nSecond )

   METHOD EDIT( cMovie ) INLINE  AVTRIMMMOVIE( ::hWnd, cMovie )

   ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cMovie , nAutoResize ) CLASS TMovie

   DEFAULT nWidth := 100, nHeight := 200, oWnd := GetWndDefault()


   ::oWnd = oWnd
   ::nStyle = 1

   ::hWnd = AVCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )

   ::cFile := cMovie

    if ! Empty( ::cFile )
        AVOPEN( ::hWnd, ::cFile )
    endif

    ::nAutoResize = nAutoResize

   oWnd:AddControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, cMovie ) CLASS TMovie

DEFAULT oWnd := GetWndDefault()

::nId     = nId
::oWnd  := oWnd
::cFile  := cMovie

oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TMovie

local hWnd:= WndGetIdentFromNib(::oWnd:hWnd,alltrim(str( ::nId )) )

if hWnd = -1
    MsgAlert( "Non found TMovie cID " + ;
    AllTrim( Str( ::nId ) ) + ;
    " in resource " + ::oWnd:cNibName )
    return nil
endif
if hWnd != 0
    ::hWnd = hWnd
else
    MsgAlert( "Non defined TMovie cID " + ;
    AllTrim( Str( ::nId ) ) + ;
    " in resource " + ::oWnd:cNibName )
endif

if !Empty(::cFile)
  ::Open( ::cFile )
endif

return nil

//----------------------------------------------------------------------------//

METHOD ControlStyle( nStyle ) CLASS TMovie


   ::nStyle = nStyle
   if ::nStyle == 1
      SETAVCONTROLSTYLEDEFAULT( ::hWnd )
   elseif ::nStyle == 2
      SETAVCONTROLSTYLEFLOATING( ::hWnd )
   elseif ::nStyle == 3
      SETAVCONTROLSTYLEMINIMAL( ::hWnd )
   elseif ::nStyle == 4
      SETAVCONTROLSTYLENONE( ::hWnd )
   else
      ::nStyle := 1
      SETAVCONTROLSTYLEDEFAULT( ::hWnd )
   endif
   

return Self

//----------------------------------------------------------------------------//

