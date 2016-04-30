//----------------------------------------------------------------------------//

function Execute( cCode )

   local oHrb, bOldError, uRet

   oHrb = HB_CompileFromBuf( cCode, "-n",;
                             "-I" + UserPath() + "/fivemac/include",;
                             "-I" + UserPath() + "/harbour/include" )

   if ! Empty( oHrb )
      BEGIN SEQUENCE
      bOldError = ErrorBlock( { | o | DoBreak( o ) } )
      uRet = hb_HrbDo( hb_HrbLoad( oHrb ) )
      END SEQUENCE
      ErrorBlock( bOldError )
   endif

return uRet

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
            "Script error at line: " + AllTrim( Str( ProcLine( 2 ) ) ) )

   BREAK

return nil

//----------------------------------------------------------------//