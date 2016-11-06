// Error handler system adapted to FiveMac

#include "FiveMac.ch"
#include "common.ch"
#include "error.ch"

//----------------------------------------------------------------------------//

proc ErrorSys()
    ErrorBlock( { | e | ErrorDialog( e ) } )
return

//----------------------------------------------------------------------------//

procedure ErrorLink()
return

//----------------------------------------------------------------------------//

static function ErrorDialog( oError ) // --> logical or quits App

   local oDlg, cCallStack := CallStack(), oBtn
   local cInfo := "FiveMac error occurred at " + DToC( Date() ) + ", " + Time() + CRLF
   
   cInfo += "============================================" + CRLF + CRLF
   cInfo += ErrorMessage( oError ) + CRLF + CRLF
   cInfo += ArgsList( oError ) + CRLF + CRLF 
   cInfo += cCallStack
   
   MemoWrit( AppPath() + "/error.log", cInfo )
   
   DEFINE DIALOG oDlg TITLE "FiveMac - error system"
   
   @ 298,  22 IMAGE oImg OF oDlg FILENAME ResPath() + "/fivetech.icns"
   
   @ 300, 160 SAY "Error description: " + ErrorMessage( oError ) SIZE 456, 80 OF oDlg

   @ 280, 160 SAY ArgsList( oError ) SIZE 300, 70 OF oDlg
   
   @ 282, 362 BUTTON "View error.log" SIZE 120, 25 OF oDlg ;
      ACTION WinExec( "TextEdit", AppPath() + "/error.log" )
   
   @ 280,  20 SAY "Called from:" OF oDlg

   @  50,  20 GET cCallStack MEMO SIZE 456, 230 OF oDlg

   @  10, 200 BUTTON oBtn PROMPT "Quit" OF oDlg ACTION oDlg:End()
   
   ACTIVATE DIALOG oDlg CENTERED
   
   GetAllWin()[ 1 ]:bValid = nil
   GetAllWin()[ 1 ]:End()
   
return nil   

//----------------------------------------------------------------------------//

static function ArgsList( oError )

   local cArgs := "", n

   if ValType( oError:Args ) == "A"
      cArgs += "Args:" + CRLF
      for n = 1 to Len( oError:Args )
         cArgs += "   [" + Str( n, 4 ) + "] = " + ValType( oError:Args[ n ] ) + ;
                  "   " + cValToChar( oError:Args[ n ] ) + ;
                  If( ValType( oError:Args[ n ] ) == "A", " length: " + AllTrim( Str( Len( oError:Args[ n ] ) ) ), "" ) + ;
                  If( ValType( oError:Args[ n ] ) == "O", " ClassName: " + oError:Args[ n ]:ClassName(), "" ) + CRLF
      next
   elseif ValType( oError:Args ) == "C"
      cArgs += "Args:" + oError:Args + CRLF
   endif
   
return cArgs   

//----------------------------------------------------------------------------//

static function CallStack()

   local cCalls := ""
   local n := 3

   while ( n < 74 )
      if ! Empty( ProcName( n ) )
         cCalls += "Called from: " + ProcFile( n ) + " => " + Trim( ProcName( n ) ) + ;
                   "( " + AllTrim( Str( ProcLine( n ) ) ) + " )" + CRLF
      endif
      n++
   end
   
return cCalls 

//----------------------------------------------------------------------------// 

function ErrorMessage( oError )

   local cMessage := If( oError:severity > ES_WARNING, "Error", "Warning" ) + " "

   if IsCharacter( oError:subsystem )
      cMessage += oError:subsystem()
   endif

   if IsNumber( oError:subCode )
      cMessage += "/" + hb_NToS( oError:subCode )
   endif

   if IsCharacter( oError:description )
      cMessage += CRLF + oError:description
   endif

   do case
      case ! Empty( oError:filename )
           cMessage += ": " + oError:filename
           
      case ! Empty( oError:operation )
          cMessage += ": " + oError:operation
   endcase

return cMessage

//----------------------------------------------------------------------------//  
