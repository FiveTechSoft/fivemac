#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TPicture 

   DATA cPicture
  
   METHOD New( cPicture )
   
   METHOD setDateShort()  INLINE if( ::cPicture == "DATE" , FormatterSetDateShort( ::hWnd )  ,) 
   METHOD setDateMedium() INLINE if( ::cPicture == "DATE" , FormatterSetDateMedium( ::hWnd ) ,) 
   METHOD setTimeShort()  INLINE if( ::cPicture == "DATE" , FormatterSetTimeShort( ::hWnd )  ,) 
   METHOD setTimeMedium() INLINE if( ::cPicture == "DATE" , FormatterSetTimeMedium( ::hWnd ) ,) 
   METHOD setCurrency() INLINE if( ::cPicture == "NUMBER" , FormatterSetCurrency( ::hWnd ) ,) 
   
   METHOD setCurrentLocale() INLINE if( ::cPicture == "NUMBER" , FormatterNumericSetLocale( ::hwnd ,LocaleCurrent()) , )
   
   ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( cPicture ) CLASS TPicture

   if Upper(cPicture) == "DATE"
      ::hWnd = FormatterDateCreate()
   elseif Upper(cPicture) == "NUMBER"
      ::hWnd = FormatterNumberCreate()
   elseif Upper(cPicture) == "CURRENCY"
      ::hWnd = FormatterNumberCreate()  
      FormatterSetCurrency(::hWnd)
   else 
      ::hWnd = FormatterCreate()
   endif
   
   ::cPicture = cPicture
          
return Self   

//----------------------------------------------------------------------------//
