#include "FiveMac.ch"

function Main()

   local oWnd, cObject, oFld, oBrw
   local aInfo := { { "top", "100" }, { "left", "100" } }
   
   DEFINE WINDOW oWnd TITLE "Object Inspector" ;
      FROM 125, 32 TO 286, 476 PANELED
   
   @ 436, 20 COMBOBOX cObject OF oWnd ;
      SIZE 246, 25 ITEMS { "Form1 as TForm" }
      
   @ 20, 20 FOLDER oFld SIZE 246, 396 OF oWnd ;
      PAGES "Properties", "Events"   

   @ 0, 0 LISTBOX oBrw FIELDS "", "" ;
      HEADERS "Name", "Value" ;
      OF oFld:aItems[ 1 ] SIZE 226, 350
   
   oBrw:SetArray( aInfo )
   oBrw:bLine = { | nRow | { aInfo[ nRow ][ 1 ], aInfo[ nRow ][ 2 ] } }
      
   ACTIVATE WINDOW oWnd
   
return nil 