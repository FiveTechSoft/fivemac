#include "FiveMac.ch"

static oWnd

function Main()

   BuildMenu() // Build the main menu
   
   DEFINE WINDOW oWnd TITLE "FiveMac"
   
   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Want to end ?" )
   
return nil   


function BuildMenu()

   local oMenu
   
   MENU oMenu
      MENUITEM "TestMnu"
      MENU
         MENUITEM "About" ACTION MsgInfo( "FiveMac sample" )
      ENDMENU
      
      MENUITEM "First"
      MENU
         MENUITEM "New"
	 MENUITEM "Open"
	 MENUITEM "Close"
	 SEPARATOR
	 MENUITEM "Exit" ACTION oWnd:End() ACCELERATOR "e"
      ENDMENU
      
      MENUITEM "Second"
      MENU
         MENUITEM "Search"
	 MENUITEM "Replace"
      ENDMENU

      MENUITEM "Third"
      MENU
         MENUITEM "Help" ACTION MsgInfo( "Help" )
	 MENUITEM "Topic Help"
      ENDMENU
      
ENDMENU

return nil
