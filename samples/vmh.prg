#include "FiveMac.ch"

#define CLR_GRAY1 0xCCCCCC
#define CLR_GRAY2 0xEEEEEE
#define CLR_TEXT  0x303030

static aPrgs := { { "", "", "" } }


static cHbmkPath := "~/harbour/bin/hbmk2"
static cCCompiler := "Xcode"

//----------------------------------------------------------------------------//

function Main()

   local oDlg, oGet1, cPrgName := Space( 20 ), oFld1
   local oBrwPrgs
   local oResult, cResult := ""

   DEFINE DIALOG oDlg TITLE "Visual Make for Harbour" ;
      SIZE 560, 540 FLIPPED

 @  20,  20 SAY "Main PRG" SIZE  80,  20  OF oDlg

   @  41,  20 GET oGet1 VAR cPrgName SIZE 300,  26  OF oDlg 

   @  30, 318 BUTTON "..." OF oDlg SIZE 50, 50 ;
      ACTION ( oGet1:VarPut( cPrgName := cGetFile( "Please select a PRG file", "*.prg" ) ),;
               oGet1:Refresh() )

   @  86,  20 SAY "Additional" SIZE  80,  20 OF oDlg
   
    
 
 
  @ 108, 20 FOLDER oFld1 PAGES "PRGs", "Cs", "OBJs", "LIBs", "HBCs" ;
      SIZE 370, 210  OF oDlg flipped
      

   @ 3, 16 BROWSE oBrwPrgs ;
      FIELDS aPrgs[ oBrwPrgs:nArrayAt ][ 1 ],;
             aPrgs[ oBrwPrgs:nArrayAt ][ 2 ],;
             aPrgs[ oBrwPrgs:nArrayAt ][ 3 ] ;
      HEADERS "Name", "Date", "Size" ;
      COLSIZES 180, 85, 85 ;
      OF oFld1:aDialogs[1] SIZE 320, 150 PIXEL

   oBrwPrgs:SetArray( aPrgs )
   
   oBrwPrgs:SetAlternateColor( .t. )
   
  // oBrwPrgs:SetColorsForAlternate( CLR_TEXT, CLR_GRAY1 )


   @  114, 328 BUTTON "+" OF oDlg SIZE 35, 25  ;
      ACTION MsgInfo( "add" )

   @  114, 350 BUTTON "-" OF oDlg SIZE 35, 25 ;
      ACTION MsgInfo( "delete" )

   @ 328,  13 SAY "Result" SIZE  80,  20  OF oDlg

   @ 347,  20 GET oResult VAR cResult MEMO SIZE 363, 144 OF oDlg 

   @ 31, 412 BUTTON "Build" ;
      SIZE 123, 50  OF oDlg ;
      ACTION MsgInfo( "Not defined yet!" )

   @ 87, 412 BUTTON "Settings" ;
      SIZE 124, 50  OF oDlg ;
      ACTION Settings()

   @ 143, 412 BUTTON "Exit" ;
      SIZE 124, 50  OF oDlg ;
      ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return oDlg

//----------------------------------------------------------------------------//

function Settings()

   local oDlg, oHbmkPath, cMakePath := cHbmkPath
   local cCompiler := cCCompiler
   local oCbx
   local lFWHTemp,oFWHPath,cFWHPathTmp := "~/fivemac/lib/"
      
   DEFINE DIALOG oDlg TITLE "Settings" SIZE 500, 400 flipped
   
   @ 15, 16 SAY "hbmk2 path" OF oDlg SIZE 80, 24 PIXEL

   @ 30, 16 GET oHbmkPath VAR cMakePath SIZE 200, 24 PIXEL OF oDlg ;
      VALID If( Empty( cHbmkPath ), ( MsgAlert( "please select hbmk2.exe path" ), .F. ), .T. )
      
   @ 20, 218 BUTTON "..." OF oDlg SIZE 50, 50 ;
      ACTION  oHbmkPath:VarPut( cGetFile( cHbmkPath ) )
      

   @ 75, 16 SAY "C compiler" OF oDlg SIZE 80, 24 PIXEL

   @ 59, 16 COMBOBOX oCbx VAR cCompiler ITEMS { "Xcode" } ;
      OF oDlg SIZE 120, 100 PIXEL
      
    @ 150, 16 CHECKBOX lFWHTemp PROMPT "Use FiveMac libraries" ;
      OF oDlg SIZE 180, 24 PIXEL

   @ 180, 16 GET oFWHPath VAR cFWHPathTmp SIZE 158, 24 PIXEL OF oDlg  //;
       // ACTION oFWHPath:VarPut( cGetDir( cFWHPathTmp ) ) ;
       // WHEN lFWHTemp   
      
      

   @ 22, 380 BUTTON "Save" ;
      SIZE 80, 30 PIXEL OF oDlg ;
      ACTION ( cHbmkPath := cMakePath, cCCompiler := cCompiler, oDlg:End() ) 

   @ 58, 380 BUTTON "Cancel" ;
      SIZE 80, 30 PIXEL OF oDlg ;
      ACTION oDlg:End()  
   
   ACTIVATE DIALOG oDlg CENTERED
   
return nil 

//----------------------------------------------------------------------------//   