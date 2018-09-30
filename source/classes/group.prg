#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TGroup FROM TControl

  CLASSDATA aProps INIT { "nTop", "nLeft", "nWidth", "nHeight","cText","cVarName",;
                           "aControls","nAutoResize", "lFlipped" }

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cPrompt, nStyle,;
               nAutoResize, cVarName, lFlipped )

   METHOD cGenPrg()

   METHOD LineH( nTop, nLeft, nWidth, oWnd , nAutoResize )

   METHOD LineV( nTop, nLeft, nWidth, oWnd ,nAutoResize )

   METHOD SetText( cText ) INLINE BoxSetTitle( ::hWnd, cText )

   METHOD GetText() INLINE BoxTitle( ::hWnd )

   METHOD SetStyle( nStyle ) INLINE BoxSetStyle( ::hWnd, nStyle )

   METHOD GetStyle() INLINE BoxGetStyle( ::hWnd )

   METHOD Hide() INLINE BoxHide( ::hWnd )

   METHOD Show() INLINE BoxShow( ::hWnd )

   METHOD SetBorderWidth( nWidth ) INLINE BoxSetBorderWidth( ::hWnd, nWidth )

   METHOD SetTitlePosition( nPosition ) INLINE ;
                                        BoxSetTitlePos( ::hWnd, nPosition )
  
   METHOD SetCustom() INLINE BoxSetCustom( ::hWnd )
   METHOD IsCustom() INLINE BoxIsCustom(::hWnd)
   
   METHOD IsLineBorder() INLINE BoxIsLineBorder( ::hWnd )
   METHOD SetBorderType( nType ) INLINE BoxsetBorderType( ::hWnd , nType )
   
   METHOD SetBorderColor( nRed,nGreen,nBlue,nAlfa ) INLINE ;
          if( ( ::isCustom() .and. ::isLineBorder()), BoxSetBorderColor(::hWnd,nRed,nGreen,nBlue,nAlfa) ,  )


    METHOD SetFillColor( nRed,nGreen,nBlue,nAlfa ) INLINE ;
          if( ( ::isCustom() .and. ::isLineBorder()), BoxSetFillColor(::hWnd,nRed,nGreen,nBlue,nAlfa) ,  )

   METHOD SetTrasparent(lTrasparent) INLINE BoxSetTrasparent( ::hWnd , lTrasparent )
   METHOD isTrasparent()             INLINE BoxIsTrasparent( ::hWnd )

 ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cPrompt, nStyle,;
            nAutoResize, cVarName, lFlipped  ) CLASS TGroup

   DEFAULT nWidth := 100, nHeight := 100, oWnd := GetWndDefault(),;
           cPrompt := "Group", nStyle := 1, lFlipped := .F.

   ::hWnd = BoxCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd, cPrompt, nStyle )
   ::oWnd = oWnd
   ::lFlipped = lFlipped

   ::nAutoResize = nAutoResize

   oWnd:AddControl( Self )
   
   DEFAULT cVarName := "oGrp" + ::GetCtrlIndex()
   
   ::cVarName = cVarName

return Self

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TGroup

   local cCode := CRLF + CRLF + "   @ " + ;
                  AllTrim( Str( ::nTop ) ) + ", " + ;
                  AllTrim( Str( ::nLeft ) ) + " GROUP " + ::cVarName + ;
                  ' PROMPT "' + ::GetText() + '" OF ' + ::oWnd:cVarName + ;
                  " ;" + CRLF + "      SIZE " + ;
                  AllTrim( Str( ::nWidth ) ) + ", " + ;
                  AllTrim( Str( ::nHeight ) )

   if ::lFlipped
        cCode += " FLIPPED"
   endif                          

   if ::nAutoResize != 0
      cCode += " AUTORESIZE " + AllTrim( Str( ::nAutoResize ) )
   endif
   
for n = 1 to Len( ::aControls )
     AEval( ::aControls, { | oCtrl | cCode += oCtrl:cGenPrg() } )
next     


return cCode

//----------------------------------------------------------------------------//

METHOD LineH( nTop, nLeft, nWidth, oWnd , nAutoResize ) CLASS TGroup

   DEFAULT nWidth := 100, oWnd := GetWndDefault()
   DEFAULT nAutoResize := 0

   ::hWnd = SeparatorH( nTop, nLeft, nWidth, oWnd:hWnd )
   ::oWnd = oWnd

   ::nAutoResize:= nAutoResize 

   oWnd:AddControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD LineV( nTop, nLeft, nWidth, oWnd , nAutoResize) CLASS TGroup

   DEFAULT nWidth := 100, oWnd := GetWndDefault()
   DEFAULT nAutoResize := 0

   ::hWnd = SeparatorV( nTop, nLeft, nWidth, oWnd:hWnd )
   ::oWnd = oWnd

   ::nAutoresize:= nAutoResize

   oWnd:AddControl( Self )

return Self

//----------------------------------------------------------------------------//
