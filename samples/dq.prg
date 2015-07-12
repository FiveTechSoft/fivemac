#include "FiveMac.ch"

REQUEST DBFCDX, PadR, Descend

static oWndMain

//----------------------------------------------------------------------------//

function Main()

   SET DECIMALS TO 2

   BuildMenu()  

   DEFINE WINDOW oWndMain TITLE "DonorQuest for Mac" ;
      SIZE ScreenWidth(), 0

   oWndMain:SetPos( ScreenHeight() )

   BuildToolBar() 
   
   ACTIVATE WINDOW oWndMain
   
return nil   

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu
   
   MENU oMenu
      MENUITEM "."
      MENU
         MENUITEM "About..." ACTION MsgAbout( "DQMac" )
         SEPARATOR
         MENUITEM "Exit..." ACTION oWndMain:End()
      ENDMENU

      MENUITEM "File"
      MENU
         MENUITEM "Exit..." ACTION oWndMain:End()
      ENDMENU
      
      MENUITEM "Donor"
      MENU
         MENUITEM "Exit..." ACTION oWndMain:End()
      ENDMENU

      MENUITEM "User"
      MENU
         MENUITEM "Exit..." ACTION oWndMain:End()
      ENDMENU

      MENUITEM "Configure"
      MENU
         MENUITEM "Exit..." ACTION oWndMain:End()
      ENDMENU

      MENUITEM "System"
      MENU
         MENUITEM "Exit..." ACTION oWndMain:End()
      ENDMENU

      MENUITEM "Window"
      MENU
         MENUITEM "Exit..." ACTION oWndMain:End()
      ENDMENU

      MENUITEM "Help"
      MENU
         MENUITEM "Exit..." ACTION oWndMain:End()
      ENDMENU

   ENDMENU
   
return oMenu

//----------------------------------------------------------------------------//

function BuildToolBar()

   local oBar

   DEFINE TOOLBAR oBar OF oWndMain

   DEFINE BUTTON OF oBar PROMPT "Open" IMAGE ImgPath() + "open2.png" ;
      ACTION Open(), Donations(), Schedule(), Notepad() 

   DEFINE BUTTON OF oBar PROMPT "Gifts" IMAGE ImgPath() + "gifts.png"

   DEFINE BUTTON OF oBar PROMPT "Pledges" IMAGE ImgPath() + "shakehands.png"

   DEFINE BUTTON OF oBar PROMPT "Memos" IMAGE ImgPath() + "notes.png"

   DEFINE BUTTON OF oBar PROMPT "Address" IMAGE ImgPath() + "address.png"

   DEFINE BUTTON OF oBar PROMPT "Links" IMAGE ImgPath() + "people.png"

   DEFINE BUTTON OF oBar PROMPT "Notepad" IMAGE ImgPath() + "write.png"

return nil

//----------------------------------------------------------------------------//

function Open()

   local oWnd, oBtn1, oBtn2, oBtn3, oBtn4, oBtn5, oBtn6, oBtn7, oBtn8, oBtn9 
   local oBrw1
   
   USE ( Path() + "/Primary/d_header.dbf" ) VIA "DBFCDX" SHARED ALIAS "ds"
   
   DEFINE WINDOW oWnd TITLE "DONOR Dataset: Main Information View for " ;
      SIZE ScreenWidth(), 300 FLIPPED
      
   oWnd:SetPos( ScreenHeight() - 410, 0 )   

   @ 5, 3 BUTTON oBtn1 PROMPT "Find" OF oWnd ;
      SIZE 183, 31

   @ 31, 3 BUTTON oBtn2 PROMPT "Add" OF oWnd ;
      SIZE 92, 30

   @ 31, 93 BUTTON oBtn3 PROMPT "Edit" OF oWnd ;
      SIZE 92, 30

   @ 57, 3 BUTTON oBtn4 PROMPT "Mark" OF oWnd ;
      SIZE 92, 30

   @ 57, 93 BUTTON oBtn5 PROMPT "Copy" OF oWnd ;
      SIZE 92, 30

   @ 83, 3 BUTTON oBtn6 PROMPT "Delete" OF oWnd ;
      SIZE 183, 31

   @ 109, 3 BUTTON oBtn7 PROMPT "Consolidate" OF oWnd ;
      SIZE 183, 31
            
   @ 135, 3 BUTTON oBtn8 PROMPT "Word Notes" OF oWnd ;
      SIZE 183, 31

   @ 161, 3 BUTTON oBtn9 PROMPT "OK" OF oWnd ;
      SIZE 183, 31

   @ 8, 192 BROWSE oBrw1 OF oWnd ;
      FIELDS ds->LastName, ds->FirstName, "", ds->OrgName, ds->Address, ds->Address2,;
             ds->City, ds->State, ds->Zip ;
      HEADERS "Last Name", "First Name", "Middle", "Organization", "Address 1", "Address 2",;
              "City", "State", "Zip Code" ;
      COLSIZES 100, 100, 70, 200, 200, 150, 100, 40, 100 ;        
      SIZE 1077, 260 ;
      ON CHANGE oWnd:SetText( "DONOR Dataset: Main Information View for " + ;
                              If( ! Empty( ds->OrgName ), AllTrim( ds->OrgName ),;
                                    AllTrim( ds->FirstName ) + " " + ;
                                    AllTrim( ds->LastName ) ) )     
      
   oBrw1:SetColorsForAlternate( nRGB( 0xAA, 0xFF, 0xFF ), nRGB( 0x66, 0xAA, 0xFF ) )   
   oBrw1:SetAlternateColor( .T. )   
      
   ACTIVATE WINDOW oWnd
   
return nil      
   
//----------------------------------------------------------------------------// 

function Donations()

   local oWnd, oBtn1, oBtn2, oBtn3, oBtn4, oBtn5 
   local oBrw1
   
   USE ( Path() + "/Primary/d_donati.dbf" ) VIA "DBFCDX" SHARED ALIAS "do" NEW
   
   DEFINE WINDOW oWnd TITLE "Donations for " ;
      SIZE ScreenWidth() / 2, 300 FLIPPED
      
   oWnd:SetPos( ScreenHeight() - 720, 0 )   

   @ 5, 3 BUTTON oBtn1 PROMPT "Add" OF oWnd ;
      SIZE 92, 31

   @ 31, 3 BUTTON oBtn2 PROMPT "Edit" OF oWnd ;
      SIZE 92, 31

   @ 57, 3 BUTTON oBtn3 PROMPT "Delete" OF oWnd ;
      SIZE 92, 31

   @ 83, 3 BUTTON oBtn4 PROMPT "Soft $" OF oWnd ;
      SIZE 92, 31

   @ 109, 3 BUTTON oBtn5 PROMPT "OK" OF oWnd ;
      SIZE 92, 31

   @ 8, 100 BROWSE oBrw1 OF oWnd ;
      FIELDS do->Date, do->Amount, do->Type, do->Account, do->Status, do->Stimulus ;
      HEADERS "Date", "Amount", "Type", "Account", "TY Code", "Stimulus" ;
      COLSIZES 100, 100, 100, 100, 100, 100 ;        
      SIZE 530, 260 ;
      ON CHANGE oWnd:SetText( "Donations for " + ;
                              If( ! Empty( ds->OrgName ), AllTrim( ds->OrgName ),;
                                    AllTrim( ds->FirstName ) + " " + ;
                                    AllTrim( ds->LastName ) ) )     
      
   oBrw1:SetColorsForAlternate( nRGB( 0xAA, 0xFF, 0xFF ), nRGB( 0x66, 0xAA, 0xFF ) )   
   oBrw1:SetAlternateColor( .T. )   

   ACTIVATE WINDOW oWnd

return nil

//----------------------------------------------------------------------------// 

function Schedule()

   local oWnd, oBtn1, oBtn2, oBtn3, oBtn4 
   local oBrw1
   
   USE ( Path() + "/Primary/d_schcon.dbf" ) VIA "DBFCDX" SHARED ALIAS "sc" NEW
   
   DEFINE WINDOW oWnd TITLE "Scheduled Contacts for " ;
      SIZE ScreenWidth() / 2 - 10, 150 FLIPPED
      
   oWnd:SetPos( ScreenHeight() - 570, ScreenWidth() / 2 + 10 )   

   @ 5, 3 BUTTON oBtn1 PROMPT "Add" OF oWnd ;
      SIZE 92, 31

   @ 31, 3 BUTTON oBtn2 PROMPT "Edit" OF oWnd ;
      SIZE 92, 31

   @ 57, 3 BUTTON oBtn3 PROMPT "Delete" OF oWnd ;
      SIZE 92, 31

   @ 83, 3 BUTTON oBtn4 PROMPT "OK" OF oWnd ;
      SIZE 92, 31

   @ 8, 100 BROWSE oBrw1 OF oWnd ;
      FIELDS sc->EventDesc, sc->UserName, sc->Action, sc->SchDate, sc->LastCon ;
      HEADERS "Description", "User Name", "Action", "Next Contact", "Last Contact" ;
      COLSIZES 180, 80, 80, 80, 80 ;        
      SIZE 520, 110 ;
      ON CHANGE oWnd:SetText( "Scheduled Contacts for " + ;
                              If( ! Empty( ds->OrgName ), AllTrim( ds->OrgName ),;
                                    AllTrim( ds->FirstName ) + " " + ;
                                    AllTrim( ds->LastName ) ) )     
      
   oBrw1:SetColorsForAlternate( nRGB( 0xAA, 0xFF, 0xFF ), nRGB( 0x66, 0xAA, 0xFF ) )   
   oBrw1:SetAlternateColor( .T. )   

   ACTIVATE WINDOW oWnd

return nil

//----------------------------------------------------------------------------// 

function Notepad()

   local oWnd, oBtn1, oBtn2, oBtn3 
   local oNotes
   
   DEFINE WINDOW oWnd TITLE "Note Pad for " ;
      SIZE ScreenWidth() / 2 - 10, 140 FLIPPED
      
   oWnd:SetPos( ScreenHeight() - 720, ScreenWidth() / 2 + 10 )   

   @ 10, 10 GET oNotes VAR ds->Notepad MEMO OF oWnd SIZE oWnd:nWidth - 20, 75

   oNotes:SetColor( 0, nRGB( 0xAA, 0xFF, 0xFF ) )

   @ 87, 4 BUTTON oBtn1 PROMPT "OK" OF oWnd ;
      SIZE 92, 31

   @ 87, 94 BUTTON oBtn2 PROMPT "Cancel" OF oWnd ;
      SIZE 92, 31

   @ 87, 184 BUTTON oBtn3 PROMPT "Save" OF oWnd ;
      SIZE 92, 31

   ACTIVATE WINDOW oWnd

return nil

//----------------------------------------------------------------------------// 

function GetTokenPlus( x, y )

return ""

function ChrKeep()

return ""

function Soundex()

return ""

//----------------------------------------------------------------------------//    