#include "FiveMac.ch"
#include "fmsgs.h"

#define NSBorderlessWindowMask               0
#define NSTitledWindowMask                   1
#define NSClosableWindowMask                 2
#define NSMiniaturizableWindowMask           4
#define NSResizableWindowMask                8
#define NSUtilityWindowMask                 16
#define NSTexturedBackgroundWindowMask     256

static aWindows := {}
static oWndDefault

//----------------------------------------------------------------------------//

CLASS TWindow

   DATA  hWnd         // handle to the NS object
   DATA  oWnd         // window parent
   DATA  aControls INIT {} // child controls array
   DATA  bInit        // action to perform before activation
   DATA  bKeyDown     // action to perform when a key is pressed
   DATA  bLButtonDown // action to perform when the mouse is left pressed
   DATA  bLButtonUp   // action to perform when the mouse is left released
   DATA  bRClicked    // action to perform when the mouse is right clicked
   DATA  bMMoved      // action to perform when the mouse is moved
   DATA  bValid       // VALID clause
   DATA  bResized     // action to perform when the window is resized 
   DATA  lValidResult // VALID clause result
   DATA  lWhenResult   // WHEN clause result
   DATA  bWhen
   DATA  oBar         // Toolbar
   DATA  bOnTimer
   DATA  cNibName
   DATA  bPainted
   DATA  lRounded INIT .F.
   DATA  cVarName
   DATA  oPopup
   DATA  lFlipped INIT .F.
   DATA  cCursor

   CLASSDATA aProps INIT { "nTop", "nLeft", "nWidth", "nHeight", "cText", "cVarName" }
   
   DATA aEvents INIT { { { "OnClick", "nRow", "nCol" }, nil },;
   	                   { { "OnClose" }, nil },;
   	                   { { "OnInit" }, nil } } 

   METHOD New( nTop, nLeft, nBottom, nRight, cTitle, lTextured, lPaneled, lNoBorder,;
               lFullScreen, nWidth, nHeight, lFlipped, cVarName )

   METHOD Activate( bLClicked, bValid, lMaximized, bPainted, lCentered, bInit,;
                    bRClicked, bResized )

   METHOD cText() INLINE ::GetText()

   METHOD GetText() INLINE WndGetText( ::hWnd )

   METHOD SetText( cText ) INLINE WndSetText( ::hWnd, cText )

   METHOD _cText( cNewText ) INLINE ::SetText( cNewText )

   METHOD AddControl( oControl )
   
   METHOD AtControl( nRow, nCol )

   METHOD CursorChange()
   
   METHOD DefControl( oControl )
   
   METHOD GetEventBlock( cEventName )
   
   METHOD GetEventCode( cEventName )

   METHOD HandleEvent( nMsg, nSender, uParam1, uParam2 )

   METHOD End()
   
   METHOD GenLocals()

   METHOD Refresh() INLINE WndRefresh( ::hWnd )

   METHOD KeyDown( nKey )
   
   METHOD SetTooltip( cText ) INLINE ViewSetTooltip( ::hWnd, cText )

   METHOD LButtonDown( nRow, nCol ) INLINE If( ::bLButtonDown != nil, Eval( ::bLButtonDown, nRow, nCol ),)

   METHOD LButtonUp( nRow, nCol ) INLINE If( ::bLButtonUp != nil, Eval( ::bLButtonUp, nRow, nCol ),)

   METHOD RButtonDown( nRow, nCol ) INLINE If( ::bRClicked != nil, Eval( ::bRClicked, nRow, nCol ),)

   METHOD MenuItemClick( nSender )

   METHOD MouseMove( nRow, nCol ) INLINE If( ::bMMoved != nil, Eval( ::bMMoved, nRow, nCol ),)

   METHOD nTop() INLINE WndTop( ::hWnd )

   METHOD _nTop( nNewTop ) INLINE WndTop( ::hWnd, nNewTop )

   METHOD nLeft() INLINE WndLeft( ::hWnd )

   METHOD _nLeft( nNewLeft ) INLINE WndLeft( ::hWnd, nNewLeft )

   METHOD nWidth() INLINE WndWidth( ::hWnd )

   METHOD _nWidth( nNewWidth ) INLINE WndWidth( ::hWnd, nNewWidth )

   METHOD nHeight() INLINE WndHeight( ::hWnd )
   
   METHOD ChangeHeight(nNewHeight) INLINE WinHeightChange(::hWnd, nNewHeight ) 
   
   METHOD ChangeWidth(nNewWidth) INLINE WinWidthChange(::hWnd, nNewWidth ) 
   
   METHOD ChangeSize(nNewHeight, nNewWidth ) INLINE WinSizeChange(::hWnd, nNewHeight, nNewWidth ) 
   
   METHOD SetSize( nWidth, nHeight ) INLINE WinSetSize( ::hWnd, nWidth, nHeight )  
   
   METHOD SetSizeChange(nNewHeight, nNewWidth ) INLINE WinSetSizeChange(::hWnd, nNewHeight, nNewWidth ) 
   
   METHOD _nHeight( nNewHeight ) INLINE WndHeight( ::hWnd, nNewHeight )

   METHOD lValid() INLINE ::lValidResult := If( ::bValid != nil, Eval( ::bValid, Self ), .t. )

   METHOD lWhen() INLINE ( ::lWhenResult := If( ::bWhen != nil, Eval( ::bWhen, Self ), .t. ) )

   METHOD UnLink()

   METHOD Center() INLINE WndCenter( ::hWnd ), If( ::nHeight < ScreenHeight() * 2 / 3, ::nTop -= 50,)

   METHOD Iconize() INLINE WndIconize( ::hWnd )

   METHOD Initiate()

   METHOD Maximize() INLINE WndMaximize( ::hWnd )

   METHOD FindControl( hWnd )

   METHOD Enable( lOnOff ) INLINE WndEnable( ::hWnd, lOnOff )
   
   METHOD FullScreen() INLINE WndfullScreen( ::hWnd )
   
   METHOD Resize() INLINE If( ::bResized != nil, Eval( ::bResized, Self ),)
   
   METHOD SetDesign( lOnOff ) INLINE WndDesign( ::hWnd, lOnOff )
   
   METHOD SetFocus() INLINE WndSetFocus( ::hWnd )

   METHOD SetMsgBar( cPrompt ) 

   METHOD SetSplash() INLINE WndSetSplash( ::hWnd )

   METHOD SetTrans(nTrans) INLINE WndSetTrans( ::hWnd,nTrans )

   METHOD Timer( nTimerID ) INLINE If( ! Empty( ::bOnTimer ), Eval( ::bOnTimer, nTimerID, Self ),)

   METHOD Update() INLINE AEval( ::aControls, { | o | If( o:lUpdate, o:Refresh(),) } )
   
   METHOD Define( cNibName ) 

   METHOD Paint() INLINE If( ::bPainted != nil, Eval( ::bPainted, Self ),)

   METHOD Say( nRow, nCol, cText ) INLINE WndSay( nRow, nCol, cText )
   
   METHOD Hide() INLINE WNDHIDE(::hwnd)
  
   METHOD Show() INLINE WNDSHOW(::hwnd) 
   
   METHOD AnimaShake( nShakes, nTime, nVigourOfShake ) 
   
   METHOD SetAutoresizesSubViews( lOnOff ) INLINE SetAutoresizesSubviews( ::hWnd, lOnOff )
   
   METHOD SetEventCode( cCode )
   
   METHOD SetPos( nRow, nCol ) INLINE WndSetPos( ::hWnd, nRow, nCol )
  
   METHOD SetTitle( cTitle ) INLINE WndSetText( ::hWnd, cTitle )  
   
   METHOD SetRounded() INLINE ::lRounded := .T., WndSetRounded( ::hWnd )
   
   METHOD cGenPrg()
   
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight, cTitle, lTextured, lPaneled, lNoBorder,;
            lFullScreen, lRounded, nWidth, nHeight, lFlipped, cVarName ) CLASS TWindow

   DEFAULT nTop := 200, nLeft := 300, nBottom := 600, nRight := 800,;
           cTitle := "FiveMac", lTextured := .F., lPaneled := .F.,;
           lNoborder := .F., lFullScreen := .F., lRounded:= .F., lFlipped := .f.

   ::lFlipped = lFlipped
      
   ::hWnd = WndCreate( nTop, nLeft, nRight - nLeft, nBottom - nTop,;
                       If( lNoborder, NSBorderlessWindowMask,;
                       nOr( NSTitledWindowMask, NSClosableWindowMask,;
	                     NSMiniaturizableWindowMask, NSResizableWindowMask,;
					             If( lTextured, NSTexturedBackgroundWindowMask, 0 ),;
					             If( lPaneled, NSUtilityWindowMask, 0 ) ) ) )
   
   if nWidth != nil
      ::SetPos( ScreenHeight() / 2 - nHeight / 2,;
                ScreenWidth() / 2 - nWidth / 2 )
      ::SetSize( nWidth, nHeight )
   endif   
      
   if lRounded
      ::SetRounded() 
   endif
   
   WndSetText( ::hWnd, cTitle )

   AAdd( aWindows, Self )
   SetWndDefault( Self )

   if lFullScreen
      ::FullScreen()
   endif

   DEFAULT cVarName := "oWnd"
   
   ::cVarName = cVarName

return Self

//----------------------------------------------------------------------------//

METHOD Activate( bLClicked, bValid, lMaximized, bPainted, lCentered, bInit,;
                 bRClicked, bResized ) CLASS TWindow

   DEFAULT lMaximized := .F., lCentered := .F.

   if bLClicked != nil
      ::bLButtonDown = bLClicked
   endif

   if bRClicked != nil
      ::bRClicked = bRClicked
   endif
   
   if bValid != nil   
      ::bValid = bValid
   endif
   
   if bPainted != nil   
      ::bPainted = bPainted
   endif   

   if bResized != nil   
      ::bResized = bResized
   endif   

   if lMaximized
      ::Maximize()
   endif

   if lCentered
      ::Center()
   endif   

   if ! Empty( bInit )
      ::bInit = bInit
      Eval( bInit, self )
   endif   

   if Empty( ::cNibName )
      WndRun( ::hWnd )
   else
      ::hWnd = WndFromNib( ::cNibName )
      ::Initiate()
   endif      

return nil

//----------------------------------------------------------------------------//

METHOD AddControl( oControl ) CLASS TWindow

   AAdd( ::aControls, oControl )
   
   oControl:oWnd = Self
   
return nil

//----------------------------------------------------------------------------//

METHOD AtControl( nRow, nCol ) CLASS TWindow

   local hCtrl := WndHitTest( ::hWnd, nRow, nCol ), n, oCtrl
   local nAt := AScan( ::aControls, { | oCtrl | oCtrl:hWnd == hCtrl } )

   if nAt == 0
      if ( oCtrl := ::FindControl( hCtrl ) ) != nil
         return oCtrl
      endif    
   endif             

return If( nAt != 0, ::aControls[ nAt ],)

//----------------------------------------------------------------------------//

METHOD DefControl( oCtrl ) CLASS TWindow

   // DEFAULT oCtrl:nId := oCtrl:GetNewId()

   if AScan( ::aControls, { | o | o:nId == oCtrl:nId } ) > 0
      MsgAlert( "Duplicated control ID " + Str( oCtrl:nId ) )
      // #define DUPLICATED_CONTROLID  2
      // Eval( ErrorBlock(), _FWGenError( DUPLICATED_CONTROLID, ;
      //                     "No: " + Str( oCtrl:nId, 6 ) ) )
   else
      AAdd( ::aControls, oCtrl )
      oCtrl:hWnd = 0
   endif

return nil 

//----------------------------------------------------------------------------//

METHOD Define( cNibName ) CLASS TWindow

   ::cNibName  = cNibName
   ::aControls = {}
   
   AAdd( aWindows, Self )
   SetWndDefault( Self )
   
return Self   

//----------------------------------------------------------------------------//

METHOD End() CLASS TWindow

   if ::lRounded
      WndDestroy( ::hWnd )
      ::UnLink()
   else
      WndClose( ::hWnd )
      if ::lValidResult
         ::UnLink()
      endif
   endif

return nil

//----------------------------------------------------------------------------//
METHOD CursorChange() CLASS TWindow

//msginfo("yo")

Return nil

//----------------------------------------------------------------------------//
METHOD AnimaShake( nShakes, nTime, nVigourOfShake ) CLASS TWindow

   DEFAULT nShakes := 10, nTime := 0.8, nVigourOfShake := 1 
 
   AnimaShake( ::hWnd, nShakes, nTime, nVigourOfShake )
      
return nil
 
//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TWindow

   local n
   
   for n = 1 to Len( ::aControls )
      ::aControls[ n ]:Initiate()
   next

return nil

//----------------------------------------------------------------------------//

METHOD MenuItemClick( hMenuItem ) CLASS TWindow

   if ::oPopup != nil
	    ::oPopup:Click( hMenuItem )
	 
	 elseif GetMenu() != nil
	    GetMenu():Click( hMenuItem )   
   
   endif

return nil

//----------------------------------------------------------------------------//

METHOD UnLink() CLASS TWindow

   local nAt

   if ( nAt := AScan( aWindows, { | o | o:hWnd == ::hWnd } ) ) != 0
      ADel( aWindows, nAt )
      ASize( aWindows, Len( aWindows ) - 1 )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetEventCode( cEventName, cCode ) CLASS TWindow

   local nAt := AScan( ::aEvents, { | aEvent | aEvent[ 1 ][ 1 ] == cEventName } )
   
   if nAt != 0
      ::aEvents[ nAt ][ 2 ] = cCode
   endif
   
return nil      

//----------------------------------------------------------------------------//

METHOD SetMsgBar( nHeight, cPrompt ) CLASS TWindow

   local oSay

   DEFAULT nHeight := 24, cPrompt := Space( 100 )
   
   WndSetMsgBar( ::hWnd, nHeight )
   
   @ 0, 10 SAY oSay PROMPT cPrompt OF self SIZE 150, 20 RAISED
   
return oSay

//----------------------------------------------------------------------------//

METHOD FindControl( hWnd ) CLASS TWindow

   local n, oControl

   if ::aControls == nil .or. Len( ::aControls ) == 0
      return nil
   endif

   for n = 1 to Len( ::aControls )
      if ::aControls[ n ]:hWnd == hWnd
         return ::aControls[ n ]
      else
         if ( oControl := ::aControls[ n ]:FindControl( hWnd ) ) != nil
	          return oControl
	       endif
      endif
   next

return nil

//----------------------------------------------------------------------------//

METHOD GenLocals() CLASS TWindow

   local cLocals := "   local " + ::cVarName, n
   
   for n = 1 to Len( ::aControls )
      cLocals += ::aControls[ n ]:GenLocals()
   next
   
return cLocals   

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TWindow

   local cCode := '#include "FiveMac.ch"' + CRLF + CRLF
   
   cCode += "function BuildWindow()" + CRLF + CRLF
   
   cCode += ::GenLocals()
   
   cCode += CRLF + CRLF + "   DEFINE WINDOW " + ::cVarName + " ;" + CRLF + ;
                '      TITLE "' + ::GetText() + '" ;' + CRLF + ;
                "      SIZE " + AllTrim( Str( ::nWidth ) ) + ;
                ", " + AllTrim( Str( ::nHeight ) )
                
   if ::lFlipped
      cCode += " FLIPPED"
   endif                

   AEval( ::aControls, { | o | cCode += o:cGenPrg() } )

   cCode += CRLF + CRLF + "   ACTIVATE WINDOW " + ::cVarName + " CENTERED "
                  
   cCode += CRLF + CRLF + "return " + ::cVarName               
                  
return cCode                  

//----------------------------------------------------------------------------//

METHOD GetEventBlock( cEventName ) CLASS TWindow

   local nAt := AScan( ::aEvents, { | aEvent | aEvent[ 1 ][ 1 ] == cEventName } )
   local cCode := "{ | ", n
   
   if nAt != 0
      for n = 2 to Len( ::aEvents[ nAt ][ 1 ] ) - 1
         cCode += ::aEvents[ nAt ][ 1 ][ n ] + ", " 
      next  
      return &( SubStr( cCode, 1, Len( cCode ) - 2 ) + ;
                "| " + ::aEvents[ nAt ][ 2 ] + " }" )  
   endif
   
return nil      

//----------------------------------------------------------------------------//

METHOD GetEventCode( cEventName ) CLASS TWindow

   local nAt := AScan( ::aEvents, { | aEvent | aEvent[ 1 ][ 1 ] == cEventName } )
   
   if nAt != 0
      return ::aEvents[ nAt ][ 2 ]  
   endif
   
return nil      

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nSender, uParam1, uParam2, uParam3 ) CLASS TWindow

   local oControl := If( nSender != nil, ::FindControl( nSender ),), oCtrl
  
   if oControl == nil
      if nMsg == WM_BRWROWS // the request is sent before its hWnd has been assigned
         for each oCtrl in ::aControls
            if oCtrl:IsKindOf( "TWBROWSE" ) .and. Empty( oCtrl:hWnd )
               oCtrl:hWnd = uParam2
               oControl = oCtrl
               exit
            endif
         next
      endif
   endif

   do case
        case nMsg == WM_PAINT
             return ::Paint()

        case nMsg == WM_KEYDOWN
             if oControl != nil
		      return oControl:KeyDown( uParam1 )
             else
                return ::KeyDown( uParam1 ) 
		   endif

        case nMsg == WM_WNDSETCURSOR
                 ::CursorChange()
                case nMsg == WM_MOUSEMOVED
             return ::MouseMove( uParam1, uParam2 )

        case nMsg == WM_LBUTTONDOWN
             return ::LButtonDown( uParam1, uParam2 )

        case nMsg == WM_LBUTTONUP
             return ::LButtonUp( uParam1, uParam2 )

        case nMsg == WM_RBUTTONDOWN
             return ::RButtonDown( uParam1, uParam2 )
        
        case nMsg == WM_RESIZE
             return ::Resize()
             
        case nMsg == WM_WNDVALID
             return ::lValid()
             
        case nMsg == WM_WHEN
              return ::lWhen()
        
        case nMsg == WM_BTNCLICK
	           if oControl != nil
	              oControl:Click()
             endif

        case nMsg == WM_CHKCLICK
	           if oControl != nil
	              oControl:Click()
	           endif
               
        case nMsg == WM_FLIPPED
             if oControl != nil
                return oControl:lFlipped
             else   
	              return ::lFlipped
	           endif   
	           
       case nMsg == WM_CBXCHANGE
	          if oControl != nil
	             oControl:Change()
	          endif
	
       case nMsg == WM_MENUITEM
            ::MenuItemClick( nSender )

	    case nMsg == WM_BRWROWS
	         if oControl != nil
		          return oControl:Rows()
		       endif
		
	    case nMsg == WM_BRWVALUE
	         if oControl != nil
		          return oControl:GetValue( uParam1, uParam2 )
		       else
		          MsgInfo( "oControl is nil" )
		       endif

      case nMsg == WM_BRWSETVALUE
           if oControl != nil
              return oControl:SetValue( uParam1, uParam2, uParam3 )
	      else
		   MsgInfo( "oControl is nil" )
		endif	
  
      case nMsg == WM_BRWCLRTEXT
           if oControl != nil
              return oControl:GetTextColor( uParam1, uParam2 )
           endif  

      case nMsg == WM_TBRCLICK
	         if ::oBar != nil
		          ::oBar:Click( nSender )
           endif

      case nMsg == WM_TIMER
           ::Timer( nSender )

      case nMsg == WM_SLIDERCHANGE
           if oControl != nil
	            oControl:Change()
	         endif
           
      case nMsg == WM_BRWDBLCLICK
	         if oControl != nil
	            oControl:Click()
           endif  
      
      case nMsg == WM_BRWCHANGED
	         if oControl != nil
	            oControl:Change()
	         endif
      case nMsg == WM_BRWDRAWRECT
         if oControl != nil 
               oControl:drawrect( uParam1 )
	         endif
	    case nMsg == WM_HEADCLICK
	         if oControl != nil
              oControl:HeadClick( uParam1 + 1 ) 					
	        endif

      case nMsg == WM_SHEETOK
           if oControl != nil
              oControl:Click( uParam1, uParam2 ) 					
	         endif

      case nMsg == WM_SCINOTIFY
           if oControl != nil
              oControl:Notify( uParam1, uParam2 )
           else
              MsgInfo( GetClassName( nSender ) )   
           endif   
           
      case nMsg == WM_CLRCHANGE
           if oControl != nil
              oControl:Change()
           endif    
           
      case nMsg == WM_TABITEMSEL
           if oControl != nil
              oControl:Change( uParam1 )
           endif   
                    				
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey ) CLASS TWindow

   if ! Empty( ::bKeyDown )
      return Eval( ::bKeyDown, nKey, Self )
   endif

return nil

//----------------------------------------------------------------------------//

function _FMH( hWnd, nMsg, hSender, uParam1, uParam2 ,uParam3 )

   local nAt := AScan( aWindows, { | o | o:hWnd == hWnd } )

   if nAt != 0
       return aWindows[ nAt ]:HandleEvent( nMsg, hSender, uParam1, uParam2, uParam3 )
   // else
   //     MsgInfo( "nAt is zero in _FMH" )
   endif

return nil

//----------------------------------------------------------------------------//

function _FMO( hWnd, nMsg, hSender, uParam1, uParam2 )

   local oControl, nAt := AScan( aWindows, { | o | o:hWnd == hWnd } )

   if nAt != 0
      oControl := aWindows[ nAt ]:FindControl( hSender )
      if oControl != nil
         return oControl:HandleEvent( nMsg, uParam1, uParam2 )
      endif
   else
      MsgInfo( "nAt is zero in FMO" )
   endif

return nil

//----------------------------------------------------------------------------//

function GetAllWin()

return aWindows

//----------------------------------------------------------------------------//

function SetWndDefault( oWnd )

   oWndDefault = oWnd

return nil

//----------------------------------------------------------------------------//

function GetWndDefault()

return oWndDefault

//----------------------------------------------------------------------------//

init procedure _Start

   CocoaInit()

return

//----------------------------------------------------------------------------//

exit procedure _End

   CocoaExit()

return

//----------------------------------------------------------------------------//