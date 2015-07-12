// Sci.framework has to be copied inside sciedit.app/Contents/frameworks

#include "FiveMac.ch"

static oWnd, oEditor, oBtnSave
static aFunLines, oFunList, out ,oGet
static aNodo := {}, oMsgBar

//----------------------------------------------------------------------------//

function Main()

   local oBar, oSplit ,oSplit2
   local cLog := Space( 20 )

   BuildMenu()

   DEFINE WINDOW oWnd FROM 100, 100 TO 800, 1200 FULL

   BuildButtonBar()

   @ 20, 0 SPLITTER oSplit OF oWnd SIZE  oWnd:nWidth, oWnd:nHeight - 98 ;
    VERTICAL STYLE 2 AUTORESIZE nOr( 16, 2 )

   DEFINE VIEW OF oSplit
   DEFINE VIEW OF oSplit
   DEFINE VIEW OF oSplit

   oSplit:SetPosition( 1, 130 )
   oSplit:SetPosition( 2, oWnd:nWidth - 130 )

   @ 0, 0 SPLITTER oSplit2 OF oSplit:aViews[2] SIZE  oSplit:aViews[2]:nWidth, oSplit:aViews[2]:nHeight ;
      HORIZONTAL STYLE 3 AUTORESIZE nOr( 16, 2 )

   DEFINE VIEW OF oSplit2
   DEFINE VIEW OF oSplit2

   oSplit2:SetPosition( 1, oSplit:nHeight - 120 )

   oEditor = TScintilla():New( 0, 0, (oSplit2:aViews[1]):nWidth , (oSplit2:aViews[1]):nHeight , (oSplit2:aViews[1]))
   oEditor:Anclaje( nOr( 16, 2 ) )
   oEditor:bChange = { || oMsgBar:SetText( "FiveMac IDE " + ;
                                           " Row: " + AllTrim( Str( oEditor:nLine() ) ) + ;
                                           " Col: " + AllTrim( Str( oEditor:nCol() ) ) ),;
                          If( oEditor:GetModify(), oBtnSave:Enable(), oBtnSave:Disable() ),;
                          SelectFunction() }

   // oEditor:Open( "sciedit.prg" )

   @ 0, 0 GET oget VAR cLog MEMO OF oSplit2:aViews[ 2 ] ;
      SIZE oSplit2:aViews[ 2 ]:nWidth, 111

   AAdd( aNodo, oEditor:cFileName )

   BuildLeft ( oSplit:aViews[ 1 ] )
   out:SetSelectItem( Len( aNodo ) )

   BuildRight( oSplit:aViews[ 3 ] )

   @ 0, 10 SAY oMsgBar PROMPT "FiveMac IDE" OF oWnd SIZE 300, 18 RAISED

   ACTIVATE WINDOW oWnd MAXIMIZED

return nil

//----------------------------------------------------------------------------//

function NewFile()

   local cFileName := "noname1.prg", n := 2

   while File( cFileName )
      cFileName = "noname" + AllTrim( Str( n++ ) ) + ".prg"
   end

   if ! File( cFileName )
      MemoWrit( cFileName, '#include "FiveMac.ch"' + CRLF + CRLF + ;
                           "function Main()" + CRLF + CRLF + ;
                           '   MsgInfo( "hello world!" )' + CRLF + CRLF + ;
                           "return nil" )
   endif

   OpenFile( cFileName )

return nil

//----------------------------------------------------------------------------//

static function OpenFile( cFileName )

   if Empty( cFileName )
      oEditor:DlgOpen()
   else
      if File( cFileName )
         oEditor:Open( cFileName )
      else
         MsgAlert( cFileName + " not found!" )
         return nil
      endif
   endif

   RecargaOutline()

   FillFuncList()

return nil

//----------------------------------------------------------------------------//

function BuildButtonBar()

   local oBar

   DEFINE TOOLBAR oBar OF oWnd

   DEFINE BUTTON OF oBar PROMPT "New File" ;
      TOOLTIP "Creates a new file" ;
       IMAGE "./../bitmaps/new.png" ;
       ACTION NewFile()

   DEFINE BUTTON OF oBar PROMPT "Open" ;
      TOOLTIP "Open a file" ;
       IMAGE "./../bitmaps/open.png" ;
       ACTION OpenFile()

   DEFINE BUTTON OF oBar PROMPT "Close" ;
      TOOLTIP "Close this file" ;
       IMAGE "./../bitmaps/folder2.png" ;
       ACTION oEditor:Close()

   DEFINE BUTTON oBtnSave OF oBar PROMPT "Save" ;
      TOOLTIP "Save the file to disk" ;
       IMAGE "./../bitmaps/save.png" ;
       ACTION oEditor:Save(), oBtnSave:Disable()

   oBtnSave:Disable()

   DEFINE BUTTON OF oBar PROMPT "Exit" ;
      TOOLTIP "Exit" ;
       IMAGE "./../bitmaps/exit3.png" ;
       ACTION Exit()

   oBar:AddSeparator()

   DEFINE BUTTON OF oBar PROMPT "Undo" ;
      TOOLTIP "Undo the lastest actions" ;
       IMAGE "./../bitmaps/undo.png" ;
       ACTION oEditor:UnDo()

   DEFINE BUTTON OF oBar PROMPT "Redo" ;
      TOOLTIP "Redo the lastest actions" ;
       IMAGE "./../bitmaps/redo.png" ;
       ACTION oEditor:ReDo()

   oBar:AddSpace()

   DEFINE BUTTON OF oBar PROMPT "Cut" ;
      TOOLTIP "Remove the selected text and put it on the clipboard" ;
       IMAGE "./../bitmaps/cut.png" ;
       ACTION oEditor:Cut()

   DEFINE BUTTON OF oBar PROMPT "Copy" ;
      TOOLTIP "Copy the selected text to the clipboard" ;
       IMAGE "./../bitmaps/copy.png" ;
       ACTION oEditor:Copy()

   DEFINE BUTTON OF oBar PROMPT "Paste" ;
      TOOLTIP "Insert text from the clipboard at the current position" ;
       IMAGE "./../bitmaps/paste.png" ;
       ACTION oEditor:Paste()

   oBar:AddSpace()

   oBar:AddSearch( , "Text to find", { | oGet | oEditor:FindText( oGet:GetText() ) } )

   DEFINE BUTTON OF oBar PROMPT "Find Previous" ;
      TOOLTIP "Repeat the search backwards" ;
       IMAGE "./../bitmaps/prev.png" ;
       ACTION oEditor:FindPrev()

   DEFINE BUTTON OF oBar PROMPT "Find Next" ;
      TOOLTIP "Repeat the search forward" ;
       IMAGE "./../bitmaps/next.png" ;
       ACTION oEditor:FindNext()

   DEFINE BUTTON OF oBar PROMPT "Replace" ;
      TOOLTIP "Search and replace" ;
       IMAGE "./../bitmaps/replace.png" ;
       ACTION oEditor:Replace()

   DEFINE BUTTON OF oBar PROMPT "Goto Line" ;
      TOOLTIP "Go to a line number" ;
       IMAGE "./../bitmaps/goline.png" ;
       ACTION oEditor:DlgGotoLine()

   oBar:AddSpace()

   DEFINE BUTTON OF oBar PROMPT "Run" ;
      TOOLTIP "Build and run" ;
       IMAGE "./../bitmaps/execute.png" ;
       ACTION Run()

   DEFINE BUTTON OF oBar PROMPT "Terminal" ;
      TOOLTIP "Open a terminal window" ;
       IMAGE "./../bitmaps/terminal.png" ;
       ACTION MacExec( "terminal.app" )

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM "SciEdit"
      MENU
         MENUITEM "About" ACTION MsgAbout( "(c) FiveTech Software 2012", "FiveMac IDE", "About" )
         SEPARATOR
         MENUITEM "Preferences..."
         SEPARATOR
         MENUITEM "Exit" ACTION oWnd:End()
      ENDMENU

      MENUITEM "File"
      MENU
         MENUITEM "New"         ACTION NewFile()
         MENUITEM "Open"        ACTION OpenFile()
         MENUITEM "Close"       ACTION oEditor:Close()
         MENUITEM "Save"        ACTION oEditor:Save()
         MENUITEM "Save as..."  ACTION oEditor:SaveAs()
         SEPARATOR
         MENUITEM "Print..."
         SEPARATOR
         MENUITEM "Recent files"
      ENDMENU

      MENUITEM "Edit"
      MENU
         MENUITEM "Undo"  ACTION oEditor:UnDo()
         MENUITEM "Redo"  ACTION oEditor:ReDo()
         SEPARATOR
         MENUITEM "Cut"   ACTION oEditor:Cut()
          MENUITEM "Copy"  ACTION oEditor:Copy()
          MENUITEM "Paste" ACTION oEditor:Paste()
          SEPARATOR
          MENUITEM "Duplicate line" + Chr( 9 ) + Chr( 9 ) + Chr( 9 ) + "F5" ;
             ACTION oEditor:LineDuplicate() ACCELERATOR "F5"
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
         MENUITEM "Terminal"
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

function Exit()

   if oEditor:GetModify()
      if MsgYesNo( "Save the changes ?", "File has changed" )
         oEditor:Save()
      endif
   endif

   oWnd:End()

return nil

//----------------------------------------------------------------------------//

function Run()

   if oEditor:GetModify()
      oEditor:Save()
   endif

   // System( "./build.sh " + cFileNoExt( oEditor:cFileName ) + " > build.log" )

   oGet:SetText( BuildML( cFileNoExt( oEditor:cFileName ) ) )

   MacExec( Path() + "/" + cFileNoExt( oEditor:cFileName ) + ".app" )

return nil

//----------------------------------------------------------------------------//

function BuildRight( oSplit )

   local nFunc := 1

   @ 0, 0 BROWSE oFunList FIELDS "" HEADERS "Functions" OF oSplit SIZE oSplit:nWidth , oSplit:nHeight

   FillFuncList()

   WITH OBJECT oFunList
      :setArray( aFunLines )
      :bLine = { | nRow | { If( Len( aFunLines ) > 0 .and. nRow <= Len( aFunLines ), aFunLines[ nRow ][ 1 ], "" ) } }

       :SetColEditable( 1, .F. )
     // :SetNoHead()
      :SetColWidth( 1, 180 )
      :SetRowHeight( 20 )
      :SetGridLines( 1 )
      :SetSelectorStyle( 1 )
      :Anclaje( nOr( 16, 2 ) )

      :bAction = { || oEditor:GotoLine( aFunLines[ oFunList:nRowPos ][ 2 ] ), oEditor:SetFocus() }
   END

return nil

//----------------------------------------------------------------------------//

function RecargaOutline()

   local oNodo, cFileName := oEditor:cFileName

   AAdd( aNodo, cFileNoPath( cFileName ) )
   oNodo = CreaNodo()

   out:SetRootNode(oNodo)

   if Len( aNodo ) > 0
      out:ExpandAll()
   endif

   out:SetSelectItem( Len( aNodo ) )

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

function CreaNodo()

   local oNode, oNode1, oNode2
   local n

   DEFINE ROOTNODE oNode

   DEFINE NODE oNode1 PROMPT "Files" OF oNode GROUP

   if Len( aNodo ) > 0
      for n =1 to Len( aNodo )
         DEFINE NODE oNode2 PROMPT aNodo[ n ] OF oNode1
      next
   endif

   ACTIVATE ROOTNODE oNode

return oNode

//----------------------------------------------------------------------------//

function BuildLeft( oSplit )

   local oNode
   local oNode1,onode2,oNode3,oNode4

/*
   DEFINE ROOTNODE oNode

   DEFINE NODE oNode1 PROMPT "Files" OF oNode  GROUP

   DEFINE NODE oNode3 PROMPT "Archivo1" OF oNode1
   DEFINE NODE oNode4 PROMPT "Archivo2"  OF oNode1

   ACTIVATE ROOTNODE oNode
*/

   oNode = CreaNodo()

   @ 0, 0 OUTLINE out TITLE "Files" SIZE oSplit:nWidth , oSplit:nHeight OF oSplit ;
          NODE oNode AUTORESIZE nOr( 16, 2 ) ACTION CambiaselectOut()

   out:SetColWidth( 290 )

   if Len( aNodo ) > 0
      out:ExpandAll()
   endif

return nil

//----------------------------------------------------------------------------//

Function CambiaselectOut()

   local cFileName := out:GetSelectItem()

   If cFileName != "Files"
      if cFileNoPath( oEditor:cFileName ) != cFileName
         oEditor:Open( cFileName )
         FillFuncList()
      endif
   endif

Return nil

//----------------------------------------------------------------------------//

function FillFuncList()

   local nLines := oEditor:GetLineCount(), n
   local cToken, cLine

   aFunLines = {}

   for n = 1 to nLines
      cToken = Lower( Left( cLine := oEditor:GetLine( n ), 4 ) )
      if cToken $ "func,proc,clas,meth"
         AAdd( aFunLines, { cLine, n, n + 1 } )
      endif
      if cToken $ "retu" .or. Left( cToken, 1 ) == "}"
         ATail( aFunLines )[ 3 ] = n
      endif
   next

   ASort( aFunLines,,, { | x, y | x[ 1 ] < y[ 1 ] } )

   if oFunList != nil
      oFunList:Refresh()
   endif

return nil

//----------------------------------------------------------------------------//