#include "FiveMac.ch"
#include "fmsgs.h"

static aNotifications:= {}

Function DeliverNotification( ownd,cTitle, cInfo, cSubTitle, lSound )
  local  oNotifi := TNotification():new(ownd, cTitle, cInfo, cSubTitle ,lSound )
         oNotification:display()
     
Return oNotify


//----------------------------------------------------------------------------//


CLASS TNotification

   DATA  hWnd
 
   METHOD New( ownd,cTitle, cInfo, cSubtitle, lSound  )
   METHOD Display() INLINE NotifyDeliver( ::hWnd )
   METHOD delete()  INLINE NotifyDelete( ::hWnd )
   METHOD SetTitle( cTitle ) INLINE NotifySetTitle ( ::hWnd , cTitle )
   METHOD SetSubTitle( cSubTitle ) INLINE NotifySetSubTitle (::hWnd, cSubTitle )
   METHOD SetInfo( cInfo ) INLINE NotifySetInfo (::hWnd, cInfo )
   METHOD isPresented()    INLINE NotifiIsPresented(::hWnd)
   METHOD shedule( nInterval ) INLINE NotifiInterval( ::hWnd, nInterval )
   METHOD HandleEvent( nMsg, uParam1, uParam2, uParam3 )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( ownd,cTitle, cInfo, cSubtitle, lSound ) CLASS TNotification

   DEFAULT cTitle := "Atención", lSound:= .t.
      
   ::hWnd :=  NotifiCreate(cTitle, cInfo, cSubTitle )
   
    aadd( aNotifications, Self )

   if lSound
         NotifiSound( ::hWnd )
    endif
      
return Self

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, uParam1, uParam2, uParam3 ) CLASS TNotification

do case
    case nMsg == WM_NOTICLICK
      msginfo("click")
    return nil
    
  endcase
    
 return nil
    

 //----------------------------------------------------------------------------//     
    
function _FMN( hWnd, nMsg, hSender, uParam1, uParam2 ,uParam3 )
    
    local oControl   //, nAt := AScan( aNotifications , { | o | o:hWnd == hWnd } )
   // msginfo(hWnd)
  //  msginfo(aNotifications[1]:hwnd )
 //   msginfo(nat)
 //   msginfo(len(aNotifications))
 //   if nAt != 0
        oControl := aNotifications[1]
       if oControl != nil
            return oControl:HandleEvent( nMsg, uParam1, uParam2, uParam3  )
        endif
        // else
        //    MsgInfo( "nAt is zero in FMO" )
   // endif
    
return nil

