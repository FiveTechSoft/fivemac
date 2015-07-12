#include "FiveMac.ch"

function Main()

  local oWnd, cTest := "Hello world!"
  local cInfo:=space(50)

   DEFINE WINDOW oWnd TITLE "TestGet" FROM 300, 300 TO 500, 700
   
   MSGBADGE("new")
      
   @ 150, 40 SAY "Titulo:" OF oWnd
   
   @ 150, 90 GET cTest OF oWnd

   @ 100, 40 SAY "Informacion:" OF oWnd

   @ 100, 140 GET cInfo OF oWnd



   @30,  50 BUTTON "Badge" OF oWnd ACTION  MSGBADGE(alltrim(cTest))
   @30, 150 BUTTON "Notificacion" OF oWnd ACTION  DELIVERNOTIFICATION( cTest , cInfo )

ACTIVATE WINDOW oWnd
         
return nil     