#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TControl FROM TWindow

   DATA   bSetGet
   DATA   bValid
   DATA   bWhen
   DATA   lUpdate AS LOGICAL
   DATA   nId
   DATA   nClrText, nClrBack 

   DATA   aProps INIT { "nTop", "nLeft", "nWidth", "nHeight", "cText",; 
                        "cVarName", "nAutoResize" }

   DATA   aEvents INIT { { { "OnClick", "nRow", "nCol" }, nil } } 

   METHOD End()
   
   METHOD Change() VIRTUAL
   
   METHOD GenLocals()

   METHOD LostFocus()

   METHOD Initiate()
   
   METHOD _nAutoResize( nStyle ) INLINE ViewSetAutoResize( ::hWnd, nStyle )

   METHOD nAutoResize() INLINE ViewAutoResize( ::hWnd )
     
   METHOD Refresh() INLINE ::SetText( If( ! Empty( ::bSetGet ),;
           cValToChar( Eval( ::bSetGet ) ), ::GetText() ) )

   METHOD SetFocus() INLINE ControlSetFocus( ::hWnd )

   METHOD GoNextCtrl() INLINE GotoNextControl( ::hWnd )
   
   METHOD _nClrText( nClrText ) INLINE ::SetColor( nClrText ) 
   
   METHOD _nClrBack( nClrBack ) INLINE ::SetColor(, nClrBack )
   
   METHOD AddSubview( oChildView ) INLINE ObjAddSubview( ::hWnd, oChildView:hWnd )
   
   METHOD RemoveFromSuperview() INLINE ObjRemoveFromSuperview( ::hWnd )
      
   METHOD SetColor( nClrText, nClrBack ) 
   
   METHOD SetFont( cFaceName, nSize ) INLINE WndSetFont( ::hWnd, cFaceName, nSize )  
      
   METHOD cGenPrg() INLINE "" 
   
   METHOD GetCtrlIndex()  
   
   METHOD SetSize( nWidth, nHeight ) INLINE ViewSetSize( ::hWnd, nWidth, nHeight )
      
ENDCLASS

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TControl

   local hWnd := WndGetControl( ::oWnd:hWnd, ::nId )
   
   if hWnd != 0
      ::hWnd = hWnd
   else
      MsgAlert( "Non defined ID " + ;
                AllTrim( Str( ::nId ) ) + ;
                " in resource " + ::oWnd:cNibName )
   endif
   
return nil                   

//----------------------------------------------------------------------------//

METHOD End() CLASS TControl

   local aControls := ::oWnd:aControls
   local nAt := AScan( aControls, { | o | o:hWnd == ::hWnd } )
   
   if nAt != 0
      ADel( aControls, nAt )
      ASize( aControls, Len( aControls ) - 1 )
      ::oWnd:aControls = aControls
   endif
   
   ViewEnd( ::hWnd )
   ::hWnd = nil
   
return nil      

//----------------------------------------------------------------------------//

METHOD GenLocals() CLASS TControl

   local cLocals := ", " + ::cVarName, n
   
   for n = 1 to Len( ::aControls )
      cLocals += ::aControls[ n ]:GenLocals()
   next
   
return cLocals   

//----------------------------------------------------------------------------//

METHOD GetCtrlIndex() CLASS TControl

   local n, nIndex := 0
   
   for n = 1 to Len( ::oWnd:aControls )
      if ::oWnd:aControls[ n ]:ClassName() == ::ClassName()
         nIndex++
      endif
   next
   
return AllTrim( Str( nIndex ) )         

//----------------------------------------------------------------------------//

METHOD LostFocus() CLASS TControl

   if ::bValid != nil
      if ! Eval( ::bValid, Self )
         ::SetFocus()
      endif
   endif

   ::oWnd:AEvalWhen()

return nil

//----------------------------------------------------------------------------//

METHOD SetColor( nClrText, nClrBack ) CLASS TControl

   if ! Empty( nClrText ) 
      SetTextcolor( ::hWnd, nRgbRed( nClrText ), nRgbGreen( nClrText ),;
                    nRgbBlue( nClrText ), 100 )
   endif
       
   if ! Empty( nClrBack ) 
      SetBkcolor( ::hWnd, nRgbRed( nClrBack ), nRgbGreen( nClrBack ),;
                  nRgbBlue( nClrBack ), 100 )
   endif    
       
return nil

//----------------------------------------------------------------------------// 
