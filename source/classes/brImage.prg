#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TBrImage FROM TControl

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd )

   METHOD OpenPanel()         INLINE IKImgBrOpenPanel( ::hWnd )  
   METHOD OpenDir( cDir )     INLINE IKImgBrOPenDir( ::hWnd, cDir )  
   METHOD OpenFile( cfile )   INLINE IKImgBrOPenFile( ::hWnd, cfile )  
   
   METHOD SetStyle( nStyle )  INLINE IKImgBroStyle( ::hWnd, nStyle )   
   
   METHOD SetZoom( nZoom )    INLINE IKImgBrSetZoom( ::hWnd, nZoom )   
   METHOD GetZoom()           INLINE IKImgBrGetZoom( ::hWnd )   
   
   METHOD RunSlide()          INLINE IKImgRunSlide( ::hWnd )
   
   METHOD Animate( lAnimate ) INLINE IKIMGBROANIMATE( ::hWnd, lAnimate )
	  
ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CLASS TBrImage

   DEFAULT nWidth := 100, nHeight := 200, oWnd := GetWndDefault()
   
   ::hWnd = IKImgBrCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
   
   ::oWnd = oWnd
   
   oWnd:AddControl( Self )
   
return Self

//----------------------------------------------------------------------------//