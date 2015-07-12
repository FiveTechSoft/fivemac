#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TFolderItem FROM TControl

   METHOD New( cPrompt, oFolder )
   METHOD AddControl( oControl ) INLINE AAdd( ::aControls, oControl )
   
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cPrompt, oFolder ) CLASS TFolderItem

   ::hWnd = FldAddItem( oFolder:hWnd, cPrompt )
   ::aControls = {}
   
return Self   

//----------------------------------------------------------------------------//