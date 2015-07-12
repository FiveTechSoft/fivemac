#include "FiveMac.ch"

function Main()

   local oWnd, oTbr, oWeb

   DEFINE WINDOW oWnd TITLE "WebView Test" 
	  	 
	 oWnd:Maximize() 	 
	  	 
	 DEFINE TOOLBAR oTbr OF oWnd 	 
	 
	 DEFINE BUTTON OF oTbr ;
	    PROMPT "Back" ;
	    TOOLTIP "Go back" ;
	    IMAGE "./../bitmaps/left.png" ;
	    ACTION oWeb:GoBack()
	    
	 DEFINE BUTTON OF oTbr ;
	    PROMPT "Forward" ;
	    TOOLTIP "Go forward" ;
	    IMAGE "./../bitmaps/right.png" ;
	    ACTION oWeb:GoForward()   
	    
	 DEFINE BUTTON OF oTbr ;
	    PROMPT "End" ;
	    TOOLTIP "Exit from the application" ;
	    IMAGE "./../bitmaps/Exit.png" ;
	    ACTION oWnd:End()   
	  	 
	 @ 20, 20 WEBVIEW oWeb ;
	    SIZE oWnd:nWidth - 40, oWnd:nHeight - 100 OF oWnd ;
	    URL "http://www.fivetechsoft.com"
	   	             
   ACTIVATE WINDOW oWnd

return nil   

//----------------------------------------------------------------------------//
