#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TSplash FROM TControl



   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd,cFileName )
   
   METHOD SetFile( cFileName ) INLINE SplashSetFile( ::hWnd, cFileName )

   METHOD Run() INLINE SplashRun(::hWnd)   
     
ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ,cFileName) CLASS TSplash

   DEFAULT nWidth := 100, nHeight := 100 
   
   
   ::hWnd = SplashCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
   
   ::oWnd  = oWnd
   
   if ! Empty( cFileName ) .and. File( cFileName )
      ::SetFile( cFileName )
   endif   

   oWnd:AddControl( Self )
   
return Self   

//----------------------------------------------------------------------------//

