#include "FiveMac.ch"


     
//----------------------------------------------------------------------------//

CLASS TMail 

   DATA hWnd

   METHOD New ( cTo, cSubject , cFrom , cMsg , aATachs )

   METHOD SetTo( cText ) INLINE MailSetTo( ::hWnd, cText )

   METHOD SetSubject(cText) INLINE MailSetSubject( ::hWnd, cText )

   METHOD SetMsg(cText) INLINE MailSetMsg( ::hWnd, cText )

   METHOD SetFrom(cText) INLINE MailSetFrom( ::hWnd, cText )
   
   METHOD AddAttach(cFile) INLINE MailAddAttach(::hWnd,cFile)   
   
   METHOD Send() INLINE MailSend(::hWnd)
        
ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( cTo, cSubject , cFrom , cMsg , aAtachs ) CLASS TMail
   local i  

   ::hWnd = MailCreate()
   
   if !Empty(cTo)
      ::SetTo(cTo)
   endif
     
    if !Empty(cSubject)
      ::SetSubject(cSubject)
   endif
      
   if !Empty(cFrom)
      ::SetFrom(cFrom)
   endif
   
   if !Empty(cMsg)
      ::SetMsg(cMsg)
   endif
      
   if !Empty(aAtachs)
      for i=1 to len(aAtachs)
         ::AddAttach(aAtachs[i])
       next
   endif      
   
return Self

//----------------------------------------------------------------------------//
