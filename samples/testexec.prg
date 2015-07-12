#include "FiveMac.ch"

function Main()

   local oWnd

   DEFINE WINDOW oWnd TITLE "Testing MacExec()"

   @ 200, 40 BUTTON "Calculator" ACTION MacExec( "calculator" )

   @ 150, 40 BUTTON "TextEdit" ACTION MacExec( "textedit" )

   ACTIVATE WINDOW oWnd

return nil