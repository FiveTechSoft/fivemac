#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TWebview FROM TControl

   DATA cUrl
 
   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cUrlName )

   METHOD GoBack() INLINE WebViewGoBack( ::hWnd )
   
   METHOD GoForward() INLINE WebViewGoForward( ::hWnd )
   
   METHOD SetURL( cUrlName ) INLINE ( ::cUrl := cUrlName , WebViewloadRequest( ::hWnd, ::cUrl ) )
   
   METHOD Stopload()   INLINE WebViewstopLoading( ::hWnd  )
   
   METHOD IsLoading() INLINE WebViewIsLoading( ::hWnd )
   
   METHOD StartSpeaking() INLINE WebViewStartSpeaking( ::hWnd )
 
   METHOD StopSpeaking() INLINE WebViewStopSpeaking( ::hWnd )
       
   METHOD SetTextSize( nPercentage ) INLINE ;
          WebViewsetTextSizeMultiplier( ::hWnd, nPercentage )
   
    METHOD Reload()     INLINE WebViewReload( ::hWnd  )
   
   METHOD Progress() INLINE WebViewProgress( ::hWnd )

   METHOD ScriptCallMethod(cMethod) INLINE WebScripCallMethod(::hWnd,cMethod)

   METHOD ScriptCallMethodArg(cMethod,cArgumento) INLINE WebScripCallMethodArg(::hWnd,cMethod,cArgumento) 
   
   METHOD Redefine( nId, oWnd, cUrlName )
   METHOD Initiate()
   
   

ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cUrlName ) CLASS TWebview

   DEFAULT nWidth := 300, nHeight := 100, oWnd := GetWndDefault()
      
   ::hWnd = WebviewCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
   ::oWnd = oWnd
  
   ::SetURL( cUrlName )
   
   oWnd:AddControl( Self ) 
	    
return Self   

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, cUrlName ) CLASS TWebview

DEFAULT oWnd := GetWndDefault()

::nId     = nId
::oWnd  := oWnd
::cUrl  := cUrlName

oWnd:DefControl( Self )

return Self
//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TWebview

local hWnd:= WNDGETIDENTFROMNIB (::oWnd:hWnd,alltrim(str( ::nId )) )   
if hWnd = -1
    MsgAlert( "Non found WEBVIEW cID " + ;
    AllTrim( Str( ::nId ) ) + ;
    " in resource " + ::oWnd:cNibName )
    return nil
endif 
if hWnd != 0 
    ::hWnd = hWnd
else
    MsgAlert( "Non defined WEBVIEW cID " + ;
    AllTrim( Str( ::nId ) ) + ;
    " in resource " + ::oWnd:cNibName )
endif

::SetURL( ::cUrl )

return nil