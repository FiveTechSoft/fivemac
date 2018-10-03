#include "FiveMac.ch"

#define DMORIENT_PORTRAIT   0
#define DMORIENT_LANDSCAPE  1



//----------------------------------------------------------------------------//

CLASS TPrinter 

   DATA hWnd
   DATA cDocument
   DATA hJob , hPrnInfo
   DATA  aControls INIT {} // child controls array
 
   METHOD New( nTop, nLeft, nWidth, nHeight, cDocument ,lAutopage )
   METHOD Run() INLINE PrnJobRun( ::hJob )
   
   METHOD GetCurrentJob() INLINE ::hJob:= PrnJobCurrent()
   METHOD CreatePrnInfo() INLINE PrnInfoCreate( ::hJob )
   METHOD CreateJob()     INLINE PrnJobCreate( ::hWnd )
   
   METHOD GetPrnInfoShared() INLINE ::hPrnInfo := PrnInfoShared()
   METHOD SetPagOrientation( nOrientation ) INLINE PrnInfoPagSetOrientation( ::hPrnInfo, nOrientation )
   
   METHOD SetLandscape() INLINE PrnInfoPagSetOrientation( hPrnInfo, DMORIENT_LANDSCAPE )
   METHOD SetPortrait()  INLINE PrnInfoPagSetOrientation( hPrnInfo, DMORIENT_PORTRAIT )
   
   METHOD Say( nRow, nCol, cText, cFontName, cFontsize, nWidth, nHeight, nClrText, nClrBk, nPad )
   METHOD AutoPage() INLINE PrnInfoAutoPage( ::hPrnInfo )   
   
   METHOD SetPaperName( cName ) INLINE PrnSetPaperName( ::hPrnInfo , cName )
   
   METHOD AddControl( oControl ) 
   
   METHOD PageWidth()  INLINE PrnInfoPageWidth( ::hPrnInfo )
   METHOD PageHeight() INLINE PrnInfoPageHeight( ::hPrnInfo )
   
   METHOD SetSize( nWidth, nHeight ) INLINE PrnSetSize( ::hWnd, nWidth, nHeight ) 
   
   METHOD SetLeftMargin( nMargin )   INLINE PrnInfoPagSetLeftMargin( ::hPrnInfo, nMargin )
   METHOD SetRightMargin( nMargin )  INLINE PrnInfoPagSetRightMargin( ::hPrnInfo, nMargin )
   METHOD SetTopMargin( nMargin )    INLINE PrnInfoPagSetTopMargin( ::hPrnInfo, nMargin )
   METHOD SetbottomMargin( nMargin ) INLINE PrnInfoPagSetbottomMargin( ::hPrnInfo, nMargin )

   METHOD GetaSizePrintable() INLINE PrnInfoImageableBounds( ::hPrnInfo )
   METHOD GetPrintableHeight()
   METHOD GetPrintableWidth()
   
 ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, cDocument,lAutopage ) CLASS TPrinter
    
   DEFAULT lAutoPage:= .t.
   DEFAULT cDocument := "Fivemac print job"
   DEFAULT nTop := 0, nLeft:= 0, nWidth:= 300, nHeight:= 300
   
   ::hWnd := PrnViewCreate( nTop ,nLeft,nWidth,nHeight )
   ::hJob    := ::CreateJob()
   ::hPrnInfo:= ::CreatePrnInfo()
   
   if lAutopage
       ::AutoPage()
   endif
   
   ::cDocument = cDocument
    
return Self

//---------------------------------------------------------------------------//

 METHOD Say( nRow, nCol, cText, cFontName, cFontsize, nWidth, nHeight, nClrText, nClrBk, nPad )CLASS TPrinter

    PrnSay(nRow,nCol,nWidth,nHeight,::hWnd,cText,cFontName,cFontsize,nClrText,nClrBk,nPad )

Return nil

//---------------------------------------------------------------------------//

METHOD GetPrintableWidth() CLASS TPrinter
local aSize  := PrnInfoImageableBounds( ::hPrnInfo )
local nWidth := PrnInfoPageWidth( ::hPrnInfo )

    if nWidth > aSize[1]
       nWidth := aSize[1]
    endif
    
Return nWidth

//---------------------------------------------------------------------------//

METHOD GetPrintableHeight() CLASS TPrinter
local aSize   := PrnInfoImageableBounds( ::hPrnInfo )
local nHeight := PrnInfoPageHeight( ::hPrnInfo )

    if nHeight > aSize[2]
       nHeight := aSize[2]
    endif
    
Return nHeight

//---------------------------------------------------------------------------//
METHOD AddControl( oControl ) CLASS TPrinter
   AAdd( ::aControls, oControl )
return nil

