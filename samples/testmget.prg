#include "FiveMac.ch"

function Main()

   local oWnd, cTest := "Hello world!"
   local oGEt
   
   DEFINE WINDOW oWnd TITLE "TestGet" FROM 300, 300 TO 800, 900
   
   @ 150, 40 SAY "Name:" OF oWnd
   
   @ 65, 90 GET oget VAR cTest MEMO OF oWnd ;
      SIZE oWnd:nWidth - 140, oWnd:nHeight - 120
  
      oGET:SetRichText(.t.)
      oGet:AddHRuler()
      oGet:SetImportGraf(.t.)
      oget:SetUndo(.t.)      
            
           
          
   @ 30, 150 BUTTON "Ok" OF oWnd ACTION oWND:END()
   
   ACTIVATE WINDOW oWnd
         
return nil     