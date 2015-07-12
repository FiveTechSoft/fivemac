#include "FiveMac.ch"

function Main()

   local oWnd, lVar := .t.
   
   DEFINE WINDOW oWnd TITLE "Test"

   @ 20, 20 CHECKBOX lVar PROMPT "checkbox" OF oWnd ;
      ON CHANGE MsgInfo( cValToChar( lVar ) )
   
   ACTIVATE WINDOW oWnd ;
      ON CLICK MsgInfo( Str( nRow ) + "," + Str( nCol ) )
   
return nil   