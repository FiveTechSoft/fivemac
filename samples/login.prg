#include "FiveMac.ch"

static oWnd

//-----------------------------------------------------------------//

function Main()

   local oBar

   BuildMenu() // Build the main menu

   DEFINE WINDOW oWnd TITLE "Application login test"

   if Logon()

      DEFINE TOOLBAR oBar OF oWnd

      DEFINE BUTTON OF oBar PROMPT "New" ;
         ACTION MsgInfo( "New" ) ;
         TOOLTIP "Creates a new customer" ;
	       IMAGE ImgPath() + "new.png"
	
	   DEFINE BUTTON OF oBar PROMPT "Open" ;
	       ACTION MsgInfo( "Open" ) ;
         TOOLTIP "Open a file" ;
	       IMAGE ImgPath() + "folder.png"

      DEFINE BUTTON OF oBar PROMPT "Exit" ;
         ACTION oWnd:End() ;
         TOOLTIP "Exit from the application" ;
         IMAGE ImgPath() + "exit.png"
	
	   DEFINE MSGBAR OF oWnd

      oWnd:Maximize()

      ACTIVATE WINDOW oWnd ;
         VALID MsgYesNo( "Want to end ?" )
   else
      MsgInfo( "non authorized user" )
   endif

return nil

//-----------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM "MyAppName"     // This becomes the name of your prg
      MENU
         MENUITEM "About" ACTION MsgInfo( "Application developed with FiveMac", "Your application name" )
      ENDMENU

      MENUITEM "Inputs"
         MENU
            MENUITEM "Job Data" ACTION MsgInfo( "Job Data" )
	          MENUITEM "Employee Records" ACTION MsgAlert( "Alert" )
 	          MENUITEM "Timesheet Data"
	          SEPARATOR
	          MENUITEM "Exit" ACTION oWnd:End() ACCELERATOR "e"
         ENDMENU

      MENUITEM "Reports"
      MENU
         MENUITEM "Search"
	       MENUITEM "Replace"
      ENDMENU

      MENUITEM "Utilities"
      MENU
         MENUITEM "Help" ACTION MsgInfo( "Help" )
	      MENUITEM "Topic Help"
         SEPARATOR
         MENUITEM "Calculator" ACTION MacExec( "calculator" )
         MENUITEM "TextEdit" ACTION MacExec( "textedit" )
      ENDMENU

ENDMENU

return nil

//-----------------------------------------------------------------------//

function Logon()

   local oDlg, lSuccess := .T.
   local cLogin := Space( 80 ), cPassw := Space( 80 )

   DEFINE DIALOG oDlg TITLE "Please Logon" ;
      FROM 0, 0 TO 200, 300

   @ 130,  50 SAY "Login:" OF oDlg SIZE 80, 20

   @ 130, 100 GET cLogin OF oDlg SIZE 160, 20

   @  90,  30 SAY "Password:" OF oDlg SIZE 100, 20

   @  90, 100 GET cPassw OF oDlg SIZE 160, 20 PASSWORD

   @  20,  50 BUTTON "OK" OF oDlg ACTION oDlg:End()

	 @  20, 170 BUTTON "Cancel" OF oDlg ACTION ( lSuccess := .F., oDlg:End() )
	
   ACTIVATE DIALOG oDlg CENTERED

   if lSuccess
      // MsgInfo( cPassw )
   endif

return lSuccess

//-----------------------------------------------------------------------//