#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TCheckBox FROM TControl

   DATA   bChange
   
   DATA   aEvents INIT { { { "OnClick", "lChecked", "Self" }, nil } } 

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, bSetGet, cPrompt, bChange,;
               lUpdate, nAutoResize, cVarName, cOnClick )
   
   METHOD Redefine( nId, oWnd, bSetGet, bChange, lUpdate )
   
   METHOD Initiate()
   
   METHOD Checked() INLINE ChkGetState( ::hWnd )
   
   METHOD Click()
   
   METHOD GetText() INLINE BtnGetText( ::hWnd )
   
   METHOD SetText( cText ) INLINE BtnSetText( ::hWnd, cText )
   
   METHOD cGenPrg()
   
ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, bSetGet, cPrompt, bChange,;
            lUpdate, nAutoResize, cVarName, cOnClick ) CLASS TCheckBox

   DEFAULT nWidth := 90, nHeight := 30, oWnd := GetWndDefault(),;
           cPrompt := "CheckBox", lUpdate := .F.
 
   ::hWnd    = ChkCreate( nTop, nLeft, nWidth, nHeight, cPrompt, oWnd:hWnd )
   ::oWnd    = oWnd
   ::bSetGet = bSetGet
   ::bChange = bChange
   ::lUpdate = lUpdate

   ChkSetState( ::hWnd, Eval( bSetGet ) )
   
   if ! Empty( cOnClick )
      ::SetEventCode( "OnClick", cOnClick )
   endif
   
   ::nAutoResize = nAutoResize   
   
   oWnd:AddControl( Self )
   
   DEFAULT cVarName := "oChk" + ::GetCtrlIndex()
   
   ::cVarName = cVarName
   
return Self   

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, bSetGet, bChange, lUpdate ) CLASS TCheckBox

   DEFAULT oWnd := GetWndDefault(), lUpdate := .F.
   
   ::nId     = nId
   ::oWnd    = oWnd
   ::bSetGet = bSetGet
   ::bChange = bChange
   ::lUpdate = lUpdate
   
   oWnd:DefControl( Self ) 
     
return Self

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TCheckBox

   local hWnd := ChkResCreate( ::oWnd:hWnd, ::nId )   

   if hWnd != 0
      ::hWnd = hWnd
   else
      MsgAlert( "Non defined ID " + AllTrim( Str( ::nId ) ) + ;
                " in resource " + ::oWnd:cNibName )
   endif

   ChkSetState( ::hWnd, Eval( ::bSetGet ) )

return nil

//----------------------------------------------------------------------------//

METHOD Click() CLASS TCheckBox

 //  if ! Empty( ::GetEventCode( "OnClick" ) )
 //     Eval( ::GetEventBlock( "OnClick" ), ::Checked(), Self )
 //  else
      if ! Empty( ::bChange )
         Eval( ::bChange, ::Checked(), Self )
      endif      
 //  endif   

   if ::bSetGet != nil
      Eval( ::bSetGet, ::Checked() )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TCheckBox

   local cCode := CRLF + CRLF + "   @ " + ;
                  AllTrim( Str( ::nTop ) ) + ", " + ;
                  AllTrim( Str( ::nLeft ) ) + " CHECKBOX " + ::cVarName + ;
                  ' PROMPT "' + ::GetText() + '" OF ' + ::oWnd:cVarName + ;
                  " ;" + CRLF + "      SIZE " + ;
                  AllTrim( Str( ::nWidth ) ) + ", " + ;
                  AllTrim( Str( ::nHeight ) ) 
                  
   local cEventCode := ::GetEventCode( "OnClick" )    
       
   if ! Empty( cEventCode )
      cCode += " ON CLICK " + cEventCode
   endif   
          
   if ::nAutoResize != 0                  
      cCode += " AUTORESIZE " + AllTrim( Str( ::nAutoResize ) )               
   endif               
                              
return cCode     

//----------------------------------------------------------------------------//