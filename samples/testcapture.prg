#include "FiveMac.ch"

function Main()

   local oDlg,oCap
   local cFile:="/Volumes/Macintosh HD/Usuarios/Manuel/Desktop/My Recorded Movie.mov"
   
   DEFINE DIALOG oDlg TITLE "Dialog"
   
@ 1, 40 BUTTON "start" OF oDlg ACTION  oCap:= CreateCaptureCaM( cFile, oDlg )
   
   @ 1, 140 BUTTON "Stop" OF oDlg ACTION   (  ocap:Stop()  )   
   
   @ 1, 280 BUTTON "Salir" OF oDlg ACTION  oDlg:end()
   
   DEFINE MSGBAR OF oDlg SIZE 32
   
   ACTIVATE DIALOG oDlg
   
return nil   

Function CreateCaptureCaM( cFile ,oDlg )
local oCap := TCapture():new( 70, 84, 330, 300, oDlg ) 
  
   oCap:Initiate( cFile ) 
   oCap:Start()
            
Return ocap
   
   
   