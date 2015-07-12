#include "FiveMac.ch"

function Main()

   local oDlg,oCap
   local cFile:="/Users/Shared/My Recorded Movie.mov"
   
   DEFINE DIALOG oDlg TITLE "Dialog"
   
   @ 1, 40 BUTTON "start" OF oDlg ACTION   (  ocap:=TCapture():new(70,84,330,300 ,oDlg,cfile ) , oCap:Start()  )
   
   @ 1, 140 BUTTON "Stop" OF oDlg ACTION   (  ocap:Stop()  )   
   
   @ 1, 280 BUTTON "Salir" OF oDlg ACTION  oDlg:end()
   
   DEFINE MSGBAR OF oDlg SIZE 32
   
   ACTIVATE DIALOG oDlg
   
return nil   

   
   
   