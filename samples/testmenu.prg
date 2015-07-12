#include "FiveMac.ch"

static oWnd

//----------------------------------------------------------------------------//

function Main()
 
   BuildMenu()
 
   DEFINE WINDOW oWnd TITLE "Hello world"
 
   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Want to end ?" )
 
return nil

//----------------------------------------------------------------------------//
 
function BuildMenu()
 
   local oMenu
 
   MENU oMenu
      MENUITEM "Files"
      MENU
         MENUITEM "New..."
         MENUITEM "Open..."
         SEPARATOR
         MENUITEM "Exit..." ACTION oWnd:End()
      ENDMENU
      
      MENUITEM "Help"
      MENU
         MENUITEM "Wiki..."
         MENUITEM "About..." ACTION MsgAbout( "(C) FiveTech Software 2012", "FiveMac" )
      ENDMENU
   ENDMENU
 
return oMenu

//----------------------------------------------------------------------------//