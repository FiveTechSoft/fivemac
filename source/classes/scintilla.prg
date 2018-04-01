#include "FiveMac.ch"
#include "Scintilla.ch"
#include "Colors.ch"

#define markerBookmark    1
#define IBNCaretChanged 1

#include "fmsgs.h"

//----------------------------------------------------------------------------//

CLASS TScintilla FROM TControl

   DATA hWnd
   
   DATA aCopys
   DATA aKey             AS ARRAY INIT {}
   
   DATA cFileName
   DATA cFilePath
   
   DATA cLastFind
   DATA bChange
   DATA oRowItem, oColItem
   DATA aCopys
   DATA aKey			AS ARRAY INIT {}
   DATA nSetStyle
   DATA lLinTabs
   DATA aBookMarker    INIT {}
   DATA aMarkerHand      INIT {}

   DATA lIndicators      INIT .F.

   DATA cCComment        INIT { CLR_GRAY, CLR_WHITE, SC_CASE_MIXED, } //HGRAY
   DATA cCCommentLin     INIT { CLR_GRAY, CLR_WHITE, SC_CASE_MIXED, }
   DATA cCString         INIT { CLR_HRED, CLR_WHITE, SC_CASE_MIXED, }
   DATA cCNumber         INIT { CLR_RED, CLR_WHITE, SC_CASE_MIXED, }
   DATA cCOperator       INIT { CLR_BLUE, CLR_WHITE, SC_CASE_MIXED, }
   DATA cCBraces         INIT { CLR_BLUE, CLR_YELLOW, SC_CASE_MIXED, }
   DATA cCBraceBad       INIT { CLR_HRED, CLR_YELLOW, SC_CASE_MIXED, }
   DATA cCIdentif        INIT { CLR_GREEN, CLR_WHITE, SC_CASE_MIXED, } //MAGENTA
   DATA cCKeyw1          INIT { METRO_ORANGE, CLR_WHITE, SC_CASE_MIXED, } //CYAN
   DATA cCKeyw2          INIT { METRO_ORANGE, CLR_WHITE, SC_CASE_MIXED, } // METRO_BROWN
   DATA cCKeyw3          INIT { METRO_BROWN, CLR_WHITE, SC_CASE_MIXED, }  // CLR_BLUE
   DATA cCKeyw4          INIT { CLR_BLUE, CLR_WHITE, SC_CASE_MIXED, } //METRO_CYAN
   DATA cCKeyw5          INIT { METRO_CYAN, CLR_WHITE, SC_CASE_MIXED, } //METRO_MAUVE   // STEEL


   CLASSDATA cLineBuffer

   METHOD New( nTop, nLeft, nBottom, nRight, oWnd )
 
   METHOD AddText( cText )          INLINE ::Send( SCI_ADDTEXT, len( cText ), cText )
   METHOD AddTextCRLF( cText )      INLINE ::Send( SCI_ADDTEXT, Len( cText )+2, cText+CRLF )

   METHOD AutoIndent()

   METHOD Backtab()                 INLINE ::Send( SCI_BACKTAB )

   METHOD BookmarkClearAll()
   METHOD BookmarkNext( lForwardScan, lSelect )

   METHOD BraceBadLight( nPos1, nPos2 )        INLINE ::Send( SCI_BRACEBADLIGHT, nPos1, nPos2 )
   METHOD BraceHighLight( nPos1, nPos2 )       INLINE ::Send( SCI_BRACEHIGHLIGHT, nPos1, nPos2 )
   METHOD BraceMatch( nPos )                   INLINE ::Send( SCI_BRACEMATCH, nPos )

   METHOD CallTipCancel()                      INLINE ::Send( SCI_CALLTIPCANCEL )

   METHOD CallTipShow( nPos, cText )           INLINE ::Send( SCI_CALLTIPSHOW, nPos, cText )

    METHOD CanRedo()                           INLINE ::Send( SCI_CANREDO ) != 0
    METHOD CanUndo()                           INLINE ::Send( SCI_CANUNDO ) != 0
    METHOD Cancel ()                           INLINE ::Send( SCI_CANCEL )

    METHOD CharAdded( nChar )

    METHOD Charleft ()                         INLINE ::Send( SCI_CHARLEFT )
    METHOD Charleftextend ()                   INLINE ::Send( SCI_CHARLEFTEXTEND )
    METHOD Charleftrectextend ()               INLINE ::Send( SCI_CHARLEFTRECTEXTEND )
    METHOD Charright ()                        INLINE ::Send( SCI_CHARRIGHT )
    METHOD Charrightextend ()                  INLINE ::Send( SCI_CHARRIGHTEXTEND )
    METHOD Charrightrectextend ()              INLINE ::Send( SCI_CHARRIGHTRECTEXTEND )
    METHOD ClearAll()                          INLINE ::Send( SCI_CLEARALL )

    METHOD Close()

    METHOD Copy()           INLINE ::Send( SCI_COPY )
    METHOD CopyLine()       INLINE ::Send( SCI_LINECOPY )
    METHOD CopyRange( nStart, nEnd )           INLINE ::Send( SCI_COPYRANGE, nStart, nEnd )
    METHOD CopyText( cCad )                    INLINE ::Send( SCI_COPYTEXT, Len( cCad ), cCad )

    
    METHOD Cut()            INLINE ::Send( SCI_CUT )

    METHOD Deleteback()                        INLINE ::Send( SCI_DELETEBACK )
    METHOD Deletebacknotline ()                INLINE ::Send( SCI_DELETEBACKNOTLINE )
    METHOD Dellineleft()                       INLINE ::Send( SCI_DELLINELEFT )
    METHOD Dellineright()                      INLINE ::Send( SCI_DELLINERIGHT )
    METHOD Delwordleft()                       INLINE ::Send( SCI_DELWORDLEFT )
    METHOD Delwordright()                      INLINE ::Send( SCI_DELWORDRIGHT )

    METHOD DlgGotoLine()

    METHOD DlgOpen()

    METHOD Documentend()                       INLINE ::Send( SCI_DOCUMENTEND )
    METHOD Documentendextend()                 INLINE ::Send( SCI_DOCUMENTENDEXTEND )
    METHOD Documentstart()                     INLINE ::Send( SCI_DOCUMENTSTART )
    METHOD Documentstartextend()               INLINE ::Send( SCI_DOCUMENTSTARTEXTEND )

    METHOD EmptyUndoBuffer()                   INLINE ::Send( EM_EMPTYUNDOBUFFER )


   METHOD FindNext() INLINE ::SearchForward()

   METHOD FindPrev() INLINE ::SearchBackward()

   METHOD FindText( cText, lForward ) INLINE SciFindText( ::hWnd, cText, lForward )

   METHOD FoldAllContract()                   INLINE ::Send( SCI_FOLDALL, SC_FOLDACTION_CONTRACT, 0 )
   METHOD FoldAllExpand()                     INLINE ::Send( SCI_FOLDALL, SC_FOLDACTION_EXPAND, 0 )
   METHOD FoldAllToggle()                     INLINE ::Send( SCI_FOLDALL, SC_FOLDACTION_TOGGLE, 0 )
   METHOD FoldLevelNumber()                   INLINE ::Send( SCI_SETFOLDFLAGS, SC_FOLDFLAG_LEVELNUMBERS, 0 )
   METHOD FoldLineNumber()                    INLINE ::Send( SCI_SETFOLDFLAGS, SC_FOLDFLAG_LINEAFTER_CONTRACTED, 0 )
   METHOD FoldLineSt()                        INLINE ::Send( SCI_SETFOLDFLAGS, 128, 0 )
   
   METHOD GetAnchor()                         INLINE SciGetProp( ::hWnd, SCI_GETANCHOR )
   METHOD GetCaretLineBack()                  INLINE SciGetProp( ::hWnd, SCI_GETCARETLINEBACK )
   
   METHOD GetCharAt( nPos ) INLINE SciGetProp( ::hWnd, SCI_GETCHARAT, nPos )

   METHOD GetTextColor( cType )

   METHOD GetCurrentLine()  INLINE SciGetProp( ::hWnd, SCI_LINEFROMPOSITION, ::GetCurrentPos() )

   METHOD GetCurrentPos()   INLINE SciGetProp( ::hWnd, SCI_GETCURRENTPOS )

   METHOD GetFuncList()

   METHOD GetIndent()       INLINE SciGetProp( ::hWnd, SCI_GETINDENT )

   METHOD GetLine( nLine )  INLINE SciGetLine( ::hWnd, nLine )

   METHOD GetLineCount()    INLINE SciGetProp( ::hWnd, SCI_GETLINECOUNT )

   METHOD GetLineIndentation( nLine ) INLINE SciGetProp( ::hWnd, SCI_GETLINEINDENTATION, nLine )

   METHOD GetModify()       INLINE SciGetProp( ::hWnd, SCI_GETMODIFY ) == 1

   METHOD GetProp ( xProp, xValue )   INLINE SciGetProp(::hWnd, xProp, xValue )

   METHOD GetSelText()      INLINE SciGetSelText( ::hWnd )

   METHOD GetText()         INLINE SciGetText( ::hWnd )

    METHOD GoDown()                            INLINE ::Send( SCI_LINEDOWN )
    METHOD GoTop()                             INLINE ::Send( SCI_HOME )
    METHOD GoBottom()                          INLINE ::Send( SCI_SCROLLTOEND )
    METHOD GoEol()                             INLINE ::Send( SCI_LINEEND )
    METHOD GoHome()                            INLINE ::Send( SCI_HOME )
    METHOD GoLeft()                            INLINE ::CharLeft()
    METHOD GoRight()                           INLINE ::CharRight()
    METHOD GoUp()                              INLINE ::Send( SCI_LINEUP )

    METHOD GotoLine( nLine ) INLINE ::Send( SCI_GOTOLINE, nLine - 1, 0 )

    METHOD GotoLineEnsureVisible( nextline )

    METHOD GoNextChar() INLINE ::GotoPos( ::GetCurrentPos() + 1 )

    METHOD GotoPos( nPos )   INLINE ::Send( SCI_GOTOPOS, nPos )

    METHOD GoUp()  INLINE ::Send( SCI_LINEUP )
   
    METHOD HandleEvent( nMsg, uParam1, uParam2, uParam3 )
    
    METHOD Home ()                       INLINE ::Send( SCI_HOME )
    METHOD Homedisplay ()                INLINE ::Send( SCI_HOMEDISPLAY )
    METHOD Homedisplayextend ()          INLINE ::Send( SCI_HOMEDISPLAYEXTEND )
    METHOD Homeextend ()                 INLINE ::Send( SCI_HOMEEXTEND )
    METHOD Homerectextend ()             INLINE ::Send( SCI_HOMERECTEXTEND )
    METHOD Homewrap ()                   INLINE ::Send( SCI_HOMEWRAP )
    METHOD Homewrapextend ()             INLINE ::Send( SCI_HOMEWRAPEXTEND )

    METHOD InsertText( nPos, cText )     INLINE ::Send( SCI_INSERTTEXT, nPos, cText )

    METHOD IntelliSense( nChar )

    METHOD LineFromPosition( nPos )      INLINE ::GetProp( SCI_LINEFROMPOSITION, nPos, 0 )
    METHOD LineLength( nLine )           INLINE ::Send( SCI_LINELENGTH, nLine - 1, 0 )
    METHOD LineCopy ()                   INLINE ::Send( SCI_LINECOPY )
    METHOD LineCut ()                    INLINE ::Send( SCI_LINECUT )
    METHOD LineDelete ()                 INLINE ::Send( SCI_LINEDELETE )
    METHOD LineDown ()                   INLINE ::Send( SCI_LINEDOWN )
    METHOD LineDownextend()              INLINE ::Send( SCI_LINEDOWNEXTEND )
    METHOD LineDownrectextend()          INLINE ::Send( SCI_LINEDOWNRECTEXTEND )
    METHOD LineDuplicate()               INLINE ::Send( SCI_LINEDUPLICATE )
    METHOD LineEnd ()                    INLINE ::Send( SCI_LINEEND )
    
    METHOD LineEnddisplay ()             INLINE ::Send( SCI_LINEENDDISPLAY )
    METHOD LineEnddisplayextend ()       INLINE ::Send( SCI_LINEENDDISPLAYEXTEND )
    METHOD LineEndextend ()              INLINE ::Send( SCI_LINEENDEXTEND )
    METHOD LineEndrectextend ()          INLINE ::Send( SCI_LINEENDRECTEXTEND )
    METHOD LineEndwrap ()                INLINE ::Send( SCI_LINEENDWRAP )
    METHOD LineEndwrapextend ()          INLINE ::Send( SCI_LINEENDWR )
    METHOD LinesScreen()                 INLINE ::Send( SCI_LINESONSCREEN )
  
   METHOD LineScrolldown ()              INLINE ::Send( SCI_LINESCROLLDOWN )
   METHOD LineScrollup()                 INLINE ::Send( SCI_LINESCROLLUP )
   METHOD LineTranspose ()               INLINE ::Send( SCI_LINETRANSPOSE )
   METHOD LineSep()
   METHOD LineUp()                       INLINE ::Send( SCI_LINEUP )

   METHOD LineUpExtend()                 INLINE ::Send( SCI_LINEUPEXTEND )
   METHOD Lineuprectextend ()            INLINE ::Send( SCI_LINEUPRECTEXTEND )

   METHOD Lowercase()                    INLINE ::Send( SCI_LOWERCASE )

   METHOD nCol()                    INLINE ::GetCurrentPos() - ::PositionFromLine( ::nLine() - 1 ) + 1

   METHOD MarginClick( nMargen, nPos )

   METHOD NewLine()                 INLINE ::Send( SCI_NEWLINE )
 
   METHOD nLine()                   INLINE SciGetProp( ::hWnd, SCI_LINEFROMPOSITION, ::GetCurrentPos() ) + 1
 
   METHOD Notify( nType, nValue )
    
   METHOD Open( cFileName )

   METHOD Pagedown()              	 INLINE ::Send( SCI_PAGEDOWN )
   METHOD Pagedownextend ()     	   INLINE ::Send( SCI_PAGEDOWNEXTEND )
   METHOD Pagedownrectextend () 		 INLINE ::Send( SCI_PAGEDOWNRECTEXTEND )
   METHOD Pageup()             	  	 INLINE ::Send( SCI_PAGEUP )
   METHOD PageUpextend()        	 	 INLINE ::Send( SCI_PAGEUPEXTEND )
   METHOD Pageuprectextend()   			 INLINE ::Send( SCI_PAGEUPRECTEXTEND )
   METHOD Paradown ()           	 	 INLINE ::Send( SCI_PARADOWN )
   METHOD Paradownextend ()    	  	 INLINE ::Send( SCI_PARADOWNEXTEND )
   METHOD Paraup ()            		   INLINE ::Send( SCI_PARAUP )
   METHOD Paraupextend ()       	 	 INLINE ::Send( SCI_PARAUPEXTEND )
   METHOD Paste()                		 INLINE ::Send( SCI_PASTE )
   METHOD PositionFromLine( nLine )  INLINE SciGetProp( ::hWnd, SCI_POSITIONFROMLINE, nLine, 0 )
   METHOD PositionEndLine( nLine )   INLINE ::Send( SCI_GETLINEENDPOSITION, nLine, 0 )
   
   METHOD ReDo() INLINE ::Send( SCI_REDO )

   METHOD ReplaceSel( cText )      INLINE ::Send( SCI_REPLACESEL,len( cText ), cText  )

   METHOD Save()
   METHOD SaveAS( cFileName )

   METHOD ScrollToEnd() INLINE ::Send( SCI_SCROLLTOEND )

   METHOD SearchBackward( cText, nFlags )

   METHOD SearchForward( cText, nFlags )

   METHOD SelectAll()       INLINE ::Send( SCI_SETSEL, 0, -1 )

   METHOD Send( nMsg, nWParam, nLParam ) INLINE SciSend( ::hWnd, nMsg, nWParam, nLParam )

   METHOD SetAnchor( nAnchor ) INLINE ::Send( SCI_SETANCHOR, nAnchor )

   METHOD SetAStyle( style, fore, back, size, face )

   METHOD SetBackspaceUnindents( nSize ) INLINE ::Send( SCI_SETBACKSPACEUNINDENTS, nSize )

   METHOD SetColorCaret( nColor, lVisible )

   METHOD SetColor( nClrText, nClrPane )
   METHOD SetColourise( lOnOff )

   METHOD SetCurrentPos( nPos ) INLINE ::Send( SCI_SETCURRENTPOS, nPos )
   METHOD SetCursor( nMode )    INLINE ::Send( SCI_SETCURSOR, nMode, 0 )

   METHOD SetEdgeColour( nColor ) INLINE ::Send( SCI_SETEDGECOLOUR, nColor )

   METHOD SetEdgeColumn( nCol ) INLINE ::Send( SCI_SETEDGECOLUMN, nCol )

   METHOD SetEdgeMode( nMode ) INLINE ::Send( SCI_SETEDGEMODE, nMode )

   METHOD SetEOL( lOn )

   METHOD SetFont( cFontName, nSize, lBold, lItalic ) INLINE ;
                   SciSetFont( ::hWnd, cFontName, nSize, lBold, lItalic )

   METHOD SetIndent( nSize, lOn )
   
   METHOD SetIndicators()

   METHOD GetKeyWords( cKeyWords, nIndex ) INLINE SciGetKeyWords( ::hWnd, cKeyWords, nIndex )

   METHOD SetLexerProp ( cProp, cValue) INLINE SciSetLexerProp( ::hWnd, cProp, cValue  )

   METHOD SetLineIndentation( nLine, nSize ) INLINE ::Send( SCI_SETLINEINDENTATION, nLine, nSize )

   METHOD SetLinIndent( lOnOff, lSinc )

   METHOD SetMargin( lOn )
   
   METHOD SetMBrace()

   METHOD SetReadOnly( lOn )      INLINE ::Send( SCI_SETREADONLY, If( lOn, 1, 0 ), 0 )

   METHOD SetSavePoint()          INLINE ::Send( SCI_SETSAVEPOINT )

   METHOD SetSel( nAnchor, nPos ) INLINE ::Send( SCI_SETSEL, nAnchor, nPos )

   METHOD SetTabIndents( nSize )  INLINE ::Send( SCI_SETTABINDENTS, nSize )

  //  METHOD SetText( cText ) INLINE SciSetText( ::hWnd, cText )

   METHOD SetText( cText )        INLINE ::Send( SCI_SETTEXT, 0, cText )

   METHOD SetTextColor( cType, nRGBColor )

   METHOD SetToggle()

   METHOD SetToggleMark()

   METHOD SetUndoCollection()     INLINE ::Send( SCI_SETUNDOCOLLECTION )

   METHOD Setup()

   METHOD SetUseTabs( lYesNo ) INLINE ::Send( SCI_SETUSETABS, If( lYesNo, 1, 0 ) )

   METHOD SetViewSpace( lOn )
   METHOD SetZoom( nZoom )

    METHOD Stutteredpagedown()                 INLINE ::Send( SCI_STUTTEREDPAGEDOWN )
    METHOD StutteredpagedownextenD()           INLINE ::Send( SCI_STUTTEREDPAGEDOWNEXTEND )
    METHOD Stutteredpageup()                   INLINE ::Send( SCI_STUTTEREDPAGEUP )
    METHOD Stutteredpageupextend ()            INLINE ::Send( SCI_STUTTEREDPAGEUPEXTEND )
    
    METHOD StylereSetDefault()                 INLINE ::Send( SCI_STYLERESETDEFAULT, 0, 0 )

    METHOD StyleSet( nStyle )				   INLINE ( ::nSetStyle := nStyle )

    METHOD StyleSetBold(  lBold )              INLINE ::Send( SCI_STYLESETBOLD  , ::nSetStyle, if( lBold, 1, 0 ) )
    METHOD StyleSetItalic( lItalic )           INLINE ::Send( SCI_STYLESETITALIC, ::nSetStyle, if( lItalic, 1, 0 ) )
    METHOD StyleSetUnderline( lUnderline )     INLINE ::Send( SCI_STYLESETUNDERLINE, ::nSetStyle, if( lUnderline, 1, 0 ) )
    METHOD StyleSetFont( cFontName )           INLINE ::Send( SCI_STYLESETFONT, ::nSetStyle, cFontName )
    METHOD StyleSetSize( nSize )               INLINE ::Send( SCI_STYLESETSIZE, ::nSetStyle, nSize )

    METHOD StyleSetColor( nClrFore, nClrBack )

    METHOD Tab()                               INLINE ::Send( SCI_TAB )
    METHOD UnDo()                              INLINE ::Send( SCI_UNDO )
    METHOD Uppercase()                         INLINE ::Send( SCI_UPPERCASE )

    METHOD Vchome()                            INLINE ::Send( SCI_VCHOME )
    METHOD Vchomeextend()                      INLINE ::Send( SCI_VCHOMEEXTEND )
    METHOD Vchomerectextend()                  INLINE ::Send( SCI_VCHOMERECTEXTEND )
    METHOD Vchomewrap()                        INLINE ::Send( SCI_VCHOMEWRAP )
    METHOD Vchomewrapextend ()                 INLINE ::Send( SCI_VCHOMEWRAPEXTEND )

    METHOD Wordleft ()                         INLINE ::Send( SCI_WORDLEFT )
    METHOD Wordleftend ()                      INLINE ::Send( SCI_WORDLEFTEND )
    METHOD Wordleftendextend ()                INLINE ::Send( SCI_WORDLEFTENDEXTEND )
    METHOD Wordleftextend ()                   INLINE ::Send( SCI_WORDLEFTEXTEND )
    METHOD Wordpartleft ()                     INLINE ::Send( SCI_WORDPARTLEFT )
    METHOD Wordpartleftextend ()               INLINE ::Send( SCI_WORDPARTLEFTEXTEND )
    METHOD Wordpartright ()                    INLINE ::Send( SCI_WORDPARTRIGHT )
    METHOD Wordpartrightextend ()              INLINE ::Send( SCI_WORDPARTRIGHTEXTEND )
    METHOD Wordright ()                        INLINE ::Send( SCI_WORDRIGHT )
    METHOD Wordrightend ()                     INLINE ::Send( SCI_WORDRIGHTEND )
    METHOD Wordrightendextend ()               INLINE ::Send( SCI_WORDRIGHTENDEXTEND )
    METHOD Wordrightextend ()                  INLINE ::Send( SCI_WORDRIGHTEXTEND )


 

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TScintilla
   ::hWnd = SciCreate( nTop, nLeft, nBottom, nRight, oWnd:hWnd )
   ::oWnd = oWnd

   oWnd:AddControl( Self )

   ::Setup()
   ::brclicked:= { ||  msginfo("rclick")    }
  
   ::cCBraces      := { CLR_BLUE, CLR_YELLOW, SC_CASE_MIXED, }
   ::cCBraceBad    := { CLR_HRED, CLR_YELLOW, SC_CASE_MIXED, }
  

return Self

//----------------------------------------------------------------------------//
#define markerBookmark 	1

METHOD SetToggle() CLASS TScintilla
Local lSw   := .F.
local nLine := ::GetCurrentLine()
   msginfo(nLine)
   if SciGetProp( ::hWnd,SCI_MARKERGET, nLine ) == 0
      ::Send( SCI_MARKERADD, nLine, markerBookmark )
     else
      ::Send( SCI_MARKERDELETE, nLine, markerBookmark )
   endif

return lSw

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

METHOD StyleSetColor( nClrFore, nClrBack ) CLASS TScintilla

   if Valtype( nClrFore ) == 'N'
      ::Send( SCI_STYLESETFORE, ::nSetStyle, nClrFore )
   endif

   if Valtype( nClrBack ) == 'N'
      ::Send( SCI_STYLESETBACK, ::nSetStyle, nClrBack )
   endif

return nil

//----------------------------------------------------------------------------//


METHOD SetColor( nClrText, nClrPane, lIni ) CLASS TScintilla

local x
//DEFAULT nClrText  := ::nClrText
//DEFAULT nClrPane  := ::nClrPane
DEFAULT lIni      := .F.

//::nClrText = nClrText
//::nClrPane = nClrPane

if lIni
//::StylereSetDefault()
For x = 0 to 31 //255
::StyleSet( x )
::StyleSetColor( nClrText, nClrPane )
Next x
endif

::Send( SCI_STYLESETFORE, STYLE_DEFAULT, nClrText )
::Send( SCI_STYLESETBACK, STYLE_DEFAULT, nClrPane )

return nil

//----------------------------------------------------------------------------//

METHOD BookmarkNext( lForwardScan, lSelect )  CLASS TScintilla

   LOCAL lineno      := ::GetCurrentLine()
   LOCAL sci_marker   := SCI_MARKERNEXT
   LOCAL lineStart      := lineno + 1      //Scan starting from next line
   LOCAL lineRetry      := 0            //If not found, try from the beginning
   LOCAL anchor      := ::Send( SCI_GETANCHOR )
   LOCAL nextline

   DEFAULT lForwardScan    := .T.
   DEFAULT lSelect         := .F.

   if ! lForwardScan
      lineStart   := lineno - 1                  //Scan starting from previous line
      lineRetry   := ::Send(SCI_GETLINECOUNT, 0, 0)   //If not found, try from the end
      sci_marker   := SCI_MARKERPREVIOUS
   endif

   * nextLine   := ::Send( sci_marker, lineRetry, 1 << markerBookmark )
   nextLine   := ::Send( sci_marker, lineStart, -1  )

   if nextLine < 0
      * nextLine   := ::Send( sci_marker, lineRetry, 1 << markerBookmark )
      nextLine   := ::Send( sci_marker, lineRetry , -1 )
   endif

   if ( nextLine < 0 .OR. nextLine == lineno )   // No bookmark (of the given type) or only one, and already on it

      Msginfo( 'No bookmarks...' )

     else

        ::GotoLineEnsureVisible(nextLine);

      //if (select)
      //   wEditor.Call(SCI_SETANCHOR, anchor);
      //

   endif

retu nil

//----------------------------------------------------------------------------//

METHOD SetColorCaret( nColor, lVisible ) CLASS TScintilla

   local nVisible
   DEFAULT nColor    := ::nCaretBackColor
   DEFAULT lVisible  := .T.

   nVisible          := if( lVisible, 1, 0 )
   ::Send( SCI_SETCARETLINEBACK, nColor )
   ::Send( SCI_SETCARETLINEVISIBLE, nVisible )

Return nColor

//----------------------------------------------------------------------------//

METHOD SetIndicators() CLASS TScintilla

   if ::lIndicators
      ::Send( SCI_INDICSETSTYLE, 10, INDIC_SQUIGGLE )
      ::Send( SCI_INDICSETSTYLE, 11, INDIC_TT )
      ::Send( SCI_INDICSETSTYLE, 12, INDIC_PLAIN )
      ::Send( SCI_INDICSETSTYLE, 13, INDIC_DOTBOX )
      ::Send( SCI_INDICSETSTYLE, 14, INDIC_DOTS )
      ::Send( SCI_INDICSETSTYLE, 15, INDIC_BOX )
      ::Send( SCI_INDICSETSTYLE, 16, INDIC_ROUNDBOX )
      ::Send( SCI_INDICSETSTYLE, 17, INDIC_STRAIGHTBOX )
      ::Send( SCI_INDICSETSTYLE, 18, INDIC_FULLBOX )
      ::Send( SCI_INDICSETSTYLE, 19, INDIC_DASH )
      ::Send( SCI_INDICSETSTYLE, 20, INDIC_TEXTFORE )
      ::Send( SCI_INDICSETSTYLE, 21, INDIC_HIDDEN )

      //::Send( SCI_BRACEHIGHLIGHTINDICATOR, 1, 15 )
      //::Send( SCI_BRACEBADLIGHTINDICATOR, 1, 18 )

   endif

Return nil


//----------------------------------------------------------------------------//

METHOD SetAStyle( style, fore, back, size, face ) CLASS TScintilla

DEFAULT size := 0
DEFAULT face := ""
DEFAULT back := CLR_WHITE

::Send( SCI_STYLESETFORE, style, fore )
::Send( SCI_STYLESETBACK, style, back )

if size >= 1
::Send( SCI_STYLESETSIZE, style, size )
endif
if ! Empty( face )
::Send( SCI_STYLESETFONT, style, face )
endif

return nil


//----------------------------------------------------------------------------//

METHOD SetIndent( nSize, lOn ) CLASS TScintilla

DEFAULT lOn := If( ::Send( SCI_GETINDENTATIONGUIDES, 0, 0 ) == 0, .T., .F. )

if lOn
    ::Send( SCI_SETINDENTATIONGUIDES, SC_IV_LOOKBOTH )
else
    ::Send( SCI_SETINDENTATIONGUIDES, SC_IV_NONE )
endif

if !Empty(nSize)
  ::Send( SCI_SETINDENT, nSize )
endif

retu nil


//----------------------------------------------------------------------------//

METHOD GetFuncList() CLASS TScintilla

   local nLines := ::GetLineCount(), n
   local cToken, cLine, aFunLines := {}
   // local cCommands := ""

   for n = 1 to nLines
      cToken = Lower( Left( cLine := LTrim( ::GetLine( n ) ), 4 ) )
      if cToken $ "func,proc,clas,meth" .and. ;
         Lower( cFileExt( ::cFileName ) ) $ "prg,ch"
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

   // To generate docs automatically!
   // if Lower( cFileExt( ::cFileName ) ) == "ch"
   //    AEval( aFunLines, { | a | cCommands += a[ 1 ] + CRLF } )
   //    MemoWrit( "commands.txt", cCommands )
   // endif

return aFunLines

//----------------------------------------------------------------------------//

METHOD GotoLineEnsureVisible( nextline )  CLASS TScintilla

   ::Send( SCI_ENSUREVISIBLEENFORCEPOLICY, nextline )
    ::Send( SCI_GOTOLINE, nextline )

return nil

//----------------------------------------------------------------------------//

METHOD BookmarkClearAll() CLASS TScintilla

   ::Send( SCI_MARKERDELETEALL, markerBookmark )

retu nil

//----------------------------------------------------------------------------//

METHOD SetToggleMark() CLASS TScintilla
Local lSw   := .F.
Local nLine := ::GetCurrentLine()
Local nPos


if ::GetProp( SCI_MARKERGET, nLine ) == 0  //.or.
        AAdd( ::aMarkerHand, ::Send( SCI_MARKERADD, nLine, 4 ) )
        AAdd( ::aBookMarker, nLine + 1 )
        lSw := .T.
         msginfo(len(::aBookMarker))
else
 msginfo("borra")
::Send( SCI_MARKERDELETE, nLine, 4 )
    nPos := AScan( ::aBookMarker, nLine + 1 )
    if !Empty( nPos )
       ADel( ::aBookMarker, nPos )
       ASize( ::aBookMarker, Len( ::aBookMarker ) - 1 )
       ::Send( SCI_MARKERDELETEHANDLE, ::aMarkerHand[ nPos ] )
       ADel( ::aMarkerHand, nPos )
       ASize( ::aMarkerHand, Len( ::aMarkerHand ) - 1 )
    endif
endif

Return lSw

//----------------------------------------------------------------------------//

METHOD SetEOL( lOn ) CLASS TScintilla

   DEFAULT lOn := If( ::Send( SCI_GETVIEWEOL ) == 0, .T., .F. )

   if lOn
       ::Send( SCI_SETVIEWEOL, 1 )
   else
       ::Send( SCI_SETVIEWEOL, 0 )
    endif

return nil

//----------------------------------------------------------------------------//

METHOD SetLinIndent( lOnOff, lSinc )  CLASS TScintilla
Local nOp  := 0
DEFAULT lOnOff := .T.
DEFAULT lSinc  := .F.
nOp := IF( lOnOff, 1 , 0 )
//::lLinTabs     := !lOnOff
// Lineas verticales de Tabuladores
if lOnOff //::lLinTabs
   ::Send( SCI_SETINDENTATIONGUIDES , 1, 0 )  //0,2,3
   if !Empty( nOp )
     ::Send( SCI_SETHIGHLIGHTGUIDE, 30, 0)
   endif
   ::lLinTabs := .F.
else
   ::Send( SCI_SETINDENTATIONGUIDES , 0, 0 )  //0,2,3
   ::lLinTabs := .T.
endif
if lSinc
 ::Refresh()
endif

Return nil

//----------------------------------------------------------------------------//

METHOD SetMargin( lOn ) CLASS TScintilla

   DEFAULT lOn := .T.

   if lOn
      ::Send( SCI_SETMARGINWIDTHN, 2, 14 )
   else
      ::Send( SCI_SETMARGINWIDTHN, 2, 0 )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LineSep() CLASS TScintilla

local nPos   := ::GetCurrentPos()
::InsertText( nPos, "//" + Replicate( "-", 76 ) + "//" + hb_eol() )
::GotoLine( ::GetCurrentLine() + 2 )

Return nil

//----------------------------------------------------------------------------//

METHOD AutoIndent() CLASS TScintilla

   local nCurLine     := ::GetCurrentLine()
   local nIndentation := ::GetLineIndentation( nCurLine - 1 )
   local cLine        := LTrim( ::GetLine( nCurLine ) )
   local cToken

   if ! Empty( cLine )

      do case
         case ! Empty( cToken := SubStr( cLine, 1, 2 ) ) .and. ;
              Lower( cToken ) == "if"
              ::InsertText( ::PositionFromLine( nCurLine + 1 ), Space( nIndentation ) + "endif" + CRLF )
              nIndentation += 3
              ::SetLineIndentation( nCurLine, nIndentation )
              ::GotoPos( ::GetCurrentPos() + nIndentation )

         case ! Empty( cToken := SubStr( cLine, 1, 5 ) ) .and. ;
              Lower( cToken ) == "while"
              ::InsertText( ::PositionFromLine( nCurLine + 1 ), Space( nIndentation ) + "end" + CRLF )
              nIndentation += 3
              ::SetLineIndentation( nCurLine, nIndentation )
              ::GotoPos( ::GetCurrentPos() + nIndentation )

         case ! Empty( cToken := SubStr( cLine, 1, 7 ) ) .and. ;
              Lower( cToken ) == "do case"
              ::InsertText( ::PositionFromLine( nCurLine + 1 ),;
                            Space( nIndentation + 3 ) + "case " + CRLF + CRLF + ;
                            Space( nIndentation ) + "endcase" + CRLF )
              ::GotoPos( ::GetCurrentPos() + nIndentation + 9 )

         case ! Empty( cToken := SubStr( cLine, 1, 4 ) ) .and. ;
              Lower( cToken ) == "case"
              ::SetLineIndentation( nCurLine, nIndentation + 5 )
              ::GotoPos( ::GetCurrentPos() + nIndentation + 5 )

         otherwise
              ::SetLineIndentation( nCurLine, nIndentation )
              ::GotoPos( ::GetCurrentPos() + nIndentation )
      endcase
   else
      ::SetLineIndentation( nCurLine, nIndentation )
      ::GotoPos( ::GetCurrentPos() + nIndentation )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetZoom( nZ ) CLASS TScintilla

    Local  nZoomFactor := ::GetProp( SCI_GETZOOM, 0, 0 )
    DEFAULT nZ  := 0
    if nZ > -11 .and. nZ < 21
       ::Send( SCI_SETZOOM, nZ, 0 )
    endif
    nZoomFactor := ::GetProp( SCI_GETZOOM, 0, 0 )

Return nZoomFactor

//----------------------------------------------------------------------------//

METHOD SetColourise( lOnOff ) CLASS TScintilla

   DEFAULT lOnOff := .T.
   if lOnOff
      ::Send( SCI_COLOURISE, 0, -1 )
   else
      ::Send( SCI_COLOURISE, 0, 1 )
   endif

Return nil

//----------------------------------------------------------------------------//

METHOD MarginClick( nMargen, nPos ) CLASS TScintilla

  local nLine      := 0
  DEFAULT nMargen  := 0
  nLine    := ::Send( SCI_LINEFROMPOSITION, nPos, 0 ) + 1
  ::GotoPos( nPos )
  Do Case
     Case nMargen = 0
          ::GoToLine( nLine )
     Case nMargen = 1
          ::GoToLine( nLine )
          ::SetToggleMark()
     Case nMargen = 2
          ::Send( SCI_TOGGLEFOLD, nLine + 1 )
     Case nMargen = 3
     Case nMargen = 4
          ::GoToLine( nLine + 1 )
     Otherwise
 EndCase

Return nil

//----------------------------------------------------------------------------//


function _FSCI( hWnd, nMsg, hSender, uParam1, uParam2 )
local aWindows:= GetAllWin()
local oControl
local nAt := AScan( aWindows, { | o | o:hWnd == hWnd } )

if nAt != 0
   oControl := aWindows[ nAt ]:FindControl( hSender )
   if oControl != nil
      return oControl:HandleEvent( nMsg, uParam1, uParam2 )
   endif

endif

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, uParam1, uParam2, uParam3 )  CLASS TScintilla

do case
   case nMsg == WM_SCINOTIFY
        ::Notify( uParam1, uParam2 )
   case nMsg == WM_LBUTTONDOWN
        msginfo("rclick")
   otherwise
     ::super:HandleEvent( nMsg, uParam1, uParam2,uParam3 )
endcase

return nil



//----------------------------------------------------------------------------//

METHOD Notify( nType, pScnNotification ) CLASS TScintilla
   local nMargin,nPos,nLine

   local nCode := ScnCode( pScnNotification )

   do case
      case nCode == SCN_CHARADDED
           ::CharAdded( ScnCh( pScnNotification ) )

      case nCode == SCN_UPDATEUI
           if ::bChange != nil
              Eval( ::bChange, Self )
           endif

     case nCode == SCN_MARGINCLICK

            nPos = ScNPos( pScnNotification )
           nLine = ::LineFromPosition( nPos )
           nMargin := ScNMargin( pScnNotification )

           if nMargin == 2
              //msginfo("yo")
             // ::Send(SCI_TOGGLEFOLD, nLine+1)
           endif
           if nMargin == 0
              ::GotoPos( nPos )
              ::SetToggleMark()

           endif
           if nMargin == 1
              // ::GotoPos( nPos )
           endif


     // case nType == IBNCaretChanged
      //     if ::bChange != nil
      //        Eval( ::bChange, Self )
        //   endif
 
   endcase


return nil

//----------------------------------------------------------------------------//

METHOD CharAdded( nChar ) CLASS TScintilla

   static nLastChar := 0

   if nLastChar == 13 .and. nChar == 10 // CRLF
      ::AutoIndent()
   else
      ::IntelliSense( nChar )
   endif

   nLastChar = nChar

return nil

//----------------------------------------------------------------------------//

METHOD Close() CLASS TScintilla

   if ::GetModify()
      if MsgYesNo( "Save the changes ?", "File has changed" )
         ::Save()
      endif
   endif

   ::SetText( "" )
   ::cFileName = ""

return nil

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

METHOD IntelliSense( nChar ) CLASS TScintilla

   local nAt   := ::nCol()
   local cLine := Lower( LTrim( ::GetLine( ::GetCurrentLine() + 1 ) ) )

   if SubStr( cLine, 1, 8 ) $ "define window"
      ::CallTipShow( ::GetCurrentPos(), "DEFINE WINDOW <oWnd>" + Chr( 10 ) + ;
                                        "   TITLE <cTitle> " + Chr( 10 ) + ;
                                        "   FROM <nTop>, <nLeft> TO <nBottom>, <nRight>" )
   else
      ::CallTipCancel()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Open( cFileName ) CLASS TScintilla

   if File( cFileName )
      ::cFileName = cFileName
      ::cFilePath = cFilePath( ::cFileName )
      ::SetText( MemoRead( cFileName ) )
      ::SetSavePoint() // unmodified state
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Save() CLASS TScintilla

   local hFile

   if Empty( ::cFileName )
      ::cFileName = SaveFile( "Save as...", "*.prg")
      ::cFilePath = cFilePath( ::cFileName )
   endif

   hFile = FCreate( ::cFileName, "w" )
   FWrite( hFile, ::GetText() )
   FClose( hFile )

   ::SetSavePoint() // unmodified state

return nil
//----------------------------------------------------------------------------//

METHOD SaveAS( cFileName ) CLASS TScintilla

local hFile

if Empty( cFileName )
   cFileName = SaveFile( "Save as...", "*.prg" )
endif

hFile = FCreate( cFileName, "w" )
FWrite( hFile, ::GetText() )
FClose( hFile )

::SetSavePoint() // unmodified state
::cFileName := cFileName
::cFilePath = cFilePath( ::cFileName )

return nil

//----------------------------------------------------------------------------//

METHOD SetMBrace() CLASS TScintilla

   ::Send( SCI_STYLESETFORE, STYLE_BRACELIGHT, ::cCBraces[ 1 ] ) //YELLOW
   ::Send( SCI_STYLESETBACK, STYLE_BRACELIGHT, ::cCBraces[ 2 ] ) //::nCaretBackColor )
   ::Send( SCI_STYLESETFORE, STYLE_BRACEBAD, ::cCBraceBad[ 1 ] ) //CLR_HRED )
   ::Send( SCI_STYLESETBACK, STYLE_BRACEBAD, ::cCBraceBad[ 2 ] ) //::nCaretBackColor )
   //::Send( SCI_BRACEHIGHLIGHTINDICATOR, 1, 1 )
   //::Send( SCI_BRACEBADLIGHTINDICATOR, 1, 1 )

Return nil

//----------------------------------------------------------------------------//

METHOD SearchBackward( cText, nFlags ) CLASS TScintilla

   DEFAULT cText := ::GetSelText()

return If( ! SciSearchBackward( ::hWnd, cText, nFlags ), MsgBeep(),)

//----------------------------------------------------------------------------//

METHOD SearchForward( cText, nFlags ) CLASS TScintilla

   DEFAULT cText := ::GetSelText()

return If( ! SciSearchForward( ::hWnd, cText, nFlags ), MsgBeep(),)

//----------------------------------------------------------------------------//

METHOD Setup() CLASS TScintilla
local n
local KeyWords1  := CadComand()
Local aMarkers

// La quinta opcion es personalizada por mi
aMarkers := { ;
    {SC_MARKNUM_FOLDEROPEN, SC_MARKNUM_FOLDER   , SC_MARKNUM_FOLDERSUB, ;
        SC_MARKNUM_FOLDERTAIL, SC_MARKNUM_FOLDEREND, SC_MARKNUM_FOLDEROPENMID,;
        SC_MARKNUM_FOLDERMIDTAIL},;
    {SC_MARK_MINUS        , SC_MARK_PLUS        , SC_MARK_EMPTY, SC_MARK_EMPTY, ;
        SC_MARK_EMPTY        , SC_MARK_EMPTY       , SC_MARK_EMPTY},;
    {SC_MARK_ARROWDOWN    , SC_MARK_ARROW       , SC_MARK_EMPTY, SC_MARK_EMPTY, ;
        SC_MARK_EMPTY        , SC_MARK_EMPTY       , SC_MARK_EMPTY},;
    {SC_MARK_CIRCLEMINUS  , SC_MARK_CIRCLEPLUS  , SC_MARK_VLINE, ;
        SC_MARK_LCORNERCURVE, ;
        SC_MARK_CIRCLEPLUSCONNECTED, SC_MARK_CIRCLEMINUSCONNECTED,;
        SC_MARK_TCORNERCURVE},;
    {SC_MARK_BOXMINUS,      SC_MARK_BOXPLUS,   SC_MARK_VLINE,   SC_MARK_LCORNER,;
        SC_MARK_BOXPLUSCONNECTED,    SC_MARK_BOXMINUSCONNECTED,    SC_MARK_TCORNER},;
    {SC_MARK_BOXMINUS,      SC_MARK_BOXPLUS,   SC_MARK_VLINE,   SC_MARK_LCORNER,;
        SC_MARK_TCORNER,             SC_MARK_VLINE,                SC_MARK_VLINE } ;
}


 // Lexer type is flagship.
 // ::Send( SCI_SETLEXER, SCLEX_FLAGSHIP, 0 )
  ::Send( SCI_SETLEXERLANGUAGE, , "flagship" )


::SetLinIndent( .t., .f. )

// Number of styles we use with this lexer.
::Send( SCI_SETSTYLEBITS, SCIGETONEPROP(::hWnd, SCI_GETSTYLEBITSNEEDED  ))


// Keywords to highlight. Indices are:
// 0 - Major keywords (reserved keywords)
// 1 - Normal keywords (everything not reserved but integral part of the language)
// 2 - Database objects
// 3 - Function keywords
// 4 - System variable keywords
// 5 - Procedure keywords (keywords used in procedures like "begin" and "end")
// 6..8 - User keywords 1..3


/*
[mEditor setReferenceProperty: SCI_SETKEYWORDS parameter: 0 value: major_keywords];
[mEditor setReferenceProperty: SCI_SETKEYWORDS parameter: 5 value: procedure_keywords];
[mEditor setReferenceProperty: SCI_SETKEYWORDS parameter: 6 value: client_keywords];
[mEditor setReferenceProperty: SCI_SETKEYWORDS parameter: 7 value: user_keywords];
*/


   ::Send( SCI_SETKEYWORDS, 0,;
"class from data classdata method inline virtual setget endclass init " + ;
"function return retu " + ;
"define activate window title maximized color style on click paint resize " + ;
"bitmap adjust noborder pixel design " + ;
"brush " + ;
"buttonbar filename button size of 2007 " + ;
"checkbox " + ;
"combobox var items " + ;
"dialog center centered " + ;
"explorerbar " + ;
"folder prompts " + ;
"font bold " + ;
"group " + ;
"icon " + ;
"image " + ;
"mdi mdichild menupos " + ;
"msgbar prompt keyboard " + ;
"menu menuitem action separator endmenu mru section " + ;
"resource " + ;
"splitter vertical previous controls hinds " + ;
"tooltip message keyboard maximized " + ;
"valid " + ;
"when " + ;
"xbrowse lines autocols recordset autosort " )

::Send( SCI_SETKEYWORDS, 1,;
"local public static private " + ;
"if else endif " + ;
"do while endwhile end " + ;
"do case otherwise endcase " + ;
"for next " + ;
"super " )

/*
 
::SetKeyWords( "class from data classdata method inline virtual setget endclass " + ;
                  "btnbmp " + ;
                  "checkbox click " + ;
                  "default flipped " + ;
                  "define activate window title valid maximized full resized centered " + ;
                  "buttonbar filename button size of 2007 " + ;
                  "browse fields headers " + ;
                  "colorwell " + ;
                  "combobox items on change " + ;
                  "autoresize " + ;
                  "dialog centered " + ;
                  "get var " + ;
                  "group " + ;
                  "image " + ;
                  "listbox " + ;
                  "msgbar prompt keyboard " + ;
                  "multiview " + ;
                  "menu menuitem action separator endmenu mru section " + ;
                  "mview " + ;
                  "progress position " + ;
                  "say raised " + ;
                  "slider value " + ;
                  "splitter vertical horizontal style AUTORESIZE " + ;
                  "tabs prompts " + ;
                  "toolbar " + ;
                  "tooltip message keyboard maximized " + ;
                  "tree " + ;
                  "view ", 0 )

   ::SetKeyWords( "function return " + ;
                  "local public static private nil " + ;
                  "if else elseif endif " + ;
                  "do while endwhile end " + ;
                  "do case otherwise endcase " + ;
                  "with object " + ;
                  "super ", 1 )

*/

  ::Send( SCI_COLOURISE, 0, -1 )
  ::Send( SCI_STYLESETBACK, STYLE_DEFAULT, rgb( 255,255,255 ) )
  ::Send( SCI_STYLECLEARALL, 0, 0 )

   ::Send( SCI_STYLESETFORE, STYLE_BRACELIGHT, CLR_WHITE )
   ::Send( SCI_STYLESETBACK, STYLE_BRACELIGHT, RGB( 0, 179, 179 ) )

   ::SetFont( "Courier", 16, .F., .F. )
   ::Send( SCI_STYLESETFONT, STYLE_BRACELIGHT, "Courier" )
   ::Send( SCI_STYLESETSIZE, STYLE_BRACELIGHT, 16 )


    ::Send(SCI_SETFOLDMARGINCOLOUR,1, rgb(210,210,210) )  // fondo margen
    ::Send(SCI_SETFOLDMARGINHICOLOUR,1, rgb(210,210,210) )  // fondo margen



   // ::Send( SCI_MARKERDEFINE, 1, SC_MARK_ARROW )
    ::Send( SCI_MARKERSETFORE, 1, CLR_BLUE )



    ::Send( SCI_SETMARGINWIDTHN, 1, 28 )
    ::Send( SCI_SETMARGINTYPEN,  1, SC_MARGIN_SYMBOL )
    ::Send(SCI_SETMARGINSENSITIVEN , 1 ,0 )

   // ::Send( SCI_MARKERSETFORE, 1, CLR_WHITE )  // color folder
   // ::Send( SCI_MARKERSETBACK, 1, CLR_BLACK )


    ::Send( SCI_MARKERDEFINE, 4, SC_MARK_BOOKMARK )
   // ::Send( SCI_SETMARGINMASKN ,1,  4 )


   ::Send( SCI_SETCARETLINEBACK, RGB( 255, 255, 192 ) )
   ::Send( SCI_SETCARETLINEVISIBLE, 1 )

   // Color parentesis

  // ::Send(SCI_BRACEHIGHLIGHTINDICATOR,0,2)

// Line number style.

  ::Send( SCI_STYLESETFORE, STYLE_LINENUMBER, rgb(240,240,240 ) )
  ::Send( SCI_STYLESETBACK, STYLE_LINENUMBER, rgb(128,128,128 ) )
  ::Send( SCI_SETMARGINTYPEN, 0, SC_MARGIN_NUMBER )
  ::Send( SCI_SETMARGINWIDTHN, 0, 35 )

/*
::Send( SCI_STYLESETBACK, SCE_FS_PREPROCESSOR, GetSysColor( COLOR_WINDOW ) )
::Send( SCI_STYLESETBACK, SCE_FS_STRING,       GetSysColor( COLOR_WINDOW ) )
::Send( SCI_STYLESETBACK, SCE_FS_COMMENTLINE,  GetSysColor( COLOR_WINDOW ) )
::Send( SCI_STYLESETBACK, SCE_FS_OPERATOR,     GetSysColor( COLOR_WINDOW ) )
::Send( SCI_STYLESETBACK, SCE_FS_KEYWORD,      GetSysColor( COLOR_WINDOW ) )
::Send( SCI_STYLESETBACK, SCE_FS_KEYWORD2,     GetSysColor( COLOR_WINDOW ) )
::Send( SCI_STYLESETBACK, SCE_FS_NUMBER,       GetSysColor( COLOR_WINDOW ) )
*/



::StyleSet( SCE_FS_COMMENTLINE	) ; ::StyleSetColor( CLR_GREEN	)
::StyleSet( SCE_FS_OPERATOR   	) ; ::StyleSetColor( CLR_HBLUE	)
::StyleSet( SCE_FS_STRING 		) ; ::StyleSetColor( rgb(210,64,54)	)
::StyleSet( SCE_FS_PREPROCESSOR	) ; ::StyleSetColor( CLR_GREEN )
::StyleSet( SCE_FS_NUMBER 		) ; ::StyleSetColor( rgb(53,51,215 ) )
::StyleSet( SCE_FS_KEYWORD 		) ; ::StyleSetColor( rgb(185,53,163) )
::StyleSet( SCE_FS_KEYWORD2 		) ; ::StyleSetColor( CLR_BLUE	)


::SetAStyle( SCE_FS_COMMENTDOC, CLR_GREEN )
::SetAStyle( SCE_FS_COMMENTLINEDOC, CLR_GREEN )
::SetAStyle( SCE_FS_COMMENT, CLR_GREEN )
::SetAStyle( SCE_FS_COMMENTLINE, CLR_GREEN )
::SetAStyle( SCE_FS_COMMENTDOCKEYWORD, CLR_YELLOW )
::SetAStyle( SCE_FS_COMMENTDOCKEYWORDERROR, CLR_YELLOW )


/*
   ::Send( SCI_STYLESETFORE, SCE_FS_STRING, CLR_YELLOW )
   ::Send( SCI_STYLESETFORE, SCE_FS_COMMENTLINE, CLR_GREEN )
   ::Send( SCI_STYLESETFORE, SCE_FS_OPERATOR, CLR_HCYAN )

   ::Send( SCI_STYLESETFORE, SCE_FS_PREPROCESSOR, CLR_MAGENTA )
   ::Send( SCI_STYLESETFORE, SCE_FS_NUMBER, CLR_HRED )
   ::Send( SCI_STYLESETFORE, SCE_FS_KEYWORD, CLR_HGREEN )
   ::Send( SCI_STYLESETFORE, SCE_FS_KEYWORD2,  CLR_BLUE	 )

*/




  //------------------ini foldering

  ::Send( SCI_SETMARGINWIDTHN, 2, 18 )
  ::Send( SCI_SETMARGINMASKN , 2, SC_MASK_FOLDERS )

  ::Send( SCI_MARKERDEFINE, SC_MARKNUM_FOLDEROPEN, SC_MARK_BOXMINUS)
  ::Send( SCI_MARKERDEFINE, SC_MARKNUM_FOLDER ,SC_MARK_BOXPLUS )
  ::Send( SCI_MARKERDEFINE, SC_MARKNUM_FOLDERSUB , SC_MARK_VLINE)
  ::Send( SCI_MARKERDEFINE, SC_MARKNUM_FOLDERTAIL ,SC_MARK_LCORNER )
  ::Send( SCI_MARKERDEFINE, SC_MARKNUM_FOLDEREND ,SC_MARK_BOXPLUSCONNECTED )
  ::Send( SCI_MARKERDEFINE, SC_MARKNUM_FOLDEROPENMID ,SC_MARK_BOXMINUSCONNECTED )
  ::Send( SCI_MARKERDEFINE, SC_MARKNUM_FOLDERMIDTAIL ,SC_MARK_TCORNER )




  ::Send(SCI_SETMARGINSENSITIVEN , 0 ,1 )
  ::Send(SCI_SETMARGINSENSITIVEN , 2 ,1 )


  ::Send( SCI_USEPOPUP,0,0 )


for  n= 25 to 31 // Markers 25..31 are reserved for folding.

    ::Send( SCI_MARKERSETFORE, n, CLR_WHITE )  // color folder
    ::Send( SCI_MARKERSETBACK, n, CLR_BLACK )

NEXT





// Init markers & indicators for highlighting of syntax errors.

 ::Send( SCI_INDICSETFORE, 0, CLR_RED )
 ::Send( SCI_INDICSETUNDER, 0, 1 )
 ::Send( SCI_INDICSETSTYLE, 0, INDIC_SQUIGGLE )

//::Send(SCI_MARKERSETFORE,SC_MARKNUM_FOLDEROPEN, 14215660 )
//::Send(SCI_MARKERSETBACK,SC_MARKNUM_FOLDEROPEN, RGB(128, 128, 128) )
//::Send(SCI_MARKERSETFORE,SC_MARKNUM_FOLDER, RGB(236, 233, 216) )
//::Send(SCI_MARKERSETBACK,SC_MARKNUM_FOLDER, RGB(128, 128, 128) )
//::Send(SCI_MARKERSETBACK,SC_MARKNUM_FOLDERSUB, RGB(128, 128, 128) )
//::Send(SCI_MARKERSETBACK,SC_MARKNUM_FOLDERTAIL, RGB(128, 128, 128) )
//::Send(SCI_MARKERSETFORE,SC_MARKNUM_FOLDEREND, RGB(236, 233, 216) )
//::Send(SCI_MARKERSETBACK,SC_MARKNUM_FOLDEREND, RGB(128, 128, 128) )
//::Send(SCI_MARKERSETFORE,SC_MARKNUM_FOLDEROPENMID, RGB(236, 233, 216) )
//::Send(SCI_MARKERSETBACK,SC_MARKNUM_FOLDEROPENMID, RGB(128, 128, 128) )
//::Send(SCI_MARKERSETBACK,SC_MARKNUM_FOLDERMIDTAIL, RGB(128, 128, 128) )


//::Send( SCI_SETMARGINTYPEN, 0, SC_MARGIN_BACK)

//::Send( SCI_STYLESETBACK,STYLE_DEFAULT, CLR_GREEN)
//::Send( SCI_STYLESETFORE,STYLE_DEFAULT, CLR_YELLOW)



//Set autoindentation con 4 spaces
::Send( SCI_SETINDENT, 4, 0  )
::Send( SCI_SETTABINDENTS, 1, 0  )
::Send( SCI_SETBACKSPACEUNINDENTS, 1, 0 )


::setLexerProp( "fold","1")
::setLexerProp( "fold.compact","0")
::setLexerProp( "fold.comment","1")
::setLexerProp( "fold.preprocessor","1")





  //-------------------end

   ::SetEdgeColumn( 128 )
   ::SetEdgeMode( 1 )

   ::SetUseTabs( .F. )

  ::SetColor( , rgb( 255,255,255 ) )

return nil

//----------------------------------------------------------------------------//

METHOD DlgGotoLine() CLASS TScintilla

  local oDlg, oGet, cLine := ""

  DEFINE DIALOG oDlg TITLE "Goto Line" ;
     FROM 220, 350 TO 340, 680

  @ 69, 37 SAY "Goto Line" OF oDlg SIZE 150, 17

  @ 67, 108 GET oGet VAR  cLine OF oDlg SIZE 192, 22

  @ 20, 218 BUTTON "OK" OF oDlg ACTION  oDlg:End()

  ACTIVATE DIALOG oDlg CENTERED

  if ! Empty( cLine )
     cLine = Val( cLine )
     if cLine != 0
        ::GotoLine( cLine )
     endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DlgOpen() CLASS TScintilla

   local cFileName := cGetfile("Select a file" , "prg" )

   if ! Empty( cFileName ) .and. File( cFileName )
      ::Open( cFileName )
      return .T.
   else
      return .F.
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GetTextColor( cType ) CLASS TScintilla

   cType = Lower( cType )

   do case
      case cType == "strings"
           return ::Send( SCI_STYLEGETFORE, SCE_FS_STRING )

      case cType == "numbers"
           return ::Send( SCI_STYLEGETFORE, SCE_FS_NUMBER )

      otherwise
           return CLR_WHITE
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD SetTextColor( cType, nRGBColor ) CLASS TScintilla

   cType = Lower( cType )

   do case
      case cType == "strings"
           return ::Send( SCI_STYLESETFORE, SCE_FS_STRING, nRGBColor )

      case cType == "numbers"
           return ::Send( SCI_STYLESETFORE, SCE_FS_NUMBER, nRGBColor )

   endcase

return nil

//----------------------------------------------------------------------------//

METHOD SetViewSpace( lOn ) CLASS TScintilla

   DEFAULT lOn := If( ::Send( SCI_GETVIEWWS ) == 0, .T., .F. )

   if lOn

      ::Send( SCI_SETVIEWWS, SCWS_VISIBLEALWAYS )
     else

      ::Send( SCI_SETVIEWWS, SCWS_INVISIBLE )

   endif

return nil

//----------------------------------------------------------------------------//


//----------------------------------------------------------------------------//

Function CadComand()
Local cCad0 := "activate adjust color style on click paint resize " + ;
"bitmap noborder pixel " + ;
"brush " + ;
"buttonbar filename button size of 2007 2010 2013 " + ;
"center centered checkbox combobox " + ;
"var items " + ;
"define design default dialog " + ;
"explorerbar " + ;
"folder prompts " + ;
"font bold " + ;
"group " + ;
"icon " + ;
"image " + ;
"maximized mdi mdichild menupos " + ;
"msgbar prompt keyboard " + ;
"menu menuitem action separator endmenu mru section " + ;
"resource " + ;
"splitter vertical previous controls hinds " + ;
"title tooltip message keyboard maximized " + ;
"valid " + ;
"when window " + ;
"xbrowse lines autocols recordset autosort "

Local cCad1 := "local public static private " + ;
"if else endif iif " + ;
"for to next " + ;
"do while endwhile end enddo loop " + ;
"do case otherwise endcase" + ;
"super "

Return ( cCad0+cCad1 )


//----------------------------------------------------------------------------//

Function CadWordFold( nOp )
Local cCad2 := "function return procedure"

Local cCad3 := "class endclass from data classdata method inline virtual setget "+;
"super with object endobject"
DEFAULT nOp  := 1
Return if( nOp = 1, cCad2, cCad3 )

//----------------------------------------------------------------------------//

