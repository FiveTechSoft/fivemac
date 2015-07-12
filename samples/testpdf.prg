//
//  testpdf.prg
//  makelibs
//
//  Created by Manuel Sanchez on 08/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#include "FiveMac.ch"

function Main()

   local oWnd, oTbr, oWeb
   local opdf
   local cImgPath := UserPath() + "/fivemac/bitmaps/"

  
   DEFINE WINDOW oWnd TITLE "WebView Test" TEXTURED
	  	 
	 oWnd:Maximize() 	 
	  	 
 DEFINE TOOLBAR oTbr OF oWnd 	 
	 
	 DEFINE BUTTON OF oTbr ;
	    PROMPT "Back" ;
	    TOOLTIP "Go back" ;
	    IMAGE cImgPath+"/left.png" ;
ACTION oPDF:goTop()
	    
	 DEFINE BUTTON OF oTbr ;
	    PROMPT "Forward" ;
	    TOOLTIP "Go forward" ;
	    IMAGE cImgPath+"right.png" ;
ACTION opdf:GoBottom()   
	    

  
DEFINE BUTTON OF oTbr PROMPT "Zoom In" ;
TOOLTIP "Zoom in" ;
IMAGE cImgPath+"/ZoomIn.tif" ;
ACTION oPdf:zoomin()

DEFINE BUTTON OF oTbr PROMPT "Zoom Out" ;
TOOLTIP "Zoom out" ;
IMAGE cImgPath+"/ZoomOut.tif" ;
ACTION oPdf:zoomOut() 
  
	 DEFINE BUTTON OF oTbr ;
	    PROMPT "Previous" ;
	    TOOLTIP "Go Previous" ;
	    IMAGE cImgPath+"_left.png" ;
        ACTION oPDF:GoPrevious()
	    
	 DEFINE BUTTON OF oTbr ;
	    PROMPT "Next" ;
	    TOOLTIP "Go Next" ;
	    IMAGE cImgPath+"_right.png" ;
        ACTION opdf:GoNext()  
 
 //   DEFINE BUTTON OF oTbr ;
 //    PROMPT "Otro" ;
 //    TOOLTIP "llama otra ventana" ;
 //    IMAGE cImgPath+"folder.png" ;
 //    ACTION otra() 

	 DEFINE BUTTON OF oTbr ;
	    PROMPT "End" ;
	    TOOLTIP "Exit from the application" ;
	    IMAGE cImgPath+"Exit.png" ;
	    ACTION oWnd:End() 
          
     @ 20, 20 PDFVIEW oPdf OF oWnd ;
         SIZE oWnd:nWidth - 40, oWnd:nHeight - 100 ;
         FILE UserPath() + "/fivemac/samples/OSXHIGuidelines.pdf" ;
         AUTOSCALE                                                     
          
                     
   ACTIVATE WINDOW oWnd


return nil   



//----------------------------------------------------------------------------//

function Otra()

local oWnd 
local oBtn,obtn2,obtn3
local oPdf
local oTbr
local path := UserPath() + "/fivemac/bitmaps/"
  
DEFINE WINDOW oWnd RESOURCE "testpdf"

 REDEFINE TOOLBAR oTbr OF oWnd 
 
 REDEFINE TBUTTON OF oTbr ;
	    PROMPT "Previous" ;
	    TOOLTIP "Go Previous" ;
	    IMAGE path+"_left.png" ;
        ACTION oPDF:GoPrevious()
	    
 REDEFINE TBUTTON OF oTbr ;
	    PROMPT "Next" ;
	    TOOLTIP "Go Next" ;
	    IMAGE path + "_right.png" ;
        ACTION opdf:GoNext()  

REDEFINE TBUTTON OF oTbr PROMPT "Zoom In" ;
TOOLTIP "Zoom in" ;
IMAGE path+"/ZoomIn.tif" ;
ACTION oPdf:zoomin()

REDEFINE TBUTTON OF oTbr PROMPT "Zoom Out" ;
TOOLTIP "Zoom out" ;
IMAGE path+"/ZoomOut.tif" ;
ACTION oPdf:zoomOut() 

REDEFINE BUTTON oBtn ID 10 OF oWnd ACTION oWnd:end()

REDEFINE PDFVIEW oPdf ID 12 FILE UserPath() + "/fivemac/samples/OSXHIGuidelines.pdf"  OF oWnd


ACTIVATE WINDOW oWnd ;
ON CLICK oWnd:SetText( Time() )

return nil   



