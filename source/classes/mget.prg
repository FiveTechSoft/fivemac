#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TMultiGet FROM TControl

   DATA   bChange

   METHOD New( nRow, nCol, nWidth, nHeight, oWnd, bSetGet )

   METHOD Change()

   METHOD LostFocus()

   METHOD SetText( cText ) INLINE TxtSetText( ::hWnd, cText )

   METHOD SetAttributedString( cRTFText ) INLINE TxtSetAttributedString( ::hWnd, cRTFText )

   METHOD GetText() INLINE TxtGetText( ::hWnd )

   METHOD GetRTF() INLINE TxtGetRtf( ::hWnd )
   
   METHOD AddLine( cTxtLine ) INLINE TxtAddLine( ::hWnd, cTxtLine )

   METHOD GoBottom() INLINE TxtGoBottom( ::hWnd )

   METHOD GoTop() INLINE TxtGoTop( ::hWnd )
   
   METHOD KeyDown( nKey ) INLINE If( ::bKeyDown != nil, Eval( ::bKeyDown, nKey ),)
   
   METHOD nRow( nNewRow ) INLINE TxtRow( ::hWnd, nNewRow )

   METHOD nCol( nNewCol ) INLINE TxtCol( ::hWnd, nNewCol )
   
   METHOD SetEditable( lYesNo ) INLINE TxtSetEditable( ::hWnd, lYesNo )
   
   METHOD SetBkColor( nColor ) INLINE TxtSetBkColor( ::hWnd, nColor )
   
   METHOD SetFont( cName, nSize ) INLINE TxtSetFont( ::hWnd, cName, nSize )
   
   METHOD Refresh() INLINE WndRefresh( ::hWnd )
   
   METHOD AddVRuler() INLINE  TxtAddRulerVert( ::hWnd )   
   
   METHOD AddHRuler() INLINE  TxtAddRulerHori( ::hWnd )   

   METHOD SetEditable( lOnOff ) INLINE TxtSetEditable( ::hWnd, lOnOff )

   METHOD SETRichText( lRich ) INLINE TxtSetRichText( ::hWnd, lRich )

   METHOD SetImportGraf( lGraf ) INLINE TxtSetImportGraf( ::hWnd, lGraf )   

   METHOD SetUndo( lUndo ) INLINE TxtSetUndo( ::hWnd, lUndo ) 
   
   METHOD SetUseFindBar( lFindBar ) INLINE TxtUSeFindBar( lFindBar )
   
   METHOD SetIncrementalSearch( lIncremental ) INLINE TxtSetincrementalSearch( lIncremental )   
   
   METHOD SetSpellCheck( lSpell ) INLINE TxtSpellCheck ( lSpell )  
   
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, nWidth, nHeight, oWnd, bSetGet ) CLASS TMultiGet

   DEFAULT oWnd := GetWndDefault(), nWidth := 224, nHeight := 124

   ::hWnd = TxtCreate( nRow, nCol, nWidth, nHeight, oWnd:hWnd )
   ::bSetGet = bSetGet

   oWnd:AddControl( Self )

   ::SetText( Eval( bSetGet ) )

return Self

//----------------------------------------------------------------------------//

METHOD Change() CLASS TMultiGet

   Eval( ::bSetGet, ::GetText() )
   
   if ! Empty( ::bChange ) 
      Eval( ::bChange, Self )
   endif
   
return nil      

//----------------------------------------------------------------------------//

METHOD LostFocus() CLASS TMultiGet

   Eval( ::bSetGet, ::GetText() )

   if ::bValid != nil
      if ! Eval( ::bValid, Self )
         ::SetFocus()
      endif
   endif

   ::oWnd:AEvalWhen()

return nil

//----------------------------------------------------------------------------//