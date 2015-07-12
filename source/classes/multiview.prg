#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TMultiview FROM TControl

   DATA   aViews
   DATA   oToolbar
   DATA   lwndresize
   DATA   nHeight,nWidth

   METHOD New(  oWnd, lWndResize,  lToolBar )
   METHOD AddView(  nTop, nLeft, nWidth, nHeight, cTitle, cPrompt, cToolTip,cImage )
   
   METHOD AddView( nTop, nLeft, nWidth, nHeight, cTitle, cPrompt, cToolTip, cImage )
   
   METHOD SetView( nButton ) 
      
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, lWndResize, lToolBar ) CLASS TMultiView
   
   local n
   DEFAULT lToolBar:= .t.
   DEFAULT lwndresize:= .t.
   DEFAULT oWnd := GetWndDefault()
   
   ::oWnd:= oWnd
  
   ::nHeight := ::oWnd:nHeight()
   ::nWidth:= ::oWnd:nWidth()
   ::lWndResize := lWndResize  
   if lToolBar
    ::oToolbar:= TToolBar():New( ::oWnd )
   endif
   ::aViews:= {}
   oWnd:AddControl( Self )
   
return Self   

//----------------------------------------------------------------------------//

METHOD AddView(  nTop, nLeft, nWidth, nHeight, cTitle, cPrompt, cToolTip, cImage) CLASS TMultiView

   local oView := TView():New( nTop, nLeft, nWidth, nHeight, ::oWnd ,cTitle )
   local nView, bAction

  aAdd(::aViews, oView )
  nView:=len(::aViews)
  if !Empty(::oToolBar)
   bAction = {|| self:SetView( nView ) }
   oBtn = ::oToolbar:AddButton( cPrompt, cToolTip, bAction,cImage,.t. ) 
  endif
       
return oView

//----------------------------------------------------------------------------//

METHOD SetView( nButton ) CLASS TMultiView

   local i
   local view
   local nWndHeight

   if Len( ::aviews ) > 0
	   
	    for i = 1 to Len( ::aViews )
		     if i == nButton
            view = ::aViews[ i ]
            ::oWnd:SetTitle( ::aViews[i]:cTitle )  
            ::aViews[ i ]:show()
         else
            ::aViews[ i ]:hide()
         endif
	   next
	   
	   if ! Empty( ::oToolBar )
		    if ::lWndResize
	  		   nWndHeight = view:nHeight() + 78
    		   ::oWnd:SetSize( view:nWidth(), nWndHeight )
		    endif	
     endif
     
  endif   
  
return nil

//----------------------------------------------------------------------------//

function MultiAddview( oMulti, nTop, nLeft, nWidth, nHeight, cTitle, cPrompt,;
                       cToolTip, cImage )

   local oView := oMulti:AddView( nTop, nLeft, nWidth, nHeight, cTitle, cPrompt,;
                                  cToolTip, cImage ) 

return oView

//----------------------------------------------------------------------------//