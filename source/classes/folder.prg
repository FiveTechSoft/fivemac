#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TFolder FROM TControl

   DATA aItems

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, aPages, cVarName, lFlipped )
   
   METHOD AddItem( cPrompt ) 
   
   METHOD FindControl( hWnd )
   
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, aPages, cVarName, lFlipped ) CLASS TFolder

   local n

   DEFAULT aPages := { "One", "Two", "Three" }
   DEFAULT lFlipped := .F.
   
   ::hWnd = FldCreate(  nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
   
   ::lFlipped = lFlipped
   ::aItems = {}
   
   for n = 1 to Len( aPages )
      ::AddItem( aPages[ n ] )
   next   
   
   oWnd:AddControl( Self )
   
   DEFAULT cVarName := "oFld" + ::GetCtrlIndex()
   
   ::cVarName = cVarName
   
return Self   

//----------------------------------------------------------------------------//

METHOD AddItem( cPrompt ) CLASS TFolder

   AAdd( ::aItems, TFolderItem():New( cPrompt, Self ) )
   
return nil   

//----------------------------------------------------------------------------//

METHOD FindControl( hWnd ) CLASS TFolder

   local n, oControl
   
   for n = 1 to Len( ::aItems )
      if ::aItems[ n ]:hWnd == hWnd
         return ::aItems[ n ]
      else
         if ( oControl := ::aItems[ n ]:FindControl( hWnd ) ) != nil
	    return oControl
	 endif
      endif
   next
   
return 0   

//----------------------------------------------------------------------------//