#include "FiveMac.ch"
#include "fmsgs.h"

#define VK_LEFT  63234
#define VK_RIGHT 63235
#define VK_BACK   127
#define VK_DELETE 63272
#define VK_RETURN 13

//----------------------------------------------------------------------------//

CLASS TGet FROM TControl

   DATA   lPassword
   DATA   bChanged
   DATA   lSearch
   DATA   cPicture
   DATA   cType
   DATA   oGet ,cCaption , lFocused , cCuetext
   DATA   nDec, nNumLen
   DATA   bPreValidate
   DATA   nPos
  
   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, bSetGet, bValid, lUpdate,;
               lPassword, lSeach, bChanged, lRounded, cTooltip, nAutoResize,;
               cVarName, cPicture, cCueText, lUtf )

   METHOD Redefine( nId, oWnd, bSetGet, lUpdate, lPassword, lSearch, bChanged,;
                    cPicture )

   METHOD Assign()

   METHOD Change()

   METHOD GenLocals()

   METHOD cGenPrg()

   METHOD Copy() INLINE GetCopySelected( ::hWnd )

   METHOD cText( uVal )

   METHOD Cut() INLINE GetCutSelected( ::hWnd )

   METHOD Disabled() INLINE TxtSetDisabled( ::hWnd )

   METHOD DispText()

   METHOD Enabled() INLINE TxtSetEnabled( ::hWnd )

   METHOD GetDelSel( nStart, nEnd )

   METHOD GetPos() INLINE GetGetPos( ::hWnd )

   METHOD GetSelPos( nStart, nEnd )

   METHOD GetString()

   METHOD GetText() INLINE GetGetText( ::hWnd )

   METHOD GetRTF() INLINE TxtGetRtf( ::hWnd )

   METHOD GoBottom() INLINE TxtGoBottom( ::hWnd )

   METHOD GoHome()

   METHOD GotFocus( hCtlLost )

   METHOD HandleEvent( nMsg, nSender, uParam1, uParam2, uParam3 )

   METHOD Initiate()

   METHOD KeyDown( nKey )

   METHOD SetTextColor( nRed, nBlue, nGreen ) INLINE ;
                        SetTextColor( ::hWnd, nRed, nBlue, nGreen )

   METHOD SetText( cText ) INLINE GetSetText( ::hWnd, cText )

   METHOD lValid()
   
   METHOD LostFocus()

   METHOD SetSizeFont( nSize ) INLINE SaySetSizeFont( ::hWnd, nSize )

   METHOD SetBezelRound( lRound ) INLINE SaySetBezeled( ::hWnd, .T., lRound )

   METHOD TbrSearch( bChanged, oWnd, bSetGet, bValid )
   
   METHOD SetCueBanner( cText ) INLINE GETSETPLACEHOLDER( ::hWnd, cText)

   METHOD SetFocus() INLINE TxtSetFocus( ::oWnd:hWnd, ::hWnd )

   METHOD SetNOSelect() INLINE TxtSetNOSelect( ::hWnd )

    METHOD OpenSheet( cDir ) INLINE  ( ChooseSheetTxt( ::hWnd, cDir ), ::Assign() )

   METHOD SetNumeric() INLINE GetSetNumeric( ::hWnd )

   METHOD SetNumMax( nMax ) INLINE GetSetNumMax( ::hWnd, nMax )
   
   METHOD SetNumFormat( cFormat ) INLINE GetSetNumberFormat( ::hWnd, cFormat )

   METHOD SetNumGroup( cSeparator, nSize ) INLINE ( GetSetGroupUses( ::hWnd ), GetSetGroupSeparator( ::hWnd,cSeparator ), GetSetGroupSize( ::hWnd,nSize  ) )
   
   METHOD SetSel( nStart, nEnd ) INLINE ;
                  nStart := If( nStart == nil, 1, nStart ),;
                  nEnd   := If( nEnd == nil, nStart, nEnd ),;
                  GetSetSelRange( ::hWnd, nStart-1 , nEnd-1 ),;
                  ::nPos := nStart
                  
   METHOD SelectAll() INLINE GetSetSelAll( ::hWnd )
  
   // SetPos() is already used to change the location of a control
   METHOD SetCurPos( nStart ) INLINE ( GetSetSelRange( ::hWnd, nStart - 1, 0 ) , ::oGet:pos := ::nPos := nStart  )
  
   METHOD SetPicture( cPicture ) INLINE ::cPicture := cPicture, GetSetPicture( ::hWnd, cPicture )
   
   METHOD SetValue( cValue )

   METHOD VarPut( uVal ) INLINE  If( ValType( ::bSetGet ) == "B",;
                                    Eval( ::bSetGet, uVal ),)

   METHOD preValidate( cText )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, bSetGet, bValid, lUpdate,;
            lPassword, lSearch, bChanged, lRounded, cToolTip, nAutoResize,;
            cVarName, cPicture, cCueText, lUtf ) CLASS TGet

   local cText := Space( 20 )

   DEFAULT nWidth := 120, nHeight := 20, oWnd := GetWndDefault(), lSearch:= .F. ,;
       bSetGet := bSETGET( cText ), lUpdate := .F., lPassword := .F.,;
       nAutoResize := 0, lRounded := .F.

   if lSearch
      ::hWnd = SearchGetCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
   else
      if ! lPassword
         ::hWnd = GetCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
      else
         ::hWnd = SGetCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
      endif
   endif

   if lRounded
      ::SetBezelRound( .T. )
   endif

   ::cCaption = If( cPicture == nil, cValToChar( Eval( bSetGet ) ), ;
           Transform( Eval( bSetGet ), cPicture ) )
           

   ::oGet      = FWGetNew( 20, 20, bSetGet, cVarName, cPicture )

   ::lSearch   = lSearch
   ::lPassword = lPassword
   ::cCueText  = cCueText
   ::oWnd      = oWnd
   ::bSetGet   = bSetGet
   ::bValid    = bValid
   ::lUpdate   = lUpdate
   ::bChanged  = bChanged
   ::cType     = ValType( Eval( bSetGet ) )

   ::nPos      = 1

   ::oGet:SetFocus()
   ::cCaption = ::oGet:Buffer


   ::oGet:KillFocus()

   if Empty( lUtf )
      lUtf := .f.
   endif

   ::SetText( ::cCaption , lUtf )
   
   // ::SetText( cValToChar( Eval( bSetGet ) ) )


   if ! Empty( cToolTip )
      ::SetToolTip( cToolTip )
   endif

  ::nAutoResize = nAutoResize

   oWnd:AddControl( Self )

   if ! Empty( cPicture )
      ::SetPicture( cPicture )
      ::nNumLen := len( cPicture )
      ::nDec   := Len( AfterAtNum( ".", cPicture ) )
   endif

   DEFAULT cVarName := "oGet" + ::GetCtrlIndex()
   
   ::cVarName = cVarName

return Self

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, bSetGet, lUpdate, lPassword, lSearch, bChanged,;
                 cPicture ) CLASS TGet

   local cText := Space( 20 )

   DEFAULT oWnd := GetWndDefault(), bSetGet := bSETGET( cText ),;
           lUpdate := .F., lSearch := .F., lPassword := .F.

   ::lPassword = lPassword
   ::lsearch   = lsearch
   ::nId       = nId
   ::oWnd      = oWnd
   ::bSetGet   = bSetGet
   ::lUpdate   = lUpdate
   ::bChanged  = bChanged

   oWnd:DefControl( Self )

   if ! Empty( cPicture )
     // ::SetPicture( cPicture )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Change(nkey) CLASS TGet

   ::Assign()
   if ! Empty( ::bChanged )
      Eval( ::bChanged, Self )
   endif
 
return nil

//----------------------------------------------------------------------------//

METHOD GenLocals() CLASS TGet

   local cCode := ", " + ::cVarName

   cCode += ", " + "c" + SubStr( ::cVarName, 2 )

   cCode += " := " + If( ! Empty( ::cText ),;
            'PadR( "' + ::cText + '", 20 )',;
            "Space( 20 )" )

return cCode

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TGet

   local cCode := CRLF + CRLF + "   @ " + ;
                  AllTrim( Str( ::nTop ) ) + ", " + ;
                  AllTrim( Str( ::nLeft ) ) + " GET " + ::cVarName + ;
                  " VAR " + "c" + SubStr( ::cVarName, 2 ) + ;
                  " OF " + ::oWnd:cVarName + ;
                  " ;" + CRLF + "      SIZE " + ;
                  AllTrim( Str( ::nWidth ) ) + ", " + ;
                  AllTrim( Str( ::nHeight ) )
                  
   if ::nAutoResize != 0
      cCode += " AUTORESIZE " + AllTrim( Str( ::nAutoResize ) )
   endif

return cCode


//----------------------------------------------------------------------------//

METHOD lValid() CLASS TGet
    
    local lRet := .t.
    
 //   if ::oGet:BadDate
 //       ::oGet:KillFocus()
 //       ::oGet:SetFocus()
 //       MsgBeep()
 //       return .f.
  //  else
        if ValType( ::bValid ) == "B"
            lRet := Eval( ::bValid, Self  )
        endif
  //  endif
   
return lRet

//----------------------------------------------------------------------------//

METHOD GetSel() CLASS TGet


local nStart := GetGetPos( ::hWnd ) + 1
local nEnd   := GetGetEndSelPos( ::hWnd ) + 1

return If( nStart != nEnd, SubStr( ::cText, nStart + 1, nEnd - nStart ), "" )


//----------------------------------------------------------------------------//

METHOD GetDelSel( nStart, nEnd ) CLASS TGet
    
      //----- seleciona y borra .......
  ::SetSel( nStart, nEnd )
   GetDelSelected( ::hWnd )
      
 //------ objecto oget
      
 ::oGet:buffer = Left( ::oGet:buffer, Min( nEnd, nStart ) ) ;
      + Right( ::oGet:buffer, ;
              Len( ::oGet:buffer ) - Max( nEnd, nStart ) ) ;
              + Space( Abs( nStart - nEnd ) )
              
 ::oGet:Assign()

  if ::oGet:Type $ "DN"
     ::oGet:KillFocus()
     ::oGet:SetFocus()
  endif

::oGet:Reset()
::nPos := ::oGet:pos := Min( nStart, nEnd ) + 1

       
Return nil
  
//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TGet

   local hWnd

   if ::lSearch
      hWnd = SearchGetResCreate( ::oWnd:hWnd, ::nId )
   else
      if ::lPassword
         hWnd = SGetResCreate( ::oWnd:hWnd, ::nId )
      else
         hWnd = GetResCreate( ::oWnd:hWnd, ::nId )
      endif
   endif

   if hWnd != 0
       ::hWnd = hWnd
   else
       MsgAlert( "Non defined GET ID " + AllTrim( Str( ::nId ) ) + ;
                 " in resource " + ::oWnd:cNibName )
   endif

   ::SetText( cValToChar( Eval( ::bSetGet ) ) )

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, uParam1, uParam2, uParam3 ) CLASS TGet

   do case
      case nMsg == WM_GETVALID
           ::Assign()
           return ::lValid()

      case nMsg == WM_GETCHANGED
           return ::Change(uParam1 )

      case nMsg == WM_KEYDOWN
           return ::KeyDown( uParam1 )

      case nMsg == WM_WHEN
          ::GotFocus()
          return ::lWhen()

      case nMsg == WM_GETGETSTRING
           return ::GetString()

      case nMsg == WM_GETSETVALUE
           return ::SetValue( uParam1 )

      case nMsg == WM_GETPARTEVALUE
            return  ::prevalidate( uParam1 )

      case nMsg == WM_GETLOSTFOCUS

           ::Assign()
           return ::lvalid()

   endcase

return Super:HandleEvent( nMsg, uParam1, uParam2, uParam3 )

//----------------------------------------------------------------------------//


METHOD GotFocus( hCtlLost ) CLASS TGet

 ::lFocused = .T.
if ! Empty( ::cPicture ) .and. ::oGet:Type == "N"
    ::oGet:Picture := StrTran( ::cPicture, ",", "" )
endif

::SetCurPos( 1 )


return 0

//----------------------------------------------------------------------------//

METHOD Assign() CLASS TGet
    
  local buffer := ::GetText()

  ::oGet:Buffer := buffer
  
  ::oGet:Assign()
 
  if ::cType == "N"
     buffer = val( buffer )
  Endif
  Eval( ::bSetGet, buffer )

Return nil

//----------------------------------------------------------------------------//

METHOD cText( uVal ) CLASS TGet

local cWindowText

if PCount() == 1
::oGet:VarPut( uVal )
::Refresh()
endif

cWindowText := GetWindowText( ::hWnd )

return If( ! Empty( ::cCueText ) .and. cWindowText == "", ::oGet:buffer, cWindowText )

//----------------------------------------------------------------------------//

METHOD LostFocus() CLASS TGet

    if ::oGet:buffer != GetWindowText( ::hWnd )  // right click popup action
       ::oGet:buffer  = GetWindowText( ::hWnd )
       ::oGet:Assign()
    endif
   
    
    if ! Empty( ::cPicture ) .and. ::oGet:Type == "N"
        ::oGet:Assign()
        ::oGet:Picture := ::cPicture
        ::oGet:UpdateBuffer()
        ::oGet:KillFocus()
    endif
    
    ::oGet:SetFocus()   // to avoid oGet:buffer be nil
    
    if ! ::oGet:BadDate .and. ;
        ( ::oGet:changed .or. ::oGet:unTransform() <> ::oGet:original )
        ::oGet:Assign()     // for adjust numbers
        // ::oGet:UpdateBuffer()
    endif
    
    
    if ::oGet:Type == "D"
        ::oGet:KillFocus()
        ::oGet:SetFocus()
    endif
    ::DispText()
    
    if ! ::oGet:BadDate
        ::oGet:KillFocus()
        else
        ::oGet:Pos = 1
       // ::nPos = 1
    endif
    
return nil





//----------------------------------------------------------------------------//

METHOD DispText() CLASS TGet

  //   SetWindowText( ::hWnd, If( Empty( ::oGet:VarGet() ),"", ::oGet:buffer ) )

return nil

//----------------------------------------------------------------------------//

METHOD prevalidate( cText ) CLASS TGet
    
    local buffer := .f.

    if !Empty( ::bPreValidate )
        buffer := Eval( ::bPreValidate , cText, Self )
    else
        if ::cType == "N"
            buffer := NumValidate( cText )
        endif

        if ::cType == "D"
            buffer := cDateValidate( cText )
            ::oGet:Setfocus()
            ::oGet:Buffer := buffer
          
        endif
        
    endif
    
return buffer

//----------------------------------------------------------------------------//

Static Function NumValidate( cText )
   local lTrue := .t.
   
   if len( hb_aTokens( cText , ".") ) > 2
      Return .f.
   endif
   
   for nFor := 1 TO Len( cText )
       if hb_asciiUpper( SubStr( cText, nFor, 1 ) ) $  "1234567890."
          lTrue := .t.
        else
           lTrue := .f.
           exit
        endif
    next
   
 Return lTrue

//----------------------------------------------------------------------------//

Static Function cDateValidate( cText )
    
    local xValue := ""
    local nFor

for nFor := 1 TO 10
    if nFor= 1
       if hb_asciiUpper( SubStr( cText, nFor, 1 ) ) $ "0123"
            xValue += SubStr( cText, nFor, 1 )
       else
            if hb_asciiUpper( SubStr( cText, nFor, 1 ) ) $ "456789"
                xValue += "0"+SubStr( cText, nFor, 1 )
                nFor++
            endif
        endif
    elseif nFor == 2
        if  hb_asciiUpper( SubStr( cText, nFor, 1 )) $ "/-"
            xValue = "0"+xValue+"/"
            nFor++
        else
            if hb_asciiUpper( SubStr( cText, nFor, 1 ) ) $ "1234567890"
                xValue += SubStr( cText, nFor, 1 )
            endif
        endif
    elseif nFor == 3
        if hb_asciiUpper( SubStr( cText, nFor, 1 ) ) $ "/-"
            xValue += SubStr( cText, nFor, 1 )
        endif
    elseif nFor == 4
        if hb_asciiUpper( SubStr( cText, nFor, 1 ) ) $ "01"
            xValue += SubStr( cText, nFor, 1 )
        else
            if hb_asciiUpper( SubStr( cText, nFor, 1 ) ) $ "23456789"
                xValue += "0"+SubStr( cText, nFor, 1 )
                nFor++
            endif

        endif

    elseif nFor == 5

        if  hb_asciiUpper( SubStr( cText, nFor, 1 )) $ "/-"
            xValue = Substr(xValue,1,nFor-2)+"0"+SubStr( cText, nFor-1, 1 )+"/"
            nFor++
        elseif hb_asciiUpper( SubStr( cText, nFor-1, 1 )) $ "1"
            if hb_asciiUpper( SubStr( cText, nFor, 1 ) ) $ "120"
                xValue += SubStr( cText, nFor, 1 )
            endif

        else
            if hb_asciiUpper( SubStr( cText, nFor, 1 ) ) $ "1234567890"
                xValue += SubStr( cText, nFor, 1 )
            endif
        endif

    elseif nFor == 6

        if hb_asciiUpper( SubStr( cText, nFor, 1 ) ) $ "/-"
            xValue += SubStr( cText, nFor, 1 )
        endif

    else

        if hb_asciiUpper( SubStr( cText, nFor, 1 ) ) $ "1234567890"
            xValue += SubStr( cText, nFor, 1 )
        endif
    endif

next

Return xValue

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey ) CLASS TGet

// MsgInfo( nkey )

   if ! Empty( ::bKeyDown )
      return Eval( ::bKeyDown, nKey, Self )
   endif

   do case
      case nKey == VK_LEFT
           // MsgInfo( "left" )
           
      case nKey == VK_RIGHT
           // MsgInfo( "right" )

       CASE nkey == 63232 // flecha arriba
       CASE nkey == 63233 // flecha abajo
       Case nkey == 13

otherwise

      endcase

return nil

//----------------------------------------------------------------------------//

METHOD SetValue( cValue ) CLASS TGet

if ::ctype == "N"
   Eval( ::bSetGet,  cValue )
elseif ::ctype == "D"
    Eval( ::bSetGet,  cValue )
else
    if Empty( ::cPicture )
        Eval( ::bSetGet,  cValue )
    else
        Eval( ::bSetGet, UnTransform( cValue, ::cPicture, ::cType ) )
    endif
endif

//::oGet:Varput( cValue )

return cValue

//----------------------------------------------------------------------------//

METHOD TbrSearch( bChanged, oWnd, bSetGet, bValid ) CLASS TGet

   local cText := Space( 20 )

   DEFAULT oWnd := GetWndDefault(), bSetGet := bSETGET( cText ),;
           bChanged := {|| .T. }

   ::hWnd     = TBrSearchCreate(ownd:hWnd)
   ::bSetGet  = bSetGet
   ::bChanged = bChanged
   ::oWnd     = oWnd
   ::bValid   = bValid
   ::oGet     = FWGetNew( 20, 20, bSetGet, "search" )

   oWnd:AddControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD GetString( ) CLASS TGet

local xValue := "" //:= Transform( Eval( ::bSetGet ), ::cPicture )
local buffer
local cPicture
local nAt := 0
local npos
local cInt
local nNumlen := 0
local nFor


if ::cType == "N"
   
    buffer:= Eval( ::bSetGet )

    if hb_isNumeric( buffer)
         buffer = Transform( buffer, ::cPicture )
    else
        // ------ si tiene picture
         if !Empty( ::cPicture )
    
             nNumlen := hb_at( ".", ::cPicture )
             if nNumlen == 0
                //  picture sin decimales
                nNumlen := len( ::cpicture )
                if len( buffer ) > nNumLen
                    buffer := SUBSTR(buffer, 1,LEN(buffer)-1)
                endif
              
             else
                // picture con decimales
                nAt := hb_at( ".",buffer )
                if nAt == 0
                    // escribe parte entera
                    if len( buffer ) > nNumLen - 1
                       buffer := SUBSTR(buffer, 1,LEN(buffer)-1)  // si se pasa recorta
                    endif
                else
                   // se ha puesto un punto
                   if nAt > 0
                       // mira que no exceda digitis decimales
                       IF LEN( substr( buffer, nat ) ) > ::nDec+1
                           buffer := SUBSTR(buffer, 1,LEN(buffer)-1)
                        endif
                 
                    endif
                    
            
                 endif
               
             endif
         ENDIF
        
   
  
     endif
    
     xValue :=  buffer
   if val( xValue) == 0
      // xValue := "0"
       ::setcurpos(1)
       ::setsel(1,2)
    endif
    Return xValue
else

   if ::cType == "D"
      buffer = Eval( ::bSetGet )
      if hb_isDate( buffer)
           buffer = Transform( buffer, ::cPicture )
      endif
      xValue:=  buffer

   else
     xValue:= Transform( Eval( ::bSetGet ), ::cPicture )
   endif
endif

Return xValue

//----------------------------------------------------------------------------//

function UnTransform( cValue, cPicture, cType )

   local xValue, nFor

   do case
      case cType == "C"
           if "R" $ cPicture
              xValue = ""
              for nFor := 1 TO Len( cPicture )
                 if hb_asciiUpper( SubStr( cPicture, nFor, 1 ) ) $ "ANX9#!LY"
                    xValue += SubStr( cValue, nFor, 1 )
                 endif
              next
           else
              xValue = cValue
           endif
                           
      case cType == "N"
          //  msginfo("no"+cValue)
          if "E" $ cPicture
              cValue = StrTran( cValue, ".", "" )
              cValue = StrTran( cValue, ",", "." )
          else
              cValue = StrTran( cValue, ",", "" )
          endif

          xValue = Val( cValue )

      case cType == "D"
           if "E" $ cPicture
              cValue = SubStr( cValue, 4, 3 ) + SubStr( cValue, 1, 3 ) + SubStr( cValue, 7 )
           endif
           if ! Empty( CToD( cValue ) )
              xValue = CToD( cValue )
           else
              if len(cValue) >= 8
                  xValue = ""
                  msginfo("fecha no valida")
              else
                 xValue =  cValue
              endif
           endif

           
      case cType == "L"
           cValue = Upper( cValue )
           xValue = "T" $ cValue .or. ;
                    "Y" $ cValue .or. ;
                    hb_LangMessage( HB_LANG_ITEM_BASE_TEXT + 1 ) $ cValue
                    
      case cType == "T"
           xValue = hb_CToT( cValue )
                               
   endcase
   
return xValue

//----------------------------------------------------------------------------//

METHOD GetSelPos( nStart, nEnd ) CLASS TGet

nStart  :=  GetGetPos(::hWnd )+1
nEnd    :=  GetGetEndSelPos(::hWnd )+1

return nil

//----------------------------------------------------------------------------//

Static Function GetWindowText( hWnd )
Return GetGetText( hWnd )

//----------------------------------------------------------------------------//

Static Function SetWindowText( hWnd, cText, lUtf )
     GetSetText( hWnd, cText, Iif( Empty(lUtf), .f. , lUtf )  )
Return nil

//----------------------------------------------------------------------------//

static function LastDay( dDate )

    local nMonth := Month( dDate )

    while Month( dDate ) == nMonth
        dDate++
    end

    dDate--

return Day( dDate )

//----------------------------------------------------------------------------//

METHOD GoHome() CLASS TGet

::oGet:Home()
if ::oGet:Type == "N"
   ::oGet:Clear := .t.
endif

::SetCurPos( 1 )

return Self


//----------------------------------------------------------------------------//

Function MsgGet( cTitle, cSay , cline  )

local oDlg, oGet
local lYes:= .f.
local backcLine
local cTipo:= "C"

DEFAULT cLine := ""

backcline:= cLine

cTipo:= valtype ( cLine )

if cTipo  == "C"
   cLine:= cLine+space(40)
endif

DEFINE DIALOG oDlg TITLE cTitle ;
FROM 220, 350 TO 340, 680

@ 88, 50 SAY cSay OF oDlg SIZE 250, 17

@ 62, 50 GET oGet VAR cLine OF oDlg SIZE 250, 22

@ 20, 218 BUTTON "OK" OF oDlg ACTION ( lYes:= .t., oDlg:End() )
@ 20, 118 BUTTON "Cancel" OF oDlg ACTION  oDlg:End()

ACTIVATE DIALOG oDlg CENTERED


if lYes
  cLine := oget:getText()
  if cTipo == "N"
      cline:=val(cline)
   else
      cline:= alltrim( cLine )
    endif
    Return .t.
else
    cline:= backcLine
    return .f.
endif


return .t.

//----------------------------------------------------------------------------//

Function AfterAtNum( cChar, cStr )
    local nAt := hb_at( cChar, cStr )
local cRest := ""
    if nAt > 0
       cRest :=  substr( cStr, nAt + 1 )
      
    endif
Return cRest

