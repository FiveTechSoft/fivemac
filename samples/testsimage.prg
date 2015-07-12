
// Building Simage sample

#include "FiveMac.ch"

#xcommand @ <nRow>, <nCol> SIMAGE [ <oImage> ] ;
             [ FILENAME <cFileName> ] ; 
             [ OF <oWnd> ] ;
                [ SIZE <nWidth>, <nHeight> ] ;
              => ;
                 [ <oImage> := ] TSimage():New( <nRow>, <nCol>, <nWidth>, <nHeight>, <oWnd>,[<(cFileName)>] )


//----------------------------------------------------------------------------//

function Main()

   local oWnd, oSay
   local oImage
   local path := "./../bitmaps"
   local cfile
           
   DEFINE WINDOW oWnd TITLE "SImage Sample" ;
       FROM 200, 250 TO 750, 1100

   DEFINE TOOLBAR oBar OF oWnd  
   
    DEFINE BUTTON OF oBar PROMPT "Open Image" ;
      TOOLTIP "Open" ;
       IMAGE path+"/image.tiff" ;
      ACTION  oImage:sheetOpen() 
         
    DEFINE BUTTON OF oBar PROMPT "Camara" ;
      TOOLTIP "Camara" ;
       IMAGE path+"/camera.tiff" ;
      ACTION  oimage:Camera()      
   
   DEFINE BUTTON OF oBar PROMPT "Save Image" ;
      TOOLTIP "Save" ;
       IMAGE path+"/floppy.png" ;
      ACTION oImage:SaveAs()  
      
                      
  DEFINE BUTTON OF oBar PROMPT "Rotate left" ;
      TOOLTIP "Creates a new file" ;
       IMAGE path+"/RotateLeft.tif" ;
      ACTION oImage:rotateleft()

DEFINE BUTTON OF oBar PROMPT "Rotate Right" ;
      TOOLTIP "Creates a new file" ;
       IMAGE path+"/RotateRight.tif" ;
      ACTION oImage:rotateRight()
      
   DEFINE BUTTON OF oBar PROMPT "Zoom In" ;
      TOOLTIP "Creates a new file" ;
       IMAGE path+"/ZoomIn.tif" ;
            ACTION oImage:zoomin()
    
  DEFINE BUTTON OF oBar PROMPT "Zoom Out" ;
      TOOLTIP "Creates a new file" ;
       IMAGE path+"/ZoomOut.tif" ;
      ACTION oImage:zoomOut()   
      
DEFINE BUTTON OF oBar PROMPT "Zoom Fit" ;
        IMAGE path+"/SizeToFit.tif" ;
      ACTION oImage:fit()   
    
DEFINE BUTTON OF oBar PROMPT "Tools edit" ;
        IMAGE path+"/tools_adjust.tiff" ;
      ACTION oImage:edit()  
    
DEFINE BUTTON OF oBar PROMPT "Cortar" ;
        IMAGE path+"/crop.tiff" ;
      ACTION oImage:crop()  

DEFINE BUTTON OF oBar PROMPT "Rotar" ;
        IMAGE path+"/rotate.tiff" ;
      ACTION oImage:rotate()    

DEFINE BUTTON OF oBar PROMPT "Cursor Normal" ;
        IMAGE path+"/cursor.tiff" ;
      ACTION oImage:normal()    

   
   DEFINE MSGBAR OF oWnd
   
                  
   @ 24,0 SIMAGE oImage  OF oWnd SIZE 850,525   
   
   oimage:hide()
         
  // @ 24,0 SIMAGE oImage FILENAME ( cFile ) OF oWnd SIZE 850,525      
         
  // @ 24,0 SIMAGE oImage FILENAME ( path+"/puerto.jpg" ) OF oWnd SIZE 850,525  

    
    @ 0, 10 SAY "Para editar DLBclick en la imagen" OF oWnd SIZE 350, 20 RAISED

   ACTIVATE WINDOW oWnd ;
           VALID MsgYesNo( "Want to end ?" ) MAXIMIZED
return nil



