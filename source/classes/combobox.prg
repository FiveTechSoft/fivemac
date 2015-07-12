#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TComboBox FROM TControl

   DATA   aItems INIT {}
   
   DATA   bChange

   CLASSDATA aProps INIT { "nTop", "nLeft", "nWidth", "nHeight", "cVarName",;
   	                       "aItems", "nAutoResize" }

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, bSetGet, aItems, bChange,;
               nAutoResize, cVarName )
   
   METHOD Redefine( nId, oWnd, bSetGet, aItems, bChange )
   
   METHOD Add( cItem ) INLINE AAdd( ::aItems, cItem ), ::SetItems( ::aItems )
   
   METHOD GenLocals()
   
   METHOD cGenPrg()
   
   METHOD Change()
   
   METHOD GetText() INLINE BtnGetText( ::hWnd )
   
   METHOD Initiate()

   METHOD Reset() INLINE CbxReset( ::hWnd ), aItems := {}
   
   METHOD Select( nItem ) INLINE ::SetText( ::aItems[ nItem ] )
   
   METHOD SetText( cText ) INLINE BtnSetText( ::hWnd, cText )
   
   METHOD SetItems( aItems )
   
   METHOD SetTitle ( cTitle) INLINE CbxSetTitle( ::hWnd, cTitle )
   
   METHOD SetPullsDown( lPullDown ) INLINE CbxSetPullsDown( ::hWnd, lPullDown )   
   
   METHOD DisableItem( nItem ) INLINE CbxSetItemDisabled( ::hWnd, nItem - 1 )
  
   METHOD EnableItem( nItem ) INLINE CbxSetItemEnabled( ::hWnd, nItem - 1 ) 
   
   METHOD nItemSelected()  INLINE  CbxGetItemSelected(::hWnd)+1
     
ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, bSetGet, aItems, bChange,;
            nAutoResize, cVarName ) CLASS TComboBox

   DEFAULT nWidth := 90, nHeight := 30, oWnd := GetWndDefault()
   DEFAULT nAutoResize := 0
   
   if Eval( bSetGet ) == nil
      Eval( bSetGet, If( Len( aItems ) > 0, aItems[ 1 ], 0 ) )
   endif   

   ::hWnd    = CbxCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
   ::oWnd    = oWnd
   ::bSetGet = bSetGet
   ::bChange = bChange
   
   ::SetItems( aItems )

   ::nAutoResize = nAutoResize

   oWnd:AddControl( Self )
   
   DEFAULT cVarName := "oCbx" + ::GetCtrlIndex()
   
   ::cVarName = cVarName
   
return Self   

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, bSetGet, aItems, bChange ) CLASS TComboBox

   DEFAULT oWnd := GetWndDefault()
   
   if Eval( bSetGet ) == nil
      Eval( bSetGet, aItems[ 1 ] )
   endif
   
   ::nId     = nId
   ::oWnd    = oWnd
   ::bSetGet = bSetGet
   ::aItems  = aItems
   ::bChange = bChange
   
   oWnd:DefControl( Self )
   
return Self      

//----------------------------------------------------------------------------//

METHOD GenLocals() CLASS TComboBox

   local cLocals := ", " + ::cVarName, n 
   
   cLocals += ", " + "aItems" + ::GetCtrlIndex()
   
   if Len( ::aItems ) == 0
      cLocals += " := {}"
   else
      cLocals += " := { " 
      for n = 1 to Len( ::aItems )
         cLocals += '"' + ::aItems[ n ] + If( n < Len( ::aItems ), '", ', '"' )
      next       
      cLocals += " }"
   endif   
   
return cLocals   

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TComboBox

   local cCode := CRLF + CRLF + "@ " + ;
                  AllTrim( Str( ::nTop ) ) + ", " + ;
                  AllTrim( Str( ::nLeft ) ) + " COMBOBOX " + ::cVarName + ;
                  ' ITEMS aItems' + ::GetCtrlIndex() + " OF " + ::oWnd:cVarName + ;
                  " ;" + CRLF + "   SIZE " + AllTrim( Str( ::nWidth ) ) + ", " + ;
                             AllTrim( Str( ::nHeight ) ) + ;
                  ' ON CHANGE MsgInfo( "change" )'    
                         
           if ::nAutoResize != 0                  
   						   cCode += " AUTORESIZE " + AllTrim( Str( ::nAutoResize ) )               
   				 endif   
                              
return cCode                                

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TComboBox

   local hWnd := CbxResCreate( ::oWnd:hWnd, ::nId )   

   if hWnd != 0
      ::hWnd = hWnd
   else
      MsgAlert( "Non defined ID " + AllTrim( Str( ::nId ) ) + ;
                " in resource " + ::oWnd:cNibName )
   endif

   ::SetItems( ::aItems )
   
return nil
   
//----------------------------------------------------------------------------//

METHOD SetItems( aItems ) CLASS TComboBox

   local n
   
   if Len( ::aItems ) > 0
      ::Reset()
   endif   
   
   ::aItems = aItems
   
   for n = 1 to Len( aItems )
      CbxAddItem( ::hWnd, aItems[ n ] )
   next

return nil   

//----------------------------------------------------------------------------//

METHOD Change() CLASS TComboBox

   if ValType( Eval( ::bSetGet ) ) == "N"
      Eval( ::bSetGet, AScan( ::aItems, ::GetText() ) )
   else
      Eval( ::bSetGet, ::GetText() )
   endif
   
   if ::bChange != nil
      Eval( ::bChange, Self )
   endif         

return nil

//----------------------------------------------------------------------------//

 