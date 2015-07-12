#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TClipGet FROM Get

   METHOD Display() VIRTUAL

ENDCLASS



//---------------------------------------------------------------------------//

function FWGetNew( nRow, nCol, bVarBlock, cVarName, cPicture, cColor )

return TClipGet():New( nRow, nCol, bVarBlock, cVarName, cPicture, cColor )

//---------------------------------------------------------------------------//
