#include "FiveMac.ch"

function Main()

   local oWnd
      
   DEFINE WINDOW oWnd TITLE "TRANPARENT WINDOW" ;
      FROM 20, 300 TO 400,200                
                 
   oWnd:Center() 
                 
   @ 90, 40 BUTTON "Set Trans" OF oWnd ACTION SetTrans( oWnd:hWnd,0.60 ) 
                 
   @ 50, 40 BUTTON "Refill" OF oWnd ACTION SetTrans( oWnd:hWnd,100 )
                 
   @ 10, 40 BUTTON "Exit" OF oWnd ACTION oWnd:End
                      
   ACTIVATE WINDOW oWnd 
     
return nil




