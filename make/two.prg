#include "FiveMac.ch"

function Another()

   local oWnd
   
   DEFINE WINDOW oWnd TITLE "Second"

   @ 3, 3 BUTTON "Third" ACTION Third()
   
   ACTIVATE WINDOW oWnd

return nil