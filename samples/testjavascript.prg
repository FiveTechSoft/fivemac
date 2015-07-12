//
//  testjavascript.prg
//  makelibs
//
//  Created by Manuel Sanchez on 08/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#include "FiveMac.ch"

function Main()

local aTipos:= {"switchToTerrainMap","switchToSatelliteMap","switchToHybridMap" }

  local oWnd, oTbr, oWeb
  local path:= PATH()
  local obtn3,obtn2,obtn1
  local oseg
  local oget1 
  local cDir:= ""
  local nX
  
   DEFINE WINDOW oWnd TITLE "WebView Test"  ;
       FROM 370, 650 TO 980, 1480        
     oWnd:Maximize()    
      
                 
    @ 40, 20 WEBVIEW oWeb ;
        SIZE oWnd:nWidth - 40, oWnd:nHeight - 120 OF oWnd ;
        URL "file://"+path+"/GoogleMap.html"
        
          
    @ 4 , 20 BUTTON obtn3 PROMPT "+" OF oWnd  ACTION oWeb:ScriptCallMethod("zoomIn")  SIZE 24,24
      oBtn3:SetBezelStyle( 11 )
    
    @ 4 , 44 BUTTON obtn2 PROMPT "-" OF oWnd ACTION oWeb:ScriptCallMethod("zoomOut")  SIZE 24,24 
      oBtn2:SetBezelStyle( 11 )
   
      
    @ 4,140 SEGMENTBTN oSeg OF oWnd SIZE 290,26 ;
            ITEMS {"PLano", "Satelite", "Hibrido" }  
              
      oSeg:bAction:=  { |ele| oWeb:ScriptCallMethod(aTipos[ele] )  }
         
      nX:=oWnd:nHeight-60
      
      @ nX , 50 GET oget1 VAR  cDir OF oWnd SIZE 660, 24 AUTORESIZE nor(8,4)
      
      //  oget1:bChanged := {||Cargadir(oWeb,oget1:getText()) }
        
         
        
    @  nX-5 ,  730 BUTTON obtn1 PROMPT "Cargar " OF oWnd ACTION oWeb:ScriptCallMethodArg("showAddress",oget1:getText())
    
       oBtn1:Anclaje(nor(8,4))     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
   ACTIVATE WINDOW oWnd

return nil   

//----------------------------------------------------------------------------//

