#include "FiveMac.ch"


 
function Main()

   local oWnd,oSlide,oSlide2,oSlide3,oSlide4
   local oProg,oProg2,oProg3,oProg4,nPos := 0
   local oBtn1,obtn2
   
   
   DEFINE WINDOW oWnd TITLE "TEST SLIDER" ;
                 FROM 20, 100 TO 440,600 
       
     oWnd:Center()   
   
    @ 320 , 20 PROGRESS oProg SIZE 460, 20 OF oWnd POSITION 0
    oProg:nAutoResize :=10
                                 
    @ 340 , 20 SLIDER oSlide SIZE 460,20 OF oWnd
    oSlide:nAutoResize :=10
    oSlide:bChange := {||oProg:Update(nPos:=oSlide:GetValue())}  
     
     
     @ 240 , 20 PROGRESS oProg2 SIZE 460, 20 OF oWnd POSITION 0
     oProg2:nAutoResize :=10
                
     @ 260 , 200 SLIDER oSlide2 SIZE 100,40 OF oWnd
     oSlide2:nAutoResize :=10
     oSlide2:SetCircular()
     oSlide2:bChange := {||oProg2:Update(nPos:=oSlide2:GetValue())} 
     

     @ 150 , 20 PROGRESS oProg3 SIZE 460, 20 OF oWnd POSITION 0
     oProg3:nAutoResize :=10
        
     @ 180,  20 SLIDER oSlide3 SIZE 460,20 OF oWND
     oSlide3:nAutoResize :=10
     oSlide3:SetTickMarks(30)
     oSlide3:bChange := {||oProg3:Update(nPos:=oSlide3:GetValue())} 
     
     
     @ 70 , 20 PROGRESS oProg4 SIZE 460, 20 OF oWnd POSITION 0     
     oProg4:nAutoResize :=10
        
     @ 90 , 200 SLIDER oSlide4 SIZE 100,40 OF oWND
     oSlide4:nAutoResize :=10
     oSlide4:SetTickMarks(10)
     oSlide4:SetCircular()
     oSlide4:bChange := {||oProg4:Update(nPos:=oSlide4:GetValue())} 
     
     
       DEFINE MSGBAR OF oWnd SIZE 40
       
       @ 2, 400 BUTTON obtn1 PROMPT "Salir" OF oWnd ACTION oWnd:end()
        oBtn1:nAutoResize := 33
        
     //  @ 2, 20 BUTTON obtn2 PROMPT "Otro" OF oWnd ACTION otro()
     //   oBtn1:nAutoResize := 33
     
   ACTIVATE WINDOW oWnd
  
     
return nil


Function Otro()
local ownd ,oPrg, oslider,obtn
local nPos

DEFINE WINDOW oWnd RESOURCE "testslid"

REDEFINE PROGRESS oPrg ID 40 OF oWnd POSITION 10
 

REDEFINE SLIDER oSlider VALUE 10 ID 30 OF oWnd 
oSlider:bChange := {||oPrg:Update(nPos:=oSlider:GetValue())}  
       
           
REDEFINE BUTTON oBtn ID 10 OF oWnd ACTION oWnd:end()

ACTIVATE WINDOW oWnd 

Return nil




