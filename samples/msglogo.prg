// MsgLogo() example by Dino Alessandri

#include "FiveMac.ch"

function Main()

   MsgLogo( "../bitmaps/test.png", 3.0 )

return nil

function MsgLogo( cBmp, nSeconds )

   local oWnd,oImg 
   
   DEFINE WINDOW oWnd FROM 20, 300 TO 600,400 NOBORDER
 
   oWnd:Center() 
   oWnd:SetSplash()
                 
   @ 100, 10 IMAGE oImg OF oWnd SIZE 400,500 FILENAME cBmp  
                 
   @ 40, 40 BUTTON "Premi" OF oWnd ACTION oWnd:End() // don't END
                 
   ACTIVATE WINDOW oWnd 
     
return nil
