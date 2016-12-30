#include "FiveMac.ch"

function Main()

   local oWnd, oBrw
   local cpath:=Path()
   local cImgPath := UserPath() + "/fivemac/bitmaps/" 
   
   USE ( cpath+"/Test.dbf" )

   DEFINE WINDOW oWnd TITLE "DBF Browse" ;
      FROM 213, 109 TO 650, 820

  @ 48, 20 BROWSE oBrw ;
      FIELDS If( Int( RecNo() % 2 ) == 0, cImgPath+"ok.png", cImgPath+"alert.png" ), Test->Last, Test->First ;
      HEADERS "Image", "Last", "First" ;
      OF oWnd SIZE 672, 363 ALIAS Alias()

   @ 8,  10 BUTTON "Top"    OF oWnd ACTION oBrw:GoTop()
   @ 8, 130 BUTTON "Bottom" OF oWnd ACTION oBrw:GoBottom()
   @ 8, 250 BUTTON "Delete" OF oWnd ACTION oBrw:SetColWidth( 2, 300 )
   @ 8, 370 BUTTON "Search" OF oWnd ACTION MsgAlertSheet( oBrw:GetColWidth( 2 ), oWnd:hWnd )
   @ 8, 490 BUTTON "Grid"  OF oWnd ACTION ( oBrw:SetGridLines( 2 ), MsgInfo( oBrw:GetGridLines() ) )
   @ 8, 610 BUTTON "Exit"   OF oWnd ACTION oWnd:End()

   oBrw:SetColBmp( 1 ) // Column 1 will display images
   
   // oBrw:bHeadClick:= { | obj , nindex| if(nindex== 1, msginfo("clickada cabecera"+str(nindex)),)  } 
   
   oBrw:bDrawRect:=  { | nRow | test->(dbskip()),;
                  if(left(test->Last,1) =="L", BRWSETGRADICOLOR(oBrw:hWnd,nRow,ETIQUETGRADCOLORS("orange") ), ) , test->(dbskip(-1)) }

   oBrw:bClrText = { | pColumn, nRowIndex | ColorFromNRGB( If( nRowIndex % 2 == 0, CLR_RED, CLR_GREEN ) ) }

   // oBrw:bAction = { | obj, nindex |  MsgInfo( oBrw:nColPos() ) }

   oBrw:bMouseDown = { | nRow, nCol, oControl | MsgInfo( Str( nCol ) ) }

   ACTIVATE WINDOW oWnd

return nil