#include "FiveMac.ch"

function Main()

  local oWnd, cTest := "Hello world!"
  local cInfo:=space(50)
  local oNotifi 
  
   DEFINE WINDOW oWnd TITLE "TestGet" FROM 300, 300 TO 500, 700

     oNotifi := TNotification():new(oWnd) 
              
   @ 150, 40 SAY "Titulo:" OF oWnd
   
   @ 150, 90 GET cTest OF oWnd

   @ 100, 40 SAY "Informacion:" OF oWnd

   @ 100, 140 GET cInfo OF oWnd


    @30,  50 BUTTON "asigna" OF oWnd ACTION  ( oNotifi:setTitle(cTest) , oNotifi:setInfo(cInfo))
    @30, 150 BUTTON "Notificacion" OF oWnd ACTION oNotifi:display()
  //  @30, 250 BUTTON "delete" OF oWnd ACTION  ( iif(oNotifi:isPresented(), msginfo("si"),msginfo("no") ) ,  oNotifi:delete() )
   @30, 250 BUTTON "Interval" OF oWnd ACTION  ( oNotifi:shedule(5) )  

ACTIVATE WINDOW oWnd 
         
return nil     