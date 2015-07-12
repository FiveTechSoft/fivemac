// Testing the CoverFlow

#include "FiveMac.ch"
			 
//----------------------------------------------------------------------------//

function Main()

   local oWnd, oCover, oBtn
   
   DEFINE WINDOW oWnd TITLE "Test CoverFlow" ;
       FROM 200, 250 TO 750, 1100
   
   DEFINE MSGBAR OF oWnd
   
   @ 64, 0 COVERFLOW oCover OF oWnd SIZE 850, 525
   
   oCover:OpenDir( "/Library/Desktop Pictures/Nature/" )    
    	
   @ 20,10 BUTTON oBtn PROMPT "+" SIZE 45, 45 OF oWnd ACTION oCover:OPENPANEL() 
	    	  		      		      
	 @  0, 10 SAY "Double click an image to preview it" OF oWnd SIZE 350, 20 RAISED

   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Want to end ?" )

return nil

//----------------------------------------------------------------------------//
