#include "FiveMac.ch"

//----------------------------------------------------------------------------//

function Main()

    local oWnd
 
    DEFINE WINDOW oWnd

    oWnd:Show()
   
    ACTIVATE WINDOW oWnd MAXIMIZED ;
       ON INIT Login()

return nil    

//----------------------------------------------------------------------------//

function Login()

   local oDlg, oGetName, cName := Space( 20 ), oBtnOK, oBtnCancel
   local oGetPasswd, cPasswd := Space( 20 )

   DEFINE DIALOG oDlg RESOURCE "hola" TITLE "Login"

   REDEFINE GET oGetName VAR cName ID 10 OF oDlg VALID ! Empty( cName )

   REDEFINE GET cPasswd ID 20 OF oDlg PASSWORD

   REDEFINE BUTTON oBtnOK ID 30 of oDlg ACTION MsgInfo( cName )

   REDEFINE BUTTON oBtnCancel ID 40 of oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//