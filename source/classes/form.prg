#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TForm FROM TWindow

   CLASSDATA aForms INIT {}
   
   CLASSDATA aProps INIT { "nTop", "nLeft", "nWidth", "nHeight", "cText",;
   	                       "cVarName", "lFlipped" }

   DATA   oSelControl // current dragged control
   
   DATA   oLastControl // last selected control

   DATA   nRowStart, nColStart
   
   DATA   oInspector
   
   DATA   lCtrlResize INIT .F.

   METHOD New()

   METHOD Initiate()
   
   METHOD LButtonDown( nRow, nCol )
   
   METHOD MouseMove( nRow, nCol )
   
   METHOD LButtonUp( nRow, nCol )
   
   METHOD DelControl()
   
   METHOD ShowPopup( nRow, nCol )
   
   METHOD KeyDown( nKey )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS TForm

   ::Super:New()
   
   AAdd( ::aForms, Self )
   
   ::SetTitle( "Form" + AllTrim( Str( Len( ::aForms ) ) ) )
   ::lFlipped = .T.
   ::SetPos( 190, 530 )
   ::SetSize( 500, 356 )
   ::Initiate()
   
   ::cVarName = "oForm" + AllTrim( Str( Len( ::aForms ) ) )

return Self

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TForm

   ::bResized = { || If( ::oInspector != nil, ::oInspector:Refresh(),) }
   ::bRClicked = { | nRow, nCol | ::ShowPopup( nRow, nCol ) }

return self

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey ) CLASS TForm

   do case
      case nKey == 63232 // VK_UP
           if ::oLastControl != nil
              ::oLastControl:nTop--
           endif

      case nKey == 63233 // VK_DOWN
           if ::oLastControl != nil
              ::oLastControl:nTop++
           endif

      case nKey == 63234 // VK_LEFT
           if ::oLastControl != nil
              ::oLastControl:nLeft--
           endif

      case nKey == 63235 // VK_RIGHT
           if ::oLastControl != nil
              ::oLastControl:nLeft++
           endif
      
      otherwise
           MsgInfo( nKey )
   endcase           

   if ::oInspector != nil
      ::oInspector:Refresh()
   endif   

return 1

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol ) CLASS TForm

   local oCtrl := ::AtControl( nRow, nCol )

   if ! ::SetDesign()
      if ! Empty( ::GetEventCode( "OnClick" ) )
         Eval( ::GetEventBlock( "OnClick" ), nRow, nCol, Self )
      endif
      return nil
   endif

   ::oSelControl  = oCtrl
   ::oLastControl = oCtrl
   
   if ::oInspector != nil
      if ::oSelControl != nil
         ::oInspector:SetControl( oCtrl )
         if ::nHeight - nRow - 20 > oCtrl:nTop + oCtrl:nHeight - 10 .and. ;
            ::nHeight - nRow - 20 <= oCtrl:nTop + oCtrl:nHeight .and. ;
            nCol - oCtrl:nLeft > oCtrl:nWidth - 5 .and. ;
            nCol - oCtrl:nLeft <= oCtrl:nWidth
            ::lCtrlResize = .T.
            ::nRowStart = ::nHeight - nRow - oCtrl:nTop - oCtrl:nHeight
         endif            
      else   
         ::oInspector:SetForm( Self )
         ::lCtrlResize = .F.
         if ! Empty( ::bLButtonDown )
            Eval( ::bLButtonDown, nRow, nCol, Self )
         endif   
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol ) CLASS TForm

   ::oSelControl = nil
   ::nRowStart   = nil
   ::nColStart   = nil
   ::lCtrlResize = .F.
   
   if ::oInspector != nil
      ::oInspector:Refresh()
   endif   

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol ) CLASS TForm

   local oCtrl := ::oSelControl

   if oCtrl != nil
      if ::nRowStart == nil
         ::nRowStart = nRow + oCtrl:nTop
         ::nColStart = nCol - oCtrl:nLeft 
      endif   
   
      if ! ::lCtrlResize
         oCtrl:SetPos( ::nRowStart - nRow, nCol - ::nColStart )
      else
         SetCursorImage( UserPath() + "/fivemac/cursors/northWestSouthEastResizeCursor.png" )
         oCtrl:SetSize( nCol - oCtrl:nLeft, ::nHeight - nRow - oCtrl:nTop - ::nRowStart )
      endif                     
         
      if ::oInspector != nil
         ::oInspector:Refresh()
      endif   
   else
      if ( oCtrl := ::AtControl( nRow, nCol ) ) != nil
         if ( ::nHeight - nRow - 20 > oCtrl:nTop + oCtrl:nHeight - 10 .and. ;
              ::nHeight - nRow - 20 <= oCtrl:nTop + oCtrl:nHeight ) .and. ;
            ( nCol - oCtrl:nLeft > oCtrl:nWidth - 10 .and. ;
              nCol - oCtrl:nLeft <= oCtrl:nWidth )
            SetCursorImage( UserPath() + "/fivemac/cursors/northWestSouthEastResizeCursor.png" )
         else
            SetCursorArrow()   
         endif 
      else
         SetCursorArrow()   
      endif
   endif   
   
return nil    

//----------------------------------------------------------------------------//

METHOD DelControl() CLASS TForm

   local oCtrl := ::oLastControl

   if ! Empty( oCtrl ) .and. ;
      MsgYesNo( "Do you want to delete control " + oCtrl:cVarName + " ?" )

      if ::oInspector != nil
         ::oInspector:DelControl( oCtrl )
      endif   

      oCtrl:End()
      ::oLastControl = nil
             
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ShowPopup( nRow, nCol ) CLASS TForm

   local oPopup, oCtrl := ::oLastControl
   
   MENU oPopup POPUP
      MENUITEM "Selected control"
      MENU
         MENUITEM "Horizontal center" ACTION If( oCtrl != nil,;
                     oCtrl:SetPos( oCtrl:nTop,;
                     oCtrl:oWnd:nWidth / 2 - oCtrl:nWidth / 2 ),)
                     
         MENUITEM "Vertical center" ACTION If( oCtrl != nil,;
                     oCtrl:SetPos( oCtrl:oWnd:nHeight / 2 - ;
                     oCtrl:nHeight / 2, oCtrl:nLeft ),)
         
         SEPARATOR
         
         MENUITEM "Delete control" ACTION ::DelControl()
      ENDMENU
      
      SEPARATOR
      
      if ::SetDesign()
         MENUITEM "Test mode" ACTION ::SetDesign( .F. )
      else
         MENUITEM "Design mode" ACTION ::SetDesign( .T. )
      endif
      
      SEPARATOR  
      
      MENUITEM "PRG source code" ;
         ACTION SourceEdit( ::cGenPrg(), "Source code" )
   ENDMENU
   
   ACTIVATE POPUP oPopup OF Self AT nRow, nCol

return nil

//----------------------------------------------------------------------------//