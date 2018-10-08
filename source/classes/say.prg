#include "FiveMac.ch"

#define TA_CENTER   2 
#define TA_RIGHT    1 
#define TA_LEFT     0 
     
//----------------------------------------------------------------------------//

CLASS TSay FROM TControl

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cPrompt, lRaised, nAlign,;
               nAutoAjust, cToolTip, cVarName )

   METHOD SetText( cText ) INLINE SaySetText( ::hWnd, cText )

   METHOD GetText() INLINE GetGetText( ::hWnd )

   METHOD SetRaised() INLINE SaySetRaised( ::hWnd )
   
   METHOD SetTextColor( nRed, nGreen, nBlue, nAlfa ) INLINE ;
                           SetTextcolor( ::hWnd, nRed, nGreen, nBlue, nAlfa )

   METHOD SetBkcolor( nRed, nGreen, nBlue, nAlfa ) INLINE ;
                           SetBkcolor( ::hWnd, nRed, nGreen, nBlue, nAlfa )
     
   METHOD SetColor( nClrFore, nClrBack ) 
   
   METHOD SetBezeled( lBezeled, lRound ) INLINE SaySetBezeled( ::hWnd, lBezeled, lRound )  
   
   METHOD SetSizeFont( nSize ) INLINE SaySetSizeFont( ::hWnd, nSize )   
   
   METHOD SetAlign( nAlign ) INLINE SetTextAlign( ::hWnd, nAlign )
   
   METHOD Redefine( nId, oWnd )
   
   METHOD Enabled() INLINE TxtSetEnabled( ::hWnd )  

   METHOD Disabled() INLINE TxtSetDisabled( ::hWnd ) 
   
   METHOD SetFont( cFontName, nSize ) INLINE SaySetFont( ::hWnd, cFontName, nSize )
         
   METHOD cGenPrg()      
         
ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cPrompt, lRaised, cAlign,;
            nAutoAjust, cToolTip, cVarName ,lutf ,cUrl ) CLASS TSay
   
   local nAlign

   DEFAULT nWidth := 90, nHeight := 20, oWnd := GetWndDefault(),;
           cPrompt := "Say", lRaised := .F., cAlign := "TEXTLEFT",;
           nAutoAjust := 0       

   if !Empty(cUrl)
        ::hWnd = SayHiperlinkCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd, cPrompt, cUrl )
   else
        ::hWnd = SayCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd, cPrompt )
        ::SetText( cPrompt )      
  endif
   
      
   ::oWnd = oWnd
   
       
   if lRaised
      ::SetRaised()
   endif  
     
   if Upper( cAlign ) == "TEXTCENTER"
      nAlign = TA_CENTER
      
   elseif Upper( cAlign ) == "TEXTRIGHT"
      nAlign = TA_RIGHT
       
   else
      nAlign = TA_LEFT 
   endif  
  
   ::SetAlign( nAlign ) 

   ::nAutoResize = nAutoAjust
   
   if ! Empty( cToolTip )
      ::SetToolTip( cToolTip )
   endif
     
   oWnd:AddControl( Self )
   
   DEFAULT cVarName := "oSay" + ::GetCtrlIndex()
   
   ::cVarName = cVarName
   
return Self

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd ) CLASS TSay

   DEFAULT  oWnd := GetWndDefault()
  
   ::oWnd = oWnd
   ::nId  = nId
   ::oWnd = oWnd
        
   oWnd:DefControl( Self ) 

return Self

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TSay

   local cCode := CRLF + CRLF + "   @ " + ;
                  AllTrim( Str( ::nTop ) ) + ", " + ;
                  AllTrim( Str( ::nLeft ) ) + " SAY " + ::cVarName + ;
                  ' PROMPT "' + ::GetText() + '" OF ' + ::oWnd:cVarName + ;
                  " ;" + CRLF + "      SIZE " + ;
                  AllTrim( Str( ::nWidth ) ) + ", " + ;
                  AllTrim( Str( ::nHeight ) )
                     
   if ::nAutoResize != 0
      cCode += " AUTORESIZE " + AllTrim( Str( ::nAutoResize ) )
   endif
                              
return cCode                                

//----------------------------------------------------------------------------//
     
METHOD SetColor( nClrFore, nClrBack ) CLASS TSay
     
   if ! Empty( nClrFore ) 
      SetTextcolor( ::hWnd, nRgbRed( nClrFore ), nRgbGreen( nClrFore ),;
                    nRgbBlue( nClrFore ), 100 )
   endif
       
   if ! Empty( nClrBack ) 
      SetBkcolor( ::hWnd, nRgbRed( nClrBack ), nRgbGreen( nClrBack ),;
                  nRgbBlue( nClrBack ), 100 )
   endif    
       
return nil 
  
//----------------------------------------------------------------------------//      