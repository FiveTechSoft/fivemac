#include "FiveMac.ch"


function Main()

   local oDlg
   
   DEFINE DIALOG oDlg TITLE "Dialog"
   
   @ 40, 40 BUTTON "print" OF oDlg ACTION imprime()
   
   DEFINE MSGBAR OF oDlg
   
   ACTIVATE DIALOG oDlg
   
return nil   


Function Imprime()
local oPrn:=TPrinter():new(0,0,50,50)
local oGroup,osay,oImg
 
    oprn:SetLeftMargin(10)
    oprn:SetRightMargin(10)
 
    @ 50, 50 SAY "A FiveMac Say " OF oPrn SIZE 150, 20 RAISED 
    
    @ 64 ,0  LINE HORIZONTAL SIZE 500 OF oPrn
 
    @ 80, 0 SAY osay PROMPT "Como Vamos" OF oPrn SIZE 450, 180
    
     osay:Setfont("Arial",30 ) 
     osay:setTextColor(0,255,0,100)  
 
       
    @ 100, 139 IMAGE oImg OF oPrn SIZE 107, 91 FILENAME "./../bitmaps/fivetech.gif"
           
               
     oprn:say( 1350, 50,"hola","Arial",20, 200, 20 )
  
     oprn:setPaperName("A4")
   
   //  msginfo( oprn:pageWidth()  )
   //  msginfo(oprn:pageHeight())
     
     oprn:setSize( oprn:pageWidth()- 20 , ( oprn:pageHeight()-180) *3 )
   
 oPrn:run()
   
//local hView:= PRNVIEWCREATE(0,0,1500,300)
//local hsay := PrnSay( 50, 50, 200, 20, hView, "Hola" )
//local hsay2 := PrnSay( 250, 50, 200, 20, hView, "Hola como estas" )


//  PRNINFOAUTOPAGE(hpi)
// PRNJOBRUN(hJob)
 
Return nil


function PrinterPaint()
/*
   DrawText( 50, 150, "Printing from FiveMac1", CreateFont( "Arial", 20 ), CLRBLUE() )
   DrawText( 50, 200, "Printing from FiveMac2", CreateFont( "Verdana", 20 ), CLRGREEN() )
   DrawText( 50, 250, "Printing from FiveMac3", CreateFont( "Times Roman", 20 ), CLRRED() )
   
    DrawText( 50, 289, "Printing from FiveMac4", CreateFont( "Times Roman", 20 ), CLRRED() )   
   */
return nil 
 