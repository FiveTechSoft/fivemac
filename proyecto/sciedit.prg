// Sci.framework has to be copied inside sciedit.app/Contents/frameworks 

#include "FiveMac.ch"

function Editor()

   local oWnd, oBar, oEditor
   
   DEFINE WINDOW oWnd
   
   DEFINE TOOLBAR oBar OF oWnd
   
   DEFINE BUTTON OF oBar PROMPT "New File" ;
      TOOLTIP "Creates a new file" ;
	    IMAGE "./../bitmaps/new.png"

   DEFINE BUTTON OF oBar PROMPT "Open" ;
      TOOLTIP "Open a file" ;
	    IMAGE "./../bitmaps/open.png"

   DEFINE BUTTON OF oBar PROMPT "Close" ;
      TOOLTIP "Close this file" ;
	    IMAGE "./../bitmaps/folder2.png"

   DEFINE BUTTON OF oBar PROMPT "Save" ;
      TOOLTIP "Save the file to disk" ;
	    IMAGE "./../bitmaps/save.png"

   DEFINE BUTTON OF oBar PROMPT "Exit" ;
      TOOLTIP "Exit" ;
	    IMAGE "./../bitmaps/exit.png" ;
	    ACTION oWnd:End()
   
   oEditor = TScintilla():New( 0, 0, 1100, 646, oWnd )
   
   oEditor:SetText( MemoRead( "sciedit.prg" ) )
   oEditor:Anclaje(16)
   
   ACTIVATE WINDOW oWnd MAXIMIZED
   
return nil   