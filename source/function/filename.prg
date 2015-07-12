// FiveWin FileNames support functions

#include "FiveMac.ch"
#include "FileIO.ch"

//---------------------------------------------------------------------------//

function lIsDir( cDirName )   // Checks an existing directory

   local aResult

   if Right( cDirName, 1 ) == "\" .or. Right( cDirName, 1 ) == "/"
      cDirName = Left( cDirName, Len( cDirName ) - 1 )
   endif
   
   aResult = Directory( cDirName, "DHS" )
   
return Len( aResult ) == 1 .and. "D" $ aResult[ 1 ][ 5 ]

//---------------------------------------------------------------------------//

function cFileDisc( cPathMask )  // returns drive of the path

return If( At( ":", cPathMask ) == 2, ;
           Upper( Left( cPathMask, 2 ) ), "" )

//---------------------------------------------------------------------------//

function cFilePath( cPathMask )   // returns path of a filename

   local n := RAt( "/", cPathMask ), cDisk

return If( n > 0, Left( cPathMask, n ),;
           ( cDisk := cFileDisc( cPathMask ) ) + If( ! Empty( cDisk ), "/", "" ) )

//---------------------------------------------------------------------------//

function cFileNoPath( cPathMask )  // returns just the filename no path

    local n := RAt( "/", cPathMask )

return If( n > 0, SubStr( cPathMask, n + 1 ), cPathMask )

//---------------------------------------------------------------------------//

function cFileName( cPathMask )

return cFileNoPath( cPathMask )

//---------------------------------------------------------------------------//

function cFileMask( cPathMask )  // returns mask of a filename

   local cMask := cFileNoPath( cPathMask )

return If( ( "*" $ cMask ) .or. ( "?" $ cMask ), cMask, "" )

//---------------------------------------------------------------------------//

function cFileNoExt( cPathMask ) // returns the filename without ext

   local cName := AllTrim( cFileNoPath( cPathMask ) )
   local n     := At( ".", cName )

return AllTrim( If( n > 0, Left( cName, n - 1 ), cName ) )

//---------------------------------------------------------------------------//

function cFileExt( cPathMask ) // returns the ext of a filename

   local cExt := AllTrim( cFileNoPath( cPathMask ) )
   local n    := RAt( ".", cExt )

return AllTrim( If( n > 0 .and. Len( cExt ) > n,;
                    Right( cExt, Len( cExt ) - n ), "" ) )

//---------------------------------------------------------------------------//

function cFileSubDir( cPath )   // returns the subdir of a path & filename

return Upper( cFilePath( If( Right( cPath, 1 ) == "\" ,;
              Left( cPath, Len( cPath ) - 1 ), cPath ) ) )

//---------------------------------------------------------------------------//

function cNewFileName( cRootName, cExt )

   local cFileName := cRootName + "1" + "." + cExt
   local nId := 1

   while File( cFileName )
      cFileName = cRootName + ;
                  StrZero( ++nId, If( nId < 10, 1,;
                           If( nId < 100, 2, 3 ) ) ) + ;
                  "." + cExt
   end

return cFileName

//----------------------------------------------------------------------------//


//----------------------------------------------------------------------------//

function GetTickCount() // Temporary workaround

return 0

function cTempFile( cPath, cExtension )        // returns a temporary filename

   local cFileName

   static cOldName

   DEFAULT cPath := "", cExtension := ""
   
   if ! "." $ cExtension
      cExtension = "." + cExtension
   endif   

   while File( cFileName := ( cPath + LTrim( Str( GetTickCount() ) ) + cExtension ) ) .or. ;
      cFileName == cOldName
   end

   cOldName = cFileName

return cFileName

//---------------------------------------------------------------------------//

function FSize( cFile ) // --> nFileSize

   local aFiles := Directory( cFile )

   If Len( aFiles ) > 0
      return aFiles[ 1 ][ 2 ]
   endif

return 0

//---------------------------------------------------------------------------//

function FDate( cFile ) // --> dFileDate

   local aFiles := Directory( cFile )

   If Len( aFiles ) > 0
      return aFiles[ 1 ][ 3 ]
   endif

return CToD( "  -  -  " )

//---------------------------------------------------------------------------//

function FTime( cFile ) // --> cFileTime

   local aFiles := Directory( cFile )

   If Len( aFiles ) > 0
      return aFiles[ 1 ][ 4 ]
   endif

return ""

//---------------------------------------------------------------------------//

function aFindFile( cFileName, cPath, aResult )

   local aFiles := Directory( cPath + "\", "D" )
   local n

   if ProcName( 5 ) == "AFINDFILE"
      return nil
   endif

   if aResult == nil
      aResult = {}
   endif

   for n = 1 to Len( aFiles )
      // SysRefresh()
      if Upper( aFiles[ n ][ 1 ] ) == Upper( cFileName )
         AAdd( aResult, cPath + "\" + cFileName )
      endif
      if aFiles[ n ][ 5 ] == "D" .and. ! ( aFiles[ n ][ 1 ] $ ".." )
         aFindFile( cFileName, cPath + "\" + aFiles[ n ][ 1 ], aResult )
      endif
   next

return aResult

//---------------------------------------------------------------------------//

function LogFile( cFileName, aInfo )

   local hFile, cLine := DToC( Date() ) + " " + Time() + ": ", n

   for n = 1 to Len( aInfo )
      cLine += cValToChar( aInfo[ n ] ) + Chr( 9 )
   next
   cLine += CRLF

   if ! File( cFileName )
      FClose( FCreate( cFileName ) )
   endif

   if( ( hFile := FOpen( cFileName, FO_WRITE ) ) != -1 )
      FSeek( hFile, 0, FS_END )
      FWrite( hFile, cLine, Len( cLine ) )
      FClose( hFile )
   endif

return nil

//---------------------------------------------------------------------------//

function LogStack()

   local cStack := ""
   local n := 1, m
   local aInfo

   LogFile( "stack.txt", { "" } )
   LogFile( "stack.txt", { "LogStack() called" } )
   LogFile( "stack.txt", { "=================" } )

   while ! Empty( ProcName( n ) )
      aInfo = { ProcName( n ) }
      for m = 1 to PCount() // PCount( n )
         // AAdd( aInfo, GetParam( n, m ) )
      next
      LogFile( "stack.txt", aInfo )
      n++
   end

return nil

//---------------------------------------------------------------------------//

#ifndef __CLIPPER__

// (0 = All drives, 1 = Floppy drives only, 2 = Hard drives only)

function ADrives( nType )  // Thanks to EMG

   local aDisk := {}
   local i

   DEFAULT nType := 0

   if nType = 0 .OR. nType = 1
      for i = ASC( "A" ) TO ASC( "B" )
          // if ISDISKETTE( CHR( i ) + ":" )
          //    AADD( aDisk, CHR( i ) + ":" )
          // endif
      next
   endif

   if nType = 0 .OR. nType = 2
      for i = ASC( "C" ) TO ASC( "Z" )
          // if ISCDROM( CHR( i ) + ":" ) .OR. FILE( CHR( i ) + ":\NUL" )
          //    AADD( aDisk, CHR( i ) + ":" )
          // endif
      next
   endif

return aDisk

#endif

//---------------------------------------------------------------------------//
