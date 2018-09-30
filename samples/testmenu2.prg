
#include "FiveMac.ch"

static oWnd

static oMenu1, omenu2

//----------------------------------------------------------------------------//

function Main()

  omenu1:=BuildMenu()
  oMenu2:= BuildMenuDlg()

  oMenu1:activate()

   DEFINE WINDOW oWnd TITLE "Hello world"

oWnd:bGetFocus:= { ||  omenu1:activate()    }

   ACTIVATE WINDOW oWnd ;
       VALID MsgYesNo( "Want to end ?" )
 
return nil

//----------------------------------------------------------------------------//
 
function BuildMenu()

   MENU oMenu1
      MENUITEM "Files"      && in menu this gives 'testmenu'
      MENU
         MENUITEM "New..."
         MENUITEM "Open..." ACTION New_Window()
         SEPARATOR
         MENUITEM "Exit..." ACTION oWnd:End()
      ENDMENU
      
      MENUITEM "Help"
      MENU
         MENUITEM "Wiki..."
         MENUITEM "About..." ACTION MsgAbout( "(C) FiveTech Software 2012", "FiveMac" )
      ENDMENU
   ENDMENU
 
return oMenu1

//----------------------------------------------------------------------------//

function New_Window()

local oDlg, oMenuDlg

DEFINE DIALOG oDlg

omenu2:activate()
  //  BuildMenuDlg()
oDlg:bGetFocus:= { ||  omenu2:activate()    }

ACTIVATE DIALOG oDlg



return nil

//----------------------------------------------------------------------------//

function BuildMenuDlg()



    MENU oMenu2
        MENUITEM 'Dialog'
        MENU
            MENUITEM "help" ACTION MsgAbout( "Do we see this", "Test" )
        ENDMENU
        MENUITEM 'Test me'
        MENU
            MENUITEM "Click on me!" ACTION MsgInfo('show me')
        ENDMENU
    ENDMENU
    
return oMenu2
