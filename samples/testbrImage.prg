//
//  testBrImage
//  fivemac
//
//  Created by Manuel Sanchez on 14/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//




#include "FiveMac.ch"


#xcommand @ <nRow>, <nCol> BRIMAGE [ <oImage> ] ;
            [ OF <oWnd> ] ;
		        [ SIZE <nWidth>, <nHeight> ] ;
		      => ;
		         [ <oImage> := ] TBrimage():New( <nRow>, <nCol>, <nWidth>, <nHeight>, <oWnd> )
				 
				 
			 

# define  IKCellsStyleNone       0
# define  IKCellsStyleShadowed   1
# define  IKCellsStyleOutlined   2
# define  IKCellsStyleTitled     4
# define  IKCellsStyleSubtitled  8

//----------------------------------------------------------------------------//

function Main()

   local oWnd, oSay
   local oBrImage
   local path := "./../bitmaps"
   local oSlide
   local npos, obtn2,obtn1,obtn3
   local oget,cText:=""
   
   
   DEFINE WINDOW oWnd TITLE "TestBrImage" ;
       FROM 200, 250 TO 750, 1100

  
   DEFINE MSGBAR OF oWnd SIZE 42
   
   @ 42,0 BRIMAGE oBrImage OF oWnd SIZE 850 , 509
   
  //  oBrImage:openDir("/Library/Desktop Pictures/Nature/")
  //  oBrImage:openDir("/Library/Desktop Pictures/")
  
    oBrImage:SetStyle(nor(IKCellsStyleTitled,IKCellsStyleShadowed, IKCellsStyleOutlined))	
    
	oBrImage:animate(.t.)
    
    
      @ 7, 10  BUTTON oBtn2 PROMPT "+" OF oWnd  ; 
         ACTION oBrImage:openPanel() SIZE 45, 26 STYLE 2
         
              
      @ -5, 760  BUTTON oBtn3 OF oWnd FILENAME path+"/PlayOff.tif" ; 
         ACTION oBrImage:RunSlide() SIZE 45, 45 STYLE 7
         
            
   	  @ 10,100 GET oget VAR cText OF oWnd SIZE 200, 24 SEARCH
		
      oget:bchanged:={ || IKIMGBROFILTER(oBrImage:hwnd,oGet:hwnd)	}
       
			  
	  oSlide:=TSlider():New( 5, 500, 200, 30,oWnd)
	  SLIDERMINMAXVALUE(oSlide:hWnd,37, 100) 	
      SLIDERMINMAXVALUE(oSlide:hWnd,0, 100) 	

     oSlide:bChange := {|| npos:= GetSliderValue(oSlide:hWnd), oBrimage:sETZOOM(npos)}  
     
	  
      ACTIVATE WINDOW oWnd ;
           VALID MsgYesNo( "Want to end ?" )

return nil

//----------------------------------------------------------------------------//