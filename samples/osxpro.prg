#include "FiveMac.ch"
#include "error.ch"
#include "dbinfo.ch"

extern dbfcdx, DBCloseArea, DbUseArea, DbGoTo, __DbList
extern __Run, HB_HRBRun, HB_HRBLoad, HB_HRBDo, HB_HRBUnLoad
extern CurDir, Directory, MemoWrit, TComboBox, TImage, MacExec, TDialog, __PP_STDRULES
extern hbcharacter

static oWndCommand, oWndResult, hPP

//----------------------------------------------------------------------------//

function Main()

   local oMemo, cCommand := "", oBar

   RddSetDefault( "DBFCDX" )

   BuildMenu()
   BuildPreprocessor()

   DEFINE WINDOW oWndCommand TITLE "Command" ;
      FROM 115, 436 TO 510, 950

   DEFINE TOOLBAR oBar OF oWndCommand	

   DEFINE BUTTON OF oBar PROMPT "New" ;
      TOOLTIP "Creates a new file" ;
	    IMAGE ImgPath() + "new.png" ;
      ACTION MsgInfo( Str( oWndCommand:nTop ) + "," + Str( oWndCommand:nLeft ) + ;
                      "," + Str( oWndCommand:nWidth ) + "," + Str( oWndCommand:nHeight ) )
	
   DEFINE BUTTON OF oBar PROMPT "Open" ;
      TOOLTIP "Open a file" ;
      IMAGE ImgPath() + "folder.png" ;
      ACTION ChooseFile( "*.prg" )
	
   DEFINE BUTTON OF oBar PROMPT "Save" ;
      TOOLTIP "Save a file" ;
	    IMAGE ImgPath() + "save.png" ;
	    ACTION ( TxtHighlight( oMemo:hWnd ), oMemo:Refresh() )	
	
   @ 20, 20 GET oMemo VAR cCommand MEMO OF oWndCommand ;
      SIZE oWndCommand:nWidth - 40, oWndCommand:nHeight - 120

   oMemo:SetBkColor( nRGB( 160, 160, 160 ) )
   oMemo:SetFont( "Monaco", 13 )

   oMemo:bKeyDown = { | nKey | DoLine( nKey, oMemo ) }

   oWndCommand:SetPos( ScreenHeight() - 700, 200 )

   BuildButtonBar()

   ACTIVATE WINDOW oWndCommand

return nil

//----------------------------------------------------------------------------//

function _QOut( cText )

   if oWndResult == nil
      BuildResult()
   endif

   oWndResult:SetFocus()

   oWndResult:aControls[ 1 ]:AddLine( cValToChar( cText ) + CRLF )
   oWndResult:aControls[ 1 ]:GoBottom()

return nil

//----------------------------------------------------------------------------//

function _Clear()

   oWndResult:aControls[ 1 ]:SetText( "" )

return nil

//----------------------------------------------------------------------------//

function DoLine( nKey, oMemo )

   local cCommand, cPP, oError
   local bError

   if nKey != 13 .and. nKey != 3
      return nil
   endif

   cCommand = MemoLine( oMemo:GetText(),, oMemo:nRow() - 1 )
   if Empty( cCommand )
      return nil
   endif
   MsgInfo( cCommand )
   BuildPreprocessor()
   cPP = __pp_process( hPP, cCommand )
   MsgInfo( cPP )

   bError = ErrorBlock( { | o | Break( o ) } )
   BEGIN SEQUENCE
      &cPP
   RECOVER USING oError
      ShowError( oError )
   END SEQUENCE
   ErrorBlock( bError )

return nil

//----------------------------------------------------------------------------//

function ShowError( oError )

   local n, cMsg := "Error description: " + CRLF + ErrorMessage( oError ) + CRLF

   if ValType( oError:Args ) == "A"
      cMsg += "   Args:" + CRLF
      for n = 1 to Len( oError:Args )
         cMsg += "     [" + Str( n, 4 ) + "] = " + ValType( oError:Args[ n ] ) + ;
                      "   " + cValToChar( oError:Args[ n ] ) + CRLF
      next
   endif

   MsgAlert( cMsg )

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu

     MENUITEM "osxpro"
     MENU
        MENUITEM "Preferences..." ACCELERATOR ","
     ENDMENU

      MENUITEM "File"
      MENU
         MENUITEM "New..." ACCELERATOR "n"
         MENUITEM "Open..." ACCELERATOR "o" ACTION ModifyCommand( ChooseFile( "*.prg" ) )
         MENUITEM "Close"
         SEPARATOR
         MENUITEM "Save" ACCELERATOR "s"
         MENUITEM "Save As..."
         MENUITEM "Save As HTML..."
         MENUITEM "Revert"
         SEPARATOR
         MENUITEM "Import..."
         MENUITEM "Export..."
         SEPARATOR
         MENUITEM "Page Setup..."
         MENUITEM "Print Preview"
         MENUITEM "Print"
         SEPARATOR
         MENUITEM "Send..."
         MENUITEM "Exit" ACTION oWndCommand:End() ACCELERATOR "e"
      ENDMENU

      MENUITEM "Edit"
      MENU
      ENDMENU

      MENUITEM "View"
      MENU
         MENUITEM "Command window" ACTION oWndCommand:SetFocus()
         MENUITEM "Result window" ACTION oWndResult:SetFocus()
      ENDMENU

      MENUITEM "Format"
      MENU
      ENDMENU

      MENUITEM "Tools"
      MENU
      ENDMENU

      MENUITEM "Program"
      MENU
         MENUITEM "Do..."
	     MENUITEM "Cancel"
	     MENUITEM "Resume"
	     MENUITEM "Suspend"
	     SEPARATOR
	     MENUITEM "Compile"
      ENDMENU

      MENUITEM "Window"
      MENU
         MENUITEM "Hide"
	     MENUITEM "Clear"
	     MENUITEM "Cycle"
	     SEPARATOR
	     MENUITEM "Command Window"
	     MENUITEM "Result Window" ACTION BuildResult()
	     MENUITEM "Data Session"
	     MENUITEM "Properties Window"
      ENDMENU

      MENUITEM "Help"
      MENU
         MENUITEM "About OsxPro..." ;
	        ACTION MsgInfo( "Developed with FiveMac" + CRLF + "(c) FiveTech Software 2006-12", "OsxPro" )
      ENDMENU

   ENDMENU

return nil

//----------------------------------------------------------------------------//

function New()

   local oWnd, oRadMenu, cType := "Program"

   DEFINE WINDOW oWnd TITLE "New" ;
      FROM 207, 22 TO 670, 300

   @ 415, 20 SAY "File type" OF oWnd

   @ 385, 32 RADIO oRadMenu VAR cType ;
      ITEMS { "Project", "DataBase", "Table", "Query", "Connection", "View", "Remote view",;
                 "Form", "Report", "Label", "Program", "Class", "Text file", "Menu" } ;
      OF oWnd

   @ 385, 170 BUTTON "New file" OF oWnd ;
      ACTION If( cType == 11, ( oWnd:End(), ModifyCommand( "test.prg" ) ),)

   @ 355, 170 BUTTON "Wizard" OF oWnd

   @  50, 170 BUTTON "Cancel" OF oWnd ACTION oWnd:End()

   @  20, 170 BUTTON "Help" OF oWnd

   ACTIVATE WINDOW oWnd ;
      ON CLICK MsgInfo( Str( oWnd:nTop ) + ", " + Str( oWnd:nLeft ) + ", " + Str( oWnd:nWidth ) + ", " + Str( oWnd:nHeight ) )

return nil

//----------------------------------------------------------------------------//

function BuildResult()

   local oMemo, oBar, cResult := ""

   if oWndResult != nil
      return nil
   endif

   DEFINE WINDOW oWndResult TITLE "Result" ;
      FROM 172, 458 TO 600, 1150

   DEFINE TOOLBAR oBar OF oWndResult

   DEFINE BUTTON OF oBar PROMPT "New" IMAGE ImgPath() + "new.png" ;
      ACTION MsgInfo( Str( oWndResult:nTop ) + ", " + ;
                      Str( oWndResult:nLeft ) + ", " + ;
                      Str( oWndResult:nWidth ) + ", " + ;
                      Str( oWndResult:nHeight ) )

   DEFINE BUTTON OF oBar PROMPT "Open" IMAGE ImgPath() + "folder.png"
   DEFINE BUTTON OF oBar PROMPT "Save" IMAGE ImgPath() + "save.png"

   @ 20, 20 GET oMemo VAR cResult MEMO OF oWndResult ;
      SIZE oWndResult:nWidth - 40, oWndResult:nHeight - 100

   oMemo:SetEditable( .f. )
   oMemo:SetBkColor( nRGB( 160, 160, 160 ) )
   oMemo:SetFont( "Monaco", 13 )

   ACTIVATE WINDOW oWndResult ;
      VALID ( oWndResult := nil, .t. )

   oWndCommand:SetFocus()

return nil

//----------------------------------------------------------------------------//

function Browse()

   local oWnd, oBrw

   if Empty( Alias() )
      return nil
   endif

   DEFINE WINDOW oWnd TITLE Alias() ;
      // FROM 213, 109 TO 717, 431

   @ 48, 20 BROWSE oBrw OF oWnd SIZE 672, 363 ALIAS Alias()

   ACTIVATE WINDOW oWnd

return nil

//----------------------------------------------------------------------------//

function DoCommand( cPrgName )

   local cPrg, pCode

   if ! "." $ cPrgName
      cPrgName += ".prg"
   endif

   if ! File( cPrgName )
      MsgAlert( cPrgName + " : file not found" )
      return nil
   endif

   cPrg = MemoRead( cPrgName )
   __Run( "./../../harbour/bin/harbour " + cPrgName + " -gh -n -I./../../harbour/include:./../include > comp.log" )
   // _QOut( MemoRead( "comp.log" ) )
   if At( "error", MemoRead( "comp.log" ) ) != 0
      MsgInfo( MemoRead( "comp.log" ) )
   endif	

   if File( SubStr( cPrgName, 1, At( ".", cPrgName ) ) + "hrb" )
      pCode = hb_HRBLoad( SubStr( cPrgName, 1, At( ".", cPrgName ) ) + "hrb" )
      hb_HRBDo( pCode )
      hb_HRBUnLoad( pCode )
   endif

return nil

//----------------------------------------------------------------------------//

function DoForm( cFileName )

   local oForm, oControl

   if ! "." $ cFileName
      cFileName += ".scx"
   endif

   if ! File( cFileName )
      MsgAlert( cFileName + " : file not found" )
      return nil
   endif

   RddInfo( RDDI_MEMOEXT, ".sct" )
   USE ( cFileName ) NEW
   SKIP 2

   if Upper( Field->Class ) == "FORM"
      oForm = TWindow():New()
      SetProps( oForm, Field->properties )

       while ! EoF() .and. ! Empty( Field->Class )
          oControl = nil
          SKIP
          do case
	       case Upper( Field->Class ) == "COMMANDBUTTON"
	               oControl = TButton():New()
		
	       case Upper( Field->Class ) == "LABEL"
	               oControl = TSay():New()

              case Upper( Field->Class ) == "TEXTBOX"
	               oControl = TGet():New()
		
	  endcase
	  if oControl != nil
	     SetProps( oControl, Field->properties )
	  endif
      end	

      oForm:Activate()
   endif

   USE
   RddInfo( RDDI_MEMOEXT, ".fpt" )

return nil

//----------------------------------------------------------------------------//

function SetProps( oControl, cProperties )

   local n, cLine, cProp, cValue

   for n = 1 to MLCount( cProperties )
      cLine = MemoLine( cProperties,, n )
      cProp = Upper( AllTrim( StrToken( cLine, 1, "=" ) ) )
      cValue = AllTrim( StrToken( cLine, 2, "=" ) )

      do case
           case cProp == "TOP"
	           if ! oControl:IsDerivedFrom( TControl() )
	              oControl:nTop = Val( cValue )
		   else
	              oControl:nTop = GetWndDefault():nHeight - Val( cValue ) - 40
		      if oControl:IsDerivedFrom( TSay() )
		         oControl:nTop += 10
		      endif
		   endif
		
	   case cProp == "LEFT"
            oControl:nLeft = Val( cValue )
		
	   case cProp == "WIDTH"
            oControl:nWidth = Val( cValue )
		
	   case cProp == "HEIGHT"
            oControl:nHeight = Val( cValue )
		
       case cProp == "CAPTION"
	        oControl:SetText( &cValue )

       case cProp == "NAME"
	        if oControl:IsDerivedFrom( TGet() )
	           oControl:SetText( &cValue )
		    endif
       endcase		
    next

return nil

//----------------------------------------------------------------------------//

function Edit()

   local oWnd, oBrw

   if Empty( Alias() )
      return nil
   endif

   DEFINE WINDOW oWnd TITLE Alias() ;
      FROM 213, 109 TO 717, 431

   @ 48, 20 BROWSE oBrw FIELDS "", "" HEADERS "FieldName", "Value" ;
      OF oWnd SIZE 672, 363 ALIAS Alias()

   oBrw:SetEdit()

   ACTIVATE WINDOW oWnd

return nil

//----------------------------------------------------------------------------//

function ModifyCommand( cPrgName )

   local oWnd, cPrg := "", oMemo, oBar

   if ! "." $ cPrgName
      cPrgName += ".prg"
   endif

   if File( cPrgName )
      cPrg = MemoRead( cPrgName )
   else
      cPrg = '#include "FiveMac.ch"' + CRLF + CRLF + ;
                 "function Main()" + CRLF + CRLF + CRLF + CRLF + ;
                 "return nil"	
   endif

   DEFINE WINDOW oWnd TITLE cPrgName ;
      FROM 100, 30 TO 650, 950
	
   oWnd:Full()

   DEFINE TOOLBAR oBar OF oWnd

   DEFINE BUTTON OF oBar ;
      PROMPT  "New" ;
      TOOLTIP "Create a new PRG" ;
      IMAGE   "./../bitmaps/new.png" ;
      ACTION MsgInfo( oWnd:nTop )

   DEFINE BUTTON OF oBar ;
      PROMPT  "Run" ;
      TOOLTIP "Build and run the PRG" ;
      IMAGE   "./../bitmaps/run.tiff" ;
      ACTION  ( MemoWrit( "_temp.prg", oMemo:GetText() ), DoCommand( "_temp.prg" ) )

   @ 0, 20 GET oMemo VAR cPRG MEMO OF oWnd SIZE 900, 550

   oMemo:SetBkColor( nRGB( 160, 160, 160 ) )
   oMemo:SetFont( "Monaco", 13 )	

   ACTIVATE WINDOW oWnd ;
      VALID ( If( MsgYesNo( "Do you want to save changes to " + cPrgName + " ?" ),;
                  MemoWrit( cPrgName, oMemo:GetText() ),), .t. ) ;
      ON PAINT oWnd:Say( 10, 10, "001"  )			

return nil

//----------------------------------------------------------------------------//

function BuildPreprocessor()

   if hPP == nil
      hPP = __pp_init()
   endif

   __pp_addRule( hPP, "#xcommand ?  [ <list,...> ] => _QOut( <list> )" )
   __pp_addRule( hPP, "#xcommand ?? [ <list,...> ] => _QQOut( <list> )" )
   __pp_addRule( hPP, "#xcommand BROWSE => Browse()" )
   __pp_addRule( hPP, "#xcommand CLEAR => _Clear()" )
   __pp_addRule( hPP, "#xcommand DO COMMAND <x> => DoCommand( <(x)> )" )
   __pp_addRule( hPP, "#xcommand DO FORM <x> => DoForm( <(x)> )" )
   __pp_addRule( hPP, "#xcommand EDIT => Edit()" )
   __pp_addRule( hPP, "#xcommand ENDPROC => return" )
   __pp_addRule( hPP, "#xcommand MODIFY COMMAND <x> => ModifyCommand( <(x)> )" )
   __pp_addRule( hPP, "#xcommand PUBLIC <x> => __mvPublic( <(x)> )" )

return nil

//----------------------------------------------------------------------------//

static function ErrorMessage( e )

   // start error message
   local cMessage := if( empty( e:OsCode ), ;
                          if( e:severity > ES_WARNING, "Error ", "Warning " ),;
                          "(DOS Error " + AllTrim( Str( e:osCode ) ) + ") " )

   // add subsystem name if available
   cMessage += if( ValType( e:SubSystem ) == "C",;
                    e:SubSystem()                ,;
                    "???" )

   // add subsystem's error code if available
   cMessage += if( ValType( e:SubCode ) == "N",;
                    "/" + AllTrim( Str( e:SubCode ) )  ,;
                    "/???" )
   // add error description if available
   if ( ValType( e:Description ) == "C" )
        cMessage += "  " + e:Description
   end

   // add either filename or operation
   cMessage += if( ! Empty( e:FileName ),;
                    ": " + e:FileName   ,;
                    if( !Empty( e:Operation ),;
                        ": " + e:Operation   ,;
                        "" ) )
return cMessage

//----------------------------------------------------------------------------//

function BuildButtonBar()

   local oWnd, oBar

   DEFINE WINDOW oWnd TITLE "OsxPro" ;
    FROM  0, 0  TO 0, ScreenWidth()

   DEFINE TOOLBAR oBar OF oWnd

   DEFINE BUTTON OF oBar PROMPT "New" ;
      TOOLTIP "Create a new file" ;
	  IMAGE ImgPath() + "new.png" ;
      ACTION New()

   DEFINE BUTTON OF oBar PROMPT "Open" ;
      TOOLTIP "Open a file" ;
      IMAGE ImgPath() + "folder.png" ;
      ACTION ModifyCommand( ChooseFile( "*.prg" ) )

   DEFINE BUTTON OF oBar PROMPT "Save" ;
      TOOLTIP "Save the file" ;
	  IMAGE ImgPath() + "floppy.png" ;
	  ACTION MsgInfo( "Save" )

   DEFINE BUTTON OF oBar PROMPT "Exit" ;
      TOOLTIP "Exit" ;
      IMAGE ImgPath() + "exit.png" ; 
      ACTION oWndCommand:End()

   oWnd:SetPos( ScreenHeight(), 0 )

   /*
   @ 5, 5 BTNBMP FILENAME "bitmaps/new.png" ACTION New()
   @ 5, 50 BTNBMP FILENAME "bitmaps/open.png"
   @ 5, 95 BTNBMP FILENAME "bitmaps/save.png"

   @ 5, 147 BTNBMP FILENAME "bitmaps/print.png"
   @ 5, 192 BTNBMP FILENAME "bitmaps/preview.png"

   @ 5, 244 BTNBMP FILENAME "bitmaps/cut.tiff"
   @ 5, 289 BTNBMP FILENAME "bitmaps/copy.tiff"
   @ 5, 334 BTNBMP FILENAME "bitmaps/save.png"

   @ 5, 386 BTNBMP FILENAME "bitmaps/left.png"
   @ 5, 431 BTNBMP FILENAME "bitmaps/right.png"

   @ 5, 483 BTNBMP FILENAME "bitmaps/print.png"
   @ 5, 528 BTNBMP FILENAME "bitmaps/run.png"
   */

   ACTIVATE WINDOW oWnd ;
      ON CLICK MsgInfo( oWnd:nTop )

return nil

//----------------------------------------------------------------------------//