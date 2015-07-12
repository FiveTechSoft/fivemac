#include "FiveMac.ch"

function Main()

   local oDlg
   local otab
     
   DEFINE DIALOG oDlg TITLE "Testing Groups" ;
      FROM 270, 350 TO 500, 740
   
    @ 70, 30 TABS otab PROMPTS {"hola","Adios"} OF oDlg SIZE 320, 120 
        
    @ 22, 83 BUTTON "cPrompt" OF otab:aControls[1] ACTION otab:aControls[1]:Settext("vamos")      
    @ 22, 83 BUTTON "OK" OF otab:aControls[2] ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED
   
return nil   
 