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

   local oDlg, oGetName, cName := "username", oBtnOK, oBtnCancel
   local oGetPasswd, cPasswd := "1234"

   DEFINE DIALOG oDlg RESOURCE "hola"

   REDEFINE GET cName ID 10 OF oDlg

   REDEFINE GET cPasswd ID 20 OF oDlg PASSWORD

   REDEFINE BUTTON oBtnOK ID 30 of oDlg ACTION MsgInfo( cName )

   REDEFINE BUTTON oBtnCancel ID 40 of oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg ON CLICK oDlg:SetText( Time() ) CENTERED

return nil

//----------------------------------------------------------------------------//