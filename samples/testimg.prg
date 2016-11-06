#include "FiveMac.ch"

function Main()

   local oWnd, oImg


   local cfile  //:= cGetfile("escoge la imagen ")
   local cNewFile

   DEFINE WINDOW oWnd ;
      FROM 444, 89 TO 689, 500
   
   oWnd:center()

   @ 100, 139 IMAGE oImg OF oWnd SIZE 107, 91 FILENAME ImgPath() + "fivetech.gif"

   oImg:bLButtonDown = { || MsgInfo( oImg:GetHeight() ) }

   @ 69, 95 SAY "(c) FiveTech Software 2007-2016" OF oWnd SIZE 210, 14
   
   @ 22, 150 BUTTON "Ok" OF oWnd ACTION oWnd:End()
   
    @ 22, 250 BUTTON "Frame" OF oWnd ACTION ( MsgInfo( oImg:GetWidth() ), oImg:setFrame( ) )

   ACTIVATE WINDOW oWnd
   
return nil


Function SaveImage( cType )
local cImage := "_MG_1706"

local cPathIni := UserPath()+"/Desktop/cross grases 2016/"

//local cFile := cPathIni +  cImage +".CR2"

local cfile := cGetfile("escoge la imagen ")

local cPathFin := UserPath()+"/Desktop/"
local cNewFile := cPathFin + cImage +"." + cType

//local cfile := cGetfile("escoge la imagen ")
//local cNewFile

local hImage := NSIMGFROMFILE( cFile )

local nWidth := NSIMGGETWIDTH( hImage )
local nHeight:= NSIMGGETHEIGHT( hImage )

//msginfo( cfile )

//msgGet( "Atencion", "Ponga el ancho", @nWidth )
//msgGet( "Atencion", "Ponga el alto", @nHeight )

// cNewFile := SaveFile( "Save Image as", "*.jpg" )

// SAVEIMAGEFROMIMAGE( cFile,cNewFile, nWidth,nHeight  )

 SAVETEXTINIMAGE( cFile,cNewFile, "Corriendo",40, 20,40  )  // fileini,filefin,ctexto, fuente, ntop, nleft
Return nil
