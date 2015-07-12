#include "FiveMac.ch"

function Main()

   local oWnd
   
   DEFINE WINDOW oWnd TITLE "First"
   
   @ 3, 3 BUTTON "Second" ACTION Another()
   
   ACTIVATE WINDOW oWnd

return nil