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
   METHOD SetImage(cImage)
   METHOD SetONImage(cImage) INLINE MnuItemSetONImage( ::hMenuItem,cImage ) 
   METHOD SetOFFImage(cImage) INLINE MnuItemSetOFFImage( ::hMenuItem,cImage ) 
   METHOD SetTooltip(cText) INLINE MnuItemSetToolTip(::hMenuItem,cText )    
ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( cPrompt, bAction, cKey, oMenu, cImage, cTooltip ) CLASS TMenuItem

local aSize

   ::cPrompt = cPrompt 
   ::oMenu   = oMenu
   ::bAction = bAction
   ::hMenuItem = MnuAddItem( oMenu:hMenu, cPrompt, cKey )

   aSize := ParseSize( @cImage, aSize )

   if !Empty( cImage )
        if !file( cImage )
           if file( ResPath() + "/bitmaps/"+ cImage )
              cImage := ResPath() + "/bitmaps/"+ cImage
            endif
        endif
        ::cImage  = cImage
        ::SetImage( cImage, aSize )

   endif

   if !Empty(cTooltip)
       ::SetTooltip(cTooltip)
   endif
     
return Self   

//----------------------------------------------------------------------------//

METHOD SetImage( cImage, aSize ) CLASS TMenuItem

if Empty ( aSize )
   MnuItemSetImage( ::hMenuItem, cImage )
else
   MnuItemSetImage( ::hMenuItem, cImage , aSize[1] , aSize[2] )
endif

Return nil

//----------------------------------------------------------------------------//

