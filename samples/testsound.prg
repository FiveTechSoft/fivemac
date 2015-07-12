//
//  testBtn.prg
//  fivemac
//
//  Created by Manuel Sanchez on 16/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#include "FiveMac.ch"

function Main()
myMain()

Return nil

Function myMain()
   local oWnd
   local obtn1,obtn2
   local osound //:=Tsound():New() 
   local oSlider 
   
 DEFINE SOUND oSound 
   
 DEFINE WINDOW oWnd TITLE "Testing coordinates" ;
      FROM 50, 50 TO 200, 400

         
   @ 70, 40 BUTTON "play" OF oWnd ACTION   oSound:play()
     
   @ 70, 140 BUTTON "pause" OF oWnd ACTION oSound:pause()      
   @ 70, 240 BUTTON "Stop" OF oWnd ACTION oSound:Stop() 
  
  
   oSlider:=TSlider():New( 20, 20, 310, 30,oWnd)
   oSlider:SetValue(oSound:GetVolumen())
   oSlider:bChange := {||oSound:Volumen(oSlider:GetValue())}  
     
                  
   ACTIVATE WINDOW oWnd 
   
     
   
return nil   
