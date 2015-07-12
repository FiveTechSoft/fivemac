// dialogs designer

#include "FiveMac.ch"

static oWndMain, oWndCode, oWnd, oWndInsp
static aForms := {}

//----------------------------------------------------------------------------//

function Main()

   BuildMenu()  

   DEFINE WINDOW oWndMain TITLE "FiveMac Designer" ;
      SIZE ScreenWidth(), 0

   oWndMain:setPos(ScreenHeight() )
   BuildImgRes()
   BuildToolBar()      
   SourceEditor()
   ShowInspector()      
   NewForm()
   
   ACTIVATE WINDOW oWndMain
   
return nil   

//----------------------------------------------------------------------------//

function BuildImgRes()
local aImg:= {"new.png","open.png","save.png","exit.png","replace.png","button.png","btnbmp.png" ,;
              "checkbox.png","radio.png","say.png","get.png","combobox.png","browse.png","image.png" } 

	copyImgInRes( aImg )

Return nil 

//----------------------------------------------------------------------------//

function BuildToolbar()

   local oBar

   DEFINE TOOLBAR oBar OF oWndMain

   DEFINE BUTTON OF oBar PROMPT "New" IMAGE ImgPath() + "new.png" ;
      ACTION NewForm()
         
   DEFINE BUTTON OF oBar PROMPT "Open" IMAGE ImgPath() + "open.png" ;
      ACTION OpenForm()

   DEFINE BUTTON OF oBar PROMPT "Save" IMAGE ImgPath() + "save.png" ;
      ACTION SaveForm()
      
   DEFINE BUTTON OF oBar PROMPT "Exit" IMAGE ImgPath() + "exit.png" ;
      ACTION oWndMain:End()
         
   oBar:AddSpace()

   DEFINE BUTTON OF oBar PROMPT "Source/form" IMAGE ImgPath() + "replace.png" ;
      ACTION oWnd:SetFocus()

   oBar:AddSpace()
   
   DEFINE BUTTON OF oBar PROMPT "Button" IMAGE ImgPath() + "button.png" ;
      ACTION AddButton()

   DEFINE BUTTON OF oBar PROMPT "BtnBmp" IMAGE ImgPath() + "btnbmp.png" ;
      ACTION AddBtnBmp()

   DEFINE BUTTON OF oBar PROMPT "Checkbox" IMAGE ImgPath() + "checkbox.png" ;
      ACTION AddCheckbox()

   DEFINE BUTTON OF oBar PROMPT "Radio" IMAGE ImgPath() + "radio.png" ;
      ACTION AddRadio()

   DEFINE BUTTON OF oBar PROMPT "Say" IMAGE ImgPath() + "say.png" ;
      ACTION AddSay()

   DEFINE BUTTON OF oBar PROMPT "Get" IMAGE ImgPath() + "get.png" ;
      ACTION AddGet()

   DEFINE BUTTON OF oBar PROMPT "ComboBox" IMAGE ImgPath() + "combobox.png" ;
      ACTION AddCombo()

   DEFINE BUTTON OF oBar PROMPT "Browse" IMAGE ImgPath() + "browse.png" ;
      ACTION AddBrws()

   DEFINE BUTTON OF oBar PROMPT "Image" IMAGE ImgPath() + "image.png" ;
      ACTION AddImg()

   DEFINE BUTTON OF oBar PROMPT "Tabs" IMAGE ImgDefPath("tabs.png") ;
      ACTION AddTabs()

   DEFINE BUTTON OF oBar PROMPT "Progress" IMAGE ImgDefPath( "progress.png") ;
      ACTION AddProgress()

   DEFINE BUTTON OF oBar PROMPT "Group" IMAGE ImgDefPath("box.png") ;
      ACTION AddGroup()
      
    DEFINE BUTTON OF oBar PROMPT "Slider" IMAGE ImgDefPath("slider.png") ;
      ACTION AddSlider()
   

return nil

//----------------------------------------------------------------------------//

function SourceEditor()

   oWndCode = TWndCode():New()

   oWndCode:AddSource( "project1.prg",; 
                       '#include "FiveMac.ch"' + CRLF + CRLF + ;
                       "//" + Replicate( "-", 72 ) + "//" + CRLF + CRLF + ;
                       "function Main()" + CRLF + CRLF + ;
                       "   public oApplication, oForm1" + CRLF + CRLF + ;
                       "   oApplication = TApplication():New()" + CRLF + CRLF + ;
                       "   oApplication:AddForm( oForm1 := TForm1():New() )" + CRLF + CRLF + ;
                       "   oApplication:Run()" + CRLF + CRLF + ;
                       "return nil " + CRLF + CRLF + ;
                       "//" + Replicate( "-", 72 ) + "//" )   
   
   oWndCode:AddSource( "form1.prg",; 
                       '#include "FiveMac.ch"' + CRLF + CRLF + ;
                       "//" + Replicate( "-", 72 ) + "//" + CRLF + CRLF + ;
                       "CLASS TForm1 FROM TForm" + CRLF + CRLF + ;
                       "   METHOD New()" + CRLF + CRLF + ;
                       "ENDCLASS " + CRLF + CRLF + ;
                       "//" + Replicate( "-", 72 ) + "//" + CRLF + CRLF + ;
                       "METHOD New() CLASS TForm1" + CRLF + CRLF + ;
                       "   super:New()" + CRLF + CRLF + ;
                       "return self" + CRLF + CRLF + ;
                       "//" + Replicate( "-", 72 ) + "//" )   

   ACTIVATE WINDOW oWndCode
   
return nil      

//----------------------------------------------------------------------------//

function NewForm()

   oWnd = TForm():New()

   oWnd:SetDesign( .T. )
   oWnd:oInspector = oWndInsp
   oWnd:bLButtonDown = { | nRow, nCol, self | oWnd := self }
   
   oWndInsp:SetForm( oWnd )

   AAdd( aForms, oWnd )
   
   ACTIVATE WINDOW oWnd
   
return nil   

//----------------------------------------------------------------------------//

function OpenForm()

   local cFileName := ChooseFile( "Select form to open", "prg" )
   
   if File( cFileName )
      oWnd = Execute( MemoRead( cFileName ) )
      HB_SetClsHandle( oWnd, TForm():ClassH )
      oWnd:Initiate()  
      oWnd:SetDesign( .T. )
      oWnd:oInspector = oWndInsp
      oWnd:bLButtonDown = { | nRow, nCol, self | oWnd := self }

      oWndInsp:SetForm( oWnd )

      AAdd( aForms, oWnd )
   endif   

return nil

//----------------------------------------------------------------------------//

function OpenPRG()

   local cFileName := ChooseFile( "Select source to open", "prg" )
   
   if File( cFileName )
      oWndCode:AddSource( cFileNoPath( cFileName ), MemoRead( cFileName ) )
      oWndCode:SetFocus()
   endif   

return nil

//----------------------------------------------------------------------------//

function SaveForm()

   local cFileName := SaveFile( "Save form as", oWnd:cVarName + ".prg" )
   
   if ! Empty( cFileName )
      MemoWrit( cFileName, oWnd:cGenPrg() )
   endif   

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu
   
   MENU oMenu
      MENUITEM "designer"
      MENU
         MENUITEM "About..." ACTION MsgAbout( "(c) FiveTech Software 2012", "Designer" )
         SEPARATOR
         MENUITEM "Exit" ACTION oWndMain:End() ACCELERATOR "q" 
      ENDMENU
      
      MENUITEM "files"
      MENU
         MENUITEM "New"  ACCELERATOR "n" ACTION NewForm()
         MENUITEM "Open" 
         MENU
            MENUITEM "Form..." ACTION OpenForm()
            MENUITEM "Program..." ACTION OpenPRG()
         ENDMENU   
         MENUITEM "Save" ACCELERATOR "s" ACTION SaveForm()
      ENDMENU
      
      MENUITEM "View"
      MENU
         MENUITEM "Inspector..." ACCELERATOR "i" ACTION ShowInspector()
         MENUITEM "Forms..." ACCELERATOR "f" ACTION SelForm()
      ENDMENU
   ENDMENU
   
return nil   

//----------------------------------------------------------------------------//

function ShowInspector()

   if oWndInsp != nil
      return nil
   endif   

   oWndInsp = TInspector():New()
  
   ACTIVATE WINDOW oWndInsp ;
      VALID ( oWndInsp := nil, .T. )
   
return nil

//----------------------------------------------------------------------------//

function SelForm()

   local oDlg, oBrw1, oBtn1, oBtn2

   DEFINE DIALOG oDlg ;
      TITLE "Select form" ;
      SIZE 270, 334 FLIPPED

   oDlg:bKeyDown = { | nKey | If( nKey == 13, Eval( oBrw1:bAction ),), 1 }

   @ 13, 12 BROWSE oBrw1 OF oDlg ;
      FIELDS "";
      HEADERS "Forms";
      SIZE 246, 254

   oBrw1:SetArray( aForms )
   oBrw1:bLine = { | nRow | { aForms[ nRow ]:cVarName } }
   oBrw1:SetColEditable( 1, .F. )
   oBrw1:SetColWidth( 1, 226 )
   oBrw1:SetColor( CLR_BLACK, CLR_PANE )
   oBrw1:bAction = { || If( oBrw1:nArrayAt != 0,;
                     ( oDlg:End(), aForms[ oBrw1:nArrayAt ]:SetFocus(),;
                       oWnd := aForms[ oBrw1:nArrayAt ], oWndInsp:SetForm( oWnd ) ),) }
   oBrw1:SetFocus()
   oBrw1:GoTop()

   @ 275, 39 BUTTON oBtn1 PROMPT "Ok" OF oDlg ;
      SIZE 90, 30 ACTION oDlg:End()

   @ 275, 137 BUTTON oBtn2 PROMPT "Cancel" OF oDlg ;
      SIZE 90, 30 ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED 

return nil

//----------------------------------------------------------------------------//

function GetParent()

   local oCtrl := oWnd:oLastControl
   
   do case
      case oCtrl:ClassName() == "TTABS"
     
           return oCtrl:aControls[ oCtrl:nTab ]
           
      case oCtrl:ClassName() == "TGROUP"
           return oCtrl
           
      otherwise
           return oWnd
   endcase
   
return nil                      

//----------------------------------------------------------------------------//

function AddButton()

   local oBtn, oParent := GetParent() 

   @ 10, 10 BUTTON oBtn PROMPT "Button" OF oParent
   
   oBtn:cVarName = "oBtn" + oBtn:GetCtrlIndex()
   
   oWndInsp:AddItem( oBtn )
   
return nil 

//----------------------------------------------------------------------------//

function AddBtnBmp()

   local oBtn, oParent := GetParent() 

   @ 10, 10 BTNBMP oBtn FILENAME ImgPath() + "mac.png" ;
      OF oParent SIZE 50, 50
   
   oBtn:cVarName = "oBtnBmp" + oBtn:GetCtrlIndex()
   
   oWndInsp:AddItem( oBtn )
   
return nil 

//----------------------------------------------------------------------------//

function AddSlider()

   local oSld, oParent := GetParent() 

   @ 10, 10 SLIDER oSld VALUE 0 OF oParent
   
   oSld:cVarName = "oSld" + oSld:GetCtrlIndex()
   
   oWndInsp:AddItem( oSld )
   
return nil 

//----------------------------------------------------------------------------//

function AddCheckbox()

   local oChk, lValue := .F., oParent := GetParent()

   @ 10, 10 CHECKBOX oChk VAR lValue PROMPT "checkbox" OF oParent SIZE 120, 25
   
   oChk:cVarName = "oChk" + oChk:GetCtrlIndex()

   oWndInsp:AddItem( oChk )   
   
return nil 

//----------------------------------------------------------------------------//

function AddCombo()

   local oCbx, cItem := "", oParent := GetParent()

   @ 10, 10 COMBOBOX oCbx VAR cItem ITEMS {} OF oParent SIZE 120, 25
   
   oCbx:cVarName = "oCbx" + oCbx:GetCtrlIndex()

   oWndInsp:AddItem( oCbx )   
   
return nil 

//----------------------------------------------------------------------------//

function AddBrws()

   local oBrw, oParent := GetParent()  
    
   @ 10, 10 BROWSE oBrw ;
     FIELDS "" ;
     HEADERS "Table" ;
     OF oParent SIZE 150, 150
     
   oBrw:SetArray( {} )
  
   oBrw:cVarName = "oBrw" + oBrw:GetCtrlIndex()
   
   oWndInsp:AddItem( oBrw )
 
return nil 

//----------------------------------------------------------------------------//

function AddGet()

   local oGet, cValue := "", oParent := GetParent()

   @ 10, 10 GET oGet VAR cValue OF oParent
   
   oGet:cVarName = "oGet" + oGet:GetCtrlIndex() 
   
   oWndInsp:AddItem( oGet )
   
return nil 

//----------------------------------------------------------------------------//

function AddGroup()

   local oGrp, oParent := GetParent()

   @ 10, 10 GROUP oGrp ;
      SIZE 200, 200 ;
      PROMPT "Group" ;
      OF oParent
      // [ STYLE <nStyle> ]

   oGrp:cVarName = "oGrp" + oGrp:GetCtrlIndex() 
   
   oWndInsp:AddItem( oGrp )
             
return nil             

//----------------------------------------------------------------------------//

function AddSay()

   local oSay, oParent := GetParent()

   @ 10, 10 SAY oSay PROMPT "Label" OF oParent

   oSay:cVarName = "oSay" + oSay:GetCtrlIndex()

   oWndInsp:AddItem( oSay )
   
return nil 

//----------------------------------------------------------------------------//

function AddImg()

   local oImg, oParent := GetParent()

   @ 10, 10 IMAGE oImg OF oParent SIZE 107, 91 ;
      FILENAME ImgPath() + "fivetech.gif"

   oImg:cVarName = "oImg" + oImg:GetCtrlIndex()

   oWndInsp:AddItem( oImg )
   
return nil 

//----------------------------------------------------------------------------//

function AddRadio()

   local oRad, oParent := GetParent()
   
   oRad = TRadio():New( 10, 10, 120, 25, oParent, "Radio" )

   oRad:cVarName = "oRad" + oRad:GetCtrlIndex()

   oWndInsp:AddItem( oRad )
   
return nil 

//----------------------------------------------------------------------------//

function AddTabs()

   local oTabs, oParent := GetParent()
   
   @ 10, 10 TABS oTabs PROMPTS { "One", "Two" } OF oParent SIZE 200, 200 

   oTabs:lFlipped = .T.

   oTabs:SetVarName( "oTabs" + oTabs:GetCtrlIndex() )

   oWndInsp:AddItem( oTabs )
   
return nil 

//----------------------------------------------------------------------------//

function AddProgress()

   local oPgr, oParent := GetParent()
   
   @ 10, 10 PROGRESS oPgr OF oParent

   oPgr:cVarName = "oPgr" + oPgr:GetCtrlIndex()

   oWndInsp:AddItem( oPgr )

return nil

//----------------------------------------------------------------------------//