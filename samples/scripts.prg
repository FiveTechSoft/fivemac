#include "FiveMac.ch"

extern DbEval, hbcharacter, hbarray, __ClsAssocType, __ClsInstSuper

function Main()

   local oWnd, oBar, oBrw, oMemo
   local cCode := '#include "FiveMac.ch"' + CRLF + CRLF + "function Test()" + CRLF + CRLF + ' MsgInfo( "Hello world!" )' + CRLF + CRLF + "return nil"
 
   if ! File( "scripts.dbf" )
      DbCreate( "scripts.dbf", { { "NAME", "C", 20, 0 }, { "DESCRIPT", "C", 100, 0 }, { "CODE", "M", 80, 0 } } )
   endif 
 
   USE scripts
 
   if RecCount() == 0
      APPEND BLANK
      Scripts->Name := "Test"
      Scripts->Descript := "This is a test script"
      Scripts->Code := cCode
   endif 

   DEFINE WINDOW oWnd

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON OF oBar PROMPT "New" ;
      TOOLTIP "New script" ;
      IMAGE "./../bitmaps/new.png" ;
      ACTION MsgInfo( "new" )

   DEFINE BUTTON OF oBar PROMPT "Execute" ;
      TOOLTIP "Execute the script" ;
      IMAGE "./../bitmaps/run.png" ;
      ACTION scripts->code := oMemo:GetText(), Execute()

   DEFINE BUTTON OF oBar PROMPT "Quit" ;
      TOOLTIP "Exit this application" ;
      IMAGE "./../bitmaps/exit.png" ;
      ACTION oWnd:End()

   @ 25, 0 BROWSE oBrw OF oWnd SIZE 10, 10 ;
      FIELDS Scripts->Name, Scripts->Descript ;
      HEADERS "Name", "Description" ;
      COLSIZES 150, 100 ;
      ON CHANGE ( oMemo:SetText( Scripts->Code ), oMemo:Refresh() )

   @ 290, 0 GET oMemo VAR Scripts->code MEMO OF oWnd SIZE 400, 100

   DEFINE MSGBAR OF oWnd PROMPT "FiveMac scripting"

   ACTIVATE WINDOW oWnd MAXIMIZED

return nil

function Execute()

   local oHrb, cResult, bOldError

   // FReOpen_Stderr( "comp.log", "w" )
   oHrb = HB_CompileFromBuf( Scripts->Code, "-n", "-I./../include", "-I./../../harbour/include" )
   // oResult:SetText( If( Empty( cResult := MemoRead( "comp.log" ) ), "ok", cResult ) )

   if ! Empty( oHrb )
      BEGIN SEQUENCE
      bOldError = ErrorBlock( { | o | DoBreak( o ) } )
      hb_HrbRun( oHrb )
      END SEQUENCE
      ErrorBlock( bOldError )
   endif

return nil

//----------------------------------------------------------------//

static function DoBreak( oError )

   local cInfo := oError:operation, n

   if ValType( oError:Args ) == "A"
      cInfo += "   Args:" + CRLF
      for n = 1 to Len( oError:Args )
         MsgInfo( oError:Args[ n ] )
         cInfo += "[" + Str( n, 4 ) + "] = " + ValType( oError:Args[ n ] ) + ;
                   "   " + cValToChar( oError:Args[ n ] ) + CRLF
      next
   endif

   MsgStop( oError:Description + CRLF + cInfo,;
            "Script error at line: " + Str( ProcLine( 2 ) ) )

   BREAK

return nil
