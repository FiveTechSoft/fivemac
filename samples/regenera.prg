#include "Fivemac.ch" 





FUNCTION MAIN() 
  REQUEST DBFCDX
  
    LOCAL oDlg 
    local ccode:=""
    local oget
    local oget2,cDlg

      DEFINE DIALOG oDlg TITLE "Dialog"
      
    @ 80, 10 GET oget VAR cCode MEMO SIZE 480, 315 OF oDlg
    
    @ 56, 10 SAY "Dialogo" SIZE 480, 20 OF oDlg
    @ 40, 10 GET oget2 VAR cDlg MEMO SIZE 480, 20 OF oDlg
    
    @ 3, 3 BUTTON "genera" ACTION ( oget:setText( regenera(alltrim(oget2:getText())) ) ) 
    @ 3, 103 BUTTON "exec" ACTION ( execscrip(oget:GetText() ) )  

    ACTIVATE DIALOG oDlg  CENTER 
            
    RETURN NIL
    
    
    
Function Regenera(cDlg)
local cpath:=Path()
local cText:=""
local cdialog,ccontrol
local id_dialog


use (cpath+"/DIALOGOS.dbf") new VIA "DBFCDX" 
cdialog:=Alias()
(cdialog)->(ordsetfocus(1))
(cdialog)->(dbgotop())
if !(cdialog)->(dbseek( cDlg ) )
    close(cdialog) 
    msginfo("error dialogo no encontrado")
    return .f.
 endif

id_dialog:=alltrim((cdialog)->codigo)
cText+= "define dialog oDlg TITLE '"+alltrim( (cdialog)->titulo) +" '"+CRLF

use (cpath+"/controles.dbf") new
ccontrol:=alias()
dbgotop()
do while !eof() 
if alltrim((ccontrol)->dialog) == id_dialog
   if  alltrim((ccontrol)->tipo) == "BUTTON"
        cText+= "@ "+ alltrim(str((ccontrol)->TOP)) +","+alltrim(str( (ccontrol)->left)) +" "+alltrim((ccontrol)->tipo) +;
        " "+alltrim((ccontrol)->codigo)+" PROMPT '" + alltrim( (ccontrol)-> titulo) +  "' ACTION "+(ccontrol)->ACTION +CRLF
      
    endif
    
endif
dbskip() 
enddo

cText+= "ACTIVATE DIALOG oDlg CENTER "

close(cdialog)
close(ccontrol) 

Return cText 


Function execscrip(cText)
 local cCode := '#include "FiveMac.ch"' + CRLF + CRLF + "function Test()" + CRLF + CRLF 
 
 cCode+=cText+CRLF
 
 cCode+=CRLF+ CRLF + "return nil"
 

msginfo(cCode)
Execute(ccode)

Return nil


function Execute(cCode)

   local oHrb, cResult, bOldError
   local cUserP:=USERPATH()
  
   oHrb = HB_CompileFromBuf( ccode , "-n", "-I"+cUserp+"/fivemac/include", "-I"+cUserp+"/harbour/include" )
  

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



function btn1(obtn)

   msginfo(str(obtn:ntop))

return nil

