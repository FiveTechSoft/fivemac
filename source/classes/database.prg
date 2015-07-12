// Clipper DataBases management as objects

#include "FiveMac.ch"

#define _DbSkipper __DbSkipper

//----------------------------------------------------------------------------//

CLASS TDataBase

   DATA   nArea                  AS NUMERIC INIT 0
   DATA   lBuffer
   DATA   lShared                AS LOGICAL INIT .t.
   DATA   aBuffer
   DATA   bBoF, bEoF, bNetError
   DATA   cAlias, cFile, cDriver
   DATA   lReadOnly              AS LOGICAL INIT .f.
   DATA   lOemAnsi
   DATA   lTenChars              AS LOGICAL INIT .t.
   DATA   aFldNames             AS ARRAY

   METHOD New( nWorkArea )  CONSTRUCTOR

   METHOD Activate()

   METHOD AddIndex( cFile, cTag ) INLINE ( ::nArea )->( OrdListAdd( cFile, cTag ) )
   MESSAGE AnsiToOem METHOD _AnsiToOem()
   METHOD Append()            INLINE ( ::nArea )->( DbAppend() )
   METHOD Blank( nRecNo )     INLINE ( ::nArea )->( nRecNo := RecNo(),;
                                                    DBGoBottom(), ;
                                                    DBSkip( 1 ), ;
                                                    ::Load(),;
                                                    DBGoTo( nRecNo ) )
   METHOD Bof()               INLINE ( ::nArea )->( BoF() )
   METHOD Close()             INLINE ( ::nArea )->( DbCloseArea() )
   METHOD CloseIndex()        INLINE ( ::nArea )->( OrdListClear() )
   METHOD Commit()            INLINE ( ::nArea )->( DBCommit() )

   METHOD Create( cFile, aStruct, cDriver ) ;
                              INLINE DbCreate( cFile, aStruct, cDriver )

   METHOD CreateIndex( cFile, cTag, cKey, bKey, lUnique) INLINE ;
          ( ::nArea )->( OrdCreate( cFile, cTag, cKey, bKey, lUnique ) )

   METHOD ClearRelation()     INLINE ( ::nArea )->( DbClearRelation() )

   METHOD DbCreate( aStruct ) INLINE DbCreate( ::cFile, aStruct, ::cDriver )

   METHOD Deactivate()        INLINE ( ::nArea )->( DbCloseArea() ), ::nArea := 0

   #ifndef __XPP__
   METHOD Eval( bBlock, bFor, bWhile, nNext, nRecord, lRest ) ;
                              INLINE ( ::nArea )->( DBEval( bBlock, bFor, ;
                                                    bWhile, nNext, nRecord, ;
                                                    lRest ) )
   #endif

   MESSAGE Delete METHOD _Delete()
   METHOD Deleted()           INLINE ( ::nArea )->( Deleted() )

   METHOD DeleteIndex( cTag, cFile ) INLINE ( ::nArea )->( OrdDestroy( cTag, cFile ) )

   METHOD Eof()               INLINE ( ::nArea )->( EoF() )

   METHOD FCount()            INLINE ( ::nArea )->( FCount() )

   MESSAGE FieldGet METHOD _FieldGet( nField )

   METHOD FieldName( nField ) INLINE ( ::nArea )->( FieldName( nField ) )

   METHOD FieldPos( cFieldName ) INLINE ( ::nArea )->( FieldPos( cFieldName ) )

   MESSAGE FieldPut METHOD _FieldPut( nField, uVal )

   METHOD Found()             INLINE ( ::nArea )->( Found() )

   METHOD GoTo( nRecNo )      INLINE ( ::nArea )->( DBGoTo( nRecNo ) ),;
                                     If( ::lBuffer, ::Load(), )

   METHOD GoTop()             INLINE ( ::nArea )->( DBGoTop() ),;
                                     If( ::lBuffer, ::Load(), )
   METHOD GoBottom()          INLINE ( ::nArea )->( DBGoBottom() ),;
                                     If( ::lBuffer, ::Load(), )

   METHOD IndexKey( ncTag, cFile )   INLINE ( ::nArea )->( OrdKey( ncTag, cFile ) )
   METHOD IndexName( nTag, cFile )   INLINE ( ::nArea )->( OrdName( nTag, cFile ) )
   METHOD IndexBagName( nInd )       INLINE ( ::nArea )->( OrdBagName( nInd ) )
   METHOD IndexOrder( cTag, cFile )  INLINE ( ::nArea )->( OrdNumber( cTag, cFile ) )

   METHOD LastRec( nRec )     INLINE ( ::nArea )->( LastRec() )

   METHOD Load()

   METHOD Lock()              INLINE ( ::nArea )->( FLock() )
   METHOD Modified()

   MESSAGE OemToAnsi METHOD _OemToAnsi()
   METHOD Pack()              INLINE ( ::nArea )->( DbPack() )
   METHOD ReCall()            INLINE ( ::nArea )->( DBRecall() )

   METHOD RecCount()          INLINE ( ::nArea )->( RecCount() )
   METHOD RecLock()           INLINE ( ::nArea )->( RLock() )
   METHOD RecNo()             INLINE ( ::nArea )->( RecNo() )
   METHOD Save()

   METHOD SetBuffer( lOnOff ) // if TRUE reloads buffer, return lBuffer.

   METHOD Seek( uExp, lSoft )

   METHOD SetOrder( cnTag, cFile )    INLINE ( ::nArea )->( OrdSetFocus( cnTag, cFile ) )

   METHOD SetRelation( ncArea, cExp ) INLINE ;
                 ( ::nArea )->( DbSetRelation( ncArea, Compile( cExp ), cExp ) )

   METHOD Skip( nRecords )
   METHOD Skipper( nRecords )

   METHOD UnLock()            INLINE ( ::nArea )->( DBUnLock() )

   METHOD Used()              INLINE ( ::nArea )->( Used() )
   METHOD Zap()               INLINE ( ::nArea )->( DbZap() )

   ERROR HANDLER OnError( uParam1 )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nWorkArea ) CLASS TDataBase

   local n, oClass, aDatas := {}, aMethods := {}

   DEFAULT nWorkArea := Select()

   ::nArea     = nWorkArea
   ::cAlias    = Alias( nWorkArea )
   ::cFile     = Alias( nWorkArea )
   ::cDriver   = ( Alias( nWorkArea ) )->( DbSetDriver() )
   ::lShared   = .t. // Set( _SET_EXCLUSIVE )
   ::lReadOnly = .f.
   ::lBuffer   = .t.
   ::lOemAnsi  = .f.

   ::bBoF      = { || MsgStop( "Beginning of file" ) }
   ::bEoF      = { || MsgStop( "End of file" ), ::GoBottom() }
   ::bNetError = { || MsgStop( "Record in use", "Please, retry" ) }

   ::Load()

   ::aFldNames = {}
   for n = 1 to ( ::cAlias )->( FCount() )
      AAdd( ::aFldNames, ( ::cAlias )->( FieldName( n ) ) )
   next

return Self

//----------------------------------------------------------------------------//

METHOD Activate() CLASS TDataBase

   local nOldArea:= Select()

   Select ( ::nArea )
   if ! Used()
      DbUseArea( .f., ::cDriver, ::cFile, ::cAlias, ::lShared, ::lReadOnly )
   endif

   Select ( nOldArea )

return nil

//----------------------------------------------------------------------------//

METHOD _AnsiToOem() CLASS TDataBase

   local n

   for n = 1 to Len( ::aBuffer )
      if ValType( ::aBuffer[ n ] ) == "C"
         ::aBuffer[ n ] = AnsiToOem( ::aBuffer[ n ] )
      endif
   next

return nil

//----------------------------------------------------------------------------//

METHOD _Delete() CLASS TDataBase

   if ::lShared
      if ::Lock()
         ( ::nArea )->( DbDelete() )
         ::Commit()
         ::UnLock()
      else
         MsgAlert( "DataBase in use", "Please try again" )
      endif
   else
      ( ::nArea )->( DbDelete() )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD _FieldGet( nPos ) CLASS TDataBase

   if ::lBuffer
      return ::aBuffer[ nPos ]
   else
      return ( ::nArea )->( FieldGet( nPos ) )
   endif

return nil

//---------------------------------------------------------------------------//

METHOD _FieldPut( nPos, uValue ) CLASS TDataBase

   if ::lBuffer
      ::aBuffer[ nPos ] := uValue
   else
      if ::lShared
         if ::RecLock()
            ( ::nArea )->( FieldPut( nPos, uValue ) )
            ::Commit()
            ::UnLock()
         else
            if ! Empty( ::bNetError )
               return Eval( ::bNetError, Self )
            endif
         endif
      else
         ( ::nArea )->( FieldPut( nPos, uValue ) )
      endif
   endif

return nil

//---------------------------------------------------------------------------//

static function Compile( cExp )
return &( "{||" + cExp + "}" )

//----------------------------------------------------------------------------//

METHOD Load() CLASS TDataBase

   local n

   if ::lBuffer
      if Empty( ::aBuffer )
         ::aBuffer = Array( ::FCount() )
      endif

      for n = 1 to Len( ::aBuffer )
         ::aBuffer[ n ] = ( ::nArea )->( FieldGet( n ) )
      next

      if ::lOemAnsi
         ::OemToAnsi()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Modified() CLASS TDataBase

   local n

   for n := 1 to Len( ::aFldNames )

      if ! ( ::cAlias )->( FieldGet( n ) ) == ::aBuffer[ n ]
         return .t.
      endif

   next

return .f.

//----------------------------------------------------------------------------//

METHOD _OemToAnsi() CLASS TDataBase

   local n

   for n = 1 to Len( ::aBuffer )
      if ValType( ::aBuffer[ n ] ) == "C"
         ::aBuffer[ n ] = OemToAnsi( ::aBuffer[ n ] )
      endif
   next

return nil

//----------------------------------------------------------------------------//

METHOD OnError( uParam1 ) CLASS TDataBase

   local cMsg   := __GetMessage()
   local nError := If( SubStr( cMsg, 1, 1 ) == "_", 1005, 1004 )

   local nField

   if ::lTenChars .and. Len( SubStr( cMsg, 2 ) ) == 9 // match fields based on nine first chars
      cMsg = Upper( cMsg )
      if SubStr( cMsg, 1, 1 ) == "_"
         if ( nField := AScan( ::aFldNames,;
                             { | cField | SubStr( cMsg, 2 ) == ;
                                 RTrim( SubStr( cField, 1, 9 ) ) } ) ) != 0
            ::FieldPut( nField, uParam1 )
         else
            _ClsSetError( _GenError( nError, ::ClassName(), SubStr( cMsg, 2 ) ) )
         endif
      else
         if( ( nField := ::FieldPos( cMsg ) ) != 0 )
            return ::FieldGet( nField )
         else
            _ClsSetError( _GenError( nError, ::ClassName(), cMsg ) )
         endif
      endif
      return nil
   endif

   if SubStr( cMsg, 1, 1 ) == "_"
      if( ( nField := ::FieldPos( SubStr( cMsg, 2 ) ) ) != 0 )
         ::FieldPut( nField, uParam1 )
      else
         _ClsSetError( _GenError( nError, ::ClassName(), SubStr( cMsg, 2 ) ) )
      endif
   else
      if( ( nField := ::FieldPos( cMsg ) ) != 0 )
         return ::FieldGet( nField )
      else
         _ClsSetError( _GenError( nError, ::ClassName(), cMsg ) )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Seek( uExpr, lSoft ) CLASS TDataBase

   local lFound

   DEFAULT lSoft := Set( _SET_SOFTSEEK )

   lFound = ( ::nArea )->( DbSeek( uExpr, lSoft ) )

   if ::lBuffer
      ::Load()
   endif

return lFound

//----------------------------------------------------------------------------//

METHOD SetBuffer( lOnOff ) CLASS TDataBase

   DEFAULT lOnOff := .t.

   if lOnOff != nil
       ::lBuffer = lOnOff
   endif

   if ::lBuffer
      ::Load()
   else
      ::aBuffer := nil
   endif

return ::lBuffer

//----------------------------------------------------------------------------//

METHOD Save() CLASS TDataBase

   local n

   if ::lBuffer
      if ! ( ::nArea )->( EoF() )
         if ::lShared
            if ::RecLock()
               for n := 1 to Len( ::aBuffer )
                  if ::lOemAnsi .and. ValType( ::aBuffer[ n ] ) == "C"
                     ( ::nArea )->( FieldPut( n, AnsiToOem( ::aBuffer[ n ] ) ) )
                  else
                     ( ::nArea )->( FieldPut( n, ::aBuffer[ n ] ) )
                  endif
               next
               ::Commit()
               ::UnLock()
            else
               if ! Empty( ::bNetError )
                  return Eval( ::bNetError, Self )
               else
                  MsgAlert( "Record in use", "Please, retry" )
               endif
            endif
         else
            for n := 1 to Len( ::aBuffer )
               if ::lOemAnsi .and. ValType( ::aBuffer[ n ] ) == "C"
                  ( ::nArea )->( FieldPut( n, AnsiToOem( ::aBuffer[ n ] ) ) )
               else
                  ( ::nArea )->( FieldPut( n, ::aBuffer[ n ] ) )
               endif
            next
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Skip( nRecords ) CLASS TDataBase

   local n

   DEFAULT nRecords := 1

   ( ::nArea )->( DbSkip( nRecords ) )

   if ::Eof()
      if ::bEoF != nil
         Eval( ::bEoF, Self )
      endif
   endif
   
   if ::lBuffer
      ::Load()
   endif

   if ::BoF()
      if ::bBoF != nil
         Eval( ::bBoF, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Skipper( nRecords ) CLASS TDataBase

   local nSkipped

   DEFAULT nRecords := 1

   nSkipped = ( ::nArea )->( _DbSkipper( nRecords ) )

   if ::lBuffer
      ::Load()
   endif

return nSkipped

//----------------------------------------------------------------------------//

function DbPack()

   PACK
   
return nil

//----------------------------------------------------------------------------//

function DbZap()

   ZAP
   
return nil

//----------------------------------------------------------------------------//

function AnsiToOem()

   MsgAlert( "AnsiToOem() not implemented yet!" )
   
return nil   

//----------------------------------------------------------------------------//

function OemToAnsi()

   MsgAlert( "OemToAnsi() not implemented yet!" )
   
return nil   

//----------------------------------------------------------------------------//

function _ClsSetError() ; return nil
function _GenError() ; return nil
