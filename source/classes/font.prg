#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TFont

   DATA   hWnd
  
   METHOD New( cName, nSize  )
   METHOD GetName() INLINE FontGetName(::hWnd)
   METHOD isVertical() INLINE FontIsVertical(::hWnd)
   METHOD SEtVertical() INLINE ::hWnd:= FontSetVertical(::hWnd)
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cName, nSize ) CLASS TFont
   DEFAULT nsize := 0
   if Empty(cName)
     ::hWnd   = FontGetSystem(nSize)
   else       
     ::hWnd   = Createfont(cName,nSize )
   endif  
return Self

//----------------------------------------------------------------------------//