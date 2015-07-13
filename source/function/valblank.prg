#include "fivemac.ch"

//----------------------------------------------------------------------------//

function uValBlank( uValue )

   local cType := ValType( uValue )
   local uResult

   do case
      case cType $ "CM"
       uResult = Space( Len( uValue ) )

      case cType == "N"
           uResult = Val( Str( uValue - uValue, Len( Str( uValue ) ) ) )

      case cType == "L"
       uResult = .f.

      case cType == "D"
       uResult = CToD( "  -  -  " )

      case cType == "T"
       uResult = hb_CToT( "" )

   endcase

return uResult

//----------------------------------------------------------------------------//
/*
function cValToChar( uVal )

   local cType := ValType( uVal )

   do case
      case cType == "C" .or. cType == "M"
           return uVal

      case cType == "D"
           
           return DToC( uVal )

      case cType == "T"
         
            return If( Year( uVal ) == 0, HB_TToC( uVal, '', Set( _SET_TIMEFORMAT ) ), HB_TToC( uVal ) )
        
      case cType == "L"
           return If( uVal, ".T.", ".F." )

      case cType == "N"
           return AllTrim( Str( uVal ) )

      case cType == "B"
           return "{|| ... }"

      case cType == "A"
           return "{ ... }"

      case cType == "O"
           return If( __ObjHasData( uVal, "cClassName" ), uVal:cClassName, uVal:ClassName() )

      case cType == "H"
           return "{=>}"

      case cType == "P"
           
            return "0x" + hb_NumToHex( uVal )
          
      otherwise

           return ""
   endcase

return nil
*/
//----------------------------------------------------------------------------//

function IfNil(...)

   local aParams := HB_AParams()
   local u
 
   if Len( aParams ) == 1 .and. ValType( aParams[ 1 ] ) == 'A'
      aParams  := aParams[ 1 ]
   endif
  
   for each u in aParams
      if u != nil
         return u
      endif
   next

return u

//----------------------------------------------------------------------------//

function nRGBReSet( nClr, r, g, b )

   DEFAULT r := nRGBRed(   nClr ), ;
           g := nRGBGreen( nClr ), ;
           b := nRGBBlue(  nClr )

   r     := Min( 255, Max( 0, r ) )
   g     := Min( 255, Max( 0, g ) )
   b     := Min( 255, Max( 0, b ) )

return nRGB( r, g, b )

//----------------------------------------------------------------------------//

function nRGBAdd( nClr, r, g, b )

   DEFAULT r := 0, g := 0, b := 0

   r  += nRGBRed(   nClr )
   g  += nRGBGreen( nClr )
   b  += nRGBBlue(  nClr )

   r     := Min( 255, Max( 0, r ) )
   g     := Min( 255, Max( 0, g ) )
   b     := Min( 255, Max( 0, b ) )

return nRGB( r, g, b )

//----------------------------------------------------------------------------//

function cClrToCode( clr )

   local cCode    := ""
   local ctmp1, ctmp2, n
   local r,g,b
   local cType    := ValType( clr )
   local aStdClrs := { ;
      { 'CLR_BLACK',             0 }, ;
      { 'CLR_BLUE',        8388608 }, ;
      { 'CLR_GREEN',         32768 }, ;
      { 'CLR_CYAN',        8421376 }, ;
      { 'CLR_RED',             128 }, ;
      { 'CLR_MAGENTA',     8388736 }, ;
      { 'CLR_BROWN',         32896 }, ;
      { 'CLR_HGRAY',      12632256 }, ;
      { 'CLR_LIGHTGRAY',  12632256 }, ;
      { 'CLR_GRAY',        8421504 }, ;
      { 'CLR_HBLUE',      16711680 }, ;
      { 'CLR_HGREEN',        65280 }, ;
      { 'CLR_HCYAN',      16776960 }, ;
      { 'CLR_HRED',            255 }, ;
      { 'CLR_HMAGENTA',   16711935 }, ;
      { 'CLR_YELLOW',        65535 }, ;
      { 'CLR_WHITE',      16777215 } }

   do case
      case cType == 'N'
         if ( n := AScan( aStdClrs, { |a| a[ 2 ] == clr } ) ) > 0
            cCode    := aStdClrs[ n ][ 1 ]
         else
            r        := nRGBRed(   clr ) // clr % 256; clr := Int( clr / 256 )
            g        := nRGBGreen( clr ) // clr % 256; clr := Int( clr / 256 )
            b        := nRGBBlue(  clr ) // clr % 256
            cCode    := "RGB(" + Str( r, 4 ) + "," + Str( g, 4 ) + "," + Str( b, 4 ) + " )"
         endif
      case cType == 'A'
         if ValType( clr[ 1 ] ) == 'A'
            cCode    := '{ ;' + CRLF
            for n := 1 to Len( clr )
               cCode    += Space( 3 ) + cClrToCode(  clr[ n ] )
               if n < Len( clr )
                  cCode += ', ;' + CRLF
               else
                  cCode += '  ;' + CRLF
               endif
            next n
            cCode    += '}'
         else
            if Len( clr ) == 1
               cCode := '{ ' + cClrToCode( clr ) + ' }'
            elseif Len( clr ) == 2
               cCode := '{ ' + ;
                         PadR( cClrToCode( clr[ 1 ] ) + ',', 23 ) + ;
                         PadR( cClrToCode( clr[ 2 ] ), 22 ) + ' }'

            elseif Len( clr ) == 3
               cCode := '{ ' + ;
                         PadR( TrimZero( Str( clr[ 1 ], 6, 4 ) ) + ',', 8 ) + ;
                         PadR( cClrToCode( clr[ 2 ] ) + ',', 23 ) + ;
                         PadR( cClrToCode( clr[ 3 ] ), 22 ) + ' }'

            endif
         endif
      case cType == 'B'
         cTmp1    := cClrToCode( Eval( clr, .t. ) )
         cTmp2    := cClrToCode( Eval( clr, .f. ) )
         if cTmp1 == cTmp2
            if CRLF $ cTmp1
               cTmp1    := Space(3) + StrTran( cTmp1, CRLF, CRLF + Space(3) )
               cCode    := '{ || ;' + CRLF + cTmp1 + ' ;' + CRLF + '}'
            else
               cCode    := '{ || ' + cTmp1 + ' }'
            endif
         else
            cTmp1    := Space(3) + StrTran( cTmp1, CRLF, CRLF + Space(3) )
            cTmp2    := Space(3) + StrTran( cTmp2, CRLF, CRLF + Space(3) )
            cCode    := '{ | lInvert | If( ! lInvert, ;' + CRLF + ;
                        cTmp2 + ',;' + CRLF + cTmp1 + ;
                        ' ;' + CRLF + ') }'
         endif
   endcase

return cCode

//----------------------------------------------------------------------------//

static function TrimZero( c )

   do while Right( c, 1 ) == '0'
      c  := Left( c, Len( c ) - 1 )
   enddo

return c

//----------------------------------------------------------------------------//
/*
function ArrayToText( aItems )

  local cText := ""

  AEval( aItems, { | u | cText += '"' + cValToChar( u ) + '", ' } )

return SubStr( cText, 1, Len( cText ) - 2 )
*/
//----------------------------------------------------------------------------//
