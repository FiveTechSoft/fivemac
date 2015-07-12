// Testing DatePickers

#include "FiveMac.ch"

function Main()

   local oDlg, oDPick 
   local oget , dDate:=ctod("12/12/11")
          
   DEFINE DIALOG oDlg TITLE "Test DatePicker" ;
      FROM 20, 300 TO 238, 480
   
   @ 192 ,20 Get dDate SIZE 80, 20
   @ 188, 100 BUTTON "Set" OF oDlg ACTION oDpick:setDate( dDate ) SIZE 60,25
       
   @ 40, 20 DATEPICKER oDPick OF oDlg SIZE 200, 160
     
   @ 10, 20 BUTTON "Value" OF oDlg ACTION MsgInfo( oDPick:GetText() ) SIZE 60,25
    
   @ 10, 100 BUTTON "End" OF oDlg ACTION oDlg:End() SIZE 60,25
       
   ACTIVATE DIALOG oDlg 
     
return nil




