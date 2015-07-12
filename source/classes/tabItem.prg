#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TTabItem FROM TControl

   DATA hWnd, oWnd
   DATA cPrompt

   METHOD New( oWnd, cText )
 
   METHOD Redefine( oWnd, nIndex )  
   
   METHOD GenLocals()
   
   METHOD SetText(cText) INLINE ( ::cPrompt:= cText , TabViewItemSetLabel( ::hWnd,cText ) )   
   
              
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, cText ) CLASS TTabItem

   ::hWnd     = TabViewItemAdd( oWnd:hWnd, cText )
   ::oWnd     = oWnd
   ::cPrompt  = cText
   ::cVarName = oWnd:cVarName + ":aControls[ " + ;
                AllTrim( Str( Len( oWnd:aControls ) + 1 ) ) + " ]"
 
   oWnd:AddControl( Self )
 
return Self

//----------------------------------------------------------------------------//

METHOD Redefine( oWnd, nIndex ) CLASS TTabItem

   ::hWnd = TabViewGetItem( oWnd:hWnd, nIndex - 1 )
   ::oWnd = oWnd
 
   oWnd:AddControl( Self )
 
return Self

//----------------------------------------------------------------------------//

METHOD GenLocals() CLASS TTabItem

   local cLocals := "", n
   
   for n = 1 to Len( ::aControls )
      cLocals += ::aControls[ n ]:GenLocals()
   next
   
return cLocals   

//----------------------------------------------------------------------------//