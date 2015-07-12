// FiveMac source code editor (uses Scintilla controls)

#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TWndCode FROM TWindow

   DATA   oEditor           // Active editor
   DATA   aEditors INIT {}  // Array of in use editors
   DATA   oBar              // Toolbar
   DATA   oBtnSave          // Toolbar Save button
   DATA   oSplitV           // Vertical splitters
   DATA   oMsgBar           // message bar
   DATA   oSayBar           // message bar prompt
   DATA   oTree             // Left side tree
   DATA   oPrgItem          // tree branch for PRGs
   DATA   oFunList          // Functions list browse at rightside
   DATA   aFunLines         // array shown at the rightside
   
   METHOD New()
   
   METHOD AddSource( cName, cCode )
   
   METHOD BuildBar()

   METHOD BuildEditor()
   
   METHOD BuildSplitter()
   
   METHOD BuildLeft()
   
   METHOD BuildMsgBar()
   
   METHOD BuildRight()
   
   METHOD Change()
   
   METHOD CloseFile()
   
   METHOD EditMethod( cMethodName, cClassName, aInfo )
   
   METHOD FunListRefresh()

   METHOD NewFile()

   METHOD OpenFile()

   METHOD Run()
   
   METHOD SaveFile() INLINE ::oEditor:Save(), ::oBtnSave:Disable()
   
   METHOD SelectFile()
   
   METHOD SelectFunction()
   
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS TWndCode

   Super:New()

   ::cText = "code editor"
   ::SetPos( ScreenHeight() - 580, 380 )
   ::SetSize( 900, 500 )  
   ::FullScreen()
   
   ::BuildBar()
   ::BuildMsgbar()
   ::BuildSplitter()
   ::BuildLeft()
   ::BuildRight()
   
return Self  

//----------------------------------------------------------------------------//    

METHOD AddSource( cFileName, cCode ) CLASS TWndCode

   local oItem := ::oPrgItem:AddItem( cFileNoPath( cFileName ),,, ImgPath() + "new.png" )
   
   oItem:Cargo = cFileName
   ::oTree:Rebuild()
   ::oTree:ExpandAll()
   ::oTree:GoBottom()

   ::BuildEditor()
   
   ::oEditor:SetText( cCode )
   ::oEditor:cFileName = cFileName

   ::FunListRefresh()

return nil

//----------------------------------------------------------------------------//    

METHOD BuildBar() CLASS TWndCode

   DEFINE TOOLBAR ::oBar OF Self

   DEFINE BUTTON OF ::oBar PROMPT "New" ;
      IMAGE ImgPath() + "new.png" ;
      ACTION ::NewFile()

   DEFINE BUTTON OF ::oBar PROMPT "Open" ;
      IMAGE ImgPath() + "open.png" ;
      ACTION ::OpenFile()

   DEFINE BUTTON ::oBtnSave OF ::oBar PROMPT "Save" ;
      IMAGE ImgPath() + "save.png" ;
      ACTION ::SaveFile()

   ::oBtnSave:Disable()

   DEFINE BUTTON OF ::oBar PROMPT "Close" ;
      TOOLTIP "Close this file" ;
      IMAGE  ImgPath() + "folder2.png" ;
      ACTION ::CloseFile()
       
   ::oBar:Addspace()

   DEFINE BUTTON OF ::oBar PROMPT "Undo" ;
      TOOLTIP "Undo the lastest actions" ;
       IMAGE  ImgPath() + "undo.png" ;
       ACTION ::oEditor:UnDo()

   DEFINE BUTTON OF ::oBar PROMPT "Redo" ;
      TOOLTIP "Redo the lastest actions" ;
       IMAGE  ImgPath() + "redo.png" ;
       ACTION ::oEditor:ReDo()

   ::oBar:AddSpace()

   DEFINE BUTTON OF ::oBar PROMPT "Cut" ;
      TOOLTIP "Remove the selected text and put it on the clipboard" ;
       IMAGE  ImgPath() + "cut.png" ;
       ACTION ::oEditor:Cut()

   DEFINE BUTTON OF ::oBar PROMPT "Copy" ;
      TOOLTIP "Copy the selected text to the clipboard" ;
       IMAGE  ImgPath() + "copy.png" ;
       ACTION ::oEditor:Copy()

   DEFINE BUTTON OF ::oBar PROMPT "Paste" ;
      TOOLTIP "Insert text from the clipboard at the current position" ;
       IMAGE  ImgPath() + "paste.png" ;
       ACTION ::oEditor:Paste()

   ::oBar:AddSpace()

   ::oBar:AddSearch( , "Text to find",;
                     { | oGet | ::oEditor:FindText( oGet:GetText() ) } )

   DEFINE BUTTON OF ::oBar PROMPT "Previous" ;
      TOOLTIP "Repeat the search backwards" ;
       IMAGE  ImgPath() + "prev.png" ;
       ACTION ::oEditor:FindPrev()

   DEFINE BUTTON OF ::oBar PROMPT "Next" ;
      TOOLTIP "Repeat the search forward" ;
       IMAGE  ImgPath() + "next.png" ;
       ACTION ::oEditor:FindNext()

   DEFINE BUTTON OF ::oBar PROMPT "Replace" ;
      TOOLTIP "Search and replace" ;
       IMAGE ImgPath() + "replace.png" ;
       ACTION ::oEditor:Replace()

   DEFINE BUTTON OF ::oBar PROMPT "Goto Line" ;
      TOOLTIP "Go to a line number" ;
       IMAGE  ImgPath() + "goline.png" ;
       ACTION ::oEditor:DlgGotoLine()

   ::oBar:AddSpace()

   DEFINE BUTTON OF ::oBar PROMPT "Run" ;
       TOOLTIP "Build and run" ;
       IMAGE ImgPath() + "execute.png" ;
       ACTION ::Run()

return nil

//----------------------------------------------------------------------------//    

METHOD BuildEditor() CLASS TWndCode

   ::oEditor = TScintilla():New( 0, 0, ::oSplitV:aViews[ 2 ]:nWidth,;
                                 ::nHeight - 99, ::oSplitV:aViews[ 2 ] )
   ::oEditor:nAutoResize = 18
   
   AAdd( ::aEditors, ::oEditor )

   ::oEditor:bChange = { || ::Change() }
   
return nil   

//----------------------------------------------------------------------------//    

METHOD BuildLeft() CLASS TWndCode

   @ 0, 2 TREE ::oTree ;
      SIZE ::oSplitV:aViews[ 1 ]:nWidth - 2, ::oSplitV:aViews[ 1 ]:nHeight - 9 ;
      OF ::oSplitV:aViews[ 1 ] ;
      TITLE "Files"

   ::oTree:SetColWidth( 100 ) 
   ::oTree:nAutoResize = 18
 
   ::oPrgItem = ::oTree:AddItem( "PRG", ImgPath() + "folder.png" )

   ::oTree:Rebuild()
   ::oTree:ExpandAll()
   
   ::oTree:bAction = { || ::SelectFile() } 

return nil

//----------------------------------------------------------------------------//    

METHOD BuildSplitter() CLASS TWndCode

   @ 21, 0 SPLITTER ::oSplitV OF Self ;
      SIZE ::nWidth, ::nHeight - 92 VERTICAL
   
   ::oSplitV:nAutoResize = 18
     
   DEFINE VIEW OF ::oSplitV
   DEFINE VIEW OF ::oSplitV
   DEFINE VIEW OF ::oSplitV
   
   ::oSplitV:SetPosition( 1, 140 )
   ::oSplitV:SetPosition( 2, ::nWidth - 180 )

return nil

//----------------------------------------------------------------------------// 

METHOD BuildMsgBar() CLASS TWndCode

   DEFINE MSGBAR ::oMsgBar PROMPT "Row: 1  Col: 1" OF Self SIZE 20

return nil

//----------------------------------------------------------------------------//

METHOD BuildRight() CLASS TWndCode

   local oSplitView := ::oSplitV:aViews[ 3 ]

   ::aFunLines = If( ::oEditor != nil, ::oEditor:GetFuncList(), {} )

   @ 0, 0 BROWSE ::oFunList FIELDS "" HEADERS "Functions List" OF oSplitView ;
      SIZE oSplitView:nWidth - 2, oSplitView:nHeight - 9

   WITH OBJECT ::oFunList  
      if ::aFunLines != nil         
         :setArray( ::aFunLines )
         :bLine = { | nRow | { If( Len( ::aFunLines ) > 0 .and. nRow <= Len( ::aFunLines ),;
                               ::aFunLines[ nRow ][ 1 ], "" ) } }
      endif
      :SetColor( CLR_BLACK, CLR_PANE ) 
      :SetColor( CLR_BLACK, CLR_PANE )
      :SetColEditable( 1, .F. ) 
      :SetColWidth( 1, 250 )
      :SetRowHeight( 20 )
      :SetGridLines( 1 )
      :nAutoResize = 18
      :bAction = { || ::oEditor:GotoLine( ::aFunLines[ ::oFunList:nRowPos ][ 2 ] ),;
                      ::oEditor:SetFocus() }   
   END

return nil

//----------------------------------------------------------------------------//  

METHOD Change() CLASS TWndCode

   local nPos := ::oEditor:GetCurrentPos(), nAt

   if Chr( ::oEditor:GetCharAt( nPos ) ) $ "([{}])"
      if ( nAt := ::oEditor:BraceMatch( nPos ) ) != -1
         ::oEditor:BraceHighlight( nPos, nAt )
      else
         ::oEditor:BraceBadLight( nPos, nAt )
      endif
   else
      ::oEditor:BraceBadLight( -1 )
   endif

   if ::oMsgBar != nil
      ::oMsgBar:SetText( " Row: " + AllTrim( Str( ::oEditor:nLine() ) ) + ;
                         "  Col: " + AllTrim( Str( ::oEditor:nCol() ) ) )
   endif

   if ::oEditor:GetModify()
      ::oBtnSave:Enable()
   else
      ::oBtnSave:Disable()
   endif

   ::SelectFunction()

   // AutoIndentation()
   
return nil

//----------------------------------------------------------------------------//  

METHOD CloseFile() CLASS TWndCode

   local nAt, nRow, oItem, oPrevItem

   ::oEditor:Close()

   oItem = ::oTree:GetSelect()
   nRow = ::oTree:RowForItem( oItem )
   oPrevItem = ::oTree:ItemAtRow( nRow - 1 )
   ::oTree:DelItem( oItem )
   ::oTree:ExpandAll()
   ::oTree:Select( oPrevItem )

   if Len( ::aEditors ) > 1 .and. ;
      ( nAt := AScan( ::aEditors, { | oEd | oEd == ::oEditor } ) ) != 0
      ADel( ::aEditors, nAt )
      ASize( ::aEditors, Len( ::aEditors ) - 1 )

      if nAt >= 1 .and. nAt <= Len( ::aEditors )
         ::oEditor:RemoveFromSuperview()
         ::oEditor:End()
         ::oEditor = ::aEditors[ nAt ]
         ::oSplitH:aViews[ 1 ]:AddSubview( ::oEditor )
      endif
   endif

   ::oTree:Click()

return nil

//----------------------------------------------------------------------------//  

METHOD EditMethod( cMethodName, cClassName, aInfo ) CLASS TWndCode

   local nAt, nNext, n
   local cParams := "(" + If( Len( aInfo ) > 1, " ", "" )

   for n = 2 to Len( aInfo )
      cParams += aInfo[ n ] + ", "
   next
   if Len( aInfo ) > 1
      cParams = SubStr( cParams, 1, Len( cParams ) - 2 ) + " "
   endif   
   cParams += ")"

   ::oEditor:GoTop()

   if ::oEditor:FindText( "METHOD " + cMethodName )
      ::oEditor:SetFocus()
   else
      ::oEditor:FindText( "ENDCLASS" )
      ::oEditor:GoUp()
      ::oEditor:AddText( CRLF + "   METHOD " + cMethodName + cParams + CRLF )
      ::oEditor:GoBottom()
      ::oEditor:GoDown()
      ::oEditor:GoDown()
      ::oEditor:AddText( CRLF + CRLF )
      ::oEditor:AddText( "//" + Replicate( "-", 72 ) + "//" + CRLF + CRLF )
      ::oEditor:AddText( "METHOD " + cMethodName + cParams + " CLASS " + cClassName + CRLF + CRLF + CRLF )
      ::oEditor:AddText( "return nil" + CRLF + CRLF )
      ::oEditor:AddText( "//" + Replicate( "-", 72 ) + "//" )
   endif

   ::oEditor:GoUp()
   ::oEditor:GoUp()
   ::oEditor:GoUp()
   ::oEditor:GoNextChar()
   ::oEditor:GoNextChar()
   ::oEditor:GoNextChar()
   ::oEditor:SetFocus()
   
   ::SetFocus()

return nil

//----------------------------------------------------------------------------//  

METHOD FunListRefresh() CLASS TWndCode

   ::aFunLines = ::oEditor:GetFuncList()
   ::oFunList:SetArray( ::aFunLines )
   ::oFunList:bLine = { | nRow | { If( Len( ::aFunLines ) > 0 .and. nRow <= Len( ::aFunLines ),;
                                       ::aFunLines[ nRow ][ 1 ], "" ) } }
   ::oFunList:Refresh()                 

return nil

//----------------------------------------------------------------------------//  

METHOD NewFile() CLASS TWndCode

   local n := 1, cFileName := "edit1" 

   while AScan( ::aEditors,;
         { | oEditor | Lower( cFileNoExt( oEditor:cFileName ) ) == cFileName } ) != 0
      cFileName = "edit" + AllTrim( Str( ++n ) )
   end 

   cFileName += ".prg"           

   ::AddSource( cFileName,;
                '#include "FiveMac.ch"' + CRLF + CRLF + ;
                "function Start()" + CRLF + CRLF + ;
                '   MsgInfo( "Hello world" )' + CRLF + CRLF + ;
                "return nil" )

return nil

//----------------------------------------------------------------------------//  

METHOD OpenFile() CLASS TWndCode

   local cFileName := ChooseFile( "Select source to open", "prg" )
   
   if File( cFileName )
      ::AddSource( cFileName, MemoRead( cFileName ) )
      ::oEditor:SetFocus()
   endif   

return nil

//----------------------------------------------------------------------------//

METHOD Run() CLASS TWndCode

   Execute( ::oEditor:GetText() )

return nil

//----------------------------------------------------------------------------//  

METHOD SelectFile() CLASS TWndCode

   local oItem := ::oTree:GetSelect(), cFileName, nAt

   if oItem == nil
      return nil
   endif   

   if ::oEditor:cFileName == oItem:Cargo
      return nil
   endif

   if oItem != nil .and. ! oItem:cName $ "PRG,CH,M"
      cFileName = oItem:Cargo
 
      if ( nAt := AScan( ::aEditors,;
         { | oEd | oEd:cFileName == cFileName .and. ! oEd == ::oEditor } ) ) != 0
         ::oSplitV:aViews[ 2 ]:AddSubview( ::aEditors[ nAt ] )

         ::aEditors[ nAt ]:nWidth  = ::oSplitV:aViews[ 2 ]:nWidth   
         ::aEditors[ nAt ]:nHeight = ::oSplitV:aViews[ 2 ]:nHeight - 7   

         ::oEditor:RemoveFromSuperview()
         ::oEditor = ::aEditors[ nAt ]
         
      else
         ::BuildEditor()
         ::oEditor:Open( cFileName )
      endif
      
      ::FunListRefresh() 
         
      if Lower( cFileExt( cFileName ) ) != "ch"
         ::oFunList:aCols[ 1 ]:SetHeader( "Functions" )
      else
         ::oFunList:aCols[ 1 ]:SetHeader( "Commands" )
      endif

   endif

return nil

//----------------------------------------------------------------------------//  

METHOD SelectFunction() CLASS TWndCode

   local nAt, nLine := ::oEditor:nLine()

   if Len( ::aFunLines ) > 0 .and. ;
      ( nAt := AScan( ::aFunLines, { | u | u[ 2 ] <= nLine .and. ;
                                           u[ 3 ] >= nLine } ) ) != 0
      ::oFunList:Select( nAt )
   endif

return nil

//----------------------------------------------------------------------------//  