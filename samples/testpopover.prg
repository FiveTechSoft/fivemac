#include "FiveMac.ch"

//---------------------------------------------------------------------------//

function Main()

   local oWnd
   local obtn

   DEFINE WINDOW oWnd TITLE "Testing popover" ;
      FROM 150, 150 TO 300, 400
   
   ownd:center()
   
   @ 100, 40 BUTTON obtn PROMPT "Dialog" OF oWnd ACTION  SHOWWINPOPOVER(obtn:hWnd, otra():hWnd )
   
   @ 40, 40 BUTTON "end" OF oWnd ACTION oWnd:end()
      
   ACTIVATE WINDOW oWnd  ;
       VALID MsgYesNo( "Want to end ?" )
   
return nil   

//---------------------------------------------------------------------------//

function otra()
local ownd2,obtn
local oget
local ctext:= "Hello Word"

 DEFINE WINDOW oWnd2 TITLE "Testing popover" ;
      FROM 150, 150 TO 400, 500
   
   @ 50, 40 GET oget VAR cText MEMO OF oWnd2 ;
      SIZE oWnd2:nWidth - 50, oWnd2:nHeight - 10
  
      oGET:SetRichText(.t.)
      oGet:AddHRuler()
      oGet:SetImportGraf(.t.)
      oget:SetUndo(.t.)      
   
    
   @ 10, 40 BUTTON obtn PROMPT "Dialog" OF oWnd2 ACTION Showpopover(oBtn:hwnd,"primer test popover")
   
   @ 10, 140 BUTTON "end" OF oWnd2 ACTION Showpopover(oBtn:hwnd,"otro mas popover") 
 
Return ownd2


//---------------------------------------------------------------------------//

