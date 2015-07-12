#include "FiveMac.ch"

function Main()

   local oWnd

   DEFINE WINDOW oWnd

   // @ 300, 200 COLORWELL oClr SIZE 100, 30 OF oWnd

   ACTIVATE WINDOW oWnd ;
      ON CLICK MsgInfo( GetClassName( ImgTemplate( "GoRight" ) ) )

return nil