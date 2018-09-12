#include "FiveMac.ch"

function Main()

   local oDlg, cVar
   local aFonts := FM_availableFonts()
   
   DEFINE DIALOG oDlg TITLE "Available fonts" SIZE 300, 300

   @ 200, 50 COMBOBOX cVar ITEMS aFonts SIZE 200, 20 OF oDlg

   ACTIVATE DIALOG oDlg CENTERED

return nil
