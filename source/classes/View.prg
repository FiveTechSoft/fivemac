#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TView FROM TControl

   DATA   hWnd
   DATA   oWnd
   DATA   cTitle 

   METHOD New( oWnd )
   METHOD Hide() INLINE ViewHide( ::hWnd )
   METHOD Show() INLINE ViewShow( ::hWnd )   
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cTitle ) CLASS TView

   DEFAULT oWnd := GetWndDefault(), cTitle := ""
   DEFAULT nTop := 0, nLeft:= 0, nWidth:= oWnd:nWidth(), nHeight:= oWnd:nHeight()
      
   ::cTitle = cTitle
   ::hWnd   = WndSetSubview( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
   ::oWnd   = oWnd
 
   oWnd:AddControl( Self )
   
   AAdd( GetAllWin(), Self ) // it receives msgs from its child controls 
 
return Self

//----------------------------------------------------------------------------//