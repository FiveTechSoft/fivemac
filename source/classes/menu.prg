#include "FiveMac.ch"

static oMenu

//----------------------------------------------------------------------------//

CLASS TMenu

   DATA   hMenu
   DATA   aItems
   DATA   lPopup INIT .F.

   METHOD New( cPrompt, lPopup )
   METHOD Activate() INLINE MnuActivate( ::hMenu ) 
   METHOD AddItem( cPrompt, bAction, cKey , cImage , cTooltip )
   METHOD AddSeparator()
   METHOD SetSubMenu( oMenu )
   METHOD Click( hMenuItem )
   
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cPrompt ,lPopup ) CLASS TMenu

   DEFAULT lPopUp := .F.
   
   ::hMenu  = MnuCreate( cPrompt )
   ::aItems = {}
   ::lPopup = lPopUp
   
   if oMenu == nil
      oMenu = Self
   endif   
   
return Self   

//----------------------------------------------------------------------------//

METHOD AddItem( cPrompt, bAction, cKey ,cImage ,cTooltip ) CLASS TMenu

   local oItem := TMenuItem():New( cPrompt, bAction, cKey, Self, cImage ,cTooltip )

   AAdd( ::aItems, oItem )
   
return oItem   

//----------------------------------------------------------------------------//

METHOD AddSeparator() CLASS TMenu

   MnuAddSeparator( ::hMenu )
   AAdd( ::aItems, nil )
   
return nil   

//----------------------------------------------------------------------------//

METHOD SetSubMenu( oMenu ) CLASS TMenu

   MnuAddSubMenu( ::hMenu, oMenu:hMenu, Len( ::aItems ) )
   ATail( ::aItems ):bAction = oMenu
   
return nil

//----------------------------------------------------------------------------//

METHOD Click( hMenuItem ) CLASS TMenu
  
   local oItem := FindItem( Self, hMenuItem )
  
   if oItem != nil .and. ValType( oItem:bAction ) == "B"
      Eval( oItem:bAction, oItem )
   endif

return nil   

//----------------------------------------------------------------------------//

static function FindItem( oMenu, hMenuItem )

   local n, oItem
   
   for n = 1 to Len( oMenu:aItems )
      oItem = oMenu:aItems[ n ]
      if oItem != nil
         if oItem:hMenuItem == hMenuItem
            return oItem
         else
            if ValType( oItem:bAction ) == "O"
	       oItem = FindItem( oItem:bAction, hMenuItem )
	       if oItem != nil
	          return oItem
	       endif
	    endif
         endif
      endif	 
   next
   
return nil   

//----------------------------------------------------------------------------//

function GetMenu()

return oMenu

//----------------------------------------------------------------------------//
