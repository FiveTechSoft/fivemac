#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TSplitItem FROM TControl

   DATA   hWnd
   DATA   oWnd

   METHOD New( oWnd )
   
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd ) CLASS TSplitItem

   ::hWnd = SplitSetSubview( oWnd:hWnd )  
   ::oWnd = oWnd
 
   oWnd:AddControl( Self )
   
   AAdd( GetAllWin(), Self ) // it receives msgs from its child controls 
 
return Self

//----------------------------------------------------------------------------//