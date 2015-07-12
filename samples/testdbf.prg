// Building our first window

#include "FiveMac.ch"

//----------------------------------------------------------------------------//

function Main()

   local oWnd, n
   local oDbf, oGetFirst, oGetLast, oGetStreet

   USE ./Test
   DATABASE oDbf
   
   BuildMenu()    
   
   DEFINE WINDOW oWnd TITLE "Tutor02" ;
       FROM 200, 200 TO 600, 400

   for n = 1 to FCount()
      @ 390 - ( n * 30 ), 40 SAY FieldName( n ) + ":" OF oWnd SIZE 70, 20
      @ 390 - ( n * 30 ), 120 GET oGet VAR oDbf:aBuffer[ n ] OF oWnd SIZE 250, 20
      oGet:bSetGet = DbfBuffer( oDbf, n )
   next   
       
   @ 15,  30 BUTTON "Top" OF oWnd SIZE 90, 30 ;
      ACTION oDbf:GoTop(), AEval( oWnd:aControls, { | o | o:Refresh() } )
   
   @ 15, 140 BUTTON "Prev" OF oWnd SIZE 90, 30 ;
      ACTION oDbf:Skip( -1 ), AEval( oWnd:aControls, { | o | o:Refresh() } )
      
   @ 15, 250 BUTTON "Next" OF oWnd SIZE 90, 30 ;
      ACTION oDbf:Skip( 1 ), AEval( oWnd:aControls, { | o | o:Refresh() } )
      
   @ 15, 360 BUTTON "Bottom" OF oWnd SIZE 90, 30 ;
      ACTION oDbf:GoBottom(), AEval( oWnd:aControls, { | o | o:Refresh() } )

   @ 15, 470 BUTTON "End" OF oWnd SIZE 90, 30 ACTION oWnd:End()
       
   ACTIVATE WINDOW oWnd   

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu
   
   MENU oMenu
      
      MENUITEM "apple"
      MENU
         MENUITEM "Quit" ACCELERATOR "q"
      ENDMENU
      
      MENUITEM "Help"
      MENU
         MENUITEM "Search..." ACCELERATOR "s"
	 SEPARATOR
	 MENUITEM "About..." ACCELERATOR "a"
      ENDMENU
      
   ENDMENU
   
return nil

//----------------------------------------------------------------------------//

function DbfBuffer( oDbf, n )

return { | u | If( PCount() == 0, oDbf:aBuffer[ n ], oDbf:aBuffer[ n ] := u ) }

//----------------------------------------------------------------------------//