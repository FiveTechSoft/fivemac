#include "FiveMac.ch"

#define WidthSizable  2
#define HeightSizable 16

//----------------------------------------------------------------------------//

CLASS TCoverflow FROM TControl

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd )
 
   METHOD Open( cImage ) INLINE IKCoverOpenFile( ::hWnd, cImage )  
   
   METHOD OpenDir( cDir ) INLINE IKCoverOpendir( ::hwnd, cDir )	
   
   METHOD OpenPanel() INLINE IKCoverOpenpanel( ::hWnd )
   
    METHOD Redefine( nId, oWnd ) 

   METHOD Initiate()

   METHOD Autoresize( nAutoResize ) INLINE IKCOVERAJUST( ::hWnd, nAutoResize )

ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CLASS TCoverflow

   DEFAULT nWidth := 100, nHeight := 200, oWnd := GetWndDefault()
   
   ::hWnd = IKCoverCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )

   ::oWnd = oWnd

   ::AutoResize( WidthSizable + HeightSizable )

   oWnd:AddControl( Self )
   
return Self

//----------------------------------------------------------------------------//
 
 METHOD Redefine( nId, oWnd ) CLASS TCoverflow

DEFAULT oWnd := GetWndDefault()

::nId     = nId
::oWnd    = oWnd

::AutoResize( 18 )

oWnd:DefControl( Self )

return Self


//----------------------------------------------------------------------------//

METHOD Initiate() CLASS  TCoverflow

local hWnd:= WNDGETIDENTFROMNIB (::oWnd:hWnd,alltrim(str( ::nId )) )   
if hWnd = -1
    MsgAlert( "Non found COVERF cID " + ;
    AllTrim( Str( ::nId ) ) + ;
    " in resource " + ::oWnd:cNibName )
    return nil
endif 
if hWnd != 0 
    ::hWnd = hWnd
else
    MsgAlert( "Non defined COVERF cID " + ;
    AllTrim( Str( ::nId ) ) + ;
    " in resource " + ::oWnd:cNibName )
endif

IKCOVERINICIAL(::hWnd)

return nil
