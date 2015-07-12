#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TPdfview FROM TControl
 
    DATA cFile 
 
    METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cPdfName , lAutoScale )

   METHOD GoBack() INLINE PdfGoBack( ::hWnd )
   
   METHOD GoForward() INLINE PdfGoForward( ::hWnd )

   METHOD SetPdf(cPdfName) INLINE ( ::cFile := cPdfName , PdfSetDocument(::hWnd , cPdfName ) )

   METHOD ZoomIn() INLINE PdfzoomIn( ::hWnd )
   METHOD ZoomOut() INLINE PdfzoomOut( ::hWnd )
   
   METHOD Gotop() INLINE PdfGotop( ::hWnd )
   METHOD GoBottom() INLINE PdfGobottom( ::hWnd )

   METHOD GoPrevious() INLINE PdfGoPrevious( ::hWnd )
   METHOD GoNext() INLINE PdfGoNext( ::hWnd )

   METHOD SetScale(nScale) INLINE PdfSetScale( ::hWnd ,nScale )
   METHOD SetAutoScale(lAuto) INLINE PdfAutoScale( ::hWnd ,lAuto )
    
   METHOD Redefine( nId, oWnd )
   METHOD Initiate()  
   
             
ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cPdfName , lAutoScale ) CLASS TPdfview

   DEFAULT nWidth := 300, nHeight := 100, oWnd := GetWndDefault()
   DEFAULT lAutoScale:= .f.  
         
   ::hWnd = PdfviewCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
   ::oWnd = oWnd
   
   ::SetPdf( cPdfName )
   ::SetAutoScale(lAutoScale) 
   
   
   oWnd:AddControl( Self ) 
	    
return Self   

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, cPdf ) CLASS TPdfview

   DEFAULT oWnd := GetWndDefault()

   ::nId     = nId
   ::oWnd    = oWnd
   ::cFile =  cPdf
     
   oWnd:DefControl( Self )

return Self
//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TPdfView

local hWnd:= WNDGETIDENTFROMNIB (::oWnd:hWnd,alltrim(str( ::nId )) )   
    if hWnd = -1
       MsgAlert( "Non found cID " + ;
        AllTrim( Str( ::nId ) ) + ;
        " in resource " + ::oWnd:cNibName )
        return nil
    endif 
    if hWnd != 0 
        ::hWnd = hWnd
    else
        MsgAlert( "Non defined cID " + ;
        AllTrim( Str( ::nId ) ) + ;
        " in resource " + ::oWnd:cNibName )
    endif
    
    ::SetPdf(::cFile )


return nil