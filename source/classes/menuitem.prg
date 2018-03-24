#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TMenuItem

   DATA   hMenuItem
   DATA   cPrompt
   DATA   oMenu
   DATA   bAction
   DATA   cImage
   
   METHOD New( cPrompt, bAction, cKey, oMenu )
   METHOD GetText() INLINE MnuItemText( ::hMenuItem ) 
   METHOD SetImage(cImage) INLINE MnuItemSetImage( ::hMenuItem,cImage ) 
   METHOD SetONImage(cImage) INLINE MnuItemSetONImage( ::hMenuItem,cImage ) 
   METHOD SetOFFImage(cImage) INLINE MnuItemSetOFFImage( ::hMenuItem,cImage ) 
   METHOD SetTooltip(cText) INLINE MnuItemSetToolTip(::hMenuItem,cText )    
ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( cPrompt, bAction, cKey, oMenu,cImage,cTooltip ) CLASS TMenuItem

   ::cPrompt = cPrompt 
   ::oMenu   = oMenu
   ::bAction = bAction
   ::hMenuItem = MnuAddItem( oMenu:hMenu, cPrompt, cKey )
   
   ::cImage  = cImage
   ::SetImage(cImage)   
   
   if !Empty(cTooltip)
       ::SetTooltip(cTooltip)
   endif
     
return Self   

//----------------------------------------------------------------------------//