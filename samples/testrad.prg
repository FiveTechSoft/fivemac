#include "FiveMac.ch"

function Main()

   local oWnd, oRad, nRad := 2

   DEFINE WINDOW oWnd TITLE "Testing RadioButtons" PANELED

   @ 200, 30 RADIO oRad VAR nRad ITEMS { "One", "Two", "Three" } OF oWnd

   @ 23,  20 BUTTON "Value" OF oWnd ACTION MsgInfo( nRad )

   @ 23, 120 BUTTON "End" OF oWnd ACTION oWnd:End()

   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Want to end ?" )

return nil
