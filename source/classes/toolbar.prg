#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TToolBar FROM TControl

   DATA   hWnd
   DATA   oWnd
   DATA   aButtons
   DATA   cStyle
   DATA   aRButtons
     
   CLASSDATA nBar
   
   METHOD New( oWnd , cStyle ,lSmall )
   
   METHOD AddButton( cPrompt, cToolTip, bAction, cImage ,lSelectable )
   METHOD AddRButton( cPrompt, cToolTip, bAction, cImage )   

   METHOD AddControl( oCtrl, cPrompt, cTooltip ) INLINE ;
              AAdd( ::aButtons, oCtrl ),;
              TbrAddControl( ::hWnd, oCtrl:hWnd, cPrompt, cTooltip, Len( ::aButtons ) - 1 )     
     
   METHOD Click( hWndButton )  // A toolbar button has been clicked
   
   METHOD AddSeparator() INLINE  AAdd( ::aButtons, TToolBarBtn():Separator( Self ) )
   METHOD AddSpaceFlex() INLINE  AAdd( ::aButtons, TToolBarBtn():Spaceflex( Self ) )   
   METHOD AddSpace() INLINE  AAdd( ::aButtons, TToolBarBtn():Space( Self ) )  
   METHOD AddPrint() INLINE  AAdd( ::aButtons, TToolBarBtn():Print( Self ) )   

   METHOD AddSearch( cPrompt, cToolTip, bAction )
   
   METHOD AddSegmentedBtn( cPrompt, cToolTip, oSegments )   
      
         
   METHOD GetItem(nAt) INLINE ::aButtons[nAt]
   METHOD SetStyle( cStyle )
   METHOD SetBtnAction( nIndex , bAction ) INLINE ( ::aButtons[nIndex]:bAction := bAction )
   
   METHOD SetBtnSelected( nIndex ) INLINE TbrItemSelected(::hWnd, ::aButtons[nIndex]:hWnd )   
   
   METHOD Redefine( oWnd ,cStyle ) 
   METHOD Initiate() 
   
   METHOD ChangebAction( nAt, bNewAction ) INLINE  ::aButtons[ nAt ]:ChangeAction( bNewAction )
  
   METHOD nHeight() INLINE TbrHeight( ::oWnd:hWnd ) 
       
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, cStyle , lSmall ) CLASS TToolBar

   DEFAULT ::nBar := 1, cStyle := "DEFAULT"
   DEFAULT lSmall := .f.

   ::hWnd = TbrCreate( oWnd:hWnd, AllTrim( Str( ::nBar++ ) ), lSmall )
   ::oWnd = oWnd
   ::aButtons = {}
   ::SetStyle( cStyle )
   
   oWnd:oBar = Self     
   
return Self  
 
//----------------------------------------------------------------------------//

METHOD Redefine( oWnd ,cStyle ) CLASS TToolBar

   DEFAULT oWnd := GetWndDefault(), cStyle := "DEFAULT", ::nBar := 1
     
   ::nBar++
   ::oWnd     = oWnd
   ::cStyle   =  cStyle
   ::aButtons = {}
   ::aRbuttons= {} 
   
    oWnd:DefControl( Self )   
        
return Self

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TToolBar

   local i, nIndex
   local hWnd:= TbrFromWnd(::oWnd:hWnd)
   local baction
   
   if hWnd != 0 
      ::hWnd = hWnd
   else
      MsgAlert( "Non defined TOOLBAR cID " + ;
      AllTrim( Str( ::nId ) ) + " in resource " + ::oWnd:cNibName )
   endif
    
   ::SetStyle( ::cStyle )
   ::oWnd:oBar = Self
    
   for nIndex = 1 to Len( ::aRButtons )
       AAdd( ::aButtons, TToolBarBtn():New( ::aRbuttons[ nIndex, 1 ], ::aRbuttons[ nIndex, 2 ],;
             ::aRbuttons[ nIndex, 3], ::aRbuttons[ nIndex, 4], Self ) )   
   next
    
return nil

//----------------------------------------------------------------------------//

METHOD AddRButton( cPrompt, cToolTip, bAction, cImage ) CLASS TToolBar

   AAdd( ::aRButtons, { cPrompt, cToolTip, bAction, cImage } )
   
return nil 

//----------------------------------------------------------------------------//

METHOD AddButton( cPrompt, cToolTip, bAction, cImage ,lSelectable ) CLASS TToolBar

   local oBtn

   AAdd( ::aButtons, oBtn := TToolBarBtn():New( cPrompt, cToolTip, bAction, cImage, Self,lSelectable ) )
   
return oBtn
   
//----------------------------------------------------------------------------//

METHOD AddSearch( cPrompt, cToolTip, bAction ) CLASS TToolBar

   AAdd( ::aButtons, TToolBarBtn():Search( cPrompt, cToolTip, bAction, Self ) )

return nil 
//----------------------------------------------------------------------------//

METHOD AddSegmentedBtn( cPrompt, cToolTip, oSegments ,nLen ) CLASS TToolBar

   AAdd( ::aButtons, TToolBarBtn():BtnSegments( cPrompt, cToolTip, oSegments, Self ,nLen  ) )
 
return nil    
   
   
//----------------------------------------------------------------------------//

METHOD Click( hWndButton ) CLASS TToolBar

   local nAt := AScan( ::aButtons, { | oBtn | oBtn:hWnd == hWndButton } )
   
   if nAt != 0 .and. ::aButtons[ nAt ]:bAction != nil 
      Eval( ::aButtons[ nAt ]:bAction, ::aButtons[ nAt ], Self )
   endif	   
   
return nil	     

//----------------------------------------------------------------------------//

METHOD SetStyle( cStyle ) CLASS TToolBar 

   ::cStyle := cStyle

   if cStyle == "ICON"
      TbSetModeIco( ::hWnd )
   
   elseif cStyle == "LABEL"
      TbSetModeLabel( ::hWnd )
   
   elseif cStyle == "ICONLABEL"
      TbSetModeIcoLbl( ::hWnd )
   
   elseif cStyle == "DEFAULT"
      TbSetModeDefault( ::hWnd )
   
   endif

return nil

//----------------------------------------------------------------------------//