#include "FiveMac.ch"

function Main()

   local oDlg
   
   DEFINE DIALOG oDlg TITLE "Dialog"
   
   @ 40, 40 BUTTON "Another" OF oDlg ACTION Another()
   
   DEFINE MSGBAR OF oDlg
   
   ACTIVATE DIALOG oDlg
   
return nil   

function Another()

   local oDlg

   DEFINE DIALOG oDlg TITLE "Dialog" 
   
   ACTIVATE DIALOG oDlg
   
return nil   
   
   