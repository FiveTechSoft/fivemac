// Application general settings

#include "FiveMac.ch"

static cImgPath

//----------------------------------------------------------------------------//

function ImgPath()

   local aFiles, n, lInit := Empty( cImgPath )

   DEFAULT cImgPath := UserPath() + "/fivemac/bitmaps/"
   
   if ! lIsDir( ResPath() + "/bitmaps" )
      MakeDir( ResPath() + "/bitmaps" )
   endif
      
   if lInit   
      aFiles = Directory( cImgPath + "*" )
      for n = 1 to Len( aFiles )
         if ! File( ResPath() + "/bitmaps/" + aFiles[ n ][ 1 ] )
            CopyFileTo( cImgPath + aFiles[ n ][ 1 ],;
                        ResPath() + "/bitmaps/" + aFiles[ n ][ 1 ] )
         endif               
      next
   endif   
  
   cImgPath = ResPath() + "/bitmaps/"               
      
return cImgPath 

//----------------------------------------------------------------------------//

function ImgDefPath(cImage,cPathImg)

   local aFiles, n
    
   DEFAULT cPathImg := UserPath() + "/fivemac/bitmaps/"
      
   if ! lIsDir( ResPath() + "/bitmaps" )
      MakeDir( ResPath() + "/bitmaps" )
   endif
   if !isFile( ResPath() + "/bitmaps/"+cImage  )
       copyImgInRes( cImage ,cPathImg )   
   endif
return ResPath() + "/bitmaps/"+cImage


//----------------------------------------------------------------------------//

function copyImgInRes( cImage, cPathImg )

   local n
       
   DEFAULT cPathImg := UserPath() + "/fivemac/bitmaps/"
   
   if ! lIsDir( ResPath() + "/bitmaps" )
            MakeDir( ResPath() + "/bitmaps" )  
    endif
    if valtype(cImage) == "A"
      for n = 1 to Len( cImage )
              CopyFileTo( cPathImg + cImage[ n ],;
                     ResPath() + "/bitmaps/" + cImage[ n ] )
      next
   else
   		if !isFile( ResPath() +"/"+ cImage )
      	 CopyFileTo( cPathImg + cImage, ResPath() +  "/bitmaps/" + cImage )     
     endif   
   endif
return nil

//----------------------------------------------------------------------------//

function SetImgPath( cPath )

   local cOldPath := cImgPath

   cImgPath = cPath
   
return cOldPath

//----------------------------------------------------------------------------//     