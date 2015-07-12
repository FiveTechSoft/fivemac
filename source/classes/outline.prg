#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TOutline FROM TControl

   DATA   bAction
   DATA   cTitle
   DATA   hHead
   DATA   oNode

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, lSelected, oNode, bAction,;
               nAutoResize, cTitle )

   METHOD AddItem( cPrompt, cBmp ) INLINE ;
                   TNode():New( cPrompt, .T., ::oNode,,cBmp )

   METHOD AddSeparator() INLINE TNode():New( "Separator", .T., ::oNode )

   METHOD AutoResizeColumn( lResize ) INLINE OutlineAutoResizeColumn( ::hWnd, lResize )

   METHOD Click() INLINE If( ::bAction != nil, Eval( ::bAction, Self ),)

   METHOD DelItem( oItem ) INLINE If( ::oNode:DelItem( oItem ), ::Rebuild(),)

   METHOD ExpandAll() INLINE OutLineExpandAll( ::hWnd )

   METHOD GetRows() INLINE OutlineGetRows( ::hWnd )

   METHOD GetSelect() INLINE ::oNode:GetItem( OutlineGetItem( ::hWnd ) )

   METHOD GetSelectName() INLINE OutlineGetItemName( ::hWnd )

   METHOD GoBottom() INLINE OutlineSetItem( ::hWnd, ::GetRows() - 1 )

   METHOD HideHead() INLINE ::hHide := OutlineSetNoHead( ::hWnd )

   METHOD Initiate()
   
   METHOD ItemAtRow( nRow ) INLINE ::oNode:GetItem( OutlineItemAtRow( ::hWnd, nRow ) )

   METHOD GetItemByName( cName ) INLINE ::oNode:GetItemByName( cName )

   METHOD Refresh() INLINE OutlineRefresh( ::hWnd )

   METHOD RowForItem( oItem ) INLINE OutlineRowForItem( ::hWnd, oItem:hWnd )

   METHOD Select( oItem ) INLINE ::SetSelectItem( ::RowForItem( oItem ) )

   METHOD SelectorStyle( lSelector ) INLINE OutlineSelectorStyle( ::hWnd, lSelector )

   METHOD SetDisclo( lOnOff ) INLINE OutlineSetDisclo( ::hWnd, lOnOff )

   METHOD SetPijama( lPijama ) INLINE OutlineSetAlternateColor( ::hWnd, lPijama )

   METHOD SetRootNode( oNode ) INLINE ( ::oNode := oNode, OutlineSetRootNode( ::hWnd, oNode:hWnd ) )

   METHOD SetTitle( cTitle ) INLINE ( ::cTitle:= cTitle, OutlineSetHeaderTitle( ::hWnd, cTitle ) )

   METHOD ShowHead( lShow ) INLINE ::hHead := OutlineShowHead( ::hWnd, ::hHead, lShow )

   METHOD Rebuild() INLINE ::SetRootNode( ::oNode:Rebuild() )

   METHOD Redefine( nId, oWnd, oNode, bAction )

   METHOD SetColWidth( nWidth ) INLINE OutLineSetColWidth( ::hWnd, nWidth )

   METHOD SetSelectItem( nItem ) INLINE OutLineSetItem( ::hWnd, nItem )

   METHOD SetScrollHShow( lShow ) INLINE OutlineScrollHShow( ::hWnd, lShow )

   METHOD SetScrollVShow( lShow ) INLINE OutlineScrollVShow( ::hWnd, lShow )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, lnoSelected, oNode, bAction,;
            nAutoResize, cTitle ) CLASS Toutline

   DEFAULT nWidth := 100, nHeight := 200, oWnd := GetWndDefault()
   DEFAULT lnoSelected := .f., oNode := TNode():New(), cTitle := "Tree"

   ::hWnd = OutlineCreate( nTop,  nLeft, nWidth, nHeight, oWnd:hWnd, lnoSelected )

   ::cTitle := cTitle

   if ! Empty( oNode )
      ::SetRootNode( oNode )
   endif

   ::SetTitle( cTitle )

   If ! Empty( nAutoResize)
      ::nAutoResize = nAutoResize
   endif

   ::SetColWidth( 100 )

   ::oWnd = oWnd
   ::bAction = bAction

   oWnd:AddControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, oNode, bAction ) CLASS Toutline

   DEFAULT oWnd := GetWndDefault()

   ::nId     = nId
   ::oWnd    = oWnd
   ::bAction = bAction

   if ! Empty(oNode)
      ::oNode = oNode
   endif

   oWnd:DefControl( Self )

return Self


//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TOutline

   local hWnd := CreateOutlineResources( ::oWnd:hWnd, ::nId )

   if hWnd != 0
      ::hWnd = hWnd

      if ! Empty( ::oNode )
       ::SetRootNode(::oNode )
      endif
   else
      MsgAlert( "Non defined ID " + ;
                AllTrim( Str( ::nId ) ) + ;
                " in resource " + ::oWnd:cNibName )
   endif

return nil

//----------------------------------------------------------------------------//