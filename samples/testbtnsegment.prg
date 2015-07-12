//
//  testbtnsegment.prg
//  fivemac
//
//  Created by Manuel Sanchez on 15/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#include "FiveMac.ch"

function Main()

  local oWnd, oTbr, oWeb
  local path:= APPPATH()
  local obtn3,obtn2,obtn1
  local oseg,oseg2
   local nX
  local nTipoback:= 1
  local oMEnu:=BuildMenu()
   
   DEFINE WINDOW oWnd TITLE "TestButton Segmented" TEXTURED ;
       FROM 370, 250 TO 480, 800	  	 
	  	 	    	 
                                                             
  @ 34,160 SEGMENTBTN oSeg2 OF oWnd SIZE 290,106 ;
           ACTION ( msginfo(" boton "+str(oseg2:SelectedItem ) ) ) ;
           ITEMS {"Hola", "Adios", "Quetal" }    
      
    oSeg2:SetStyle(1)  
    
    oseg2:setenabled(.f.,2)
   
    oseg2:SetImg("./../bitmaps/exit.png" ,3)
     
    oSeg2:SetMenu(oMenu,3)
     
        
    oSeg:=Tsegment():new(4,140, 290,26, oWnd,{|ele| msginfo(" boton "+str(ele) ) } )
	
    oSeg:SetCount(4)
	oSeg:SetLabel(1,"Plano")
	oSeg:SetLabel(2,"Satelite") 
	oSeg:SetLabel(3,"Hibrido") 		
	oSeg:SetLabel(4,"StreetView") 	
	
    		
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
   ACTIVATE WINDOW oWnd

return nil  


function BuildMenu()

   local oMenu
   
   MENU oMenu
      MENUITEM "TestMnu"
      MENU
         MENUITEM "About" ACTION MsgInfo( "FiveMac sample" )
      ENDMENU
      
      MENUITEM "First"
      MENU
         MENUITEM "New"
	 MENUITEM "Open"
	 MENUITEM "Close"
	 SEPARATOR
	 MENUITEM "Exit" ACTION oWnd:End() ACCELERATOR "e"
      ENDMENU
      
      MENUITEM "Second"
      MENU
         MENUITEM "Search"
	 MENUITEM "Replace"
      ENDMENU

      MENUITEM "Third"
      MENU
         MENUITEM "Help" ACTION MsgInfo( "Help" )
	 MENUITEM "Topic Help"
      ENDMENU
      
ENDMENU

return oMenu