#include "FiveMac.ch"

function Main()

   local oDlg, cFirst := Space( 20 ), cLast := Space( 20 )
   local oGroup
   local otab
   local otab1,otab2 
   local i:= 1
   


   DEFINE DIALOG oDlg TITLE "Testing Groups" ;
      FROM 270, 350 TO 500, 740
      

  @ 70, 30 GROUP oGroup PROMPT "Test" SIZE 320, 120 OF oDlg

   oGroup:setCustom()
   
   oGroup:setBorderType(1)
   oGroup:setBorderColor(0,255,0,100)
   oGroup:setFillColor(0,0,0,50)
   
   



   @ 60, 14 SAY "First:" OF oGroup SIZE 50, 17
      
   @ 60, 70 GET cFirst OF oGroup SIZE 208, 22 ;
   VALID If( Empty( cFirst ), ( MsgInfo( "Please type something" ), .f. ), .t. )
   
    
   @  98, 50 SAY "Last:" OF oDlg SIZE 50, 17
   
   @  96, 108 GET cLast OF oDlg SIZE 208, 22

   @ 22, 83 BUTTON "style" OF oDlg ACTION ( if( i > 4, i := 1 ,i++ ), if(i=2, i++,), oGroup:setStyle(i),oDlg:refresh() )
   
   @ 22, 218 BUTTON "Cancel" OF oDlg ACTION oDlg:End()
   
  @ 60 ,10  LINE HORIZONTAL SIZE 372 OF oDlg
       
   ACTIVATE DIALOG oDlg CENTERED
   
   

return nil   
 