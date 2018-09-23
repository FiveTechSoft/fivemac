#include "FiveMac.ch"

function Main()

   local oDlg
   local oget2
   local oBtnOk
   local nTest := 12345.232
   local cText := "Hello world", dTest := Date()
   
   SET DATE FRENCH
   
   DEFINE DIALOG oDlg TITLE "TestGet" SIZE 400, 200 FLIPPED

   @ 15, 30 SAY "Number:" OF oDlg
   
   
   @ 15, 90 GET oget2 VAr nTest OF oDlg  PICTURE "9999999.99"  TOOLTIP "a number"

 //NGETSETDECIFORMAT( oget2:hWnd , 2 )



 //  oget2:SetNumeric()

 //  oget2:SetDecimals( 1 )



//@ 15, 90 GET oGet2 VAR nTest OF oDlg TOOLTIP "tik hier in" SIZE 100, 25
//oGet2:SetNumeric()

//oGet2:SetNumFormat("###0.##")    &&this does not work correct, if I enter something and then a dot everything disappears

   @ 45, 30 SAY "String:" OF oDlg

   @ 45, 90 GET cText PICTURE "@!" OF oDlg TOOLTIP "a string" 

   @ 75, 30 SAY "Date:" OF oDlg

   @ 75, 90 GET dTest PICTURE "@D" OF oDlg TOOLTIP "a date" 
   
   @ 140, 150 BUTTON oBtnOk PROMPT "Ok" OF oDlg ACTION msginfo( valtype( nTest)), MsgInfo( nTest ), MsgInfo( cText ), MsgInfo( dTest ), oBtnOk:SetFocus()

oget2:setfocus()
 // oBtnOk:SetFocus()

   ACTIVATE DIALOG oDlg CENTERED

return nil

/*
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
*/
