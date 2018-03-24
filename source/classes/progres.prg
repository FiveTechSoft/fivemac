#include "FiveMac.ch"

#define COLORDEFAULT  1
#define COLORBLUE     2 
#define COLORGRAFITE  3
#define COLORCLEAR    4

//----------------------------------------------------------------------------//

CLASS TProgress FROM TControl

   DATA   nMax, nMin, nPos, nStep AS NUMERIC 
   
   CLASSDATA aProps INIT { "nTop", "nLeft", "nWidth", "nHeight", "cVarName",;
                           "nValue", "lIndeterminate", "nAutoResize" }

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, nValue, nAutoResize, cVarName )
   
   METHOD Redefine( nId, oWnd, nPos ) 
   
   METHOD Initiate()
   
   METHOD nValue() INLINE ::nPos
   
   METHOD _nValue( nPos ) INLINE ::Update( nPos )
   
   METHOD lIndeterminate() INLINE ProgressIndeterminate( ::hWnd )
   
   METHOD _lIndeterminate( lOnOff ) INLINE ::SetIndeterminate( lOnOff ) 

   METHOD Update( nPos ) INLINE ( ::nPos := nPos, ProgressUpdate( ::hWnd, nPos ) )
    
   METHOD SetRange( nMin, nMax ) 
   
   METHOD SetStep( nStepInc ) INLINE ( ::nStep:= nStepInc, ProgressIncremen( ::hWnd,::nStep ) )
   
   METHOD SetSpinStyle( lSpinStyle ) INLINE ;
          If( lSpinStyle, ProgressSetSpin( ::hWnd ), ProgressSetBar( ::hWnd ) )

   METHOD GetPos() INLINE ::nPos   
  
   METHOD SetIndeterminate( lIndeterminate ) INLINE ;
          ProgressSetIndeterminate( ::hWnd, lIndeterminate ) 
   
   // METHOD SetBezeled (lBezeled)  INLINE  ProgressSetBezeled(::hWnd,lBezeled)   
   
   // METHOD SetColor(nColor)   
   
   METHOD StartAnime() INLINE ProgressStartAnime( ::hWnd )
   
   METHOD StopAnime() INLINE ProgressStopAnime( ::hWnd )   
   
   METHOD cGenPrg()
       
ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, nValue, nAutoResize, cVarName ) ;
   CLASS TProgress

   DEFAULT nWidth := 100, nHeight := 20, nValue := 30
   
   ::hWnd = ProgressCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd, nValue )

   ::oWnd   = oWnd
   ::nValue = nValue
   
   ::nAutoResize = nAutoResize

   oWnd:AddControl( Self )
   
   DEFAULT cVarName := "oPrg" + ::GetCtrlIndex()
   
   ::cVarName = cVarName
   
return Self  

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, nPos ) CLASS TProgress

   DEFAULT nPos := 0
   DEFAULT oWnd := GetWndDefault()

   ::nId  = nId
   ::oWnd = oWnd
   ::nPos = nPos
     
   oWnd:DefControl( Self )
   
return Self  

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TProgress

   local hWnd := WNDGETIDENTFROMNIB( ::oWnd:hWnd, AllTrim( Str( ::nId ) ) )   
  
   if hWnd != 0 
      ::hWnd = hWnd
   else
      MsgAlert( "Non defined PROGRESS cID " + ;
                AllTrim( Str( ::nId ) ) + ;
                " in resource " + ::oWnd:cNibName )
   endif
    
   ::Update( ::nPos )

return nil

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TProgress

   local cCode := CRLF + CRLF + "   @ " + ;
                  AllTrim( Str( ::nTop ) ) + ", " + ;
                  AllTrim( Str( ::nLeft ) ) + " PROGRESS " + ::cVarName + ;
                  " OF " + ::oWnd:cVarName + ;
                  " ;" + CRLF + ;
                  "      POSITION " + AllTrim( Str( ::nValue() ) ) + ;
                  " SIZE " + ;
                  AllTrim( Str( ::nWidth ) ) + ", " + ;
                  AllTrim( Str( ::nHeight ) )
                  
            if ::nAutoResize != 0                  
   				  	   cCode += " AUTORESIZE " + AllTrim( Str( ::nAutoResize ) )               
   			  	endif       
                                                           
return cCode   

//----------------------------------------------------------------------------//

METHOD SetRange( nMin, nMax ) CLASS TProgress
 
   if ! Empty( nMin ) 
      ::nMin = nMin
      ProgressSetMin( ::hWnd, ::nMin ) 
   endif     

   if ! Empty( nMax ) 
      ::nMax = nMax
      ProgressSetMax( ::hWnd, ::nMax ) 
   endif   
 
return nil

//----------------------------------------------------------------------------//