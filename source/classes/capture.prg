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
   
   METHOD CreateDefaultVideo()	INLINE CreateCapDefDevInputVideo()
   METHOD CreateDefaultAudio()	INLINE CreateCapDefDevInputAudio()
   METHOD CreateDevInput( hDevice )	INLINE ::oDeviceInput  := CreateCapDevInput( hDevice )
   
   METHOD CreateDevOutput(cfile ) INLINE ::oDeviceOutput := CreateCapDevOutput( cfile )
   METHOD SetInputDev()           INLINE AVCaptureSetInput( ::oSession, ::oDeviceInput )
   METHOD SetOutputDev()          INLINE AVCaptureSetOutput( ::oSession, ::oDeviceOutput )
   METHOD SetSession()            INLINE AVCaptureSetSession( ::hWnd, ::oSession  )
   
   METHOD CreateScreenInput()   INLINE ::oDeviceInput  := CreateCapScreenInput()
  
   METHOD SetScreencrop( nTop, nLeft, nWidth, nHeight ) INLINE SetCapScreenCrop( ::oDeviceInput, nTop, nLeft, nWidth, nHeight )
   METHOD SetScreenxFactor( nFactor ) INLINE SetCapScreenFactor( ::oDeviceInput, nFactor )
   METHOD SetScreenlMouseClick( lMouseClick ) INLINE SetCapScreenMouseclick( ::oDeviceInput, lMouseClick )
      
   METHOD setOutFile( cFile ) 
   
   METHOD Start() INLINE CaptureStart( ::oSession, ::oDeviceOutput, ::cFile )
   METHOD Stop()  INLINE CaptureStop( ::oSession, ::oDeviceOutput )
   METHOD PausaResume() INLINE CapturePauseResume( ::oDeviceOutput )
    
     
 // METHOD Redefine( nId, oWnd, cMovie )
 
   METHOD Initiate( cFile, lScreen, lAudio  )
   
      
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

METHOD Initiate( cFile , lScreen, lAudio ) CLASS TCapture
local hDev
DEFAULT lScreen := .f.
DEFAULT lAudio  := .f.

   // configuracion de session
   ::CreateSession()
   if !Empty(::oSession )
      ::SetSession()
   else
      Msginfo( " no se ha podido genera una sesion de captura")
      Return .f.
   endif
   
   // configuracion de Entrada Video
   if lScreen
      ::CreateScreenInput() 
   else
hDev := ::CreateDefaultVideo()
      ::CreateDevInput( hDev )
   endif
   ::SetInputDev()
   
    // configuracion de Entrada Audio
    if lAudio
       hDev := ::CreateDefaultAudio()
      ::CreateDevInput( hDev )
      ::SetInputDev()  
    endif 
   
   
  // configuracion de salida 
  if !Empty( cFile )
   	 if !::SetOutFile( cfile )
      		Msginfo( "no se ha podido asignar el archivo")
   	 endif
     ::SetOutPutDev()     
   EndIf
   
Return nil

