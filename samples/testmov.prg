// Playing movies!

#include "FiveMac.ch"

//----------------------------------------------------------------------------//

function Main()

   local oWnd, oSay, oMovie
   
   DEFINE WINDOW oWnd TITLE "Playing movies" ;
       FROM 200, 250 TO 750, 1100

   DEFINE MSGBAR OF oWnd
   
   @ 70,  20 MOVIE oMovie SIZE 800, 450 OF oWnd AUTORESIZE 18
   
   oMovie:ControlStyle( 2 )
 
   @ 30,  20 BUTTON "Select movie" SIZE 100, 40 OF oWnd ACTION  oMovie:DlgOpen() 
  
  @ 30, 120 BUTTON "play" SIZE 200, 40 OF oWnd ;
      ACTION oMovie:play()
      
   @ 30, 250 BUTTON "Edit" SIZE 100, 40 OF oWnd ;
      ACTION oMovie:edit()


  // @ 30, 120 BUTTON "Switch to control mode" SIZE 200, 40 OF oWnd ;
  //    ACTION oMovie:SetControlVisible( ! oMovie:GetControlvisible() )

   @  0,  10 SAY "FiveMac power!" OF oWnd SIZE 150, 20 RAISED

   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Want to end ?" )

return nil

//----------------------------------------------------------------------------//