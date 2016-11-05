#include "FiveMac.ch"
/*
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
*/

#include "FiveMac.ch"

function Main()

local oDlg
local cText1 := "Abelia ×grandiflora", cText2 := "Abelia schumannii 'Bumblebee'", cText3 := "Ceanothus ×delilianus 'Henri Défossé' "

SET DATE FRENCH

DEFINE DIALOG oDlg TITLE "TestGet" SIZE 400, 200 FLIPPED

@ 15, 30 SAY "Text1:" OF oDlg

@ 15, 90 GET cText1 OF oDlg TOOLTIP "a string with cross" SIZE 350, 25 UTF

@ 45, 30 SAY "Text2:" OF oDlg

@ 45, 90 GET cText2 OF oDlg TOOLTIP "a string with apo" SIZE 350, 25

@ 75, 30 SAY "Text3:" OF oDlg

@ 75, 90 GET cText3 OF oDlg TOOLTIP "a normal string" SIZE 350, 25

@ 140, 150 BUTTON "Ok" OF oDlg ACTION MsgInfo( cText1 ), MsgInfo( cText2 ), MsgInfo( cText3 )

ACTIVATE DIALOG oDlg CENTERED

return nil