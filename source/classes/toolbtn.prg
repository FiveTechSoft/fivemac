#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TToolBarBtn FROM TControl

   DATA  hWnd
   DATA  cPrompt
   DATA  cToolTip
   DATA  bAction
   DATA  cImage
   DATA  oToolBar
   DATA  oSearch
   
   METHOD New( cPrompt, cToolTip, bAction, cImage, oToolBar, lSelectable )
   
   METHOD Separator( oToolBar ) 
   METHOD SpaceFlex( oToolBar )   
   METHOD Space( oToolBar )
   METHOD Search( cPrompt, cToolTip, bAction, oToolBar )
   METHOD BtnSegments( cPrompt, cToolTip, oSegments, oToolBar  )
   METHOD Print( oToolBar )
   
   METHOD ChangeLabel( cPrompt )
   METHOD ChangeTooltip( cTooltip )
   
   METHOD Disable() INLINE TbrItemDisable( ::hWnd )
   METHOD Enable() INLINE TbrItemEnable( ::hWnd )  
   METHOD ChangeLabel( cPrompt )
   METHOD ChangeTooltip( cTooltip )
   METHOD ChangeAction( bAction )
   METHOD Selectable() INLINE TbrItemSelectable(::oToolbar:hWnd,::hWnd)  
   
   METHOD SetSize( nWidth ) INLINE TbrItemSetSize( ::hWnd, nWidth ) 
   
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cPrompt, cToolTip, bAction, cImage, oToolBar,lSelectable ) CLASS TToolBarBtn

   DEFAULT lSelectable:= .f.
   
   ::cPrompt  = cPrompt
   ::cToolTip = cToolTip
   ::bAction  = bAction
   ::cImage   = cImage
   ::oToolBar = oToolBar
   
   ::hWnd     = TbrAddItem( oToolBar:hWnd, cPrompt, Len( oToolBar:aButtons ), cToolTip, cImage )
   if lSelectable
      ::Selectable()
   endif
   
return Self 
        
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

METHOD Separator( oToolBar ) CLASS TToolBarBtn

   ::oToolBar = oToolBar
   ::hWnd     = TbrAddSeparator( oToolBar:hWnd, Len( oToolBar:aButtons ) )
   
return Self    
  
//----------------------------------------------------------------------------//
  
METHOD Print( oToolBar ) CLASS TToolBarBtn

   ::oToolBar = oToolBar
   ::hWnd     = TBRAddPrint( oToolBar:hWnd, Len( oToolBar:aButtons ) )

return nil   

//----------------------------------------------------------------------------//

METHOD SpaceFlex( oToolBar ) CLASS TToolBarBtn

   ::oToolBar = oToolBar
   ::hWnd     = TbrAddSpaceFlex( oToolBar:hWnd, Len( oToolBar:aButtons ) )
   
return Self

//----------------------------------------------------------------------------//

METHOD Space( oToolBar ) CLASS TToolBarBtn

   ::oToolBar = oToolBar
   ::hWnd     = TbrAddSpace( oToolBar:hWnd, Len( oToolBar:aButtons ) )
   
return Self 

//----------------------------------------------------------------------------//

 METHOD Search( cPrompt, cToolTip, bAction, oToolBar  ) CLASS TToolBarBtn
   
   local oSearch
   
   ::oToolBar = oToolBar
   ::bAction  = bAction
   ::oSearch  = TGet():TbrSearch( bAction, oToolbar:oWnd )  
   ::hWnd = TbrAddSearch( oToolBar:hWnd, cPrompt, Len( oToolBar:aButtons ), cToolTip, ::oSearch:hWnd )
       			
return Self	
//----------------------------------------------------------------------------//

 METHOD BtnSegments( cPrompt, cToolTip, oSegments, oToolBar , nLen ) CLASS TToolBarBtn
     
   ::oToolBar = oToolBar
   ::hWnd = TbrAddSegmentedBtn( oToolBar:hWnd, cPrompt, Len( oToolBar:aButtons ), cToolTip, oSegments:hWnd ,nLen )
       			
return Self	


//----------------------------------------------------------------------------//

METHOD ChangeLabel( cPrompt ) CLASS TToolBarBtn
    ::cPrompt :=  cPrompt
    TbrChangeItemLabel(::hWnd,cPrompt )
return nil


//----------------------------------------------------------------------------//

METHOD ChangeTooltip( cTooltip ) CLASS TToolBarBtn
    ::cTooltip :=  cToolTip
    TbrChangeItemTooltip(::hWnd,cTooltip )
return nil

//----------------------------------------------------------------------------//

METHOD ChangeAction( bAction ) CLASS TToolBarBtn
  ::bAction :=  bAction
  if ::oSearch != nil
     ::oSearch:bChanged:= bAction
   endif  
return nil

