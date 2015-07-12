#include "FiveMac.ch"


//----------------------------------------------------------------------------//

Function pausa(cMsg)
Msginfo(cMsg)
return nil

//----------------------------------------------------------------------------//

Function Compila( cBlock)
 return &("{||"+cBlock +"}")

//----------------------------------------------------------------------------//
Function SoloAbre(cfichero)
local cFich:= cDbfPath+cFichero
     USE (cfich) ALIAS (cCheckArea(cfichero)) NEW SHARED
    
Return Alias()

//----------------------------------------------------------------------------//

function cCheckArea( cDbfName )
 local n      := 2
 local cAlias := cDbfName
   while Select( cAlias ) != 0
      cAlias = cDbfName + AllTrim( Str( n++ ) )
   end
return cAlias

//------------------------------------------------------------------------------

Function Abrimos(cFile,cVia)
  if !Usamos(cFile,cCheckArea(cFile))
      Return nil
  endif
RETURN Alias()

//------------------------------------------------------------------------------

Function Usamos(fichero,alias)
    local cFichero:= cDbfPath+fichero
    Default alias:=  Fichero
	 USE (cFichero) ALIAS (alias) NEW SHARED VIA "DBFCDX"
    // dbusearea(.t.,,cfichero,alias,.t.)
Return  !netErr() 
  
