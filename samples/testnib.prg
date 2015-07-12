// Once you build this example, create this folder:
// fivemac/samples/testnib.app/Contents/Resources/Engligh.lproj
// and copy the folder HudWindow.nib into it

#include "FiveMac.ch"

function Main()

   local oWnd,obtn

   DEFINE WINDOW oWnd 

 //  REDEFINE BUTTON obtn ID 10 OF oWnd ACTION primer()
@ 20, 20 BUTTON "Another" ACTION primer()

   ACTIVATE WINDOW oWnd

return nil

//----------------------------------------------------------------------------//

function Another()

   local oWnd 
   local oGet, cText := "Hello world", oBtn
   local oChk, lTest := .T.
   local oCbx, cVar  := "One"
   
   DEFINE WINDOW oWnd RESOURCE "HuidView"
   
   REDEFINE GET oGet VAR cText ID 10 OF oWnd
   
   REDEFINE CHECKBOX oChk VAR lTest ID 20 OF oWnd ON CHANGE MsgBeep()
   
   REDEFINE COMBOBOX oCbx ID 30 OF oWnd ITEMS { "One", "Two", "Three" } ;
      ON CHANGE MsgBeep()
   
   REDEFINE BUTTON oBtn ID 40 OF oWnd ACTION MsgInfo( cText )
   
   ACTIVATE WINDOW oWnd ;
      ON CLICK oWnd:SetText( Time() )
   
return nil  


//----------------------------------------------------------------------------//

function primer()

local oWnd 
local oGet, cText := "Hello world", oBtn
local oChk, lTest := .T.
local oCbx, cVar  := "One"
local oSlide3,oseg ,Obrw
local oNode ,out
local ldisclo:= .f.
 local onode1,onode2,onode3,onode4
local osay 
 
DEFINE WINDOW oWnd RESOURCE "hola"

REDEFINE BUTTON oBtn ID 10 OF oWnd ACTION oWnd:end()

   
    REDEFINE SLIDER oSlide3 ID 22 VALUE 100 OF oWnd 


    oSlide3:bChange := {||   msginfo(str(oSlide3:GetValue())) } 

    REDEFINE SEGMENTBTN oSeg  ID 18 OF oWnd
    oseg:bAction :=   {|ele| msginfo("Boton"+str(ele)) } 

    REDEFINE CHECKBOX oChk VAR lTest  ID 16 ;
    OF oWnd ;
    ON CHANGE (ldisclo:= !ldisclo, Out:Setdisclo(ldisclo),out:refresh() )

    
    DEFINE ROOTNODE oNode
   
       DEFINE NODE oNode1 PROMPT "Casa" OF oNode  GROUP
       DEFINE NODE oNode2 PROMPT "Coche" OF oNode GROUP
       
       DEFINE NODE oNode3 PROMPT "cocina" OF oNode1 
       DEFINE NODE oNode4 PROMPT "rueda"  OF oNode2 
   
   ACTIVATE ROOTNODE oNode  
    
   REDEFINE OUTLINE Out ID 77 OF oWnd ;
   NODE oNode ;
    
   out:bAction:=  {||  msginfo(out:GetSelectName()) }

   USE ./Test

   REDEFINE BROWSE oBrw ID 44 ;
   FIELDS If( Int( RecNo() % 2 ) == 0, "./../bitmaps/ok.png", "./../bitmaps/alert.png" ), Test->Last, Test->First ;
   HEADERS "Image", "Last", "First" ;
    OF oWnd ALIAS Alias()


 //oBrw:SetColBmp( 1 ) // Column 3 will display images

oBrw:bHeadClick:= { | obj , nindex| if(nindex== 1, msginfo("clickada cabecera"+str(nindex)),)  } 

oBrw:bChange := { | obj , nindex|   msginfo("cambio a reg:"+str(obj:nRowPos()) ) } 

REDEFINE SAY osay  ID 19  OF oWnd  

REDEFINE GET oGet VAR cText ID 29 OF oWnd  

oGEt:bChanged := { | ele | osay:SetText(ele:GetText() ),.t.  }


ACTIVATE WINDOW oWnd ;
ON CLICK oWnd:SetText( Time() )

return nil   