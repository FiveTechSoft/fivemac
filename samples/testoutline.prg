#include "FiveMac.ch"

function Main()

   local oWnd, out
   local oNode
   local onode1,onode2,onode3,onode4
   local ldisclo:= .t.
   local lpijama := .f.
   local lhead := .t.
   
    MSGBADGE("New")
   
   DEFINE WINDOW oWnd TITLE "DBF Browse" ;
      FROM 213, 109 TO 650, 820
   
     
   DEFINE ROOTNODE oNode
   
       DEFINE NODE oNode1 PROMPT "Casa" OF oNode  GROUP
       DEFINE NODE oNode2 PROMPT "Coche" OF oNode GROUP
       
       DEFINE NODE oNode3 PROMPT "cocina" OF oNode1 
       DEFINE NODE oNode4 PROMPT "rueda"  OF oNode2 
       
       
   
   ACTIVATE ROOTNODE oNode  
    
          
   @ 48,20 OUTLINE out SIZE 672 , 363 OF oWnd ;
   NODE oNode
   
   out:setTitle("Desplegable")
   
   @ 8, 20 BUTTON "Disclosure" OF oWnd ;
  ACTION ( ldisclo:=!ldisclo ,  out:setDisclo(ldisclo) ,out:refresh() )
  
  @ 8, 120 BUTTON "Pijama" OF oWnd ;
  ACTION ( lpijama:=!lpijama , out:Setpijama(lpijama) ,out:refresh() )  
  
   @ 8, 220 BUTTON "show/hide Title" OF oWnd ;
  ACTION ( lhead:=!lhead ,out:ShowHead(lhead)  )    
 ACTIVATE WINDOW oWnd

return nil


