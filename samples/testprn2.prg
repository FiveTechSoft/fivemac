#include "FiveMac.ch"

function Main()

   PrinterSelect()

return nil

function PrinterPaint()

   DrawText( 50, 150, "Printing from FiveMac", CreateFont( "Arial", 20 ), CLR_BLUE() )
   DrawText( 50, 200, "Printing from FiveMac", CreateFont( "Verdana", 20 ), CLR_GREEN() )
   DrawText( 50, 250, "Printing from FiveMac", CreateFont( "Times Roman", 20 ), CLR_RED() )
   
return nil   
 