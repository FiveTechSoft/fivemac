#include "FiveMac.ch"

function Main()

   local oDlg, oFld, oGet1, cText1 := "", oGet2, cText2 := ""

   DEFINE DIALOG oDlg SIZE 600, 400

   @ 0, 0 FOLDER oFld OF oDlg PAGES "First", "Second" SIZE 600, 350 

   @ 0, 0 GET oGet1 VAR cText1 MEMO OF oFld:aDialogs[ 1 ] SIZE 580, 300

   oGet1:SetRichText( .T. )
   oGet1:SetImportGraf( .T. )
   oGet1:AddHRuler()
   oGet1:SetUndo( .T. )
   oGet1:SetFocus()

   cText1 = "{\rtf1\ansi\ansicpg1200\deff0\deflang1043{\fonttbl{\f0\fnil\fcharset0 TIMES NEW ROMAN;}}" + ;
           "{\*\generator Msftedit 5.41.21.2510;}\viewkind4\uc1\pard\f0\fs24 FIRST Bij deze fraaie plant " + ;
           "is het jonge blad roze gekleurt. Later verkleurt dit blad naar groen met een cr'e8mewitte rand." + ;
           "De jonge takken zijn opvallend rood gekleurt, wat goed contrasteerd met het fris gekleurde blad.\par}"

   oGet1:SetAttributedString( cText1 )
   oGet1:GoTop()

   @ 0, 0 GET oGet2 VAR cText2 MEMO OF oFld:aDialogs[ 2 ] SIZE 600, 346

   oGet2:SetRichText( .T. )
   oGet2:SetImportGraf( .T. )
   oGet2:AddHRuler()
   oGet2:SetUndo( .T. )
   oGet2:SetFocus()

   cText2 = "{\rtf1\ansi\ansicpg1200\deff0\deflang1043{\fonttbl{\f0\fnil\fcharset0 TIMES NEW ROMAN;}}" + ;
           "{\*\generator Msftedit 5.41.21.2510;}\viewkind4\uc1\pard\f0\fs24 SECOND Bij deze fraaie plant " + ;
           "is het jonge blad roze gekleurt. Later verkleurt dit blad naar groen met een cr'e8mewitte rand." + ;
           "De jonge takken zijn opvallend rood gekleurt, wat goed contrasteerd met het fris gekleurde blad.\par}"

   oGet2:SetAttributedString( cText2 )
   oGet2:GoTop()

   ACTIVATE DIALOG oDlg CENTERED

return nil