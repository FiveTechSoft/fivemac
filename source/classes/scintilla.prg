#include "FiveMac.ch"
#include "Scintilla.ch"
#include "Colors.ch"

#define SCI_AUTOCSETCASEINSENSITIVEBEHAVIOUR 2634
#define SC_CASEINSENSITIVEBEHAVIOUR_IGNORECASE 1
#define SCI_SETAUTOMATICFOLD 2663
#define SC_AUTOMATICFOLD_CLICK 0x0002

#define markerBookmark    1
#define IBNCaretChanged 1

#include "fmsgs.h"

#define CLR_VSBAR  Rgb( 207, 214, 228 )

//----------------------------------------------------------------------------//

CLASS TScintilla FROM TControl

   DATA hWnd
   
   DATA aCopys
   DATA aKey             AS ARRAY INIT {}

   DATA nTextColor       INIT CLR_BLUE
   DATA nBackColor       INIT nRgb( 170, 170, 170 )
   DATA nClrPane

   DATA nTColorLin       INIT CLR_BLUE
   DATA nBColorLin       INIT CLR_VSBAR

   DATA nMargLeft
   DATA nMargRight
   DATA nSpacLin
   
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
   
   DATA lFolding
   
   DATA cLexer
   DATA cListFuncs

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

   METHOD FindText( cText, lForward ) INLINE If( lForward, ::SearchForward( cText ), ::SearchBackward( cText ) )

   METHOD FoldAllContract()                   INLINE ::Send( SCI_FOLDALL, SC_FOLDACTION_CONTRACT, 0 )
   METHOD FoldAllExpand()                     INLINE ::Send( SCI_FOLDALL, SC_FOLDACTION_EXPAND, 0 )
   METHOD FoldAllToggle()                     INLINE ::Send( SCI_FOLDALL, SC_FOLDACTION_TOGGLE, 0 )
   METHOD FoldLevelNumber()                   INLINE ::Send( SCI_SETFOLDFLAGS, SC_FOLDFLAG_LEVELNUMBERS, 0 )
   METHOD FoldLineNumber()                    INLINE ::Send( SCI_SETFOLDFLAGS, SC_FOLDFLAG_LINEAFTER_CONTRACTED, 0 )
   METHOD FoldLineSt()                        INLINE ::Send( SCI_SETFOLDFLAGS, 128, 0 )
   
   METHOD GetAnchor()                         INLINE SciGetProp( ::hWnd, SCI_GETANCHOR )
   METHOD GetCaretInLine()
   METHOD GetCaretLineBack()                  INLINE SciGetProp( ::hWnd, SCI_GETCARETLINEBACK )
   
   METHOD GetCharAt( nPos ) INLINE SciGetProp( ::hWnd, SCI_GETCHARAT, nPos )

   METHOD GetTextColor( cType )
   
   METHOD GetCurLine()
   
   METHOD GetCurrentLine()                   INLINE SciGetProp( ::hWnd, SCI_LINEFROMPOSITION, ::GetCurrentPos() )
   METHOD GetCurrentPos()                    INLINE SciGetProp( ::hWnd, SCI_GETCURRENTPOS )
   METHOD GetCurrentLineNumber()             INLINE SciGetProp( ::hWnd, SCI_LINEFROMPOSITION, ::GetCurrentPos() )
   
   METHOD GetCurrentStyle()  INLINE SciGetProp( ::hWnd, SCI_GETSTYLEAT, ::GetCurrentPos() )
   
   METHOD GetFuncList()

   METHOD GetIndent()       INLINE SciGetProp( ::hWnd, SCI_GETINDENT )
   METHOD GetLexer()        INLINE SciGetProp( ::hWnd, SCI_GETLEXER )
   METHOD GetLine( nLine )  INLINE SciGetLine( ::hWnd, nLine )

   METHOD GetLineCount()    INLINE SciGetProp( ::hWnd, SCI_GETLINECOUNT )

   METHOD GetLineIndentation( nLine ) INLINE SciGetProp( ::hWnd, SCI_GETLINEINDENTATION, nLine )

   METHOD GetModify()       INLINE SciGetProp( ::hWnd, SCI_GETMODIFY ) == 1

   METHOD GetProp ( xProp, xValue )   INLINE SciGetProp(::hWnd, xProp, xValue )

   METHOD GetSelText()      INLINE SciGetSelText( ::hWnd )

   METHOD GetStyleAt( nPos )                   INLINE SciGetProp( ::hWnd, SCI_GETSTYLEAT, nPos )

   METHOD GetText()                            INLINE SciGetText( ::hWnd )

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

    METHOD InitEdt()
    
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


   METHOD SetHighlightColors()

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

   METHOD SetLinColor( nClrText, nClrPane )
   
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

    METHOD MenuEdit( lPopup )
    
    METHOD ValidChar( c ) INLINE  Lower( c ) $ "abcdefghijklmnopqrstuvwxyz1234567890ñ"

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight, oWnd , cLex ) CLASS TScintilla
    
    DEFAULT cLex :=  "flagship"
    
    ::hWnd = SciCreate( nTop, nLeft, nBottom, nRight, oWnd:hWnd )
    ::oWnd = oWnd

    oWnd:AddControl( Self )

  //  ::cCKeyw1       := { METRO_ORANGE, ::nClrPane, SC_CASE_MIXED, } //CYAN
  //  ::cCKeyw2       := { METRO_ORANGE, ::nClrPane, SC_CASE_MIXED, } // METRO_BROWN
  
    ::cCKeyw1       := { rgb(185,53,163), ::nClrPane, SC_CASE_MIXED, } //CYAN
    ::cCKeyw2       := { rgb(185,53,163), ::nClrPane, SC_CASE_MIXED, } // METRO_BROWN
  
    ::cCKeyw3       := { METRO_BROWN, ::nClrPane, SC_CASE_MIXED, }  // CLR_BLUE
    ::cCKeyw4       := { CLR_BLUE,    ::nClrPane, SC_CASE_MIXED, }     //METRO_CYAN
    ::cCKeyw5       := { METRO_CYAN,  ::nClrPane, SC_CASE_MIXED, }   //METRO_MAUVE   // STEEL

    ::cCComment     := { CLR_GRAY, ::nClrPane, SC_CASE_MIXED, }    //HGRAY
    ::cCCommentLin  := { CLR_GRAY, ::nClrPane, SC_CASE_MIXED, }
    ::cCString      := { CLR_HRED, ::nClrPane, SC_CASE_MIXED, }
    ::cCNumber      := { CLR_RED,  ::nClrPane, SC_CASE_MIXED, }
    ::cCOperator    := { CLR_BLUE, ::nClrPane, SC_CASE_MIXED, }
    ::cCBraces      := { CLR_BLUE, CLR_YELLOW, SC_CASE_MIXED, }
    ::cCBraceBad    := { CLR_HRED, CLR_YELLOW, SC_CASE_MIXED, }
    ::cCIdentif     := { CLR_GREEN, ::nClrPane, SC_CASE_MIXED, }    //MAGENTA
    
    ::lFolding    := .t.
    
    ::cLexer   := cLex

    ::Setup()
    ::brclicked:= { ||  msginfo("rclick")    }
    
  
return Self

//----------------------------------------------------------------------------//
#define markerBookmark 	1

METHOD SetToggle() CLASS TScintilla
Local lSw   := .F.
local nLine := ::GetCurrentLineNumber()
   msginfo(nLine)
   if SciGetProp( ::hWnd,SCI_MARKERGET, nLine ) == 0
      ::Send( SCI_MARKERADD, nLine, markerBookmark )
     else
      ::Send( SCI_MARKERDELETE, nLine, markerBookmark )
   endif

return lSw

//----------------------------------------------------------------------------//


METHOD MenuEdit( lPopup ) CLASS TScintilla

local oMnu
DEFAULT lPopup  := .F.

if !lPopup
MENU oMnu
endif

MENUITEM "Undo" ACTION ::Undo()
SEPARATOR
MENUITEM  "Code &separator" ACTION ::LineSep()

if !lPopup
ENDMENU
endif

Return oMnu

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


 if !empty(nClrText)
   :: nTextColor := nClrText
 endif
 if !empty(nClrPane )
   ::nBackColor := nClrPane
 endif
::setup()


return nil

//----------------------------------------------------------------------------//

METHOD SetLinColor( nClrText, nClrPane ) CLASS TScintilla
 
if !empty(nClrText)
:: nTColorLin := nClrText
endif
if !empty(nClrPane )
::nBColorLin := nClrPane
endif
::setup()


return nil

//----------------------------------------------------------------------------//

METHOD BookmarkNext( lForwardScan, lSelect )  CLASS TScintilla

   LOCAL lineno      := ::GetCurrentLineNumber()
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

METHOD GetCurLine() CLASS TScintilla
    
    local nLine := ::GetCurrentLineNumber()
    local cText := ::GetLine( nLine + 1 )
    
RETURN cText

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
Local nLine := ::GetCurrentLineNumber()
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

METHOD GetCaretInLine() CLASS TScintilla
    
    local nCaret     := ::GetCurrentPos()
    local nLine      := ::LineFromPosition( nCaret )
    local nLineStart := ::PositionFromLine( nLine )
    
RETURN nCaret - nLineStart

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
::GotoLine( ::GetCurrentLineNumber() + 2 )

Return nil

//----------------------------------------------------------------------------//

METHOD AutoIndent() CLASS TScintilla

   local nCurLine     := ::GetCurrentLineNumber()
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
#define WM_COMMAND 1001

METHOD HandleEvent( nMsg, uParam1, uParam2, uParam3 )  CLASS TScintilla

do case

 case nMsg ==WM_RBUTTONDOWN
 NSLOG( "RB" )
 case nMsg == WM_COMMAND



 case nMsg == WM_LBUTTONDOWN
 NSLOG( "LB" )

//Case nMsg == WM_CONTEXTMENU
  //  ::Send( SCI_USEPOPUP, 0 )
  //   ? "usepop"

 NSLOG( "CONTEXT" )
case nMsg == WM_SCINOTIFY
    ::Notify( uParam1, uParam2 )
  otherwise
     NSLOG ( "Super" )
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

if nMargin < 0
msginfo("yo")
// ::Send(SCI_TOGGLEFOLD, nLine+1)
endif

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


METHOD InitEdt() CLASS TScintilla
    
    local oCrs
    
    ::nMargLeft     := 4
    ::nMargRight    := 4
    ::nSpacLin      := 2
    
/*
    ::nWidthTab     := 3
    ::aHCopy        := {}
    ::aCopys        := {}
    ::aBookMarker   := {}
    ::aMarkerHand   := {}
    ::aPointBreak   := {}
    ::nMarker       := SC_MARK_SHORTARROW
    ::lVirtSpace    := .T.
    ::bViews        := { || .T. }
    ::bDoubleView   := { || .T. }
    ::cPlugIn       := ""
    ::lLinTabs      := .F.
    ::nMargen       := -1
    ::nPos64        := -1
    ::lTipFunc      := .T.
    ::nColorSelectionB  := ::nCaretBackColor
    ::aIndentChars  := { ;
        { "IF", 1 },;
        { "ENDIF", -1 },; //{ "ELSE", -1 },;
        { "FOR", 1 },;
        { "NEXT", -1 },;
        { "DO", 1 },;
        { "WITH", 1 },;
        { "END", -1 },;
        { "ENDDO", -1 },;
        { "FUNCTION", 0 },;
        { "RETURN", 0 },;
        { "METHOD", 0 },;
        { "CLASS", 0 },;
        { "HB_FUNC", 0 } ;
    }
    
    if ::lPtr
        ::GetDirecPointer()
    endif
    if ::lMultiView
        ::GetDocPointer()
    endif
*/

Return nil

//----------------------------------------------------------------------------//


//----------------------------------------------------------------------------//

METHOD IntelliSense( nChar ) CLASS TScintilla

   local nAt   := ::nCol()
   local cLine := Lower( LTrim( ::GetLine( ::GetCurrentLineNumber() + 1 ) ) )

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
//local KeyWords1  := CadComand()

local cCad0 := ;
    "action activate adjust array as autocols autosort " + ; //aadd //ascan atail
    "bar begin bitmap bold bool bottom break brush button buttonbar byte " + ;
    "center centered century change checkbox checked " + ; //cfilenopath
    "click color colors columns colsizes controls " + ;
    "combobox constructor crlf cursor " + ;
    "default #define deleted design dialog " + ; //disable
    "#else #endif endini entry enum epoch explorer " + ;  //enable
    "filter folder folderex font footer " + ; //filename
    "get group " + ;
    "hbitmap header height hinds horizontal " + ;
    "icon id #ifdef #ifndef image #include ini init items " + ;
    "justify " + ;
    "keyboard " +;
    "left lib lines listbox local long lpstr lpwstr " + ;
    "margin maximized mdi mdichild memo " + ;  //memoline memoread memowrit
    "menuitem menupos message msgbar msgitem mru " + ;
    "new noborder " + ;
    "of on option " + ;
    "paint pascal pixel previous private prompt prompts public " + ;
    "radioitem radiomenu readonly recordset refresh resize resource right round " + ;
    "say section separator sequence set setfocus size spinner splitter " + ;
    "static style super struct " + ;
    "tab title to tooltip top transparent typedef " + ;
    "#undef update " + ;
    "valid var vertical " + ;
    "when width window " + ;
    "xbrowse " + ;
    "2007 2010 2013 2015"


local cCad1 := " "

local cCad2 := "function procedure return class method for while " + ;
    "iif if else elseif do with object begindump " + ;
    "hb_func func loop case otherwise switch menu void "

local cCad3 := "endif endclass next from data classdata inline virtual "+;
    "setget endcase endobject endmenu return "+;
    "memvar enddo end endwhile endwith enddump endswitch hb_ret " + ;
    "hb_retc hb_retc_nul hb_retc_buf hb_retc_con hb_retclen " + ;
    "hb_retds hb_retd hb_retdl hb_rettd hb_rettdt hb_retl " + ;
    "hb_retnd hb_retni hb_retnl hb_retns hb_retnint hb_retnlen "+;
    "hb_retndlen hb_retnilen hb_retnllen hb_retnintle hb_reta " + ;
    "hb_retptr hb_retnll hb_retnlllen "

local cCad4 := "$@\\&<>#(){}[]"

local KeyWords0 := ""
local KeyWords1 := ""
local KeyWords2 := ""
local KeyWords3 := ""
local KeyWords4 := ""

local aMarkers := { ;
    { SC_MARKNUM_FOLDEROPEN, SC_MARKNUM_FOLDER , SC_MARKNUM_FOLDERSUB, SC_MARKNUM_FOLDERTAIL, ;
        SC_MARKNUM_FOLDEREND , SC_MARKNUM_FOLDEROPENMID, SC_MARKNUM_FOLDERMIDTAIL },;
    { SC_MARK_MINUS        , SC_MARK_PLUS        , SC_MARK_EMPTY, SC_MARK_EMPTY, ;
        SC_MARK_EMPTY        , SC_MARK_EMPTY       , SC_MARK_EMPTY},;
    { SC_MARK_ARROWDOWN    , SC_MARK_ARROW       , SC_MARK_EMPTY, SC_MARK_EMPTY, ;
        SC_MARK_EMPTY        , SC_MARK_EMPTY       , SC_MARK_EMPTY},;
    { SC_MARK_CIRCLEMINUS  , SC_MARK_CIRCLEPLUS  , SC_MARK_VLINE, ;
        SC_MARK_LCORNERCURVE, ;
        SC_MARK_CIRCLEPLUSCONNECTED, SC_MARK_CIRCLEMINUSCONNECTED,;
        SC_MARK_TCORNERCURVE },;
    { SC_MARK_BOXMINUS,      SC_MARK_BOXPLUS,  SC_MARK_VLINE,   SC_MARK_LCORNER,;
        SC_MARK_BOXPLUSCONNECTED, SC_MARK_BOXMINUSCONNECTED, SC_MARK_TCORNER },;
    { SC_MARK_BOXMINUS,      SC_MARK_BOXPLUS,   SC_MARK_VLINE,   SC_MARK_LCORNER,;
        SC_MARK_TCORNER,             SC_MARK_VLINE,                SC_MARK_VLINE }, ;
    { SC_MARK_CIRCLEMINUS  , SC_MARK_CIRCLEPLUS  , SC_MARK_VLINE, ;
        SC_MARK_LCORNER, ;
        SC_MARK_CIRCLEPLUSCONNECTED, SC_MARK_CIRCLEMINUSCONNECTED,;
        SC_MARK_TCORNER };
}


::nClrPane := ::nBackColor

if !Empty( ::cListFuncs )
    KeyWords0  := lower( ::cListFuncs )
    KeyWords1  := cCad2 + cCad3
    else
    KeyWords0  := cCad2
    KeyWords1  := cCad3
endif

 KeyWords2  := cCad0


 // Lexer type is flagship.
 ::Send( SCI_SETLEXERLANGUAGE, , ::cLexer  )

 ::InitEdt()

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



::Send( SCI_SETKEYWORDS, 0, KeyWords0 )
::Send( SCI_SETKEYWORDS, 1, KeyWords1 )
::Send( SCI_SETKEYWORDS, 2, KeyWords2 )

//::Send( SCI_SETKEYWORDS, 3, KeyWords3 )
//::Send( SCI_SETKEYWORDS, 4, KeyWords4 )


  ::Send( SCI_COLOURISE, 0, -1 )
  
  ::Send( SCI_STYLESETFORE, STYLE_DEFAULT, ::nTextColor )  // texto gernerico
  ::Send( SCI_STYLESETBACK, STYLE_DEFAULT, ::nBackColor )  // Color fondo editor

  ::Send( SCI_STYLECLEARALL, 0, 0 )
 
   ::Send( SCI_AUTOCSETIGNORECASE, 1, 0 )
   ::Send( SCI_AUTOCSETCASEINSENSITIVEBEHAVIOUR, SC_CASEINSENSITIVEBEHAVIOUR_IGNORECASE, 0 ) // -> 1
   ::Send( SCI_AUTOCSETMAXHEIGHT, 10, 0 )
  
   ::Send( SCI_SETEXTRAASCENT , Max( 1.6, ::nSpacLin ) )
   ::Send( SCI_SETEXTRADESCENT, Max( 1.6, ::nSpacLin ) )
   ::Send( SCI_SETMARGINLEFT, 0, ::nMargLeft )
   ::Send( SCI_SETMARGINRIGHT, 0, ::nMargRight )

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

   ::Send( SCI_SETCARETLINEBACK, CLR_HCYAN )
   ::Send( SCI_SETCARETLINEVISIBLE, 1 )

   ::SetHighlightColors()

// ----------------Line number style.  ---------------------------

  ::Send( SCI_SETMARGINTYPEN, 0, SC_MARGIN_NUMBER )
  ::Send( SCI_SETMARGINWIDTHN, 0, 35 )

  ::SetAStyle( SCE_FS_COMMENTDOCKEYWORD, CLR_YELLOW )
  ::SetAStyle( SCE_FS_COMMENTDOCKEYWORDERROR, CLR_YELLOW )

  //------------------ini foldering

  if  ::lFolding
      ::Send( SCI_SETAUTOMATICFOLD, SC_AUTOMATICFOLD_CLICK, 0 )
  endif


  ::Send( SCI_SETMARGINWIDTHN, 2, 18 )
  ::Send( SCI_SETMARGINMASKN , 2, SC_MASK_FOLDERS )

  ::Send( SCI_MARKERDEFINE, SC_MARKNUM_FOLDEROPEN, SC_MARK_BOXMINUS )
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

   local cFileName := cGetfile( "Select a file", "prg,ch,c,m,h" )

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

#define SCLEX_FLAGSHIP 73

METHOD SetHighlightColors() CLASS TScintilla
 
 
    if ::GetLexer() == SCLEX_FLAGSHIP
       
       ::SetAStyle( SCE_FS_COMMENTLINE,    ::cCCommentLin[ 1 ], ::nClrPane )
       ::SetAStyle( SCE_FS_COMMENTDOC,     ::cCComment[ 1 ]   , ::nClrPane )
       ::SetAStyle( SCE_FS_COMMENTLINEDOC, ::cCCommentLin[ 1 ], ::nClrPane )
       ::SetAStyle( SCE_FS_COMMENT,        ::cCComment[ 1 ]   , ::nClrPane )
       ::SetAStyle( SCE_FS_PREPROCESSOR ,  ::cCIdentif[ 1 ]   , ::nClrPane )
       
        ::StyleSet( SCE_FS_OPERATOR      ) ; ::StyleSetColor( ::cCOperator[ 1 ] )
        ::StyleSet( SCE_FS_STRING     )    ; ::StyleSetColor( ::cCString[ 1 ]  )
        ::StyleSet( SCE_FS_NUMBER     )    ; ::StyleSetColor( ::cCNumber[ 1 ] )
  
        ::StyleSet( SCE_FS_KEYWORD       ) ; ::StyleSetColor( ::cCKeyw1[ 1 ] )
        ::StyleSet( SCE_FS_KEYWORD4      ) ; ::StyleSetColor( ::cCKeyw4[ 1 ] )
        ::StyleSet( SCE_FS_KEYWORD2     )  ; ::StyleSetColor( ::cCKeyw2[ 1 ] )
        ::StyleSet( SCE_FS_KEYWORD3     )  ; ::StyleSetColor( ::cCKeyw3[ 1 ] )
    
        ::Send( SCI_STYLESETFORE, STYLE_LINENUMBER, ::nTColorLin )
        ::Send( SCI_STYLESETBACK, STYLE_LINENUMBER, ::nBColorLin )
    
        ::Send( SCI_STYLESETBACK, SCE_FS_STRING,       ::nClrPane )
        ::Send( SCI_STYLESETBACK, SCE_FS_COMMENTLINE,  ::nClrPane )
        ::Send( SCI_STYLESETBACK, SCE_FS_OPERATOR,     ::nClrPane )
        ::Send( SCI_STYLESETBACK, SCE_FS_NUMBER,       ::nClrPane )
    
        ::Send( SCI_STYLESETBACK, SCE_FS_KEYWORD,      ::nClrPane )
        ::Send( SCI_STYLESETBACK, SCE_FS_KEYWORD4,     ::nClrPane )
        ::Send( SCI_STYLESETBACK, SCE_FS_KEYWORD2,     ::nClrPane )
        ::Send( SCI_STYLESETBACK, SCE_FS_KEYWORD3,     ::nClrPane )
     /*
        if Upper( ::oFont:cFaceName ) <> Upper( "FixedSys" )
            ::Send( SCI_STYLESETITALIC, SCE_FS_COMMENTLINE, 1 )
        endif
      */
        else
       
         ::SetAStyle( SCE_FS_COMMENTLINE,    ::cCCommentLin[ 1 ], ::nClrPane )
         ::SetAStyle( SCE_FS_COMMENTDOC,     ::cCComment[ 1 ]   , ::nClrPane )
         ::SetAStyle( SCE_FS_COMMENTLINEDOC, ::cCCommentLin[ 1 ], ::nClrPane )
         ::SetAStyle( SCE_FS_COMMENT,        ::cCComment[ 1 ]   , ::nClrPane  )
       
         ::Send( SCI_STYLESETFORE, STYLE_LINENUMBER, ::nTColorLin )
         ::Send( SCI_STYLESETBACK, STYLE_LINENUMBER, ::nBColorLin )
     
 
        ::Send( SCI_STYLESETFORE, SCE_FWH_OPERATOR, ::cCOperator[ 1 ] )
        ::Send( SCI_STYLESETFORE, SCE_FWH_STRING, ::cCString[ 1 ] )
        ::Send( SCI_STYLESETFORE, SCE_FWH_NUMBER, ::cCNumber[ 1 ] )
        ::Send( SCI_STYLESETFORE, SCE_FWH_BRACE, ::cCBraces[ 1 ] )
        ::Send( SCI_STYLESETFORE, SCE_FWH_IDENTIFIER, ::cCIdentif[ 1 ] )
       
        ::Send( SCI_STYLESETFORE, SCE_FWH_KEYWORD, ::cCKeyw1[ 1 ] )
        ::Send( SCI_STYLESETFORE, SCE_FWH_KEYWORD1, ::cCKeyw2[ 1 ] )
        ::Send( SCI_STYLESETFORE, SCE_FWH_KEYWORD2, ::cCKeyw3[ 1 ] )
        ::Send( SCI_STYLESETFORE, SCE_FWH_KEYWORD3, ::cCKeyw4[ 1 ] )
        ::Send( SCI_STYLESETFORE, SCE_FWH_KEYWORD4, ::cCKeyw5[ 1 ] )
      
        ::Send( SCI_STYLESETBACK, SCE_FWH_DEFAULT, ::nClrPane )
       
        ::Send( SCI_STYLESETBACK, SCE_FWH_OPERATOR, ::cCOperator[ 2 ] )
        ::Send( SCI_STYLESETBACK, SCE_FWH_STRING, ::cCString[ 2 ] )
        ::Send( SCI_STYLESETBACK, SCE_FWH_NUMBER, ::cCNumber[ 2 ] )
        ::Send( SCI_STYLESETBACK, SCE_FWH_BRACE, ::cCBraces[ 2 ] )
        ::Send( SCI_STYLESETBACK, SCE_FWH_IDENTIFIER, ::cCIdentif[ 2 ] )
   
        ::Send( SCI_STYLESETBACK, SCE_FWH_KEYWORD, ::cCKeyw1[ 2 ] )
        ::Send( SCI_STYLESETBACK, SCE_FWH_KEYWORD1, ::cCKeyw2[ 2 ] )
        ::Send( SCI_STYLESETBACK, SCE_FWH_KEYWORD2, ::cCKeyw3[ 2 ] )
        ::Send( SCI_STYLESETBACK, SCE_FWH_KEYWORD3, ::cCKeyw4[ 2 ] )
        ::Send( SCI_STYLESETBACK, SCE_FWH_KEYWORD4, ::cCKeyw5[ 2 ] )
     
        ::Send( SCI_STYLESETCASE, SCE_FWH_COMMENTDOC, ::cCComment[ 3 ] )
        ::Send( SCI_STYLESETCASE, SCE_FWH_COMMENT, ::cCComment[ 3 ] )
        ::Send( SCI_STYLESETCASE, SCE_FWH_COMMENTLINE, ::cCCommentLin[ 3 ] )
        
        ::Send( SCI_STYLESETCASE, SCE_FWH_OPERATOR, ::cCOperator[ 3 ] )
        ::Send( SCI_STYLESETCASE, SCE_FWH_STRING, ::cCString[ 3 ] )
        ::Send( SCI_STYLESETCASE, SCE_FWH_NUMBER, ::cCNumber[ 3 ] )
        ::Send( SCI_STYLESETCASE, SCE_FWH_BRACE, ::cCBraces[ 3 ] )
        ::Send( SCI_STYLESETCASE, SCE_FWH_IDENTIFIER, ::cCIdentif[ 3 ] )
  
        ::Send( SCI_STYLESETCASE, SCE_FWH_KEYWORD, ::cCKeyw1[ 3 ] )
        ::Send( SCI_STYLESETCASE, SCE_FWH_KEYWORD1, ::cCKeyw2[ 3 ] )
        ::Send( SCI_STYLESETCASE, SCE_FWH_KEYWORD2, ::cCKeyw3[ 3 ] )
        ::Send( SCI_STYLESETCASE, SCE_FWH_KEYWORD3, ::cCKeyw4[ 3 ] )
        ::Send( SCI_STYLESETCASE, SCE_FWH_KEYWORD4, ::cCKeyw5[ 3 ] )
        
        /*
        //::Send( SCI_STYLESETFONT, SCE_FWH_DEFAULT , ::oFont:cFaceName ) //::oFntLin:cFaceName )
        //::Send( SCI_STYLESETSIZE , SCE_FWH_DEFAULT, Abs( Int( ::oFont:nHeight ) * 1 ) )
        //::Send( SCI_STYLESETFONT, SCE_FWH_COMMENT, ::oFont:cFaceName ) //::oFntLin:cFaceName )
        //::Send( SCI_STYLESETSIZE , SCE_FWH_COMMENT, Abs( Int( ::oFont:nHeight ) * 1 ) )
        
        if !Empty( ::oFont )
            if Upper( ::oFont:cFaceName ) <> Upper( "FixedSys" )
                ::Send( SCI_STYLESETITALIC, SCE_FWH_COMMENT, 1 )
                ::Send( SCI_STYLESETITALIC, SCE_FWH_COMMENTDOC, 1 )
                ::Send( SCI_STYLESETITALIC, SCE_FWH_COMMENTLINE, 1 )
            endif
        endif
       */
    endif
  
return nil



//----------------------------------------------------------------------------//

Function CadWordFold( nOp )
Local cCad2 := "function return procedure"

Local cCad3 := "class endclass from data classdata method inline virtual setget "+;
"super with object endobject"
DEFAULT nOp  := 1
Return if( nOp = 1, cCad2, cCad3 )

//----------------------------------------------------------------------------//

