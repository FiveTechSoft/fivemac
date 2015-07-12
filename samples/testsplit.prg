//
//  testsplit.prg
//  fivemac
//
//  Created by Manuel Sanchez on 14/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#include "FiveMac.ch"
    

//----------------------------------------------------------------------------/

function Main()

   local oWnd, oSay
   local obtn2,obtn3,obtn1
   local osplit
  // local vista1,vista2,vista3
  
     
   
   DEFINE WINDOW oWnd TITLE "TestSplit" ;
       FROM 10, 10 TO 700, 700
	   
   DEFINE MSGBAR OF oWnd
   
   
   @ 64, 0 SPLITTER oSplit OF oWnd SIZE  690, 629
   
   oSplit:addView()
   oSplit:addView()	
   oSplit:addView()
   
                            	     
 //  vista1:= oSplit:GetView(1)
 //  vista2:= oSplit:GetView(2)             
 //  vista3:= oSplit:GetView(3)  
   
        	    
    @ 20,10 BUTTON obtn1 PROMPT "Vista1" SIZE 245, 45 OF (oSplit:aViews[1]) ACTION msginfo("vista1")
   	@ 20,10 BUTTON obtn2 PROMPT "Vista2" SIZE 245, 45 OF oSplit:aViews[2] ACTION msginfo("vista2")													  
	@ 20,10 BUTTON obtn3 PROMPT "Vista3" SIZE 245, 45 OF oSplit:aViews[3] ACTION msginfo("vista3")																														        		      
    
    @ 0, 10 SAY "Ejemplo de Splitters" OF oWnd SIZE 350, 20 RAISED

   ACTIVATE WINDOW oWnd ;
           VALID MsgYesNo( "Want to end ?" )

return nil

//----------------------------------------------------------------------------//
