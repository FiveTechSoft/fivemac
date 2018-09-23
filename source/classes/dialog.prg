#include "FiveMac.ch"

#define NSBorderlessWindowMask               0
#define NSTitledWindowMask                   1
#define NSClosableWindowMask                 2
#define NSMiniaturizableWindowMask           4
#define NSResizableWindowMask                8
#define NSUtilityWindowMask                 16
#define NSTexturedBackgroundWindowMask     256

//----------------------------------------------------------------------------//

CLASS TDialog FROM TWindow

   METHOD New( nTop, nLeft, nBottom, nRight, cTitle, lTextured, lPaneled,;
               nWidth, nHeight ,lflipped )

   METHOD Activate( bLClicked, bValid, lModeless, lCentered, bInit, bRClicked,;
                    bResized )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight, cTitle, lTextured, lPaneled ,nWidth, nHeight ,lflipped ) CLASS TDialog

   DEFAULT nTop := 300, nLeft := 300, nBottom := 700, nRight := 800,;
                 cTitle := "FiveMac", lTextured := .f., lPaneled := .f. ,;
                 lflipped:= .f.

   ::lflipped:= lflipped
    
   ::hWnd = WndCreate( nTop, nLeft, nRight - nLeft, nBottom - nTop,;
                       nOr( NSTitledWindowMask, NSClosableWindowMask,;
	                     NSMiniaturizableWindowMask,;
					             If( lTextured, NSTexturedBackgroundWindowMask, 0 ),;
					             If( lPaneled, NSUtilityWindowMask, 0 ) ) )
  
 
   if nWidth != nil .or. nHeight!= nil
        ::SetSize( nWidth, nHeight )
   endif   

    
   ::aControls = {}

   WndSetText( ::hWnd, cTitle )

   AAdd( GetAllWin(), Self )
   SetWndDefault( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Activate( bLClicked, bValid, lModeless, lCentered, bInit, bRClicked,;
                 bResized ) CLASS TDialog

   DEFAULT lModeless := .F., lCentered := .F.

   if bLClicked != nil
      ::bLButtonDown = bLClicked
   endif

   if bRClicked != nil
      ::bRClicked = bRClicked
   endif

   if bResized != nil
      ::bResized = bResized
   endif
   
   ::bValid = bValid

   if lCentered
      ::Center()
   endif

   // AEval( ::aControls, { | o | o:Initiate() } )

   if ! Empty( bInit )
     ::bInit = bInit
   endif
   if ! Empty( ::bInit )
       Eval( ::bInit, self )
   endif

   if ! lModeless
      DlgModal( ::hWnd )
      ::UnLink()
   endif

 
return nil

//----------------------------------------------------------------------------//

Function RoundMsg(cMensa,nTimer)
local oWnd
STATIC oMsgRWT
if !Empty(nTimer)
    oWnd := GetWndDefault()  
    oWnd:bOnTimer = { | nTimerId, oWnd |  RoundMsg()   } 
    TimerCreate( nTimer, oWnd:hWnd )
endif
if Empty(cMensa)
  MsgRoundClose(oMsgRWT)
 else
 oMsgRWT:= MsgRoundCreate( cMensa )
endif

Return nil

//----------------------------------------------------------------------------//

Function ShowWinInpopOver(oCrtl , oWnd ) // control pulsado - ventana a mostrar 
 
   ShowWinpopover(oCrtl:hWnd,oWnd:hwnd)
   
Return nil   
