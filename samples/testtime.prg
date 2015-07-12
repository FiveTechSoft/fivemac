// Testing a Timer

#include "FiveMac.ch"

function Main()

   local oWnd, oSay
   local obusca
   local oTimer


   DEFINE WINDOW oWnd    
    
  

   @ 100, 100 SAY oSay PROMPT Time() OF oWnd 

   DEFINE TIMER oTimer INTERVAL 1 ;
          ACTION  oSay:SetText( Time() )  ;
          OF oWnd REPEAT DEACTIVATE 

 // oTimer:=Ttimer():New( 1 , { | nTimerId, oWnd |  oSay:SetText( Time() )  }, oWnd , .t., .t. )
  
   @ 20,20 Button "Stop"  Action   oTimer:DeActivate()
   @ 20,120 Button "Start"  Action oTimer:Activate()
        
     ACTIVATE WINDOW oWnd  
 

    

return nil

