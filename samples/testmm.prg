#include "FiveMac.ch"

function Main()

   local oWnd, oBtn
   
   DEFINE WINDOW oWnd TITLE "Mouse Move"
   
   @ 20, 20 BUTTON oBtn PROMPT "OK" 
   
   oWnd:bMMoved = { | nRow, nCol | oBtn:nTop := nRow, oBtn:nLeft := nCol }
   
   ACTIVATE WINDOW oWnd
   
return nil   