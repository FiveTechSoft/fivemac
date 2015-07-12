#include "FiveMac.ch"
 
 function Main()

   local oWnd, oProg
   local lIndeterminate := .F.
   local lSpin := .F.
   
   DEFINE WINDOW oWnd TITLE "TEST PROGRESS" ;
      FROM 20, 100 TO 420, 640 TEXTURED FLIPPED
      
   @ 124, 10 PROGRESS oProg SIZE 510, 20 OF oWnd AUTORESIZE 9
      
   @ 40, 40 BUTTON "Indeterminate" OF oWnd ;
        ACTION ( lIndeterminate := ! lIndeterminate,;
                 oProg:SetIndeterminate( lIndeterminate ),;
                 If( lIndeterminate, oProg:startAnime(), oProg:StopAnime() ) )
   
   @ 40, 140 BUTTON "Run" OF oWnd ACTION ProgressRun( oProg, oWnd )

   @ 40, 240 BUTTON "Spin" OF oWnd ACTION ( lSpin:= ! lSpin, oProg:SetSpinStyle(lSpin ) )
  
   ACTIVATE WINDOW oWnd CENTER
     
return nil

function ProgressRun( oProg, oWnd )

   local nPos := 0, oTmr
    
   oWnd:bOnTimer = { | nTimerId, oWnd | oProg:Update( nPos += 25 ) /* If( nPos == 125, oWnd:End(), ) */ } 

   TimerCreate( 1 , oWnd:hWnd ) // 1 second 
    
return oProg