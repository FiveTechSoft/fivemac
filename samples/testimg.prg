#include "FiveMac.ch"

function Main()

   local oWnd, oImg, ocbx, cType
   local i:= 0

   local cfile  //:= cGetfile("escoge la imagen ")
   local cNewFile

   DEFINE WINDOW oWnd ;
      FROM 444, 89 TO 689, 500
   
   oWnd:center()

 //  @ 100, 139 IMAGE oImg OF oWnd SIZE 107, 91 FILENAME cFile

   @ 69, 95 SAY "(c) FiveTech Software 2007-2012" OF oWnd SIZE 210, 14

// @ 22, 50 BUTTON "load" OF oWnd ACTION ( cfile := cGetfile("escoge la imagen "), oImg:setfile( cfile )  )

@ 21, 10 COMBOBOX oCbx VAR cType OF oWnd ;
SIZE 110, 25 ITEMS { "PNG", "JPG", "TIF", "BMP", "GIF" }


@ 22, 150 BUTTON "Save" OF oWnd ACTION SaveImage(cType )

@ 22, 250 BUTTON "Exit" OF oWnd ACTION oWnd:End()
   
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
