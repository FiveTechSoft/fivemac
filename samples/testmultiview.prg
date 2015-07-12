//
//  testmultiview.prg
//  fivemac
//
//  Created by Manuel Sanchez on 12/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#include "FiveMac.ch"
    

//----------------------------------------------------------------------------/

function Main()

   local oWnd, oSay
   local obtn2,obtn3,obtn1
   local oMulti
  
     
   
   DEFINE WINDOW oWnd TITLE "TestMultiview" ;
       FROM 10, 10 TO 700, 700
	   
   DEFINE MSGBAR OF oWnd
   
   DEFINE MULTIVIEW oMulti OF oWnd RESIZED
  
   @ 0,0 MVIEW PROMPT "Vista 1" SIZE 80, 80 TITLE "Vista 1™" OF oMulti ;
         TOOLTIP "vista 1" IMAGE "vista1"  
   
   @ 0,0 MVIEW PROMPT "Vista 2" SIZE 400, 400 TITLE "Vista 2™" OF oMulti ;
          TOOLTIP "vista 2" IMAGE "vista2"   
         
   @ 0,0 MVIEW PROMPT "Vista 3" SIZE 400, 400 TITLE "Vista 3™" OF oMulti ;
          TOOLTIP "vista 3" IMAGE "vista3"         
		  
 
	/* 	   
  oMulti:AddView(  0, 0, 80, 80, "Vista 1", "vista1" )
  oMulti:AddView(  0, 0, 400, 400, "Vista 2", "vista2" )
  oMulti:AddView(  0, 0, 900, 900, "Vista 3", "vista3" )
    
  */  
        	    
 																					
    
  //  oMulti:SetView(1)                                              						        		      
    
    @ 0, 10 SAY "Ejemplo de Splitters" OF oWnd SIZE 350, 20 RAISED

   ACTIVATE WINDOW oWnd ;
           VALID MsgYesNo( "Want to end ?" )

return nil

//----------------------------------------------------------------------------//
