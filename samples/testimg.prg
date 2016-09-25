#include "FiveMac.ch"

function Main()

   local oWnd, oImg

   DEFINE WINDOW oWnd ;
      FROM 444, 89 TO 689, 500
   
   oWnd:center()
   
   @ 100, 139 IMAGE oImg OF oWnd SIZE 107, 91 FILENAME ImgPath() + "fivetech.gif"

   oImg:bLButtonDown = { || MsgInfo( oImg:GetHeight() ) }

   @ 69, 95 SAY "(c) FiveTech Software 2007-2016" OF oWnd SIZE 210, 14
   
   @ 22, 150 BUTTON "Ok" OF oWnd ACTION oWnd:End()
   
    @ 22, 250 BUTTON "Frame" OF oWnd ACTION ( MsgInfo( oImg:GetWidth() ), oImg:setFrame( ) )
   
   ACTIVATE WINDOW oWnd
   
return nil
