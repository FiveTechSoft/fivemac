#include "FiveMac.ch"

CLASS NSObject

   DATA   hObj
   
   METHOD New( cClassName )
   
   METHOD SendMsg( cMsg, uValue ) INLINE ObjC_ObjSendMsg( ::hObj, cMsg, uValue )
   
   METHOD GetClassName() INLINE ObjC_GetClassName( ::hObj )

   METHOD GetInstanceVariable( cVarName ) INLINE ObjC_GetInstanceVariable( ::hObj, cVarName )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cClassName ) CLASS NSObject

   ::hObj = ObjC_ObjInstantiate( cClassName )
   
return Self

//----------------------------------------------------------------------------//      