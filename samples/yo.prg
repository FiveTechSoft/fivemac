#include "FiveMac.ch"


function Main()

local nValue := 0
local nEntero
local ownd

 DEFINE WINDOW oWnd FROM 100, 100 TO 800, 1200 FULL
 
 
 ACTIVATE WINDOW oWnd ON INIT ( Espar(), ownd:end() )
 
 
return nil

Function Espar(  )

local nEntero

local nValue := 0

do while .t.

  msgGet( "es par?","atencion", @nValue )
    if nValue == 0
       exit
    endif

nEntero:= int( nValue /2 )

if  ( nValue/2 ) == nEntero
  Msginfo("par")
else
   msginfo( "impar" )
endif

enddo

Return 
