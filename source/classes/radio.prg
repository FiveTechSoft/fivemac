#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TRadio FROM TControl

   DATA   oRadMenu

   METHOD New( nRow, nCol, nWidth, nHeight, oWnd, cText, oRadMenu, lUpdate )
   METHOD Click()
   METHOD lChecked() INLINE ChkGetState( ::hWnd )
   METHOD SetCheck( lOnOff ) INLINE ChkSetState( ::hWnd, lOnOff )
   METHOD SetText( cText ) INLINE BtnSetText( ::hWnd, cText )
   METHOD GetText() INLINE BtnGetText( ::hWnd )
   
   METHOD Redefine( nId, oWnd, cText , oRadMenu , lUpdate )  
   METHOD Initiate() 

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, nWidth, nHeight, oWnd, cText, oRadMenu, lUpdate ) ;
   CLASS TRadio

   DEFAULT oWnd := GetWndDefault(), nWidth := 100, nHeight := 23,;
           lUpdate := .F., oRadMenu := TRadMenu()

   ::hWnd     = RadCreate( nRow, nCol, nWidth, nHeight, cText, oWnd:hWnd )
   ::oRadMenu = oRadMenu
   ::lUpdate  = lUpdate
   ::oWnd     = oWnd

   oWnd:AddControl( Self )

   ::cVarName = "oRad" + ::GetCtrlIndex()

return Self

//----------------------------------------------------------------------------//

METHOD Click() CLASS TRadio

   local nAt := AScan( ::oRadMenu:aItems, { | oRadio | oRadio:hWnd == ::hWnd } )

   if ::lChecked .and. nAt != 0
      Eval( ::oRadMenu:bSetGet, nAt )
   endif
   
   for n = 1 to Len( ::oRadMenu:aItems )
      if n != nAt
         ::oRadMenu:aItems[ n ]:SetCheck( .f. )
      endif
   next      

return nil

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, cText , oRadMenu , lUpdate ) CLASS  TRadio
  
   local hGroup := oRadMenu:hGroup
  
   DEFAULT oWnd := GetWndDefault(), lUpdate := .F.
 
   ::nId     = nId
   ::oWnd    = oWnd
   ::lUpdate = lUpdate
   ::oRadMenu = oRadMenu
   
   oWnd:DefControl( Self ) 
     
return Self

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TRadio

   local hWnd := BtnResCreate( ::oWnd:hWnd, ::nId )   

   if hWnd != 0
      ::hWnd = hWnd
   else
      MsgAlert( "Non defined Radio ID " + AllTrim( Str( ::nId ) ) + ;
      " in resource " + ::oWnd:cNibName )
   endif

return nil

//----------------------------------------------------------------------------//