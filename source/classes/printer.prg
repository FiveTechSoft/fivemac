#include "FiveMac.ch"

#define DMORIENT_PORTRAIT   0
#define DMORIENT_LANDSCAPE  1

//----------------------------------------------------------------------------//

CLASS TPrinter 

   DATA  hWnd
   DATA  cDocument
   DATA  hJob, hPrnInfo
   DATA  aControls INIT {} // child controls array
   DATA  nPages INIT 0
   DATA  nRowsPerPage INIT 40
 
   METHOD New( nTop, nLeft, nWidth, nHeight, cDocument ,lAutopage )
   METHOD Run() INLINE PrnJobRun( ::hJob )
   
   METHOD GetCurrentJob() INLINE ::hJob := PrnJobCurrent()
   METHOD CreatePrnInfo() INLINE PrnInfoCreate( ::hJob )
   METHOD CreateJob()     INLINE PrnJobCreate( ::hWnd )
   
   METHOD GetPrnInfoShared() INLINE ::hPrnInfo := PrnInfoShared()
   METHOD SetPagOrientation( nOrientation ) INLINE PrnInfoPagSetOrientation( ::hPrnInfo, nOrientation )
   
   METHOD SetLandscape() INLINE PrnInfoPagSetOrientation( hPrnInfo, DMORIENT_LANDSCAPE )
   METHOD SetPortrait()  INLINE PrnInfoPagSetOrientation( hPrnInfo, DMORIENT_PORTRAIT )
   
   METHOD Say( nRow, nCol, cText, nClrText, nClrBack, cFontName, nFontSize ) 
   METHOD SayAttr( nRow, nCol, cText, cFontName, cFontsize, nWidth, nHeight, nClrText, nClrBk, nPad )
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

   METHOD StartPage() INLINE ::nPages++
   METHOD EndPage()

   METHOD LastRow() INLINE ::nRowsPerPage - 1 
   METHOD TopRow()  INLINE ::GetaSizePrintable()[ 2 ] * ( ::nPages - 1 ) 
 
   METHOD RowPos( nRow ) INLINE ::TopRow() + nRow * ( ::GetaSizePrintable()[ 2 ] / ::nRowsPerPage )

 ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, cDocument, lAutopage ) CLASS TPrinter
    
   DEFAULT lAutoPage:= .T.
   DEFAULT cDocument := "Fivemac print job"
   DEFAULT nTop := 0, nLeft := 0, nWidth := 300, nHeight := 300
   
   ::hWnd     := PrnViewCreate( nTop ,nLeft,nWidth,nHeight )
   ::hJob     := ::CreateJob()
   ::hPrnInfo := ::CreatePrnInfo()
   
   ::SetTopMargin( 0 )
   ::SetBottomMargin( 0 )
   ::SetLeftMargin( 0 )
   ::SetRightMargin( 0 )
   ::SetPaperName( "A4" )

   if lAutoPage
      ::AutoPage( .T. )
   endif

   ::cDocument = cDocument
    
return Self

//---------------------------------------------------------------------------//

METHOD Say( nRow, nCol, cText, nClrText, nClrBack, cFontName, nFontSize ) CLASS TPrinter

   local oSay

   @ ::RowPos( nRow ), nCol SAY oSay PROMPT cText OF Self

   if nClrText != nil .and. nClrBack != nil
      oSay:SetColor( nClrText, nClrBack )
   endif

   if cFontName != nil .and. nFontSize != nil
      oSay:SetFont( cFontName, nFontSize )
   endif

return nil 

//---------------------------------------------------------------------------//

 METHOD SayAttr( nRow, nCol, cText, cFontName, cFontsize, nWidth, nHeight, nClrText, nClrBk, nPad ) CLASS TPrinter

    PrnSay( nRow, nCol, nWidth, nHeight, ::hWnd, cText, cFontName, cFontsize, nClrText, nClrBk, nPad )

return nil

//---------------------------------------------------------------------------//

METHOD GetPrintableWidth() CLASS TPrinter

   local aSize  := PrnInfoImageableBounds( ::hPrnInfo )
   local nWidth := PrnInfoPageWidth( ::hPrnInfo )

   if nWidth > aSize[ 1 ]
      nWidth := aSize[ 1 ]
   endif
    
Return nWidth

//---------------------------------------------------------------------------//

METHOD GetPrintableHeight() CLASS TPrinter

   local aSize   := PrnInfoImageableBounds( ::hPrnInfo )
   local nHeight := PrnInfoPageHeight( ::hPrnInfo )

   if nHeight > aSize[2]
      nHeight := aSize[2]
   endif
    
return nHeight

//---------------------------------------------------------------------------//

METHOD AddControl( oControl ) CLASS TPrinter

   AAdd( ::aControls, oControl )

return nil

//---------------------------------------------------------------------------//

METHOD EndPage() CLASS TPrinter

   local aSize := ::GetaSizePrintable()

   ::SetSize( aSize[ 1 ], ::nPages * aSize[ 2 ] )

return nil

//---------------------------------------------------------------------------//

function PrinterPaint() 

return nil

//---------------------------------------------------------------------------//