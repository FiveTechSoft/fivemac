#include "FiveMac.ch"

//---------------------------------------------------------------------------//

function Main()

   local oWnd

   DEFINE WINDOW oWnd TITLE "Testing coordinates" ;
      FROM 50, 50 TO 300, 200

   @ 100, 40 BUTTON "Dialog" OF oWnd ACTION ADialog()
   
   @ 40, 40 BUTTON "Window" OF oWnd ACTION Another()
   
   ACTIVATE WINDOW oWnd ;
      ON CLICK MsgInfo( ChooseFile( oWnd:hWnd ) ) ;
      VALID MsgYesNo( "Want to end ?" )
   
return nil   

//---------------------------------------------------------------------------//

function Another()

   local oWnd
   
   DEFINE WINDOW oWnd TITLE "Another window" ;
      TEXTURED

   @ 40, 40 BUTTON "Iconize" OF oWnd ACTION UrlLoad("http://www.google.es")  
   
   ACTIVATE WINDOW oWnd
   
return nil   

//---------------------------------------------------------------------------//

function ADialog()

   local oDlg
   
   DEFINE DIALOG oDlg TITLE "A modal dialog"

   @ 40, 40 BUTTON "End" OF oDlg ACTION oDlg:End()

   @ 40, 150 BUTTON "Another" OF oDlg ACTION Dialog2()
   
   ACTIVATE DIALOG oDlg ;
      VALID MsgYesNo( "Close ?" )
   
return nil

//---------------------------------------------------------------------------//

function Dialog2()

   local oDlg
   
   DEFINE DIALOG oDlg TITLE "Another dialog"

   @ 40, 40 BUTTON "End" OF oDlg ACTION oDlg:End()
   
   ACTIVATE DIALOG oDlg
   
return nil

//---------------------------------------------------------------------------//