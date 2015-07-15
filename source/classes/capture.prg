#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TCapture FROM TControl

   DATA cfile
   DATA oSession,oOutput

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cPrompt, nStyle )
   METHOD CaptureCam() INLINE  ( ::oSession:= CaptureCam(::hWnd) )
   METHOD setFile(cfile) INLINE ( ::cFile := cfile , ::oOutPut := CaptureFileOutput(::oSession,::cfile), msginfo(22) )
   
   METHOD Start() INLINE CaptureStart( ::oSession  )
   METHOD Stop()  INLINE CaptureStop( ::oSession,::oOutput )
   
 // METHOD Redefine( nId, oWnd, cMovie )
 //  METHOD Initiate()
   
   
   
ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cMovie ) CLASS TCapture

   DEFAULT nWidth := 100, nHeight := 200, oWnd := GetWndDefault()
   
   ::oWnd = oWnd

   ::hWnd = AVCaptureViewCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )

   ::cFile := cMovie

   ::CaptureCam()

    if ! Empty( ::cFile )

       ::setfile(::cFile )   
   endif

   oWnd:AddControl( Self )
   
return Self

//----------------------------------------------------------------------------//
