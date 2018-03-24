#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TLocale 

   METHOD New(cId )
   
   METHOD isMetric() INLINE LocaleMesureIsMetric( ::hWnd )
   METHOD GetMesureSystem() INLINE LocaleGetMesureSystem( ::hWnd )
   METHOD GetPrefId() INLINE LocaleGetPrefID()
   METHOD GetName() INLINE LocaleGetName( ::hWnd )
      
ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( cId ) CLASS TLocale

   if Empty( cid )
      ::hWnd = LocaleCurrent()    
   else
     ::hWnd = LocaleCreateFromID( cId )
   endif  
          
return Self   

//----------------------------------------------------------------------------//
