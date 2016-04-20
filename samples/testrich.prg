#include "FiveMac.ch"

function Main()

   local oDlg, oFld, oGet, cText := ""

   DEFINE DIALOG oDlg SIZE 600, 400

   @ 0, 0 FOLDER oFld OF oDlg PAGES "Test" SIZE 600, 350 

   @ 0, 0 GET oGet VAR cText MEMO OF oFld:aDialogs[ 1 ] SIZE 580, 300

   oGet:SetRichText( .T. )
   oGet:SetImportGraf( .T. )
   oGet:AddHRuler()
   oGet:SetUndo( .T. )
   oGet:SetFocus()

   cText = "{\rtf1\ansi\ansicpg1200\deff0\deflang1043{\fonttbl{\f0\fnil\fcharset0 TIMES NEW ROMAN;}}" + ;
           "{\*\generator Msftedit 5.41.21.2510;}\viewkind4\uc1\pard\f0\fs24 Bij deze fraaie plant " + ;
           "is het jonge blad roze gekleurt. Later verkleurt dit blad naar groen met een cr'e8mewitte rand." + ;
           "De jonge takken zijn opvallend rood gekleurt, wat goed contrasteerd met het fris gekleurde blad.\par}"

   oGet:SetAttributedString( cText )
   oGet:GoTop()

   ACTIVATE DIALOG oDlg CENTERED

return nil