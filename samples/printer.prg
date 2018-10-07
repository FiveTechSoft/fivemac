#include "FiveMac.ch"

function Main()

   local oDlg

   DEFINE DIALOG oDlg TITLE "Printer test"

   @ 40, 40 BUTTON "Print" OF oDlg ACTION Print()

   ACTIVATE DIALOG oDlgAniTuner 

return nil

function Print()

   local n, oPrn := TPrinter():New

   for n = 1 to 10 // ten pages
      oPrn:StartPage()
      
         oPrn:Say( 0, 250, "Header " + Alltrim( Str( oPrn:nPages ) ) )
         oPrn:Say( oPrn:LastRow(), 250, "- Page " + Alltrim( Str( oPrn:nPages ) ) + " -" )

      oPrn:EndPage()
   next

   oPrn:Run()

return nil


