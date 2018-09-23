#include "FiveMac.ch"

#define   LeftTextAlign       0
#define   RightTextAlign      1
#define   CenterTextAlign     2
#define   JustifiedTextAlign  3
#define   NaturalTextAlign    4

#define   RoundedBezelStyle            1
#define   RegularSquareBezelStyle      2
#define   ThickSquareBezelStyle        3
#define   ThickerSquareBezelStyle      4
#define   DisclosureBezelStyle         5
#define   ShadowlessSquareBezelStyle   6
#define   CircularBezelStyle           7
#define   TexturedSquareBezelStyle     8
#define   HelpButtonBezelStyle         9
#define   SmallSquareBezelStyle        10
#define   TexturedRoundedBezelStyle    11
#define   RoundRectBezelStyle          12
#define   RecessedBezelStyle           13
#define   RoundedDisclosureBezelStyle  14


//  Tipos de boton
/*
   NSMomentaryLightButton   = 0,
   NSPushOnPushOffButton    = 1,
   NSToggleButton           = 2,
   NSSwitchButton           = 3,
   NSRadioButton            = 4,
   NSMomentaryChangeButton  = 5,
   NSOnOffButton            = 6,
   NSMomentaryPushInButton  = 7,
   NSMomentaryPushButton    = 0,
   NSMomentaryLight         = 7
*/


//----------------------------------------------------------------------------//

CLASS TButton FROM TControl

   DATA   bAction

   DATA   nAlignText
   
   METHOD New( nTop, nLeft, nWidth, nHeight, cPrompt, oWnd, bAction, nStyle,;
               nType, cBmp, nAutoResize, cToolTip, cVarName, cOnclick )

   METHOD Redefine( nId, oWnd, bAction )

   METHOD cGenPrg()
   
   METHOD Click() 

   METHOD GetText() INLINE BtnGetText( ::hWnd )

   METHOD SetText( cText ) INLINE BtnSetText( ::hWnd, cText )

   METHOD SetAlignText( nAlignText ) INLINE (::nAlignText := nAlignText ,  BtnAlignText(::hWnd,nAlignText ) )

   METHOD SetBezelStyle( nBezel ) INLINE BtnSetBezel( ::hWnd, nBezel )

   METHOD SetType( nType ) INLINE BtnSetType( ::hWnd, nType )

   METHOD SetSound( cSound ) INLINE BtnSetSound( ::hWnd, cSound )

   METHOD SetDisclotriangle() INLINE  ( ::SetBezelStyle( 5 ), ::SetType( 1 ), ::SetText( "" ) )

   METHOD SetDisclosure() INLINE ( ::SetBezelStyle( 14 ), ::SetType( 1 ), ::SetText( "" ) )

   METHOD Initiate()

   METHOD SetFileName( cFileName ) INLINE BtnBmpFile( ::hWnd, cFileName )

   METHOD SetImage( hImage ) INLINE BtnSetImage( ::hWnd, hImage )

   METHOD SetFocus() INLINE btnSetFocus( ::oWnd:hWnd, ::hWnd )

  METHOD SetDefault() INLINE BTNSETDEFAULT( ::oWnd:hWnd, ::hWnd )



  // METHOD SetFocus() INLINE ::oWnd:SetFocus()

   METHOD Enable() INLINE BtnSetEnabled(::hWnd,.t.)

   METHOD Disable() INLINE BtnSetEnabled(::hWnd,.f.)

   METHOD setBordered( lborder ) INLINE BtnSetBordered( lborder )

   METHOD setTransparent( lTrasparent ) INLINE BtnSetTransparent(::hwnd, lTrasparent )

   METHOD setHighlight( lhighlight) INLINE BtnSetHighLight(::hWnd, lhighlight )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, cPrompt, oWnd, bAction, nStyle,;
            nType, cBmp, nAutoResize, cToolTip, cVarName, cOnclick ) CLASS TButton

   DEFAULT nWidth := 90, nHeight := 30, oWnd := GetWndDefault(),;
           cPrompt := "button", nAutoResize := 0

   ::hWnd = BtnCreate( nTop, nLeft, nWidth, nHeight, cPrompt, oWnd:hWnd )

   if ! Empty( nStyle )
        ::SetBezelStyle( nStyle )
   endif

   if ! Empty( ntype )
        ::SetType( nType )
   endif

   if ! Empty( cBmp )
      ::SetFileName( cBmp )
   endif

   if ! Empty( cTooltip )
      ::SetToolTip( cToolTip )
   endif

   ::oWnd    = oWnd
   ::bAction = bAction
   
   if ! Empty( cOnClick )
      ::SetEventCode( "OnClick", cOnClick )
   endif
   
   ::nAutoResize = nAutoResize
    
   oWnd:AddControl( Self )
   
   DEFAULT cVarName := "oBtn" + ::GetCtrlIndex()
   
   ::cVarName = cVarName
   
return Self

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, bAction ) CLASS TButton

   DEFAULT oWnd := GetWndDefault()

   ::nId     = nId
   ::oWnd    = oWnd
   ::bAction = bAction

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TButton

   local cCode := CRLF + CRLF + "   @ " + ;
                  AllTrim( Str( ::nTop ) ) + ", " + ;
                  AllTrim( Str( ::nLeft ) ) + " BUTTON " + ::cVarName + ;
                  ' PROMPT "' + ::GetText() + '" OF ' + ::oWnd:cVarName + ;
                  " ;" + CRLF + "      SIZE " + ;
                  AllTrim( Str( ::nWidth ) ) + ", " + ;
                  AllTrim( Str( ::nHeight ) ) 
                  
   local cEventCode := ::GetEventCode( "OnClick" )    
       
   if ! Empty( cEventCode )
      cCode += " ACTION " + cEventCode
   endif     
                       
  if ::nAutoResize != 0
      cCode += " AUTORESIZE " + AllTrim( Str( ::nAutoResize ) )
   endif

return cCode

//----------------------------------------------------------------------------//

METHOD Click() CLASS TButton

 //  if ! Empty( ::GetEventCode( "OnClick" ) )
 //     Eval( ::GetEventBlock( "OnClick" ),  Self )
 //  else
 
     IF ::bAction != nil
       if  valtype(::bAction)== "C"
          MsgInfo( ::bAction )
          Eval( &( "{ | sender | " + ::bAction + " }" ), Self )
       else
          Eval( ::bAction, Self )
       endif
     ENDIF
     
 //  endif 
       
return nil  

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TButton

   local hWnd := BtnResCreate( ::oWnd:hWnd, ::nId )

   if hWnd != 0
      ::hWnd = hWnd
   else
      MsgAlert( "Non defined ID " + ;
                AllTrim( Str( ::nId ) ) + ;
                " in resource " + ::oWnd:cNibName )
   endif

return nil

//----------------------------------------------------------------------------//
