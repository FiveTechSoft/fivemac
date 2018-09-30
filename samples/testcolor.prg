#include "FiveMac.ch"


 
function Main()

   local oWnd
   local nrgb
   local oBtn1,obtn2

   local hcolor, hcolor2

  local oClr

  nrgb:= nRgb( 100, 200, 110 )


  ? nrgb

  hcolor :=  COLORFROMNRGB( nrgb )
  hcolor2 := COLORFROMNRGB2( 100,200,  110 )

 ? GETCOLORRGB( hcolor )

 ? GETCOLORRGB( hcolor2 )

  ? GETBLUENSCOLOR( hcolor )
 ? GETBLUENSCOLOR2( hcolor )
   
   DEFINE WINDOW oWnd TITLE "TEST color" ;
                 FROM 20, 100 TO 440,600 
       
     oWnd:Center()   

  @ 100, 60 COLORWELL oClr SIZE 100, 30 OF ownd ;
   ON CHANGE oClr:GetColor()

     oClr:setColor( nrgb )



@ 2, 200 BUTTON obtn1 PROMPT "ok" OF oWnd ACTION msginfo( oclr:getColor() )



       @ 2, 400 BUTTON obtn1 PROMPT "Salir" OF oWnd ACTION oWnd:end()

        

     
   ACTIVATE WINDOW oWnd
  
     
return nil

function btnclick()
local a:= oclr:getColor()
   msginfo( a )
oclr:setcolor( a )
oclr:refresh()

return nil




