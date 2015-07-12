// Splash test
// would require styleMask: NSBorderlessWindowMask of window

#include "FiveMac.ch"

function Main()

   local oWnd, oSplash 
       
   DEFINE WINDOW oWnd TITLE "" ;
      FROM 20, 300 TO 600,400 
         
   oWnd:Center()   
    
   oSplash := TSplash():New( 100, 10, 400, 500, oWnd, "../bitmaps/test.png" )
   
//   oSplash:center()
   oSplash:run()
     
   ACTIVATE WINDOW oWnd 
     
return nil
