#include "FiveMac.ch"
#include "Colors.ch"
#include "Scintilla.ch"

static cPrefFile
static oWnd, aEditors := {}, oEditor, oBtnSave, oMsgBar, oMruFiles
static oSplitV, oSplitH
static oGet, cLog
static aFunLines := {}, oFunList
static oTree, oPrgItem, oChItem, oMItem, cBmpPath
static lSplit1, lSplit2, lSplit3
static cDbfPath, popoverMas

extern dbfcdx, DBCloseArea, DbUseArea, DbGoTo, OrdSetFocus

#define __HBEXTREQ__
#include "harbour.hbx"
#include "fivemac.hbx"

//----------------------------------------------------------------------------//

function Main()

  local oSlide, oSayZoom
  
   cBmpPath = ImgPath()
   cDbfPath = AppPath() + "/"

   RddSetDefault( "DBFCDX" )
   SET DELETED ON

   BuildPreferences()
   BuildScriptDbf()
   BuildMenu()

   DEFINE WINDOW oWnd FROM 100, 100 TO 800, 1200 FULL

   BuildButtonBar()

   @ 21, 0 SPLITTER oSplitV OF oWnd SIZE oWnd:nWidth, oWnd:nHeight - 92 VERTICAL ;
     AUTORESIZE 18 VIEWS 3

   @ 0, 0 SPLITTER oSplitH OF oSplitV:aViews[ 2 ] ;
      SIZE oSplitV:aViews[ 2 ]:nWidth, oSplitV:aViews[ 2 ]:nHeight ;
      HORIZONTAL STYLE 3 AUTORESIZE 18 VIEWS 2

   oSplitV:SetPosition( 1, 250 )

   BuildLeft( oSplitV:aViews[ 1 ] )
   BuildRight( oSplitV:aViews[ 3 ] )

   lsplit1 = .T.
   lsplit2 = .T.
   lsplit3 = .T.

   LoadRecentFiles()

   if Len( aEditors ) == 0
      BuildEditor()
   endif

   DEFINE MSGBAR OF oWnd SIZE 20

   @ 0, 0 GET oGet VAR cLog MEMO OF oSplitH:aViews[ 2 ] ;
      SIZE oSplitH:aViews[ 2 ]:nWidth, oSplitH:aViews[ 2 ]:nHeight - 6

   @ 0, 10 SAY oMsgBar PROMPT "FiveMac IDE" OF oWnd SIZE 300, 18 RAISED

   oWnd:Maximize()

   oSplitV:SetPosition( 1, 250 )
   oSplitV:SetPosition( 2, oWnd:nWidth - 300 )
   oSplitH:SetPosition( 1, oSplitV:nHeight - 120 )

   @ 2, 210 BUTTON oSayZoom PROMPT "Zoom : 100%"  OF oWnd SIZE 110, 16 ;
      ACTION oSayZoom:setText("Zoom : "+ alltrim(str( ( ( oEditor:setZoom( 0 )+10)*10 ) ) )+ "%" )

   oSayZoom:SetBezelStyle( 13 )

   @ 1, 324 SLIDER oSlide SIZE 100,18 OF oWnd

   oSlide:SetMinMaxValue( -9, 20 )
   oSlide:bChange := { || oSayZoom:setText("Zoom : " + ;
                          Alltrim(str( ( ( oEditor:setZoom( oSlide:GetValue() ) + 10 ) * 10 ) ) ) + "%" ) }

   ACTIVATE WINDOW oWnd
   
return nil

//----------------------------------------------------------------------------//

function SelectionSegmentos( oSeg2 )

   local nSelect := oSeg2:SelectedItem

   if nSelect == 2
      lsplit2 = ! lsplit2
      if ! lsplit2
         oSplitH:SetPosition( 1, oSplitV:nHeight )
      else
         oSplitH:SetPosition( 1, oSplitV:nHeight - 120 )
      endif
   endif

   if nSelect == 1
      lsplit1 = ! lsplit1
      if ! lsplit1
         oSplitV:SetPosition( 1, 0 )
      else
         oSplitV:SetPosition( 1, 250 )
      endif
   endif

   if nSelect == 3
      lsplit3 = ! lsplit3
      if ! lsplit3
         oSplitV:SetPosition( 2, oWnd:nWidth )
      else
         oSplitV:SetPosition( 2, oWnd:nWidth - 300 )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

function AutoIndentation()

/*
 // void SciTEBase::MaintainIndentation(char ch) {

   local nEolMode  := oEditor:GetEolMode()
   local nCurLine  := oEditor:GetCurrentLineNumber()
   local nLastLine := nCurLine
   local nLineLen  := 0
   local nIndentAmount := 0

   if (((eolMode == SC_EOL_CRLF || eolMode == SC_EOL_LF) && ch == '\n') ||
       (eolMode == SC_EOL_CR && ch == '\r'))

        if nLastLine >= 1  // .and. props.GetInt("indent.automatic"))
        do
          {
               lineLen = GetLineLength( --lastLine );
          } while (lineLen == 0 .and. nLastLine > 0 )
      endif

      if nLastLine >= 0
         indentAmount = GetLineIndentation( nLastLine )
      endif

      if nIndentAmount > 0
           SetLineIndentation( nCurLine, nIndentAmount )
       endif
   endif
*/

return nil

//----------------------------------------------------------------------------//

function BuildEditor()

   if oEditor != nil
      oEditor:RemoveFromSuperview()
   endif

   oEditor = TScintilla():New( 0, 0, oSplitH:aViews[ 1 ]:nWidth,;
                               oSplitH:aViews[ 1 ]:nHeight - 7, oSplitH:aViews[ 1 ] )
   oEditor:nAutoResize = 18

   oEditor:bChange = { || EditorChange() }
//   oEditor:SetColor( , nRgb( 167, 167, 167 ) , .t. )

   AAdd( aEditors, oEditor )

return nil

//----------------------------------------------------------------------------//

function BuildPreferences()

   cPrefFile = Path() + "/fivedit.plist"

   if ! File( cPrefFile )
       SetPlistValue( cPrefFile, "PathHarbour", "./../../harbour", .T. )
       SetPlistValue( cPrefFile, "PathFiveMac", "./../../fivemac", .T. )
       SetPlistValue( cPrefFile, "PathSDK", ;
       "/Applications/Xcode.app/Contents/Developer/Platforms/" + ;
           "MacOSX.platform/Developer/SDKs/MacOSX.sdk", .T. )
   endif

   CreatePlistHarblib()
   CreatePlistFrameWorks()

return nil

//----------------------------------------------------------------------------//

function BuildScriptDbf()

   local scriptDbf := AppPath() + "/scripts.dbf"
   local cAlias
   local cCode := '#include "FiveMac.ch"' + CRLF + CRLF + ;
                  "function Main()" + CRLF + CRLF + ;
                  ' MsgInfo( "Hello world!" )' + CRLF + CRLF + ;
                  "return nil"

   if ! File( scriptDbf )
      DbCreate( scriptDbf, { { "NAME", "C", 20, 0 },;
                             { "DESCRIPT", "C", 100, 0 },;
                             { "CODE", "M", 80, 0 } } )
      cAlias = Abrimos( "scripts" )
      if ! Empty( cAlias )
         ( cAlias )->(dbAppend())
         ( cAlias )->Name = "Test"
         ( cAlias )->Descript = "Code for Tests"
         ( cAlias )->Code = cCode
         ( cAlias )->( dbUnlock() )
         close( cAlias )
      endif
   else
      USE ( scriptDbf )
      PACK
      CLOSE
   endif

return nil

//----------------------------------------------------------------------------//

function EditorChange()

   local nPos := oEditor:GetCurrentPos(), nAt

   if Chr( oEditor:GetCharAt( nPos ) ) $ "([{}])"
      if ( nAt := oEditor:BraceMatch( nPos ) ) != -1
         oEditor:BraceHighlight( nPos, nAt )
      else
         oEditor:BraceBadLight( nPos, nAt )
      endif
   else
      oEditor:BraceBadLight( -1 )
   endif

   if oMsgBar != nil
      oMsgBar:SetText( "FiveMac IDE " + ;
                       " Row: " + AllTrim( Str( oEditor:nLine() ) ) + ;
                       " Col: " + AllTrim( Str( oEditor:nCol() ) ) )
   endif

   if oEditor:GetModify()
      oBtnSave:Enable()
   else
      oBtnSave:Disable()
   endif

   SelectFunction()

   AutoIndentation()

return nil

//----------------------------------------------------------------------------//

function LoadRecentFiles()

   local lCarga := .F.
   local n, cFileName
   local oPlist := TPlist():New( cPrefFile )
   local aFiles := oPlist:GetArrayByName( "LastFiles" )

   if Len( aFiles ) > 0

      for n = 1 to Len( aFiles )

         cfileName = afiles[ n ]

         // cFileName = GetPlistValue( cPrefFile, "File" + AllTrim( Str( n ) ) )

         if ! Empty( cFileName )
            OpenFile( cFileName )
            lCarga = .T.
         endif
      next

      if lCarga
         if Len( oTree:oNode:aNodes[ 1 ]:aNodes ) > 0
            oTree:Select( oTree:oNode:aNodes[ 1 ]:aNodes[ 1 ] )
            SelectFile()
         endif
      endif

   endif

return nil

//----------------------------------------------------------------------------//

function CreatePlistHarblib()

  local oPlist := TPlist():New( cPrefFile )
  local lHarblib := oPlist:IsKeyByName( "HarbLibs" )
  local aHarbLibs:={ "hbdebug", "hbvm", "hbrtl", "hblang", "hbrdd",;
                     "hbrtl", "gttrm", "hbvm", "hbmacro", "hbpp", "rddntx",;
                     "rddcdx", "rddfpt", "hbsix", "hbcommon", "hbcplr" }
  if ! lHarblib
     oPlist:SetArrayByName( "HarbLibs", aHarbLibs, .T. )
  endif

return nil

//----------------------------------------------------------------------------//

function CreatePlistFrameWorks()

  local oPlist := TPlist():New( cPrefFile )
  local lFramewors := oPlist:IsKeyByName( "FrameWorks" )
  local lExtraFrameworks := oPlist:IsKeyByName( "ExtraFrameWorks" )
  local aFrameWorks := { "Cocoa", "WebKit", "QTkit", "Quartz" }
  local aExtraFrameworks := { "Scintilla" }

  if ! lFramewors
     oPlist:SetArrayByName( "FrameWorks", aFrameWorks, .T. )
  endif

  if ! lExtraFrameworks
     oPlist:SetArrayByName( "ExtraFrameWorks", aExtraFrameworks, .T. )
  endif

return nil

//----------------------------------------------------------------------------//

function RunScript( oEditor )

   local oHrb, cResult, bOldError
   local cPrefFile := Path() + "/fivedit.plist"
   local cFivePath := GetPlistValue( cPrefFile, "PathFiveMac" )
   local cHarbourPath := GetPlistValue( cPrefFile, "PathHarbour" )

   oHrb = HB_CompileFromBuf( StrTran( oEditor:GetText(), "Main", "__Main" ),;
                             .T., "-n", "-I" + alltrim( cFivePath ) + "/include",;
                             "-I" + alltrim( cHarbourPath ) + "/include" )

   if ! Empty( oHrb )
      BEGIN SEQUENCE
         bOldError = ErrorBlock( { | o | DoBreak( o ) } )
         hb_HrbRun( oHrb )
      END SEQUENCE
      ErrorBlock( bOldError )
   endif

return nil

//----------------------------------------------------------------------------//

static function DoBreak( oError )

   local cInfo := oError:operation, n

   if ValType( oError:Args ) == "A"
      cInfo += "   Args:" + CRLF
      for n = 1 to Len( oError:Args )
         MsgInfo( oError:Args[ n ] )
         cInfo += "[" + Str( n, 4 ) + "] = " + ValType( oError:Args[ n ] ) + ;
                  "   " + cValToChar( oError:Args[ n ] ) + CRLF
      next
   endif

   MsgStop( oError:Description + CRLF + cInfo,;
   FWString( "Script error at line:" ) + " " + ;
             AllTrim( Str( ProcLine( 2 ) ) ) )

   BREAK

return nil

//----------------------------------------------------------------------------//

function dummy1()

   local oMovie:= Tmovie():New()
   local oprogres:= TProgress():New()
   local afile:= {}

return nil

//----------------------------------------------------------------------------//

function OSName()

return TaskExec( "/usr/bin/uname", { "-s" } )

//--------------------------------------------------------------------------

function NewFile()

   local scriptDbf := AppPath() + "/scripts.dbf"
   local cFileName := "noname1.prg", n := 2
   local cAlias

   while File( cFileName )
      cFileName = "noname" + AllTrim( Str( n++ ) ) + ".prg"
   end

   if ! File( cFileName )
      cAlias = Abrimos( "scripts" )
      if ! Empty( cAlias )
         MemoWrit( cFileName, ( cAlias )->CODE )
      endif
      // MemoWrit( cFileName, '#include "FiveMac.ch"' + CRLF + CRLF + ;
      //                       "function Main()" + CRLF + CRLF + ;
      //                       '   MsgInfo( "hello world!" )' + CRLF + CRLF + ;
      //                       "return nil" )
   endif

   Close( cAlias )
   OpenFile( cFileName )

return nil

//----------------------------------------------------------------------------//

function Preferences()

   local oDlg, oMulti
   local oTree, oItem, oClr
   local oTree2, oItem2
   local oTree3, oItem3
   local oTree4, oItem4
   local oTreeFlag, oItemFlag
   local oplist := TPlist():New( cPrefFile )

   local oGet1, cVar1 := oPlist:GetItemByName( "PathFiveMac" )
   local oGet2, cVar2 := oPlist:GetItemByName( "PathHarbour" )
   local oGet3, cVar3      := oPlist:GetItemByName( "PathSDK" )
   local oGetIcon,cVarIcon := oPlist:GetItemByName( "PathIcon" )
   local oImg
   
   local aFrameworks      := oPlist:GetArrayByName( "FrameWorks" )
   local aHarbLibs        := oPlist:GetArrayByName( "HarbLibs" )
   local aExtraFrameworks := oPlist:GetArrayByName( "ExtraFrameWorks" )
   local aHarbourFlags    := oPlist:GetArrayByName( "HarbourFlags" )
   
   local cStringColor := oPlist:GetItemByName( "Color-Strings" )

   local i, n, obtn1, oBtn2, obtn3, obtn4, obtn8, oBtn5, oBtn6
   local oBtnaddFlag,oBtndelFlag

   ? cStringColor

   DEFINE DIALOG oDlg TITLE "Preferences"
 
   DEFINE MULTIVIEW oMulti OF oDlg RESIZED

   @ 0,0 MVIEW PROMPT "Fonts & Colors" SIZE 500, 382 TITLE "Fonts & Colors" OF oMulti ;
         TOOLTIP "Fonts & Colors" IMAGE "ColorPanel" 

   @ 0,0 MVIEW PROMPT "WorkSpace" SIZE 500, 382 TITLE "WorkSpace" OF oMulti ;
         TOOLTIP "WorkSpace" IMAGE cBmpPath+"WorkSpace2.tiff"

   @ 0,0 MVIEW PROMPT "Frameworks" SIZE 420, 382 TITLE "Frameworks" OF oMulti ;
         TOOLTIP "Frameworks" IMAGE  cBmpPath+"Framework.tiff"

   @ 0,0 MVIEW PROMPT "Harbour" SIZE 420, 382 TITLE "Harbour" OF oMulti ;
   TOOLTIP "Harbour" IMAGE cBmpPath+"Libs.tiff"

   oMulti:oToolbar:SetBtnSelected( 1 )

   @ 1, 1 TREE oTree TITLE "Categories" ;
      SIZE 180, 380 OF oMulti:aViews[ 1 ]

   oTree:bAction = { || ShowColor( oClr, oTree )  }

   oItem = oTree:AddItem( "Colors","ColorPanel" ) //cBmpPath+"Coloring.tiff" )
      oItem:AddItem( "Strings" )
      oItem:AddItem( "Numbers" )
      oItem:AddItem( "Comments" )
      oItem:AddItem( "Harbour" )
      oItem:AddItem( "FiveMac" )

   oItem = oTree:AddItem( "ToolBar" )
      oItem:AddItem( "Prompts" )

   oItem = oTree:AddItem( "Font","FontPanel") // cBmpPath+"Fonts.tiff"  )
      oItem:AddItem( "Name" )
      oItem:AddItem( "Size" )

    oTree:Select( oTree:GetItemByName( "Strings" ))
    oTree:refresh()

   @ 300, 260 COLORWELL oClr SIZE 100, 30 OF oMulti:aViews[ 1 ] ;
      ON CHANGE SetEditorColor( oTree:GetSelect():cName, oClr:GetColor() )

   //------ controles en segunda vista ------------

   @ 224, 40 SAY "Icon app:" OF oMulti:aViews[ 2 ]

   @ 230, 160 IMAGE oImg OF oMulti:aViews[ 2 ] SIZE 130, 130 FILENAME cVarIcon
       oImg:setFrame()

   @ 204, 40 GET oGetIcon VAR cVarIcon OF oMulti:aViews[ 2 ] SIZE 390, 20
   
   @ 204, 440  BTNBMP OF oMulti:aViews[ 2 ]  ;
     FILENAME "RevealFreestanding"  ;
      ACTION ChooseSheetTxtImg(oGetIcon:hwnd,oImg:hWnd ) SIZE 20, 20 STYLE 10
      
   oGetIcon:SetNOSelect()

   @ 170, 40 SAY "Fivemac Path:" OF oMulti:aViews[ 2 ]
   @ 150, 40 GET oGet1 VAR cVar1 OF oMulti:aViews[ 2 ] SIZE 390, 20

   @ 150, 440  BTNBMP OF oMulti:aViews[ 2 ]  ;
      FILENAME "RevealFreestanding"  ;
      ACTION oGet1:opensheet( ParentPath( oGet1:gettext() ) )  SIZE 20, 20 STYLE 10

   @ 120, 40 SAY "Harbour Path:" OF oMulti:aViews[ 2 ]
   @ 100, 40 GET oGet2 VAR cVar2 OF oMulti:aViews[ 2 ] SIZE 390, 20

   @ 100, 440  BTNBMP OF oMulti:aViews[ 2 ]  ;
      FILENAME "RevealFreestanding"  ;
      ACTION oGet2:opensheet( oGet2:gettext() )  SIZE 20, 20 STYLE 10
  
   @ 70, 40 SAY "SDK Path:" OF oMulti:aViews[ 2 ]
   @ 10, 40 GET oGet3 VAR cVar3 OF oMulti:aViews[ 2 ] SIZE 390, 60

   @ 10, 440  BTNBMP OF oMulti:aViews[ 2 ]  ;
      FILENAME "RevealFreestanding"  ;
     ACTION oGet3:opensheet(ParentPath( oGet3:gettext()))  SIZE 20, 60 STYLE 10

  //------ controles en vista 3 -----------

   @ 40, 10 TREE oTree2 TITLE "Frameworks" ;
      SIZE 180, 340 OF oMulti:aViews[ 3 ]

   oTree2:SetPijama( .T. )
   oTree2:SetScrollHShow( .F. )

   oItem2 = oTree2:AddItem( "Frameworks" ,"Folder")

   i = Len( aFrameworks )
   for n = 1 to i
      oItem2:AddItem( aFrameworks[n],,, cBmpPath + "Framework.tiff" )
   next

   @ 12, 10 BTNBMP oBtn1 OF oMulti:aViews[ 3 ] ;
      FILENAME "Remove" ;
      ACTION Dellib( oTree2, 1 ) SIZE 30, 30 STYLE 10

   @ 12, 39 BTNBMP oBtn2  OF oMulti:aViews[ 3 ]  ;
      FILENAME "Add" ;
      ACTION DlgAddlib(oTree2,1) SIZE 30, 30 STYLE 10

   @ 12, 68 BUTTON "" OF oMulti:aViews[ 3 ] ;
      ACTION .T. SIZE 122, 30 STYLE 10 TYPE 10

   @ 40, 200 TREE oTree4 TITLE "Extra Frameworks" ;
      SIZE 180, 340 OF oMulti:aViews[ 3 ]

   oTree4:SetPijama( .T. )

   oTree4:SetScrollHShow( .F. )

   oItem4 = oTree4:AddItem( "Extra Frameworks" ,"Folder")

   i= Len( aExtraFrameworks )
   for n = 1 to i
      oItem4:AddItem( aExtraFrameworks[ n ],,, cBmpPath + "Framework.tiff" )
   next

   @ 12, 200 BTNBMP oBtn5 OF oMulti:aViews[ 3 ] ;
      FILENAME "Remove" ;
      ACTION Dellib( oTree4, 3 ) SIZE 30, 30 STYLE 10

   @ 12, 229 BTNBMP oBtn6 OF oMulti:aViews[ 3 ] ;
      FILENAME "Add" ;
      ACTION DlgAddlib( oTree4, 3 ) SIZE 30, 30 STYLE 10

   @ 12, 258 BUTTON "" OF oMulti:aViews[ 3 ] ;
      ACTION .T. SIZE 122, 30 STYLE 10 TYPE 10

   //------ controles en vista 4 -----------

   @ 40, 10 TREE oTree3 TITLE "Harbour Libs" ;
     SIZE 180, 340 OF oMulti:aViews[ 4 ]

   oTree3:SetPijama( .T. )

   oTree3:SetScrollHShow( .F. )

   oItem3 = oTree3:AddItem( "Harbour Libs" ,"Folder")

   i = Len( aHarbLibs )
   for n = 1 to i
      oItem3:AddItem( aHarbLibs[n],,, cBmpPath + "Libs.tiff" )
   next

   @ 12, 10 BTNBMP oBtn3 OF oMulti:aViews[ 4 ] ;
   FILENAME "Remove" ;
   ACTION Dellib( oTree3, 2 ) SIZE 30, 30 STYLE 10

   @ 12, 39 BTNBMP oBtn4 OF oMulti:aViews[ 4 ] ;
      FILENAME "Add" ;
      ACTION DlgAddlib( oTree3, 2 ) SIZE 30, 30 STYLE 10

   @ 12, 68 BUTTON "" OF oMulti:aViews[ 4 ] ;
      ACTION .T. SIZE 122, 30 STYLE 10 TYPE 10

   @ 40, 200 TREE oTreeFlag TITLE "HarbourFlags";
      SIZE 180, 340 OF oMulti:aViews[ 4 ]

   oTreeFlag:SetPijama( .T. )

   oTreeFlag:SetScrollHShow( .F. )

   oItemFlag = oTreeFlag:AddItem( "HarbourFlags" ,"Folder")

   i = Len( aHarbourFlags )
   for n = 1 to i
      oItemFlag:AddItem( aHarbourFlags[ n ],,, "SmartBadge" )
   next

   @ 12, 200 BTNBMP oBtndelFlag OF oMulti:aViews[ 4 ] ;
      FILENAME "Remove" ;
      ACTION Dellib( oTreeFlag, 4 ) SIZE 30, 30 STYLE 10

   @ 12, 229 BTNBMP oBtnaddFlag OF oMulti:aViews[ 4 ] ;
      FILENAME "Add" ;
      ACTION DlgAddlib( oTreeFlag, 4 ) SIZE 30, 30 STYLE 10

   @ 12, 258 BUTTON "" OF oMulti:aViews[ 4 ] ;
      ACTION .T. SIZE 122, 30 STYLE 10 TYPE 10

   //------ controles en vista 5 -----------

   oMulti:setView( 1 )

   ACTIVATE DIALOG oDlg CENTERED ;
      ON INIT ( oTree:Rebuild(), oTree:ExpandAll(),;
                oTree2:Rebuild(), oTree2:ExpandAll(),;
                oTree3:Rebuild(), oTree3:ExpandAll(),;
                oTree4:Rebuild(), oTree4:ExpandAll(),;
               oTreeFlag:Rebuild(), oTreeFlag:ExpandAll(),;
               oTree:Select( oTree:GetItemByName( "Strings" )),;
               oTree:refresh() ) 

   if ! ( cVar1 == GetPlistValue( cPrefFile, "PathFiveMac" ) )
      SetPlistValue( cPrefFile, "PathFiveMac", cVar1, .T. )
   endif

   if ! ( cVar2 == GetPlistValue( cPrefFile, "PathHarbour" ) )
      SetPlistValue( cPrefFile, "PathHarbour", cVar2, .T. )
    endif

   if ! ( cVar3 == GetPlistValue( cPrefFile, "PathSDK" ) )
      SetPlistValue( cPrefFile, "PathSDK", cVar3, .T. )
   endif
  
    if !(  oGetIcon:getText() == GetPlistValue( cPrefFile, "PathIcon" ) )
         SetPlistValue( cPrefFile, "PathIcon",  cVarIcon , .T. )
    endif

   if ! ( GetPlistValue( cPrefFile, "PathIcon" ) == oImg:GetFile() )
      SetPlistValue( cPrefFile, "PathIcon", oImg:GetFile(), .T. )
   endif

    SetPlistValue( cPrefFile, "Color-Strings", 1234, .T. )

return nil

//----------------------------------------------------------------------------//

function DelLib( oTree, ntipo )

   local i, n
   local oPlist := TPlist():New( cPrefFile )
   local aLibs := {}
   local oNodo
   local aTipo := { "FrameWorks", "HarbLibs", "ExtraFrameWorks", "HarbourFlags" }

   oTree:DelItem( oTree:GetSelect() )
   oTree:Expandall()

   oNodo = oTree:oNode:aNodes[ 1 ]

   n = oNodo:nItems

   for i = 1 to n
      AAdd( aLibs, oNodo:aNodes[ i ]:cName )
   next

   oPlist:SetArrayByName( aTipo[ nTipo ], aLibs, .T. )

 return nil

//----------------------------------------------------------------------------//

function DlgAddlib( oTree, ntipo )

   local oDlg, oGet, cLib := ""
   local i, n
   local oPlist:= TPlist():New( cPrefFile )
   local aLibs := {}
   local oNode
   local cBmp
   local cTitle := "Add Lib"
   local aTitles
   local cVar

   if ntipo == 4
      cTitle:= "Add Flag"
   endif

   DEFINE DIALOG oDlg TITLE cTitle ;
      FROM 220, 350 TO 340, 690

   @ 69, 37 SAY cTitle OF oDlg SIZE 150, 17

   @ 67, 108 GET oGet VAR cLib OF oDlg SIZE 192, 22
   
   if nTipo == 1
      
      cVar := oPlist:GetItemByName( "PathSDK" )
      cVar += "/System/Library/Frameworks/"
      
      @ 67, 306 BTNBMP OF oDlg  ;
      FILENAME "RevealFreestanding"  ;
      ACTION ( cGetNombreRecortado( oGet:opensheet( cVar ), oGet ) ) SIZE 22, 22 STYLE 10
      
   endif

   @ 20, 218 BUTTON "OK" OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

   if !Empty( cLib )

      oNode = oTree:oNode:aNodes[ 1 ]

       if nTipo == 2
          cBmp = cBmpPath + "Libs.tiff"
       elseif nTipo == 1
          cBmp = cBmpPath + "Framework.tiff"
       endif

       oNode:AddItem( cLib,,, cBmp )

       n = oNode:nItems

       for i = 1 to n
          AAdd( aLibs, oNode:anodes[ i ]:cName )
       next

       aTitles:= { "FrameWorks" , "HarbLibs" ,"ExtraFrameWorks","HarbourFlags" }

       oPlist:SetArrayByName( aTitles[nTipo], aLibs, .T. )

       oTree:Rebuild()
       oTree:ExpandAll()

   endif

return nil

//----------------------------------------------------------------------------//

static function cGetNombreRecortado( cfile , oGet )

   oGet:setText( cFileNoext( cFilenopath( cfile ) ) )
   oGet:assign()
   
return nil

//----------------------------------------------------------------------------//

 function SetEditorColor( cType, nRGBColor )

  oEditor:SetTextColor( cType, nRGBColor )

  ? cType
  ? "Color-" + cType
  ? nRGBColor
  
  ? ISKEYPLIST( cPrefFile, "Color-" + cType )  
  
   SetPlistValue( cPrefFile, "Color-" + cType, nRGBColor, .T. )
  
   ?  GetPlistValue( cPrefFile, "Color-" + cType )
  
 return nil

//----------------------------------------------------------------------------//

function ShowColor( oClr, oTree )

   local oItem := oTree:GetSelect(), cName

   if oItem != nil
      cName = oItem:cName

      if cName $ "Strings,Numbers,Comments,Harbour,FiveMac"
         oClr:SetColor( oEditor:GetTextColor( cName ) )
      else
         oClr:SetColor( CLR_WHITE )
      endif

   endif

return nil

//----------------------------------------------------------------------------//

static function OpenFile( cFileName )

   local oItem

   if Empty( cFileName )
      BuildEditor()
      if oEditor:DlgOpen()
         cFileName = oEditor:cFileName
         oMruFiles:bAction:AddItem( oEditor:cFileName,;
                                    { | oMenuItem | OpenFile( oMenuItem:cPrompt ) } )
      else
         return nil
      endif
   else
      if File( cFileName )
         if ( oItem := oTree:GetItemByName( cFileNoPath( cFileName ) ) ) == nil .or. ;
            oItem:Cargo != cFileName
            BuildEditor()
            oEditor:Open( cFileName )
            oMruFiles:bAction:AddItem( oEditor:cFileName,;
                                       { | oMenuItem | OpenFile( oMenuItem:cPrompt ) } )
         endif
      else
         MsgAlert( cFileName + " not found!" )
         return nil
      endif
   endif

   if oItem == nil
      if Lower( cFileExt( cFileName ) ) == "prg"
         oItem = oPrgItem:AddItem( cFileNoPath( oEditor:cFileName ),,, cBmpPath + "new.png" )

      elseif Lower( cFileExt( cFileName ) ) == "ch"
         if oChItem == nil
            oChItem = oTree:AddItem( "CH", cBmpPath + "Group.tiff" )
         endif
         oItem = oChItem:AddItem( cFileNoPath( oEditor:cFileName ),,, cBmpPath + "new.png" )

      elseif Lower( cFileExt( cFileName ) ) == "m"
         if oMItem == nil
            oMItem = oTree:AddItem( "M", cBmpPath + "Group.tiff" )
         endif
         oItem = oMItem:AddItem( cFileNoPath( oEditor:cFileName ),,,, cBmpPath + "new.png" )
      endif
   endif

   if oItem != nil
      if oItem:Cargo != oEditor:cFileName
         oItem:Cargo = oEditor:cFileName
         oTree:Rebuild()
      endif

      oTree:ExpandAll()
      oTree:Select( oItem )
   endif

   oEditor:SetFocus()

   FillFuncList()

   if Lower( cFileExt( oEditor:cFileName ) ) == "prg"
      oFunList:aCols[ 1 ]:SetHeader( "Functions" )
   else
      oFunList:aCols[ 1 ]:SetHeader( "Commands" )
   endif

return nil

//----------------------------------------------------------------------------//

function BuildButtonBar()

   local oBar, oSeg

   DEFINE TOOLBAR oBar OF oWnd

   DEFINE BUTTON OF oBar PROMPT "New File" ;
      TOOLTIP "Creates a new file" ;
      IMAGE  cBmpPath + "new.png" ;
      ACTION NewFile()

   DEFINE BUTTON OF oBar PROMPT "Open" ;
      TOOLTIP "Open a file" ;
       IMAGE  cBmpPath + "open.png" ;
       ACTION OpenFile()

   DEFINE BUTTON OF oBar PROMPT "Close" ;
      TOOLTIP "Close this file" ;
       IMAGE  cBmpPath + "folder2.png" ;
       ACTION CloseFile()

   DEFINE BUTTON oBtnSave OF oBar PROMPT "Save" ;
      TOOLTIP "Save the file to disk" ;
      IMAGE  cBmpPath + "floppy.png" ;
       ACTION oEditor:Save(), oBtnSave:Disable()

   oBtnSave:Disable()

   DEFINE BUTTON OF oBar PROMPT "Exit" ;
      TOOLTIP "Exit" ;
       IMAGE  cBmpPath + "exit3.png" ;
       ACTION Exit()

   oBar:Addspace()

   DEFINE BUTTON OF oBar PROMPT "Undo" ;
      TOOLTIP "Undo the lastest actions" ;
       IMAGE  cBmpPath + "undo.png" ;
       ACTION oEditor:UnDo()

   DEFINE BUTTON OF oBar PROMPT "Redo" ;
      TOOLTIP "Redo the lastest actions" ;
       IMAGE  cBmpPath + "redo.png" ;
       ACTION oEditor:ReDo()

   oBar:AddSpace()

   DEFINE BUTTON OF oBar PROMPT "Cut" ;
      TOOLTIP "Remove the selected text and put it on the clipboard" ;
       IMAGE  cBmpPath + "cut.png" ;
       ACTION oEditor:Cut()

   DEFINE BUTTON OF oBar PROMPT "Copy" ;
      TOOLTIP "Copy the selected text to the clipboard" ;
       IMAGE  cBmpPath + "copy.png" ;
       ACTION oEditor:Copy()

   DEFINE BUTTON OF oBar PROMPT "Paste" ;
      TOOLTIP "Insert text from the clipboard at the current position" ;
       IMAGE  cBmpPath + "paste.png" ;
       ACTION oEditor:Paste()

   oBar:AddSpace()

   oBar:AddSearch( , "Text to find",;
                   { | oGet | oEditor:FindText( oGet:GetText() ) } )

   DEFINE BUTTON OF oBar PROMPT "Previous" ;
      TOOLTIP "Repeat the search backwards" ;
       IMAGE  cBmpPath + "prev.png" ;
       ACTION oEditor:FindPrev()

   DEFINE BUTTON OF oBar PROMPT "Next" ;
      TOOLTIP "Repeat the search forward" ;
       IMAGE  cBmpPath + "next.png" ;
       ACTION oEditor:FindNext()

   DEFINE BUTTON OF oBar PROMPT "Replace" ;
      TOOLTIP "Search and replace" ;
       IMAGE cBmpPath + "replace.png" ;
       ACTION oEditor:Replace()

   DEFINE BUTTON OF oBar PROMPT "Goto Line" ;
      TOOLTIP "Go to a line number" ;
       IMAGE  cBmpPath + "goline.png" ;
       ACTION oEditor:DlgGotoLine()

   oBar:AddSpace()

   DEFINE BUTTON OF oBar ;
      IMAGE cBmpPath + "run.png"  ;
      PROMPT FWString( "Script" ) ACTION RunScript(oEditor ) ;
      TOOLTIP FWString( "Run as script" )

   DEFINE BUTTON OF oBar PROMPT "Run" ;
      TOOLTIP "Build and run" ;
      IMAGE cBmpPath + "execute.png" ;
      ACTION Run()

   DEFINE BUTTON OF oBar PROMPT "Terminal" ;
      TOOLTIP "Open a terminal window" ;
      IMAGE  cBmpPath + "terminal.png" ;
      ACTION MacExec( "terminal.app" )

   DEFINE BUTTON OF oBar PROMPT "Dbf Builder" ;
      TOOLTIP "Create Dbf" ;
      IMAGE  cBmpPath + "save.png" ;
      ACTION FunCreaDbf()

   oBar:AddSpace() // AddSpaceFlex()

   @ 0, 0 SEGMENTBTN oSeg OF oWnd SIZE 290, 40 ;
      ACTION SelectionSegmentos( oSeg ) ;
      ITEMS { "", "", "" } ;
      IMAGES { cBmpPath + "ideleft.tiff", cBmpPath + "idebottom.tiff" , cBmpPath + "ideright.tiff"  } ;
      STYLE 5 ;
      TRACKING 1 ;
      AUTORESIZE 1

  // oSeg:Anclaje( 1 )
  // oSeg:SetStyle( 5 )
  // oSeg:SetTracking( 1 )
  // oSeg:SetImg( cBmpPath + "ideleft.tiff", 1 )
  // oSeg:SetImg( cBmpPath + "idebottom.tiff", 2 )
  // oSeg:SetImg( cBmpPath + "ideright.tiff", 3 )

   oBar:AddSegmentedBtn( "Views", "Views", oSeg, 108 )

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu
   local lfolder:= .f.

   MENU oMenu
      MENUITEM "SciEdit"
      MENU
         MENUITEM "About..." ACTION MsgAbout( "(c) FiveTech Software 2012",;
                                              "FiveMac IDE", "About" )
         SEPARATOR
         MENUITEM "Preferences..." ACCELERATOR "," ACTION Preferences()
         SEPARATOR
         MENUITEM "Exit" ACCELERATOR "q" ACTION Exit() IMAGE "exit2.png(20x20)"
      ENDMENU

      MENUITEM "File"
      MENU
         MENUITEM "New"   ACCELERATOR "n" ACTION NewFile()
         MENUITEM "Open"  ACCELERATOR "o" ACTION OpenFile()
         MENUITEM "Close" ACCELERATOR "w" ACTION CloseFile()
         MENUITEM "Save"  ACCELERATOR "s" ACTION oEditor:Save()
         MENUITEM "Save as..." ACCELERATOR "S" ACTION oEditor:SaveAs()
         SEPARATOR
         MENUITEM "Print..." ACCELERATOR "p"
         SEPARATOR
         MENUITEM oMruFiles PROMPT "Recent files"
         MENU
         ENDMENU
      ENDMENU

      MENUITEM "Edit"
      MENU
         MENUITEM "Undo"  ACCELERATOR "z" ACTION oEditor:UnDo()
         MENUITEM "Redo"  ACCELERATOR "Z" ACTION oEditor:ReDo()
         SEPARATOR
         MENUITEM "Cut"   ACCELERATOR "x"  ACTION oEditor:Cut()
         MENUITEM "Copy"  ACCELERATOR "c"  ACTION oEditor:Copy()
         MENUITEM "Paste" ACCELERATOR "v" ACTION oEditor:Paste()
         MENUITEM "Select &All" ACTION oEditor:SelectAll()

         SEPARATOR

         MENUITEM "Duplicate line" + Chr( 9 ) + Chr( 9 ) + Chr( 9 ) + "F5" ;
            ACTION oEditor:LineDuplicate() ACCELERATOR "F5"

         SEPARATOR
         MENUITEM "Code Separator" ACTION oEditor:LineSep()
         SEPARATOR
         MENUITEM "Set Upper" ACTION oEditor:Uppercase()
         MENUITEM "Set Lower" ACTION oEditor:Lowercase()

      ENDMENU

      MENUITEM "View"
      MENU
         MENUITEM "Whitespace" ACTION  oEditor:SetViewSpace()
         MENUITEM "&Indentation Guides"  ACTION  oEditor:SetIndent()
         MENUITEM "Fold Margin"         ACTION  oEditor:SetMargin( lfolder:= !lfolder )
         MENUITEM "End of line"         ACTION  oEditor:SetEOL()
         SEPARATOR
         MENUITEM "Toggle Bookmark"     ACTION  oEditor:SetToggle()
         MENUITEM "Next Bookmark"       ACTION  oEditor:BookMarkNext( .t. )
         MENUITEM "Previous Bookmark"   ACTION  oEditor:BookMarkNext( .f. )
         MENUITEM "Clear All Bookmarks" ACTION  oEditor:BookMarkClearAll()

      ENDMENU

      MENUITEM "Search"
      MENU
         MENUITEM "Find..."
         MENUITEM "Find Next" ACTION oEditor:FindNext()
         MENUITEM "Find Prev" ACTION oEditor:FindPrev()
         MENUITEM "Replace..."
         SEPARATOR
         MENUITEM "Goto..." ACTION oEditor:DlgGotoLine()

         SEPARATOR

         MENUITEM "Find in files"
      ENDMENU

      MENUITEM "Project"
      MENU
         MENUITEM "New"
         MENUITEM "Open"
         MENUITEM "Close"
         SEPARATOR
         MENUITEM "Recent projects"
      ENDMENU

      MENUITEM "Tools"
      MENU
         MENUITEM "Terminal" ACTION MacExec( "Terminal.app" )

         SEPARATOR

         MENUITEM "Tool configuration..."
      ENDMENU

      MENUITEM "Help"
      MENU
         MENUITEM "Index"
      ENDMENU

   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

function CloseFile()

   local nAt

   oEditor:Close()

   oTree:DelItem( oTree:GetSelect() )
   oTree:ExpandAll()

   if Len( aEditors ) > 1 .and. ;
      ( nAt := AScan( aEditors, { | oEd | oEd == oEditor } ) ) != 0
      ADel( aEditors, nAt )
      ASize( aEditors, Len( aEditors ) - 1 )

      if nAt >= 1 .and. nAt <= Len( aEditors )
         oEditor:RemoveFromSuperview()
         oEditor:End()
         oEditor = aEditors[ nAt ]
         oSplitH:aViews[ 1 ]:AddSubview( oEditor )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

function Exit()

   local oPlist
   local n, oEditor
   local afiles:= {}
   
   oPlist := TPlist():new( cPrefFile  )

   for n = 1 to Len( aEditors )

      oEditor = aEditors[ n ]

    //  oPlist:SetItemByName("File" + AllTrim( Str( n ) ), oEditor:cFileName )

      AAdd( afiles, oEditor:cFileName )

      if oEditor:GetModify()
         if MsgYesNo( "Save the changes ?", "File has changed" )
            oEditor:Save()
         endif
      endif

   next

     while n < 10
      //  oPlist:SetItemByName("File"+AllTrim( Str( n++ ) ) , "" )

        aadd(aFiles, ""   )
        n++

     end

     oPlist:SetArrayByName( "LastFiles", aFiles , .t. )

   oWnd:End()

return nil

//----------------------------------------------------------------------------//

function Run()

   local cText := ""
   local oPlist := TPlist():New( cPrefFile  )
   local aFrameworks := oPlist:GetArrayByName( "FrameWorks" )
   local aHarbLibs := oPlist:GetArrayByName( "HarbLibs" )
   local aExtraFrameworks := oPlist:GetArrayByName( "ExtraFrameWorks" )

   local SdkPath  := oPlist:GetItemByName( "PathSDK"  )
   local HarbPath := oPlist:GetItemByName( "PathHarbour" )
   local FivePath := oPlist:GetItemByName( "PathFiveMac" )
   local IconPath := oPlist:GetItemByName( "PathIcon" )

   local Framework:= ""
   local HarbLibs := ""
   local ExtraFrameWork:= ""
   local i, n
   local cFinText
   local cFileName := cFileNoExt( oEditor:cFileName )
   local cFilePath := cFilePath(  oEditor:cFileName )
   
   local cAuxFile
   
   local cCurrentPath := Path() + "/"

   local oArrayArguments
   local cResult
   

   n = Len( aFrameworks )
   for i = 1 to n
      Framework = Framework + "-framework " + AllTrim( aFrameworks[ i ] ) + " "
   next

   if Len( aExtraFrameworks ) > 0
      n = Len( aExtraFrameworks )
      for i = 1 to n
         ExtraFramework = ExtraFramework + "-framework " + AllTrim( aExtraFrameworks[ i ] ) + " "
      next
   endif

   n = Len( aHarbLibs )
   for i = 1 to n
      HarbLibs += "-l" + AllTrim( aHarbLibs[ i ] ) + " "
   next

   if oEditor:GetModify()
      oEditor:Save()
   endif

   cText = cText + "PRG compiling..." + Chr( 13 )
   oGet:GoBottom()

   cResult := RunHarbour( oEditor:cFileName )
   if Empty( cResult )
      Return .f.
   endif
   
   cText += cResult + Chr( 13 )

   oGet:SetText( cText )
   oGet:GoBottom()

   if ! IsFile( cFilePath + cfileName + ".c" )
      MsgInfo( "PRG compile error, please review the reported errors" )
      return nil
   endif

   cText += "C compiling..." + Chr( 13 )
   oGet:SetText( cText )
   oGet:GoBottom()

   cText += RunGcc( cFilePath + cFileName )
   oGet:SetText( cText )
   oGet:GoBottom()

   if ! IsFile( cFilePath + cfileName + ".o" )
      cText +=  Chr( 13 )+ "C compile error, no object file generate. please review the reported errors" + Chr( 13 )
      Return nil
   else
      cText += "OK" + Chr( 13 )
      oGet:SetText( cText )
      oGet:GoBottom()
   endif

 // System( "./build.sh " + cFileNoExt( oEditor:cFileName ) + " > build.log" )
 
   if ! IsFile( cFilePath + cFileName + ".app" )
      CreateDir( cFilePath + cFileName + ".app" )
   endif

   cText += "building the app..." + Chr( 13 )
   oGet:SetText( cText )
   oGet:GoBottom()

   //---------- incluye info.plist -----------

   if  ! IsFile( cFilePath + cFileName + ".app/Contents" )
        CreateDir( cFilePath + cFileName + ".app/Contents" )
   endif

   CreateInfoFile( cFileName, cFilePath, FileNoPath( IconPath ) )

   cText += "building info.plist" + Chr( 13 )
   oGet:SetText( cText )
   oGet:GoBottom()
   
   //----------- crea dir de exe --------------

   if ! IsFile(  cFilePath + cFileName + ".app/Contents/MacOS" )
      CreateDir( cFilePath + cFileName + ".app/Contents/MacOS" )
   endif

  //------------- incluir icono ------------

   if Empty( IconPath )
      IconPath := FivePath + "/icons/fivetech.icns"
   endif

   cAuxFile := cFilePath + cFileName + ".app/Contents/Resources"
   
   if  ! IsFile( cAuxFile )
        CreateDir( cAuxFile )
   endif
  
   cAuxFile += "/" + FileNoPath( IconPath )
   
   if file(  cAuxFile )
       cText += " App icon yo existe..." + Chr( 13 )
   else
        if ( CopyFileTo( IconPath, cAuxFile ) )
            cText += "including app icon..." + Chr( 13 )
       else
            cText += " NO including app icon..." + Chr( 13 )
       endif
   endif
   
   oGet:SetText( cText )
   oGet:GoBottom()

   //-----------  incluir frameworks ------------

   cAuxFile := cFilePath + cFileName + ".app/Contents/frameworks"
   
   if Len( aExtraFrameworks ) > 0
       
      if  ! IsFile( cAuxFile )
         CreateDir( cAuxFile )
      endif
    
      for n = 1 to Len( aExtraFrameworks )
          CopyFileTo( Fivepath + "/frameworks/" + AllTrim( aExtraFrameworks[ n ] ) + ".framework",;
                      cAuxFile +"/" + AllTrim( aExtraFrameworks[ n ] ) + ".framework" )
      next
      
   endif
   
   //-----------  create sh file ------------
   
   cAuxFile := cFilePath + cFileName + ".sh"
   
   MakeshFile( cAuxFile )
   SETEXECUTABLE( cAuxFile )

    cText+= "creando archivo sh" + Chr( 13 )
    oGet:SetText( cText )
    oGet:GoBottom()

/*
    oArrayArguments := ArrayCreateEmpty()
    ArrayAddString( oArrayArguments, cAuxFile  )
    ArrayAddString( oArrayArguments, cFilename  )
    cText += TaskExecArray( "/bin/sh", oArrayArguments )
*/

    cText += TaskExec( "/bin/sh", { cAuxFile, cFilename } )

    oGet:SetText( cText )
    oGet:GoBottom()

    cFinText = AllTrim( SubStr( cText, Len( ctext ) - 5, 5 ) )

    if cFinText = "done!"
       
      cAuxFile := cFilePath + cFileName
       
      MoveToTrash( cAuxFile +".sh" )

      if IsFile( cAuxFile + ".o" )
         MoveToTrash( cAuxFile + ".c" )
         MoveToTrash( cAuxFile + ".o" )
         if IsFile( cAuxFile + ".app/Contents/MacOS/" + cFileName )
            MacExec( cAuxFile + ".app" )
         endif
      else
         MoveToTrash( cAuxFile + ".app" )
         MsgInfo( "app creation error" )
      endif
    endif

return nil

//----------------------------------------------------------------------------//

function RunHarbour( cFile )

   local oPlist := TPlist():New( cPrefFile  )
   local aHarbFlags := oPlist:GetArrayByName( "HarbourFlags" )
   local HarbPath   := oPlist:GetItemByName( "PathHarbour" )
   local FivePath   := oPlist:GetItemByName( "PathFiveMac" )
   local cText
   local cHarbour := HarbPath + "/bin/harbour"
   local cIncludes := "-I" + FivePath + "/include:" + HarbPath + "/include"
   local i
   local oArrayArguments
   local aArguments := {}
   
   local cFileName := cFileNoExt( cFile )
   local cFilePath := cFilePath( cFile )

    if !file( cFile )
       msginfo( "el archivo no existe "+ cFile )
       Return nil
    endif
    
    if !file( FivePath + "/include/FiveMac.ch" )
        if msgYesNo( "el path de FiveMac parace no estar bien. Quiere comprobarlo ?", "Atencion" )
            Preferences()
            msginfo( "Vuelva a ejecutar run ")
        endif
        Return nil
    endif
    
    if !File( cHarbour )
       if msgYesNo( "el path de Harbour parace no estar bien. Quiere comprobarlo ?", "Atencion" )
          Preferences()
          msginfo( "Vuelva a ejecutar run ")
       endif
       Return nil
    endif

   oArrayArguments := ArrayCreateEmpty()
  
   aadd( aArguments, cFile )
  
//   ArrayAddString( oArrayArguments, cFile  )

   if Len( aHarbFlags ) > 0
      for i = 1 to Len( aHarbFlags )
//         ArrayAddString( oArrayArguments, "-" + AllTrim( aHarbFlags[ i ] ) )
          aadd( aArguments, "-" + AllTrim( aHarbFlags[ i ] ) )
      next
   endif

 //  ArrayAddString( oArrayArguments, cIncludes )
 //  ArrayAddString( oArrayArguments, "-o"+ cFilePath + cFileName +".c" )
//   cText = TaskExecArray( cHarbour, oArrayArguments )
  
   aadd( aArguments, cIncludes )
   aadd( aArguments, "-o"+ cFilePath + cFileName +".c" )
   
   cText = TaskExec( cHarbour, aArguments )
 
return cText

//----------------------------------------------------------------------------//

function RunGcc( cFile )

   local oPlist := TPlist():New( cPrefFile  )
   local HarbPath := oPlist:GetItemByName( "PathHarbour" )
   local FivePath := oPlist:GetItemByName( "PathFiveMac" )
   local SdkPath  := oPlist:GetItemByName( "PathSDK"  )
  
   local cGcc := "/Applications/Xcode.app/Contents/Developer/usr/bin/gcc"
   
   local HEADERS   := SdkPath + "/usr/include"
   local FRAMEPATH := sdkPath + "/System/Library/Frameworks"

   local aArg := {}
   
/*
local oArrayArguments :=  ArrayCreateEmpty()
   
   ArrayAddString( oArrayArguments, cFile + ".c" )
   ArrayAddString( oArrayArguments, "-c" )
   ArrayAddString( oArrayArguments, "-o"+ cFile + ".o" )
   ArrayAddString( oArrayArguments, "-I" + HarbPath + "/include" )
   ArrayAddString( oArrayArguments, "-I" + HEADERS )
   ArrayAddString( oArrayArguments, "-I" + FRAMEPATH )

return TaskExecArray( cGcc, oArrayArguments )
*/

   aadd( aArg, cFile + ".c")
   aadd( aArg, "-c"   )
   aadd( aArg, "-o"+ cFile + ".o" )
   aadd( aArg, "-I" + HarbPath + "/include" )
   aadd( aArg, "-I" + HEADERS  )
   aadd( aArg, "-I" + FRAMEPATH  )

return TaskExec( cGcc, aArg )

//----------------------------------------------------------------------------//

function MakeShFile( cShFile )
    
    local oPlist := TPlist():New( cPrefFile  )
    local cHarbPath  := oPlist:GetItemByName( "PathHarbour" )
    local cFivePath  := oPlist:GetItemByName( "PathFiveMac" )
    local cSdkPath   := oPlist:GetItemByName( "PathSDK"  )

    local cCurrentPath := cFilePath( cShFile )
    local cText
    local cMPath := strTran( cCurrentPath, " ","\ ")
    
    local aHarbLibs   := oPlist:GetArrayByName( "HarbLibs" )
    local aFrameworks := oPlist:GetArrayByName( "FrameWorks" )
    local aExtraFrameworks := oPlist:GetArrayByName( "ExtraFrameWorks" )
    
    local n, i, cUsrPath

     //-------- cortamos los path --------------------
     
     cFivePath := strTran( cFivePath, "/Usuarios", "/Users" )
     cHarbPath := strTran( cHarbPath, "/Usuarios", "/Users" )
     
     cFivePath := substr( cFivePath, hb_at("/Users", cFivePath ) )
     cHarbPath := substr( cHarbPath, hb_at("/Users", cHarbPath ) )
     
     //----------------- generamos el texto ----------------------

     cText := "SDKPATH="+ cSdkPath + hb_eol() + ;
              "HEADERS=$SDKPATH/usr/include"+ hb_eol() +;
              "CRTLIB=$SDKPATH/usr/lib"+ hb_eol()
     
      //--------- libs harbour ----------------------
      
      if len( aHarbLibs ) > 0
             cText += "HRBLIBS='"
              n:= Len( aHarbLibs )
              for i=1 to n
                  cText += " -l" + alltrim( aHarbLibs[i] )
              next
              cText += "' " + hb_eol()
     else
     
        cText += "HRBLIBS='-lhbdebug -lhbvm -lhbrtl -lhblang -lhbrdd -lhbrtl -lgttrm -lhbvm" +;
                         " -lhbmacro -lhbpp -lrddntx -lrddcdx -lrddfpt -lhbsix -lhbcommon -lhbcplr -lhbcpage'" + hb_eol()
     
     endif
     
     //---------- frameworks -----------------------
     
     if len( aFrameworks ) > 0
         cText += "FRAMEWORKS='"
          n:= Len( aFrameworks )
         for i=1 to n
             cText += " -framework " + alltrim( aFrameworks[i] )
         next
         cText += "' " + hb_eol()
     else
     
         cText += "FRAMEWORKS='-framework Cocoa -framework WebKit -framework QTkit -framework Quartz  -framework ScriptingBridge -framework AVKit -framework AVFoundation -framework CoreMedia -framework iokit'"+ hb_eol()
     
     endif
     
     
    cText+= "FIVEPATH=" + cFivePath + hb_eol()
    cText+= "HARBPATH=" + cHarbPath + hb_eol()

    cText +="gcc " + cMPath + "/$1.o -o " + cMPath + "/$1.app/Contents/MacOS/$1 -L$CRTLIB " +;
                "-L$FIVEPATH/lib -lfive -lfivec "+;
                "-L$HARBPATH/lib $HRBLIBS "+;
                "$FRAMEWORKS"
    
    //--------- Extraframeworks ----------------------
    
    if len( aExtraFrameworks ) > 0
        
        cText += " -F$FIVEPATH/frameworks"
        n = Len( aExtraFrameworks )
        for i = 1 to n
           cText += " -framework "+ AllTrim( aExtraFrameworks[ i ] )
        next
        cText +=  hb_eol()
    endif

 ShFileFromString( cText, cCurrentPath + cFileNoPath( cShFile ) )

return nil

//----------------------------------------------------------------------------//

function BuildRight( oSplit )

  local nFunc := 1
  local oSplitH2
  local oBrwSniped
  local aSniped
  local oBtnAdd,oBtnDel,obtnnull

   @ 0, 0 SPLITTER oSplitH2 OF oSplit ;
      SIZE oSplit:nWidth, oSplit:nHeight-10 ;
      HORIZONTAL STYLE 3 AUTORESIZE nOr( 16, 2 ) VIEWS 2

  // DEFINE VIEW OF oSplitH2
  // DEFINE VIEW OF oSplitH2

   @ 0, 0 BROWSE oFunList FIELDS "" HEADERS "Functions" OF oSplitH2:aViews[ 1 ];
    SIZE oSplitH2:aViews[ 1 ]:nWidth-2, oSplitH2:aViews[ 1 ]:nHeight ;
    COLSIZES 300 ;
    AUTORESIZE nOr( 16, 2 )

   FillFuncList()

   WITH OBJECT oFunList
      if aFunLines != nil
         :setArray( aFunLines )
         :bLine = { | nRow | { If( Len( aFunLines ) > 0 .and. nRow <= Len( aFunLines ),;
                               aFunLines[ nRow ][ 1 ], "" ) } }
      endif

      :SetColEditable( 1, .F. )
      //:SetColWidth( 1, 180 )
      :SetRowHeight( 20 )
      :SetGridLines( 1 )
      :SetSelectorStyle( 1 )
      //:Anclaje( nOr( 16, 2 ) )

      :bAction = { || oEditor:GotoLine( aFunLines[ oFunList:nRowPos ][ 2 ] ),;
                      oEditor:SetFocus() }
   END

   @ 22, 0 BROWSE oBrwSniped FIELDS "" HEADERS "Code Sniped" OF oSplitH2:aViews[ 2 ];
      SIZE oSplitH2:aViews[ 2 ]:nWidth-2, oSplitH2:aViews[ 2 ]:nHeight ;
      ON CHANGE ( Showpopover( oBrwSniped:hwnd , aSniped[oBrwSniped:nRowPos][2]  ) );
      AUTORESIZE  nOr( 16, 2 ) ;
      COLSIZES 180

   aSniped:=FillSnipedCode()

   WITH OBJECT oBrwSniped
      if aSniped != nil
         :setArray( aSniped )
         :bLine = { | nRow | { If( Len( aSniped ) > 0 .and. nRow <= Len( aSniped ),;
         aSniped[ nRow ][ 1 ], "" ) } }
       endif
      :SetColEditable( 1, .F. )
      //:SetColWidth( 1, 180 )
      :SetRowHeight( 20 )
      :SetGridLines( 1 )
      :SetSelectorStyle( 1 )
     // :Anclaje( nOr( 16, 2 ) )
      :SetAlternateColor( .t. )


      :bAction = { || oEditor:AddText( aSniped[ oBrwSniped:nRowPos ][ 2 ] ), ;
                      oEditor:SetFocus() }
   END

   @ 0, 0 BTNBMP oBtndel OF oSplitH2:aViews[ 2 ];
      FILENAME "Remove" ;
      ACTION DeleteSnipet( aSniped, oBrwSniped ) SIZE 22, 22 STYLE 10

   @ 0, 22 BTNBMP oBtnadd OF oSplitH2:aViews[ 2 ];
      FILENAME "Add" ;
      ACTION popoverMas := ShowWinPopOver( oBtnAdd:hWnd,;
             DlgAddSnipet( @aSniped, @oBrwSniped ):hWnd ) SIZE 22, 22 STYLE 10

   @ 0, 44 BUTTON obtnnull PROMPT "" OF oSplitH2:aViews[ 2 ] ;
      ACTION .T. SIZE 128, 22 STYLE 10 TYPE 10 AUTORESIZE 2

   oSplitH2:SetPosition( 1, oSplit:nHeight - 120 )

   // obtnnull:Anclaje( 2 )

return nil

//----------------------------------------------------------------------------//

Function deletesnipet(aSniped,oBrw)

   local cAlias := Abrimos( "scripts" )

   ( cAlias )->( DbGoto( oBrw:nRowPos ) )

   if ( cAlias )->name != "Test"
      ( cAlias )->( DbRlock() )
      ( cAlias )->( DbDelete() )
      ( cAlias )->( DbUnlock() )
      ADel( aSniped, oBrw:nRowPos )
      ASize( aSniped, Len( aSniped ) - 1 )
   endif

   Close( cAlias )
   oBrw:Refresh()

return nil

//----------------------------------------------------------------------------//

function fillSnipedCode()

   local cAlias  := Abrimos( "scripts" )
   local aSniped := {}

   // local cText1:=" //----------------------------------------------------------------------------//"+CRLF
   // local aSniped:= {{ "Separator",cText1} ,{"codigo dos","yo"},{"codigo tres","tu" } }

   if ! Empty( cAlias )
      ( cAlias )->( DbGotop() )

      while ! ( cAlias )->( Eof() )
         AAdd( aSniped, { ( cAlias )->name, ( cAlias )->Code } )
         ( cAlias )->( DbSkip() )
      end
   endif

   Close( cAlias )

return aSniped

//----------------------------------------------------------------------------//

function DlgAddSnipet( aSniped, oBrwSniped )

   local oDlg, oGetName, cName := ""
   local oGetDescrip, cDescrip := ""
   local oGetText, cText := ""
   local lsave := .f.


   DEFINE DIALOG oDlg TITLE "Snipet Code" ;
      FROM 220, 350 TO 620, 800

   @ 413, 34 SAY "Name Snippet" OF oDlg SIZE 150, 17

   @ 387, 34 GET oGetName VAR  cName OF oDlg SIZE 192, 22

   @ 343, 34 SAY "Descrip Snippet" OF oDlg SIZE 150, 17

   @ 317, 34 GET oGetDEscrip VAR  cDescrip OF oDlg SIZE 400, 22

   @ 278, 34 SAY "Snippet Code" OF oDlg SIZE 150, 17

   @ 57, 34 GET oGetText VAR  cText MEMO OF oDlg   ;
      SIZE 400 , 220

   @ 10, 34 BUTTON "Save" OF oDlg ACTION ( Savesnipet(cName,cDescrip,oGetText,aSniped),;
      oBrwSniped:refresh(), Roundmsg("snippet grabado",1), ClosePopOver( popoverMas ) ) ;
      STYLE 12

   // @ 10, 336 BUTTON "Exit" OF oDlg ACTION  oDlg:End() STYLE 12

   // ACTIVATE DIALOG oDlg CENTERED

return oDlg

//----------------------------------------------------------------------------//

Function Savesnipet(cName,cDescrip,oGetText,aSniped)
local cText
local calias

if !Empty( cName )
  cText:= oGetText:GetText()+CRLF
  if !Empty(cText)
    calias:=Abrimos("scripts")
    (cAlias)->(dbappend())
    (cAlias)->Name:=cName
    (cAlias)->Descript:=cDescrip
    (cAlias)->Code := cText
    (calias)->(dbunlock())
   endif
    close(calias)
    aadd(aSniped, { cName,cText } )

endif

return nil

//----------------------------------------------------------------------------//

function SelectFunction()

   local nAt, nLine := oEditor:nLine()

   if Len( aFunLines ) > 0 .and. ;
      ( nAt := AScan( aFunLines, { | u | u[ 2 ] <= nLine .and. ;
                                         u[ 3 ] >= nLine } ) ) != 0
      oFunList:Select( nAt )
   endif

return nil

//----------------------------------------------------------------------------//

function BuildLeft( oSplit )

   @ 0, 2 TREE oTree SIZE oSplit:nWidth-2 , oSplit:nHeight-10 OF oSplit ;
      TITLE "Files" AUTORESIZE nOr( 16, 2 ) ;
      ACTION ( SelectFile() )

   oTree:SetColWidth( 90 )

  // oTree:Anclaje( nOr( 16, 2 ) )

   oPrgItem = oTree:AddItem( "PRG", cBmpPath + "folder.png" )

 //  oTree:bAction = { || SelectFile() }

return nil

//----------------------------------------------------------------------------//

function SelectFile()

   local oItem := oTree:GetSelect(), cFileName, nAt

   if oItem != nil .and. ! oItem:cName $ "PRG,CH,M"
      cFileName = oItem:Cargo

      if ( nAt := AScan( aEditors,;
         { | oEd | oEd:cFileName == cFileName .and. ! oEd == oEditor } ) ) != 0
         oSplitH:aViews[ 1 ]:AddSubview( aEditors[ nAt ] )

         aEditors[ nAt ]:nWidth  = oSplitH:aViews[ 1 ]:nWidth
         aEditors[ nAt ]:nHeight = oSplitH:aViews[ 1 ]:nHeight - 7

         oEditor:RemoveFromSuperview()
         oEditor = aEditors[ nAt ]

      else
         BuildEditor()
         oEditor:Open( cFileName )
      endif

      FillFuncList()

      if Lower( cFileExt( cFileName ) ) != "ch"
         oFunList:aCols[ 1 ]:SetHeader( "Functions" )
      else
         oFunList:aCols[ 1 ]:SetHeader( "Commands" )
      endif

   endif

return nil

//----------------------------------------------------------------------------//

function FillFuncList()

   local nLines, n
   local cToken, cLine
   // local cCommands := ""

   if oEditor == nil
      return nil
   endif

   nLines = oEditor:GetLineCount()

   aFunLines = {}

   for n = 1 to nLines
      cToken = Lower( Left( cLine := LTrim( oEditor:GetLine( n ) ), 4 ) )
      if cToken $ "func,proc,clas,meth" .and. ;
         Lower( cFileExt( oEditor:cFileName ) ) $ "prg,ch"
         AAdd( aFunLines, { cLine, n, n + 1 } )
      endif

      if Left( cLine, 12 ) == "static funct"
         AAdd( aFunLines, { cLine, n, n + 1 } )
      endif

      if Left( cLine, 6 ) == "#xcomm"
         if StrToken( cLine, 2 ) == "@"
            AAdd( aFunLines, { "@ ... " + StrToken( cLine, 5 ), n, n + 1 } )
         else
            AAdd( aFunLines, { StrToken( cLine, 2 ) + " " + ;
                               StrToken( cLine, 3 ), n, n + 1 } )
         endif
      endif

      if Left( cLine, 7 ) == "HB_FUNC"
         AAdd( aFunLines, { cLine, n, n + 1 } )
      endif

      if cToken $ "retu" .or. Left( cToken, 1 ) == "}"
         if ATail( aFunLines ) != nil
            ATail( aFunLines )[ 3 ] = n
         endif
      endif
   next

   ASort( aFunLines,,, { | x, y | x[ 1 ] < y[ 1 ] } )

   if oFunList != nil
      oFunList:SetArray( aFunLines )
      oFunList:Refresh()
   endif

   // To generate docs automatically!
   // if Lower( cFileExt( oEditor:cFileName ) ) == "ch"
   //    AEval( aFunLines, { | a | cCommands += a[ 1 ] + CRLF } )
   //    MemoWrit( "commands.txt", cCommands )
   // endif

return nil

//----------------------------------------------------------------------------//

function FunCreaDbf()

   local oDlg, oBrw, cFieldName := "", cType, nLength := 10, nDec := 0
   local cFileName := "", cRDD
   local aFields := {  }
   local oGet,oGetDeci ,oGetName,oGetLen,oCbx
   local oBtnCreate,oBtnEdit
   local aStruct

   DEFINE DIALOG oDlg TITLE "DBF Builder" ;
      FROM 207, 274 TO 590, 790

   @ 351, 20 SAY "FieldName:" OF oDlg SIZE 78, 17

   @ 326, 20 GET oGet VAR cFieldName OF oDlg SIZE 125, 22

   @ 351, 153 SAY "Type:" OF oDlg SIZE 51, 17

   @ 326, 153 COMBOBOX oCbx VAR cType OF oDlg ;
      SIZE 124, 25 ITEMS { "Character", "Numeric", "Logical", "Date", "Memo" } ;
      ON CHANGE ( Iif(cType== "Numeric",oGetDeci:enabled() ,oGetDeci:disabled() ) )

   @ 351, 285 SAY "Length:" OF oDlg SIZE 50, 17

   @ 326, 285 GET oGetLen VAR nLength OF oDlg SIZE 43, 22

   @ 351, 336 SAY "Dec:" OF oDlg SIZE 31, 17

   @ 326, 336 GET oGetDeci VAR nDec OF oDlg SIZE 43, 22

   oGetDeci:Disabled()

   @ 73, 20 LISTBOX oBrw FIELDS "", "", "", "" ;
      HEADERS "FieldName", "Type", "Length", "Decimals" ;
      OF oDlg SIZE 379, 245 ;
      ON CHANGE ( cFieldName := aFields[ oBrw:nRowPos, 1 ], oGet:Refresh(),;
                  cType   := aFields[ oBrw:nRowPos, 2 ], oCbx:Refresh(),;
                  nLength :=  aFields[ oBrw:nRowPos, 3 ], oGetLen:Refresh(),;
                  nDec    :=  aFields[ oBrw:nRowPos, 4 ], oGetDeci:Refresh() )

   oBrw:SetArray( aFields )
   oBrw:bLine = { | nRow | { aFields[ nRow ][ 1 ], aFields[ nRow ][ 2 ],;
                             AllTrim( Str( aFields[ nRow ][ 3 ] ) ),;
                             AllTrim( Str( aFields[ nRow ][ 4 ] ) ) } }

   oBrw:SetSelectorStyle( 1 )

   oBrw:SetAlternateColor( .t. )
   obrw:SetColEditable( 1, .f. )
   obrw:SetColEditable( 2, .f. )
   obrw:SetColEditable( 3, .f. )
   obrw:SetColEditable( 4, .f. )

   @ 324, 407 BUTTON "Add" OF oDlg ;
      ACTION ( btnAddField( @aFields, { cFieldName,cType,nLength,nDec }, oBrw:nRowPos ),;
      cFieldName := "", oBrw:Refresh(), oBrw:GoDown(), oGet:Refresh() )

   @ 274, 407 BUTTON oBtnedit PROMPT "Edit" OF oDlg ;
      ACTION ( btnEditField( aFields, { cFieldName, cType, nLength, nDec }, oBrw:nRowPos ),;
      cFieldName := "", oBrw:Refresh(), oGet:Refresh() )

   // oBtnEdit:disable()

   @ 242, 407 BUTTON "Up"   OF oDlg ACTION ( SetFieldUp( @aFields, oBrw:nRowPos ), oBrw:Refresh() )
   @ 210, 407 BUTTON "Down" OF oDlg ACTION ( SetFieldDown( @aFields, oBrw:nRowPos ), oBrw:Refresh())
   @ 178, 407 BUTTON "Del"  OF oDlg ACTION ( ADel( aFields, oBrw:nRowPos ),;
                                             ASize( aFields, Len( aFields ) - 1 ), oBrw:Refresh() )

   @ 48, 20 SAY "DBF filename:" OF oDlg SIZE 92, 17

   @ 46, 110 GET oGetName VAR cFileName OF oDlg SIZE 275, 22 ;
      VALID ( if( ! Empty( cFileName ) .and. Len( aFields ) > 0, oBtnCreate:Enable(), oBtnCreate:Disable() ), .T. )

   @ 20, 73 SAY "RDD:" OF oDlg SIZE 108, 17

   @ 16, 110 COMBOBOX cRDD OF oDlg ;
      SIZE 94, 25 ITEMS { "DBFNTX", "DBFCDX" }

   @ 101, 407 BUTTON "Code Gen." OF oDlg ;
      ACTION ( oEditor:AddText( DbfGen( aFields ) ), oDlg:End() )

   @ 71, 407 BUTTON "Import" OF oDlg ;
      ACTION ( aStruct := ImportDbf(), If( ! Empty( aStruct ),;
             ( aFields := aStruct, oBrw:SetArray( aFields ) ),), oBrw:Refresh() )

   @ 41, 407 BUTTON oBtnCreate PROMPT "Create" OF oDlg ;
      ACTION ( MsgInfo( "crea dbf" ), DbCreate( cFileName, aFields, cRdd ) )

   oBtnCreate:Disable()

   ACTIVATE DIALOG oDlg

return nil

//----------------------------------------------------------------------------//

function SetFieldUp( aFields, nIndex )

   local BakaField

   if nIndex > 1
      BakaField = aFields[ nIndex - 1 ]
      aFields[ nIndex - 1 ] = aFields[ nIndex ]
      aFields[ nIndex ] = BakaField
   endif

return nil

//----------------------------------------------------------------------------//

function SetFieldDown( aFields, nIndex )

   local BakaField

   if nIndex < Len( aFields )
      BakaField = aFields[ nIndex + 1 ]
      aFields[ nIndex + 1 ] = aFields[ nIndex ]
      aFields[ nIndex ] = BakaField
   endif

return nil

//----------------------------------------------------------------------------//

function ImportDbf()

   local cFile := ChooseFile( "Select dbf file :", "dbf" )
   local calias
   local aStruct

   if Upper( SubStr( cFile, Len( cFile ) - 3, 4 ) ) == ".DBF"
      USE ( cFile ) NEW
      cAlias = Alias()
      aStruct = ( cAlias )->( DbStruct() )
      Close( cAlias )
   else
      MsgInfo( "incorrect file type" )
   endif

return aStruct

//----------------------------------------------------------------------------//

function BtnEditField( aFields, aField, nAt )

   local aItem

   DEFAULT nAt := Len( aFields )

   if Valtype( aField[ 3 ] ) == "C"
      aField[ 3 ] = Val( aField[ 3 ] )
   endif

   if Valtype( aField[ 4 ] ) == "C"
      aField[ 4 ] = Val( aField[ 4 ] )
   endif

   aFields[ nAt ] = aField

return nil

//----------------------------------------------------------------------------//

function BtnAddField( aFields, aField, nAt)

   local aItem

   DEFAULT nAt := Len( aFields )

   if Valtype( aField[ 3 ] ) == "C"
      aField[ 3 ] = Val( aField[ 3 ] )
   endif

   if Valtype( aField[ 4 ] ) == "C"
      aField[ 4 ] = Val( aField[ 4 ] )
   endif

   if Len( aFields ) == 0
      nAt = Len( aFields )
   endif

   if nAt == Len( aFields )
      AAdd( aFields, aField )
   else
      ASize( aFields, Len( aFields ) + 1 )
      AIns( aFields, nAt + 1 )
      aFields[ nAt + 1 ] = aField
   endif

return nil

//----------------------------------------------------------------------------//

static function DbfGen( aFields )

   local cPrg  := "local aFields := "
   local aInfo := aFields
   local n, cTempName

   for n = 1 to Len( aInfo )
      cPrg += If( n == 1, "{ ", space(18) ) + '{ "' + ;
              aInfo[ n ][ 1 ] + '", "' + ;
              aInfo[ n ][ 2 ] + '", ' + ;
              AllTrim( Str( aInfo[ n ][ 3 ] ) ) + ", " + ;
              AllTrim( Str( aInfo[ n ][ 4 ] ) ) + "}" + ;
              If( n < Len( aInfo ), ",;", " } " ) + CRLF
   next

return cPrg

//----------------------------------------------------------------------------//
//-------------- functions for dbfs ---------------------------//

function cCheckArea( cDbfName )

   local n      := 2
   local cAlias := cDbfName

   while Select( cAlias ) != 0
      cAlias = cDbfName + AllTrim( Str( n++ ) )
   end

return cAlias

//------------------------------------------------------------------------------

Function Abrimos( cFile, cVia )

   if ! Usamos( cFile, cCheckArea( cFile ) )
      return nil
   endif

return Alias()

//------------------------------------------------------------------------------

function Usamos( fichero, alias )

   local cFichero:= cDbfPath+fichero

   DEFAULT alias:=  Fichero

   USE (cFichero) ALIAS (alias) NEW SHARED VIA "DBFCDX"
   // dbusearea(.t.,,cfichero,alias,.t.)

return  ! NetErr()

//------------------------------------------------------------------------------
