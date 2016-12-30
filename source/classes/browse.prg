#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TWBrowse FROM TControl

   DATA   bLine, bGetValue
   DATA   bDrawRect
   DATA   bSetValue
   DATA   aHeaders
   DATA   aCols INIT {}
   DATA   bLogicLen
   DATA   bChange
   DATA   cAlias
   DATA   oDataSet
   DATA   bAction, bHeadclick
   DATA   lVScroll, lHScroll
   DATA   nArrayAt
   DATA   bClrText
   DATA   bMouseDown

   CLASSDATA aProps INIT { "nTop", "nLeft", "nWidth", "nHeight", "cVarName",;
                             "nClrText", "nClrBack", "nAutoResize" }

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, bLine, aHeaders, cAlias ,;
                      nAutoResize, aSizes, nClrText, nClrBack, cVarName )

   METHOD cGenPrg()

   METHOD GetTextColor( pColumn, nRowIndex ) INLINE ;
                    If( ::bClrText != nil, Eval( ::bClrText, pColumn, nRowIndex ),)

   METHOD GetValue( nCol, nRow )

   METHOD SetValue( nCol, nRow, oObj )

   METHOD GoTop() INLINE BrwGoTop( ::hWnd )

   METHOD GoBottom() INLINE BrwGoBottom( ::hWnd )

   METHOD GoDown() INLINE BrwGoDown( ::hWnd )

   METHOD GoUp() INLINE BrwGoUp( ::hWnd )

   METHOD Rows() INLINE If( ::bLogicLen != nil, Eval( ::bLogicLen ), 0 )

   METHOD SetArray( aArray )

   METHOD SetEdit()

   METHOD SetText() INLINE .T.

   METHOD Refresh() INLINE BrwRefresh( ::hWnd )

   METHOD nRowPos() INLINE BrwRowPos( ::hWnd )

   METHOD nColPos() INLINE BrwColPos( ::hWnd )

   METHOD SetColBmp( nColumn ) INLINE BrwSetColBmp( ::hWnd, nColumn ) // Sets a column to display images

   METHOD SetColBmpTxt( nColumn ) INLINE BrwSetColBmpTxt( ::hWnd, nColumn ) // Sets a column to display image and text

   METHOD SetColWidth( nColumn, nWidth ) INLINE BrwSetColWidth( ::hWnd, nColumn, nWidth )

   METHOD GetColWidth( nColumn ) INLINE BrwGetColWidth( ::hWnd, nColumn )

   METHOD SetRowHeight( nHeight ) INLINE BrwSetRowHeight( ::hWnd, nHeight )

   METHOD GetRowHeight() INLINE BrwGetRowHeight( ::hWnd )

   METHOD SetAlternateColor( lOnOff ) INLINE BrwSetAltColor( ::hWnd, lOnOff )

   METHOD SetColorsForAlternate( nColorIni, nColorEnd )

   METHOD SetGridLines( nType ) INLINE BrwSetGridLines( ::hWnd, nType )

   METHOD GetGridLines() INLINE BrwGetGridLines( ::hWnd )

   METHOD SetColEditable( nColumn, lEdit ) INLINE BrwSetColeditable( ::hWnd, nColumn, lEdit )

   METHOD SetHeadTooltip( nColumn, cText ) INLINE BrwSetHeadTooltip( ::hWnd, nColumn, cText )

   METHOD SetNoHead() INLINE BrwSetNoHead( ::hWnd )

   METHOD SetIndicatorDescent( nColumn ) INLINE BrwSetIndicatorDescent( ::hWnd, nColumn )

   METHOD SetIndicatorAscend( nColumn ) INLINE BrwSetIndicatorAscend( ::hWnd, nColumn )

   METHOD DelIndicator( nColumn ) INLINE BrwSetNoIndicator( ::hWnd, nColumn )

   METHOD SetRowPos( nRow ) INLINE BrwSetRowPos( ::hWnd, nRow )

   METHOD Select( nAt ) INLINE BrwSetRowPos( ::hWnd, nAt )  // para compatibilidad

   METHOD SetSelectorStyle( nStyle ) INLINE BrwSetSelectorStyle( ::hWnd, nStyle )

   METHOD SetColor( nClrText, nClrBack )

   METHOD Redefine( nId, oWnd )

   METHOD Initiate()

   METHOD Click() INLINE If( ::bAction != nil, Eval( ::bAction, Self ),)

   METHOD Drawrect(nRow) INLINE If( :: bDrawRect != nil, Eval( ::bDrawRect, nRow ), )

   METHOD Change() INLINE If( ::bChange != nil, Eval( ::bChange, Self ),)

   METHOD Headclick( nHead ) INLINE If( ::bHeadclick != nil, Eval( ::bHeadclick, Self,nHead ),)

   METHOD Anclaje( nAutoResize ) INLINE ( ::nAutoResize := nAutoResize, BrwAutoAjust ( ::hWnd, ::nAutoResize ) )

   METHOD ScrollAutoHide( lAutoHide ) INLINE BrwScrollAutoHide( ::hWnd, lAutoHide )

   METHOD ScrollStyle( nStyle ) INLINE BrwScrollStyle ( ::hWnd, nStyle )

   METHOD ScrollHShow( lHScroll ) INLINE ( ::lHscroll := lHscroll, BrwScrollHShow( ::hWnd, ::lHscroll ) )

   METHOD ScrollVShow( lVScroll ) INLINE ( ::lVscroll := lVscroll, BrwScrollVShow( ::hWnd, ::lVscroll ) )

   METHOD ScrollSetGraphite() INLINE ( BrwsSetcrollhGrafite( ::hWnd ), BrwsSetCrollvGrafite( ::hWnd ) )

   METHOD HandleEvent( nMsg, uParam1, uParam2 )

   METHOD SetFont( cFaceName, nSize ) INLINE BrwSetFont( ::hWnd, cFaceName, nSize )

   METHOD SetDblclick() INLINE BrwSetDblAction( ::hWnd )

   METHOD SetSize( nWidth, nHeight ) INLINE BrwSetSize( ::hWnd, nWidth, nHeight )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, bLine, aHeaders, bChange,;
            cAlias, nAutoResize, aSizes, nClrText, nClrBack, cVarName ) CLASS TWBrowse

   local n

   DEFAULT nWidth := 300, nHeight := 100, cAlias := Alias()

   if ! Empty( cAlias )
      ::cAlias = cAlias

      if ValType( cAlias ) == "O"
          ::cAlias = "_DATASET"
           ::oDataSet = cAlias
          ::bLogicLen = { || ::oDataSet:LastRec() }
       else
         ::bLogicLen = { || ( ::cAlias )->( RecCount() ) }
       endif

      DEFAULT bLine := { || ( ::cAlias )->( GetFields() ) }
      DEFAULT aHeaders := ASize( ( ::cAlias )->( GetHeaders( bLine ) ), Len( Eval( bLine ) ) )
   else
      DEFAULT aHeaders := AFill( Array( Len( Eval( bLine ) ) ), "" )
   endif

   oWnd:AddControl( Self )

   DEFAULT cVarName := "oBrw" + ::GetCtrlIndex()
   
   ::cVarName = cVarName

   ::lHscroll = .T.
   ::lVscroll = .T.

   ::hWnd     = BrwCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
   ::oWnd     = oWnd
   ::bLine    = bLine
   ::aHeaders = aHeaders
   ::bChange  = bChange

   for n = 1 to Len( aHeaders )
      AAdd( ::aCols, TBrwColumn():New( BrwAddColumn( ::hWnd, aHeaders[ n ] ), self, aHeaders[ n ] ) )
   next

   if ! Empty( aSizes )
      for n = 1 to Len( aSizes )
         ::SetColWidth( n, aSizes[ n ] )
      next
   endif


  ::SetColor( nClrText, nClrBack )
   
  ::nAutoResize = nAutoResize

 // ::bDrawRect:= { |row| BrwSetGrayColors(::hWnd ,row ) }

return Self

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, bLine, aHeaders, bChange , cAlias ) CLASS TWBrowse

   DEFAULT oWnd := GetWndDefault(), cAlias := Alias()

   ::nId     = nId
   ::oWnd    = oWnd

   if ! Empty( cAlias )
      ::cAlias = cAlias
      if ValType( cAlias ) == "O"
         ::cAlias = "_DATASET"
         ::oDataSet = cAlias
         ::bLogicLen = { || ::oDataSet:LastRec() }
      else
         ::bLogicLen = { || ( ::cAlias )->( RecCount() ) }
      endif

      DEFAULT bLine := { || ( ::cAlias )->( GetFields() ) }
      DEFAULT aHeaders := ASize( ( ::cAlias )->( GetHeaders( bLine ) ), Len( Eval( bLine ) ) )
   else
      DEFAULT aHeaders := AFill( Array( Len( Eval( bLine ) ) ), "" )
   endif

   ::bLine  = bLine
   ::aHeaders = aHeaders
   ::lHscroll:= .t.
   ::lVscroll:= .t.

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TWBrowse

   local hWnd := BrwResCreate( ::oWnd:hWnd, ::nId )

   if hWnd != 0
      ::hWnd = hWnd
   else
      MsgAlert( "Non defined ID " + AllTrim( Str( ::nId ) ) + ;
                " in resource " + ::oWnd:cNibName )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GetValue( nCol, nRow ) CLASS TWBrowse

   local nField
   local cString

   do case
      case ::cAlias == "_EDIT"
            DbGoTop()
            DbSkip( Int( nRow / ( FCount() + 1 ) ) )
             nField = ( nRow + 1 ) % ( FCount() + 1 )
           return If( nField == 0, If( nCol == 0, "-------------", "-------------------------------------" ),;
                    If( nCol == 0, FieldName( nField ), cValToChar( FieldGet( nField ) ) ) )

      case ::cAlias == "_ARRAY"
            if nRow >= 0 .and. nRow < Eval( ::bLogicLen )
               ::nArrayAt = nRow + 1
              return Eval( ::bLine, nRow + 1 )[ nCol + 1 ]
             endif

       case ::cAlias == "_DATASET"
            ::oDataSet:GoTop()
            ::oDataSet:Skip( nRow )
            if nRow >= 0 .and. nRow < Eval( ::bLogicLen )
                 cString = cValToChar( Eval( ::bLine )[ nCol + 1 ] )
                 //LogFile( "info.txt", { nRow, nCol, cString } )
              return cString
             endif

         case ::cAlias == "_INSPECT"
              if ! Empty( ::bGetValue )
                 ::nArrayAt = nRow + 1
                 return Eval( ::bGetValue, nRow, nCol )
              endif

      case ! Empty( ::cAlias )
           if Select( ::cAlias ) == 0
              return Array( Len( ::aCols ) )
           endif
            ( ::cAlias )->( DbGoTop() )
            ( ::cAlias )->( DbSkip( nRow ) )
           return cValToChar( Eval( ::bLine )[ nCol + 1 ] )
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD SetColor( nClrText, nClrBack ) CLASS TWBrowse

if ! Empty( nClrText ) 

  BrwSetTextcolor( ::hWnd, nRgbRed( nClrText ), nRgbGreen( nClrText ),;
                         nRgbBlue( nClrText ), 100 )
endif

if ! Empty( nClrBack ) 

  BrwSetBkcolor( ::hWnd, nRgbRed( nClrBack ), nRgbGreen( nClrBack ),;
                           nRgbBlue( nClrBack ), 100 )
endif    

return nil

//----------------------------------------------------------------------------//

METHOD SetValue( nCol, nRow, oObj ) CLASS TWBrowse

   do case
       case ::cAlias == "_INSPECT"
            if ! Empty( ::bSetValue )
                   return Eval( ::bSetValue, nRow, nCol, NSStringToString( oObj ) )
               endif

         case ::cAlias == "_ARRAY"
            if ! Empty( ::bSetValue )
                  return Eval( ::bSetValue, nRow + 1, nCol + 1, NSStringToString( oObj ) )
               endif
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TWBrowse

   local cCode := CRLF + CRLF + "   @ " + ;
                  AllTrim( Str( ::nTop ) ) + ", " + ;
                  AllTrim( Str( ::nLeft ) ) + " BROWSE " + ::cVarName + ;
                  " OF " + ::oWnd:cVarName + " ;" + CRLF + ;
                  '      FIELDS "";' + CRLF + ;
                  '      HEADERS "Header";' + CRLF + ;
                  "      SIZE " + AllTrim( Str( ::nWidth ) ) + ", " + ;
                                  AllTrim( Str( ::nHeight ) )
   if ::nAutoResize != 0
   		cCode += " AUTORESIZE " + AllTrim( Str( ::nAutoResize ) )
   endif
   							
return cCode

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, hWnd, uParam1, uParam2 ) CLASS TWBrowse

   local oControl := If( hWnd != nil, ::FindControl( hWnd ),)

   do case
      case nMsg == WM_BRWVALUE
           if oControl != nil
                return oControl:GetValue( uParam1, uParam2 )
            else
               MsgInfo( "oControl is nil" )
            endif
            
      case nMsg == WM_MOUSEDOWN
           if ! Empty( oControl:bMouseDown )
              Eval( oControl:bMouseDown, uParam1, uParam2, oControl )
           endif   
            

      otherwise
           return super:HandleEvent( nMsg, uParam1, uParam2 )
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD SetArray( aArray ) CLASS TWBrowse

   ::bLogicLen = { || Len( aArray ) }
   ::cAlias = "_ARRAY"

   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD SetEdit() CLASS TWBrowse

   ::bLogicLen = { || RecCount() * ( FCount() + 1 ) }
   ::cAlias = "_EDIT"

   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD SetColorsForAlternate( nColorIni, nColorEnd ) CLASS TWBrowse

  ::bDrawRect:= { | nRow | BrwSetColorsForalternate( ::hWnd, nRow,;
                  COLORFROMNRGB( nColorIni ), COLORFROMNRGB( nColorEnd ) ) }

return nil

//----------------------------------------------------------------------------//

static function GetFields()

   local aFields := {}, n

   for n = 1 to FCount()
      if FieldType( n ) != "M"
         AAdd( aFields, cValToChar( FieldGet( n ) ) )
      else
         AAdd( aFields, If( Len( FieldGet( n ) ) == 0, "memo", "Memo" ) )
      endif
   next

return aFields

//----------------------------------------------------------------------------//

static function GetHeaders()

   local aHeaders := {}, n

   for n = 1 to FCount()
      AAdd( aHeaders, FieldName( n ) )
   next n

return aHeaders

//----------------------------------------------------------------------------//

CLASS TBrwColumn

   DATA   hWnd
   DATA   cHeader
   DATA   oWnd

   METHOD New( hWnd, cHeader, oWnd )

   METHOD SetHeader( cHeader ) INLINE ::cHeader := cHeader,;
                                      ColSetHeader( ::hWnd, cHeader )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( hWnd, cHeader, oWnd ) CLASS TBrwColumn

   ::hWnd    = hWnd
   ::cHeader = cHeader
   ::oWnd    = oWnd

return self

//----------------------------------------------------------------------------//