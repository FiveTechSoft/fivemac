#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TCapture FROM TControl

   DATA cfile
   DATA oSession
   DATA oDeviceInput
   DATA oDeviceOutput
   DATA oOutput

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd )
   METHOD CreateSession() 		  INLINE ::oSession := CreateCapSession()
   METHOD CreateDevInput()		  INLINE ::oDeviceInput  := CreateCapDevInput()
   METHOD CreateDevOutput(cfile ) INLINE ::oDeviceOutput := CreateCapDevOutput( cfile )
   METHOD SetInputDev()           INLINE AVCaptureSetInput( ::oSession, ::oDeviceInput )
   METHOD SetOutputDev()          INLINE AVCaptureSetOutput( ::oSession, ::oDeviceOutput )
   METHOD SetSession()            INLINE AVCaptureSetSession( ::hWnd, ::oSession  )
   
   
   METHOD setOutFile( cFile ) 
   
   METHOD Start() INLINE CaptureStart( ::oSession, ::oDeviceOutput, ::cFile )
   METHOD Stop()  INLINE CaptureStop( ::oSession, ::oDeviceOutput )
   
    
   
 // METHOD Redefine( nId, oWnd, cMovie )
 
   METHOD Initiate( cFile )
   
   
   
ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CLASS TCapture
local cdir
   DEFAULT nWidth := 100, nHeight := 200, oWnd := GetWndDefault()
   
   ::oWnd = oWnd

   ::hWnd = AVCaptureViewCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )

   oWnd:AddControl( Self )
   
return Self

//----------------------------------------------------------------------------//

METHOD SetOutFile( cFile ) CLASS TCapture

   ::cFile := cFile
   
   if file( ::cFile )
      fErase( ::cFile ) 
   endif

   cDir :=  cFilePath( ::cFile )
   if lIsDir( cDir )
      ::CreateDevOutput( ::cFile )
   else
      Msginfo( " El Directorio del archivo no existe")
      Return .f.
   endif
   
Return .t.

//----------------------------------------------------------------------------//

METHOD Initiate( cFile ) CLASS TCapture

   ::CreateSession()
   
   if !Empty(::oSession )
      ::SetSession()
   else
      Msginfo( " no se ha podido genera una sesion de captura")
      Return .f.
   endif
   
   ::CreateDevInput()
   ::setInputDev()
   
   if !::setOutFile( cfile )
       Msginfo( "no se ha podido asignar el archivo")
   endif
       
   ::setOutPutDev()

Return nil