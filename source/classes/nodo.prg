#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TNode

  DATA   hWnd
  DATA   aNodes INIT {}
  DATA   oParent
  DATA   lGroup
  DATA   cName,cBmp
  DATA   Cargo
  
  METHOD New( cName, lGroup , oParent, uCargo ,cBmp ) CONSTRUCTOR
  
  METHOD AddItem( cPrompt, lGroup, oParent, cBmp )
  
  METHOD AddSeparator() INLINE ::AddItem( "Separator" )
    
  METHOD DelItem( oItem )

  METHOD GetItem( hItem )

  METHOD GetItemByName( cName )
  
  METHOD nItems() INLINE Len( ::aNodes )
  
  METHOD PrevItem()
  
  METHOD Rebuild() 
  
  METHOD SetText( cName ) INLINE ::cName := cName, ::Rebuild()
            
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cName, lGroup, oParent, uCargo, cBmp ) CLASS TNode

   ::cName   = cName
   ::cBmp    = cBmp
   ::lGroup  = lGroup
   ::oParent = oParent
   ::Cargo   = uCargo
   
   if oParent != nil   
      AAdd( oParent:aNodes, self )
   endif

return self

//----------------------------------------------------------------------------//

METHOD AddItem( cPrompt, lGroup, oParent, cBmp ) CLASS TNode

   local oNode := TNode():New( cPrompt, lGroup, oParent, ,cBmp )
  
   AAdd( ::aNodes, oNode )
   
return oNode       

//----------------------------------------------------------------------------//

METHOD PrevItem() CLASS TNode

   local nAt := AScan( ::aNodes, { | oNode | oNode == Self } )
   
return If( nAt > 1, ::aNodes[ nAt - 1 ], nil )   

//----------------------------------------------------------------------------//

METHOD DelItem( oItem ) CLASS TNode

   local n
   
   for n = 1 to Len( ::aNodes )
      if ::aNodes[ n ] == oItem
         ADel( ::aNodes, n )
	       ASize( ::aNodes, Len( ::aNodes ) - 1 )
         return .T. 
      else
         if Len( ::aNodes[ n ]:aNodes ) > 0 
            if DelItem( ::aNodes[ n ]:aNodes, oItem )
               return .T.
            endif
         endif      
      endif
   next
   
return .F.

//----------------------------------------------------------------------------//

static function DelItem( aNodes, oItem )

   local n
   
   for n = 1 to Len( aNodes )
      if aNodes[ n ] == oItem
         ADel( aNodes, n )
	       ASize( aNodes, Len( aNodes ) - 1 )
         return .T. 
      else
         if DelItem( aNodes[ n ]:aNodes, oItem )
            return .T.
         endif
      endif
   next
   
return .F.

//----------------------------------------------------------------------------//

METHOD GetItem( hItem ) CLASS TNode

   local n, oItem
   
   for n = 1 to Len( ::aNodes )
      if ::aNodes[ n ]:hWnd == hItem
         return ::aNodes[ n ]
      else
         if Len( ::aNodes[ n ]:aNodes ) > 0 
            if ( oItem := GetItem( ::aNodes[ n ]:aNodes, hItem ) ) != nil
               return oItem
            endif
         endif      
      endif
   next
   
return nil            

//----------------------------------------------------------------------------//

static function GetItem( aNodes, hItem )

   local n, oItem 
   
   for n = 1 to Len( aNodes )
      if aNodes[ n ]:hWnd == hItem
         return aNodes[ n ]
      else
         if ( oItem := GetItem( aNodes[ n ]:aNodes, hItem ) ) != nil
            return oItem
         endif
      endif
   next
   
return nil            

//----------------------------------------------------------------------------//

METHOD GetItemByName( cName ) CLASS TNode

   local n, oItem
   
   for n = 1 to Len( ::aNodes )
      if ::aNodes[ n ]:cName == cName
         return ::aNodes[ n ]
      else
         if Len( ::aNodes[ n ]:aNodes ) > 0 
            if ( oItem := GetItemByName( ::aNodes[ n ]:aNodes, cName ) ) != nil
               return oItem
            endif
         endif      
      endif
   next
   
return nil            

//----------------------------------------------------------------------------//

static function GetItemByName( aNodes, cName )

   local n, oItem 
   
   for n = 1 to Len( aNodes )
      if aNodes[ n ]:cName == cName
         return aNodes[ n ]
      else
         if ( oItem := GetItemByName( aNodes[ n ]:aNodes, cName ) ) != nil
            return oItem
         endif
      endif
   next
   
return nil            

//----------------------------------------------------------------------------//

METHOD Rebuild() CLASS TNode

   local n, aData := ::aNodes
   local hNode := NodeRootCreate()
 
   if Len( aData ) > 0
      for n := 1 to Len( aData )
         RecursioNode( aData[ n ], hNode )
      next
   endif

   ::hWnd = hNode
   
return self

//----------------------------------------------------------------------------//

static function RecursioNode( oNode, hNode )

   local n, aData := oNode:aNodes
   local hNode1 := NodeCreate( hNode, oNode:cName, oNode:lGroup , oNode:cBmp )
   
   oNode:hWnd = hNode1 
 
   if Len( aData ) > 0
      for n := 1 to Len( aData )
         RecursioNode( aData[ n ], hNode1 )
      next
   endif 
     
return nil

//----------------------------------------------------------------------------//