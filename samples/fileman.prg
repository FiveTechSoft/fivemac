#include "FiveMac.ch"

#define CLR_PANE RGB( 150, 150, 150 )

static oWnd, oSplitV, oTree, oBrwLeft, oBrwRight
static cLeftPath, cLeftMask
static cRightPath, cRightMask
static aFilesLeft, aFilesRight
static oSayLeft, oSayRight
static cFileName, cPathName, oSayLName, oSayRName

//----------------------------------------------------------------------------//    

function Main()

   local oBtn

   cLeftMask  = "/*"
   cLeftPath  = UserPath()
   cRightMask = "/*"
   cRightPath = UserPath()

   DEFINE WINDOW oWnd TITLE "FiveMac File Manager" ;
      FROM 0, 0 TO ScreenHeight(), ScreenWidth()
   
   oWNd:bKeyDown = { | nKey | If( nKey == 13, 1, 0 ) } // Avoid "beep"

   BuildBar()
   BuildSplitter()
   
   BuildLeft()
   BuildRight()
   
   @ ScreenHeight() - 185, 10 SAY oSayLeft PROMPT cLeftPath OF oWnd SIZE 300, 15

   @ ScreenHeight() - 185, ScreenWidth() / 2 + 10 SAY oSayRight PROMPT cRightPath ;
      OF oWnd SIZE 300, 15
   
   @ 53, 10 SAY oSayLName PROMPT "" SIZE 300, 15 OF oWnd
   
   @ 53, ScreenWidth() / 2 + 20 SAY oSayRName PROMPT "" SIZE 300, 15 of oWnd
   
   @ 5, 30 BUTTON "View (F3)" OF oWnd ;
      SIZE 200, 30 ACTION View()

   @ 5, 240 BUTTON "Edit (F4)" OF oWnd ;
      SIZE 200, 30 ACTION MsgInfo( "Edit" )

   @ 5, 450 BUTTON "Copy (F5)" OF oWnd ;
      SIZE 200, 30 ACTION MsgInfo( "Copy" )

   @ 5, 660 BUTTON "Move (F6)" OF oWnd ;
      SIZE 200, 30 ACTION MsgInfo( "Move" )

   @ 5, 870 BUTTON "Create (F7)" OF oWnd ;
      SIZE 200, 30 ACTION MsgInfo( "Create" )

   @ 5, 1080 BUTTON "Remove (F8)" OF oWnd ;
      SIZE 200, 30 ACTION Remove()
   
   ACTIVATE WINDOW oWnd MAXIMIZED ;
      VALID MsgNoYes( "Want to end ?" )
   
return nil   

//----------------------------------------------------------------------------//    

function BuildBar()

   local oBar

   DEFINE TOOLBAR oBar OF oWnd

   DEFINE BUTTON OF oBar PROMPT "Search" IMAGE ImgPath() + "search.png" ;
      ACTION SearchFiles()
   
   DEFINE BUTTON OF oBar PROMPT "Exit" IMAGE ImgPath() + "exit2.png" ;
      ACTION oWnd:End()
   
return nil   

//----------------------------------------------------------------------------//    

function BuildSplitter()

   @ 21, 0 SPLITTER oSplitV OF oWnd ;
      SIZE oWnd:nWidth, oWnd:nHeight - 92 VERTICAL
   
   oSplitV:nAutoResize = 18
     
   DEFINE VIEW OF oSplitV
   DEFINE VIEW OF oSplitV
   
   oSplitV:SetPosition( 1, ScreenWidth() / 2 )

return nil

//----------------------------------------------------------------------------//    

function GetRow( nRow, lLeft )

   local cPath  := If( lLeft, cLeftPath, cRightPath )
   local aFiles := If( lLeft, aFilesLeft, aFilesRight ) 
   local lFolder, lApp 

   do case
      case nRow == 1
           return { "..", "", "", "", "" }
           
      otherwise     
           lFolder = "D" $ aFiles[ nRow - 1 ][ 5 ]

           return { { GetImage( aFiles[ nRow - 1 ][ 1 ], lFolder, lLeft, @lApp ),;
           	          "     " + aFiles[ nRow - 1 ][ 1 ], lApp },;
                    If( lFolder, "--", AllTrim( Str( aFiles[ nRow - 1 ][ 2 ] ) ) ),;
                    DToC( aFiles[ nRow - 1 ][ 3 ] ) + " " + aFiles[ nRow - 1 ][ 4 ],;
                    If( lFolder, "Folder", "Archive" ) }   
   endcase
   
return nil   

//----------------------------------------------------------------------------//    

function GetImage( cFileName, lFolder, lLeft, lApp )

   local cExt  := cFileExt( cFileName ), cImage, oPList
   local cPath := If( lLeft, cLeftPath, cRightPath )   
      
   lApp = .F.   
      
   do case
      case lFolder .and. cExt == "app"
           cImage = cPath + "/" + cFileName 
           lApp = .T.
           
      case lFolder
           cImage = ImgPath() + "folder.png"     

      case Lower( cExt ) $ "png,gif,jpg,bmp,tiff,icns"
           cImage = cPath + "/" + cFileName
           
      otherwise
           cImage = ImgPath() + "binary.png"
   endcase
   
return cImage                   

//----------------------------------------------------------------------------//    

function BuildLeft()

   @ 60, 2 BROWSE oBrwLeft ;
      FIELDS "", "", "", "" ;
      HEADERS "Name", "Size", "Date", "Kind" OF oSplitV:aViews[ 1 ] ;
      SIZE oSplitV:aViews[ 1 ]:nWidth - 2, oSplitV:aViews[ 1 ]:nHeight - 200

   oBrwLeft:SetColBmpTxt( 1 )
   oBrwLeft:SetColWidth( 1, 264 )   
   oBrwLeft:SetColWidth( 3, 190 )   
   oBrwLeft:SetColEditable( 1, .F. )   
   oBrwLeft:SetColEditable( 2, .F. )   
   oBrwLeft:SetColEditable( 3, .F. )   
   oBrwLeft:SetColEditable( 4, .F. )   
   oBrwLeft:SetColor( CLR_BLACK, CLR_PANE )
   oBrwLeft:SetRowHeight( 20 )
   oBrwLeft:SetFont( "Geneva", 16 )
   
   oBrwLeft:bAction  = { || Action( .T. ) } 
   oBrwLeft:bKeyDown = { | nKey | If( nKey == 13, ( Action( .T. ), 1 ), 0 ) } 
   oBrwLeft:bChange  = { || SelFile( .T. ) }

   oBrwLeft:SetColorsForAlternate( nRGB( 0xAA, 0xFF, 0xFF ), nRGB( 0x66, 0xAA, 0xFF ) )   
   oBrwLeft:SetAlternateColor( .T. )

   Fill( .T. )

   oBrwLeft:bLine = { | nRow | GetRow( nRow, .T. ) }
      
return nil       

//----------------------------------------------------------------------------//    

function Remove()

   if ! Empty( cFileName ) .and. ;
      MsgYesNo( "Do you want to delete " + cPathName + "/" + cFileName )
      FErase( cPathName + "/" + cFileName )
      Fill( .T. )
      Fill( .F. )
   endif   

return nil

//----------------------------------------------------------------------------//    

function SearchFiles()

   local oDlg, cSearchFor := Space( 200 ), cSearchIn := PadR( cPathName, 200 )
   local cFindText := Space( 200 ), oBrw, aFiles, aResults := {}
   
   DEFINE DIALOG oDlg TITLE "Search files" SIZE 500, 400 FLIPPED
   
   @  30,  20 SAY "Search for:" OF oDlg
   
   @  28, 100 GET cSearchFor OF oDlg SIZE 300, 23
   
   @  27, 410 BUTTON "Go" OF oDlg SIZE 80, 25 ;
      ACTION ( aResults := {},;
               aFiles := Directory( AllTrim( cSearchIn ) + "/" + cSearchFor ),;
               AEval( aFiles, { | aFile | AAdd( aResults, aFile[ 1 ] ) } ),;
               oBrw:SetArray( aResults ) )
   
   @  70,  20 SAY "Search in:" OF oDlg

   @  68, 100 GET cSearchIn OF oDlg SIZE 300, 23

   @  67, 410 BUTTON "Cancel" OF oDlg SIZE 80, 25 ACTION oDlg:End()
   
   @ 110,  20 SAY "Find text:" OF oDlg

   @ 108, 100 GET cFindText OF oDlg SIZE 300, 23

   @ 150,  20 SAY "Search results:" OF oDlg
   
   @ 170,  20 BROWSE oBrw ;
      FIELDS "" ;
      HEADERS "filename" ;
      OF oDlg SIZE 460, 190
   
   oBrw:SetArray( aResults )
   oBrw:bLine = { | nRow | { If( Len( aResults ) >= nRow, aResults[ nRow ], "" ) } }
   oBrw:SetColWidth( 1, 440 )
   
   oDlg:aControls[ 2 ]:SetFocus()
   
   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//    

function SelFile( lLeft )

   local oBrw   := If( lLeft, oBrwLeft, oBrwRight )
   local aFiles := If( lLeft, aFilesLeft, aFilesRight ) 
   local cPath  := If( lLeft, cLeftPath, cRightPath )
   local oSay   := If( lLeft, oSayLName, oSayRName )
   
   if oBrw:nRowPos > 1
      cFileName = aFiles[ oBrw:nRowPos - 1 ][ 1 ]
      cPathName = cPath
      oSay:SetText( cFileName )
   else
      cFileName = ""
   endif
   
return nil         

//----------------------------------------------------------------------------//    

function Action( lLeft )

   local oBrw   := If( lLeft, oBrwLeft, oBrwRight )
   local aFiles := If( lLeft, aFilesLeft, aFilesRight ) 
   
   if oBrw:nRowPos == 1
      CalcPath( lLeft )
      Fill( lLeft )
   else
      if ! "D" $ aFiles[ oBrw:nRowPos - 1 ][ 5 ] 
         View()
      else
         CalcPath( lLeft )
         Fill( lLeft )
      endif
   endif
   
return nil         

//----------------------------------------------------------------------------//    

function CalcPath( lLeft )

   local oBrw   := If( lLeft, oBrwLeft, oBrwRight )
   local aFiles := If( lLeft, aFilesLeft, aFilesRight ) 

   cPathName = If( lLeft, cLeftPath, cRightPath )

   if oBrw:nRowPos == 1
      if ! cPathName == "/"
         cPathName = SubStr( cPathName, 1, RAt( "/", cPathName ) - 1 )
      endif
   else   
      cPathName += "/" + aFiles[ oBrw:nRowPos - 1 ][ 1 ]
   endif          

   if lLeft
      cLeftPath = cPathName
   else
      cRightPath = cPathName
   endif      

   oSayLeft:SetText( If( ! Empty( cLeftPath ), cLeftPath, "/" ) )
   oSayRight:SetText( If( ! Empty( cRightPath ), cRightPath, "/" ) )

return nil

//----------------------------------------------------------------------------//    

function Fill( lLeft )

   local oBrw   := If( lLeft, oBrwLeft, oBrwRight )
   local cPath  := If( lLeft, cLeftPath, cRightPath )
   local aFiles := If( lLeft, aFilesLeft, aFilesRight ) 
   local cMask  := If( lLeft, cLeftMask, cRightMask ) 

   aFiles = Directory( cPath + cMask, "D" )

   ASort( aFiles,,, { | x, y | Upper( x[ 1 ] ) < Upper( y[ 1 ] ) } )
   // ASort( aFiles,,, { | x, y | "D" $ x[ 5 ] } )

   oBrw:cAlias = "_ARRAY"
   oBrw:bLogicLen = { || Len( aFiles ) + If( ! cPath == "/", 1, 0 ) }
   oBrw:Refresh()

   if lLeft
      aFilesLeft = aFiles
   else
      aFilesRight = aFiles                             
   endif
   
   oBrw:GoTop()
   
return nil

//----------------------------------------------------------------------------//    

function BuildRight()

   @ 60, 0 BROWSE oBrwRight ;
      FIELDS "", "", "", "" ;
      HEADERS "Name", "Size", "Date", "Kind" OF oSplitV:aViews[ 2 ] ;
      SIZE oSplitV:aViews[ 2 ]:nWidth - 2, oSplitV:aViews[ 2 ]:nHeight - 200

   oBrwRight:SetColBmpTxt( 1 )
   oBrwRight:SetColWidth( 1, 264 )   
   oBrwRight:SetColWidth( 3, 190 )   
   oBrwRight:SetColEditable( 1, .F. )   
   oBrwRight:SetColEditable( 2, .F. )   
   oBrwRight:SetColEditable( 3, .F. )   
   oBrwRight:SetColEditable( 4, .F. )   
   oBrwRight:SetColor( CLR_BLACK, CLR_PANE )
   oBrwRight:SetRowHeight( 20 )
   oBrwRight:SetFont( "Geneva", 16 )

   oBrwRight:bAction = { || Action( .F. ) } 
   oBrwRight:bKeyDown = { | nKey | If( nKey == 13, ( Action( .F. ), 1 ), 0 ) } 
   oBrwRight:bChange  = { || SelFile( .F. ) }

   oBrwRight:SetColorsForAlternate( nRGB( 0xAA, 0xFF, 0xFF ), nRGB( 0x66, 0xAA, 0xFF ) )   
   oBrwRight:SetAlternateColor( .T. )
      
   Fill( .F. )

   oBrwRight:bLine = { | nRow | GetRow( nRow, .F. ) }
      
return nil

//----------------------------------------------------------------------------//           

function View()

   local oWnd, oGet
   local cExt := cFileExt( cFileName ), cFile, oImg, oPdf
   local oMovie
   
   if Empty( cFileName )
      return nil
   endif   
   
   DEFINE WINDOW oWnd TITLE "View: " + cPathName + "/" + cFileName ;
      FROM 50, 50 TO ScreenHeight() - 50, 1000
   
   if Len( cExt ) >= 3 .and. Lower( cExt ) $ "gif, png, tiff, icns, jpg, bmp"
      @ 10, 10 IMAGE oImg FILENAME cPathName + "/" + cFileName OF oWnd

      oWnd:SetSize( oImg:nWidth + 20, oImg:nHeight + 30 )
      
   elseif Lower( cExt ) $ "pdf"
   
      @ 10, 10 PDFVIEW oPdf OF oWnd ;
         SIZE oWnd:nWidth - 20, oWnd:nHeight - 40 ;
         FILE cPathName + "/" + cFileName ;
         AUTOSCALE                                                     
    
   elseif Len( cExt ) >= 3 .and. Lower( cExt ) $ "mov, avi, mp4, mp3, m4a, mkv, m4v"   
                 
      @ 10, 10 MOVIE oMovie SIZE 800, 450 OF oWnd  
                    
      if Lower( cExt ) $ "m4a, mp3"
         oWnd:SetSize( oMovie:nWidth + 20, 80 )      
      else            
         oWnd:SetSize( oMovie:nWidth + 20, oMovie:nHeight + 30 )     
      endif 
        
      oMovie:nAutoResize = 18            
      oMovie:Open( cPathName + "/" + cFileName )
                                                                           
   else
      cFile = MemoRead( cPathName + "/" + cFileName )   
   
      @ 10, 0 GET oGet VAR cFile MEMO OF oWnd SIZE oWnd:nWidth, oWnd:nHeight - 31
   
      oGet:SetFont( "Courier", 16 )
      oGet:SetColor( CLR_BLACK, CLR_GRAY )
      oGet:nAutoResize = 18
      oGet:SetFocus()
   endif
   
   ACTIVATE WINDOW oWnd CENTERED

return nil

//----------------------------------------------------------------------------//           