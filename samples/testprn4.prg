#include "fivemac.ch"

static oPrn

function Main()

   local oDlg

   DEFINE DIALOG oDlg TITLE "Printer test"

   @ 40, 40 BUTTON "Print" OF oDlg ACTION Print()

   ACTIVATE DIALOG oDlg

return nil

function Print()

   local nWidth, nHeight

   oPrn = TPrinter():New()

   oPrn:SetLeftMargin( 0 )
   oPrn:SetRightMargin( 0 )
   oPrn:SetTopMargin( 0 )
   oPrn:SetBottomMargin( 0 )
   oPrn:SetPaperName( "A4" )
   oPrn:AutoPage( .T. )

   nHeight := oPrn:GetPrintableHeight()
   nWidth  := oPrn:GetPrintableWidth()

   oPrn:SetSize( nWidth, nHeight )

 oPrn:Run()

return nil

function PrinterPaint()

   local nStep, n, nLine := 1
   local  nHeight := oPrn:GetPrintableHeight()

    nStep =   nHeight/30 // 30 lines

   for n = 1 to nHeight  STEP nStep
      @ n, 0 SAY Str( nLine++ ) OF oPrn
   next
   
return nil

