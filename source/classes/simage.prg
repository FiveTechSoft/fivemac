#include "FiveMac.ch"

//------------- preprocesado -----------------
//
// #xcommand @ <nRow>, <nCol> SIMAGE [ <oImage> ] ;
//             [ FILENAME <cFileName> ] ;
//             [ OF <oWnd> ] ;
//                [ SIZE <nWidth>, <nHeight> ] ;
//              => ;
//                 [ <oImage> := ] TSimage():New( <nRow>, <nCol>, <nWidth>, <nHeight>, <oWnd>,[<(cFileName)>] )
//
//----------------------------------------------------------------------------//

CLASS TSimage FROM TControl


   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cPrompt, nStyle )

   METHOD Open(cImage) INLINE SImageOpen(::hWnd,cImage)

   METHOD Fit() INLINE SImageFit(::hWnd )

   METHOD VerticalFlip() INLINE SImageVFLIP(::hWnd )

   METHOD edit() INLINE SImageedit(::hWnd )

   METHOD setautoresize(lauto) INLINE  SImageAutoResize(::hWnd,lauto)

   METHOD Getautoresize() INLINE SImagegetautoresize(::hWnd)

   METHOD zoomin() INLINE SImagezoomIn(::hWnd)

   METHOD zoomOut() INLINE SImagezoomOut(::hWnd)

   METHOD Rotateleft() INLINE SImageRotaLeft(::hWnd)

    METHOD RotateRight() INLINE SImageRotaRight(::hWnd)

   METHOD crop() INLINE  SImageSetCrop(::hWnd)

   METHOD rotate() INLINE SImageSetRotate(::hwnd)

   MEthod Normal() INLINE SImageSetNormal(::hwnd)
   
   METHOD Hide()  INLINE SImageSetHide(::hWnd)
   
   METHOD show()  INLINE SImageSetShow (::hWnd)    
   
   METHOD SheetOpen() INLINE  ChooseSheetSImage ( ::hwnd ) 
   
   METHOD SaveAs()  INLINE SImageSaveAs(::hWnd )
   
   METHOD Camera()  INLINE  PhotoCamLoad(::hWnd)
      
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cImage ) CLASS TSimage

   DEFAULT nWidth := 100, nHeight := 200, oWnd := GetWndDefault()

   ::hWnd = SImageCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )

   if !Empty(cImage)
       SImageOpen(::hWnd,cImage)
   endif

   ::oWnd = oWnd

   oWnd:AddControl( Self )

return Self

//----------------------------------------------------------------------------//







