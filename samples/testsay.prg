// Building our first window

#include "FiveMac.ch"


#define CLR_BLACK             0             
#define CLR_BLUE        8388608   
          
//----------------------------------------------------------------------------//

function Main()

   local oWnd, oSay,oSay2, osay3
   
   DEFINE WINDOW oWnd TITLE "Tutor02" ;
       FROM 200, 250 TO 550, 750

   DEFINE MSGBAR OF oWnd

   @ 0, 10 SAY "A FiveMac MsgBar" OF oWnd SIZE 150, 20 RAISED
   
   @ 70,10 SAY osay PROMPT "A FiveMac MsgBar" OF oWnd SIZE 150, 20    
   osay:setTextColor(0,255,0,100)
   
      @ 140,10 SAY osay2 PROMPT "A FiveMac MsgBar" OF oWnd SIZE 150, 20    
      
    osay2:setBkColor(0,0,128,100)
        
    osay2:setBezeled(.t.,.f.)   
   
   
    @ 200,10 SAY osay3 PROMPT "A FiveMac MsgBar" OF oWnd SIZE 150, 20    
      
    osay3:setColor(CLR_BLUE ,CLR_BLACK )
    osay3:setBezeled(.t.,.t.)  
    osay3:SetSizeFont(14) 
    osay3:setAlign(1)
       
                
      ACTIVATE WINDOW oWnd ;
        ON CLICK MsgInfo( "click" ) ;
      VALID MsgYesNo( "Want to end ?" )

return nil


//----------------------------------------------------------------------------//
