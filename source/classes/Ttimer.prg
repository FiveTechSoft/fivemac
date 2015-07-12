
#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TTimer

   DATA   bAction
   DATA   lActive
   DATA   nInterval
   DATA   lRepeat
   DATA   hWnd
   DATA   Cargo
   DATA   hWndOwner

   METHOD New( nInterval, bAction, oWnd,lRepeat, lDeActivate ) CONSTRUCTOR

   METHOD Fire() INLINE TimerFire( ::hWnd ) 

   METHOD End() INLINE ::DeActivate()   

   METHOD Activate() INLINE ( ::lActive:= .t. , ::hWnd := TimerCreate( ::nInterval ,::hWndOwner , ::lRepeat ) )
   
   METHOD DeActivate() INLINE  If( ::lActive , (::lActive:= .f. , TimerEnd( ::hWnd ) ),  )


ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nInterval, bAction, oWnd ,lRepeat ,lDeActivate ) CLASS TTimer

   DEFAULT nInterval := nil , bAction := { || nil }
   DEFAULT lRepeat := .t. 
   DEFAULT lDeActivate := .f.
     
   oWnd:bOnTimer:= bAction
   
   ::hWndOwner := oWnd:hWnd
   
   ::lRepeat := lRepeat 
   ::nInterval:= nInterval
   ::bAction  := bAction
   ::lActive  := .t.
      
   ::Activate()
   
   iF lDeActivate
      ::DeActivate()
   endif

      
return Self

//----------------------------------------------------------------------------//

