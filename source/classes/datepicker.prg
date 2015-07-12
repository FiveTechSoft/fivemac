#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TDatePicker FROM TControl

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd )
   
   METHOD GetText() INLINE DatePickGetText( ::hWnd )
   
   METHOD SetDate( cDate ) INLINE DatePickSetText( ::hWnd , cDate )
   
   METHOD GetDate() INLINE  ctod(DatePickGetText( ::hWnd ))
   
   METHOD SetMaxDate( cDate ) INLINE DatePickSetMaxDate( ::hWnd , cDate )
   
   METHOD SetMinDate( cDate ) INLINE DatePickSetMinDate( ::hWnd , cDate )
   
   METHOD SetBezeled( lBezeled ) INLINE DatePickSetBezeled( ::hWnd , lBezeled )   
   
   METHOD SetStyle( nStyle ) INLINE  DatePickSetStyle( ::hWnd , nStyle )  // valores ->0 (texto y stepper) ,1 (calendar),2(texto)   
   
   METHOD SetToDay() INLINE DatePickSetToday(::hWnd)
      
   METHOD SetColor( nClrFore, nClrBack )
   
   METHOD SetDrawBack( ldraw ) INLINE  DatePickSetDrawBack( ::hWnd, ldraw )
      
   METHOD SetClrBack(nRed,nGreen,nBlue,nAlfa) INLINE ( ::SetDrawBack( .t. ) ,DatePickSetBackColor(::hWnd,nRed,nGreen,nBlue,nAlfa) )
   
   METHOD SetClrText(nRed,nGreen,nBlue,nAlfa) INLINE DatePickSetTextColor(::hWnd,nRed,nGreen,nBlue,nAlfa)
   

ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CLASS TDatePicker

   DEFAULT nWidth := 100, nHeight := 100 
      
   ::hWnd = DatePickCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
   ::oWnd = oWnd
   
   oWnd:AddControl( Self )
   
return Self   

//----------------------------------------------------------------------------//
    
METHOD SetColor( nClrFore, nClrBack ) CLASS TDatePicker
     
   if ! Empty( nClrFore ) 
      ::SetClrText( nRgbRed( nClrFore ), nRgbGreen( nClrFore ),;
                    nRgbBlue( nClrFore ),100 )
   endif
       
   if ! Empty( nClrBack ) 
      ::SetClrBack(  nRgbRed( nClrBack ), nRgbGreen( nClrBack ),;
                  nRgbBlue( nClrBack ), 100 )
   endif    
       
return nil 