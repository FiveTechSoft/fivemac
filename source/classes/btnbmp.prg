#include "FiveMac.ch"

static aLayouts := { "NOIMAGE","ONLYIMAGE","LEFT","RIGHT","BOTTOM","TOP","OVERLAP" }

//----------------------------------------------------------------------------//

CLASS TBtnBmp FROM TControl

   DATA bAction
   DATA __nType INIT 0
   DATA __cFileName INIT ""
   DATA nLayout


   CLASSDATA  aProps INIT { "nTop", "nLeft", "nWidth", "nHeight", "cFileName",;
   	                        "cText", "cVarName", "nAutoResize", "lPressed", "nType" }

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, bAction, cFileName, nStyle,;
               cToolTip, nAutoResize, cVarName, cOnclick, cLayout )
   
   METHOD cGenPrg()
   
   METHOD Click() 
   
   METHOD GetText() INLINE BtnGetText( ::hWnd )

   METHOD _lPressed( lOnOff ) INLINE BtnSetState( ::hWnd, If( lOnOff, 1, 0 ) )
   
   METHOD lPressed() INLINE BtnGetState( ::hWnd ) == 1

   METHOD _nType( nType ) INLINE ::__nType := nType, BtnSetType( ::hWnd, nType )
   
   METHOD nType() INLINE ::__nType
   
   METHOD SetText( cText ) INLINE BtnSetText( ::hWnd, cText )
   
   METHOD _cFileName( cFileName ) INLINE ;
                      ::__cFileName := cFileName, ::SetFileName( cFileName )
   
   METHOD cFileName() INLINE ::__cFileName
   
   METHOD SetFileName( cFileName ) INLINE BtnBmpFile( ::hWnd, cFileName )
   
   METHOD SetBezelStyle( nBezel) INLINE BtnSetBezel( ::hWnd, nBezel ) 
   
   METHOD SetType( nType ) INLINE BtnSetType( ::hWnd, nType )

   METHOD SetBmpPosition( nLayout )
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, bAction, cFileName, nStyle,;
            cToolTip, nAutoResize, cVarName, cOnclick, cLayout ) CLASS TBtnBmp

   DEFAULT nWidth := 50, nHeight := 50, oWnd := GetWndDefault()
   DEFAULT nAutoResize := 0

   ::hWnd    = BtnBmpCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
   ::oWnd    = oWnd
   ::bAction = bAction

    if ! Empty( cOnClick )
      ::SetEventCode( "OnClick", cOnClick )
   endif

   if ! Empty( cFileName )
      ::cFileName = cFileName
   endif   
    
   if ! Empty( nStyle )
  		::SetBezelStyle( nStyle )
   endif 
   
   if ! Empty( cToolTip )
      ::SetToolTip( cToolTip )
   endif
   
   ::nAutoResize = nAutoResize
   
   oWnd:AddControl( Self )
   
   DEFAULT cVarName := "oBtnBmp" + ::GetCtrlIndex()
   
   ::cVarName = cVarName
   ::nLayout   = AScan( aLayouts, cLayout )

   
return Self   

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TBtnBmp

   local cCode := CRLF + CRLF + "   @ " + ;
                  AllTrim( Str( ::nTop ) ) + ", " + ;
                  AllTrim( Str( ::nLeft ) ) + " BTNBMP " + ::cVarName + ;
                  " ;" + CRLF + '      FILENAME "' + ::cFileName + '"' + ;
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

METHOD Click() CLASS TBtnBmp

  // if ! Empty( ::GetEventCode( "OnClick" ) )
  //    Eval( ::GetEventBlock( "OnClick" ), Self )
  // else
      if ::bAction != nil
         if ValType( ::bAction ) == "C"
            Eval( &( "{ | sender | " + ::bAction + " }" ), Self )
         else
            Eval( ::bAction, Self )
         endif
      endif
 //  endif
          
return nil 

//----------------------------------------------------------------------------//

METHOD SetBmpPosition( cLayout ) CLASS TBtnBmp
/*
NSNoImage        = 0,
NSImageOnly      = 1,
NSImageLeft      = 2,
NSImageRight     = 3,
NSImageBelow     = 4,
NSImageAbove     = 5,
NSImageOverlaps  = 6
*/

if Valtype(cLayout) == "N"
   ::nLayout := cLayout
else
   ::nLayout   = AScan( aLayouts, cLayout )
endif

BTNSETIMAGENPOSITION( ::hWnd, ::nLayout )

Return nil

