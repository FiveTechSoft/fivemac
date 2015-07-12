#include "FiveMac.ch"

function Main()

 

   local oDlg,obtn,oBar
   
   DEFINE DIALOG oDlg TITLE "Capturador"  FROM 10, 10 TO 10, 160    
   
    oDlg:center()
     
   DEFINE TOOLBAR oBar OF oDlg 
   
   
    DEFINE BUTTON OF oBar PROMPT "Capturar" ;
      TOOLTIP "Capturar" ;
      IMAGE  RESPATH()+"/camera.tiff" ;
      ACTION  ( oDlg:hide(), sleep(1),savescreen(), ANIMABOTES(.t.),sleep(3), oDlg:end())
            
   ACTIVATE DIALOG oDlg 
   
   
return nil   

function Another()

   local oDlg

   DEFINE DIALOG oDlg TITLE "Dialog" 
   
   ACTIVATE DIALOG oDlg
   
return nil
