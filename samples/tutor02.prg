// Building our first window

#include "FiveMac.ch"

//----------------------------------------------------------------------------//

function Main()

   local oWnd
   
   DEFINE WINDOW oWnd TITLE "Tutor02" ;
       FROM 200, 250 TO 550, 750

   DEFINE MSGBAR OF oWnd

   @ 0, 10 SAY "A FiveMac MsgBar" OF oWnd SIZE 150, 20 RAISED
  
   ACTIVATE WINDOW oWnd ;
      ON CLICK MsgInfo( "click" ) ;
      VALID MsgYesNo( "Want to end ?" )

return nil

//----------------------------------------------------------------------------//
