#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TRadMenu

   DATA   aItems INIT {}
   DATA   bSetGet, bChange
   DATA   hGroup
   DATA   lUpdate

   METHOD New( nRow, nCol, oWnd, bSetGet, acItems, nWidth, nHeight, lUpdate )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, oWnd, bSetGet, acItems, nWidth, nHeight, lUpdate ) ;
   CLASS TRadMenu

   local n, hGroup := 0, nAt

   DEFAULT oWnd := GetWndDefault(), nWidth := 100, nHeight := 23, lUpdate := .f.

   ::bSetGet = bSetGet
   ::hGroup  = 0
   ::lUpdate = lUpdate

   for n = 1 to Len( acItems )
      AAdd( ::aItems, TRadio():New( nRow, nCol, nWidth, nHeight, oWnd, acItems[ n ],;
                                                   Self, lUpdate ) )
      nRow -= nHeight + 5
   next

   n = Eval( bSetGet )
   if ValType( n ) != "N"
      if ( nAt := AScan( acItems, n ) ) == 0
         n = 1
	  else
	     n = nAt	 
      endif		 
      Eval( bSetGet, n )
   endif

   if n > 0 .and. n <= Len( acItems )
      ::aItems[ n ]:SetCheck( .t. )
   endif

return Self

//----------------------------------------------------------------------------//