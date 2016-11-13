//
//  testBtn.prg
//  fivemac
//
//  Created by Manuel Sanchez on 16/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#include "FiveMac.ch"

function Main()

   local oWnd
   local obtn1,obtn2
   local oGroup,osay
   local Cfirst:= "Hola"
   local lvista:= .f.
   local nHeight:= 100
   local nWidth:= 40

 DEFINE WINDOW oWnd TITLE "Testing coordinates" ;
      FROM 50, 50 TO 200, 400

 @ 30, 40 BUTTON "Dialog" OF oWnd ACTION msginfo( GETSERIALNUMBER() )  //oWnd:Iconize()


  @ 80, 20 BUTTON obtn1 PROMPT "Disclusure" OF oWnd ACTION MsgInfo ("no");
        SIZE 140,40 TOOLTIP "Boton de Disclosure" AUTORESIZE AnclaTop

  @ 70, 35 GROUP oGroup PROMPT "Test" SIZE 320, 120 OF oWnd

  @ 60, 14 SAY osay PROMPT "First:" OF oGroup SIZE 50, 17 TOOLTIP "say Primero"


   oBtn1:setDisclosure()

   oBtn1:baction:= {|| ( lvista:= !lvista ,;
 if (lvista, ( oWnd:ChangeSize(nHeight, nWidth ), oGroup:show()),;
             ( oGroup:hide(),oWnd:ChangeSize(-nHeight, -nWidth )  ) ) ) }



   oGroup:hide()

   ACTIVATE WINDOW oWnd ;
       VALID MsgYesNo( "Want to end ?" )

return nil
