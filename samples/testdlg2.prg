#include "FiveMac.ch"

static oDlg

//----------------------------------------------------------------------------//

function Main()

   local cFirst := Space( 20 ), cLast := Space( 20 )
   local obtn1, oPopup
   
   DEFINE DIALOG oDlg TITLE "Testing Gets" ;
      FROM 220, 350 TO 450, 750 

   @ 139, 50 SAY "First:" OF oDlg SIZE 50, 17

   @ 137, 108 GET cFirst OF oDlg SIZE 208, 22 ;
      VALID If( Empty( cFirst ), ( MsgInfo( "Please type something" ), .f. ), .t. )

   @  98, 50 SAY "Last:" OF oDlg SIZE 50, 17

   @  96, 108 GET cLast OF oDlg SIZE 208, 22

   @ 34, 83 BUTTON obtn1 PROMPT "OK" OF oDlg ACTION oDlg:End()

   @ 34, 218 BUTTON "Cancel" OF oDlg ACTION oDlg:End()
   
   oPopup = BuildMenu()  

   ACTIVATE DIALOG oDlg CENTERED ;
      ON RIGHT CLICK ShowPopup( oPopup, nRow, nCol )

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu
   
   MENU oMenu POPUP
      MENUITEM "About" ACTION MsgInfo( "FiveMac sample" )
      MENUITEM "Exit"  ACTION oDlg:End() ACCELERATOR "e"
      MENUITEM "Help"  ACTION MsgInfo( "Help" )
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

function ShowPopup( oPopup, nRow, nCol )

    ACTIVATE POPUP oPopup OF oDlg AT nRow, nCol

return nil 

//----------------------------------------------------------------------------//