#include "FiveMac.ch"

function Main()

   local oDlg 
   local nTest := 123456789, cText := "Hello world", dTest := Date()
   
   SET DATE FRENCH
   
   DEFINE DIALOG oDlg TITLE "TestGet" SIZE 400, 200 FLIPPED
   
   @ 15, 30 SAY "Number:" OF oDlg
   
   @ 15, 90 GET nTest PICTURE "999,999,999" OF oDlg TOOLTIP "a number" 

   @ 45, 30 SAY "String:" OF oDlg

   @ 45, 90 GET cText PICTURE "@!" OF oDlg TOOLTIP "a string" 

   @ 75, 30 SAY "Date:" OF oDlg

   @ 75, 90 GET dTest PICTURE "@D" OF oDlg TOOLTIP "a date" 
   
   @ 140, 150 BUTTON "Ok" OF oDlg ACTION MsgInfo( nTest ), MsgInfo( cText ), MsgInfo( dTest )
   
   ACTIVATE DIALOG oDlg CENTERED
         
return nil     