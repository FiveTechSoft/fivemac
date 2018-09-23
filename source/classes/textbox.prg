#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TTextbox FROM TControl

   DATA   lPassword ,lseach, bChanged ,cType
   
   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, bSetGet, bValid, lUpdate,;
               lPassword , lSeach,bChanged )
   
   METHOD Redefine( nId, oWnd, bSetGet, lUpdate,bchanged )
   
   METHOD SetText( cText ) INLINE GetSetText( ::hWnd, cText )
   
   METHOD GetText() INLINE GetGetText( ::hWnd )
   
   METHOD Assign() INLINE Eval( ::bSetGet, ::GetText() )
   
   METHOD lValid() INLINE If( ::bValid != nil, Eval( ::bValid ), .T. )
   
   METHOD Initiate()
   
 //  METHOD SetNumeric() INLINE GetSetNumeric( ::hWnd )

   METHOD setFormatter(oFormatter) INLINE GetSetFormatter(::hWnd ,oFormatter:hwnd )

   METHOD tabbusca(bChanged,ownd)
	   
ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, bSetGet, bValid, lUpdate,;
            lPassword,lseach, bChanged, lRounded, cToolTip, nAutoResize,;
            cVarName, cPicture ) CLASS TTextbox

   local cText := Space( 20 )

   DEFAULT nWidth := 120, nHeight := 20, oWnd := GetWndDefault(),;
           bSetGet := bSETGET( cText ), lUpdate := .f., lPassword := .F. , lseach:= .f.


    ::hWnd = GetCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )


   ::lseach  :=  lseach 
   ::lPassword = lPassword
   ::oWnd      = oWnd
   ::bSetGet   = bSetGet
   ::bValid    = bValid
   ::bChanged  = bChanged
   ::lUpdate   = lUpdate
   
   ::cType     = ValType( Eval( bSetGet ) )
   
    if ::cType == "N"
        getsetnumber(::hwnd,cValToChar( Eval( bSetGet ) ))
    else
      ::SetText( cValToChar( Eval( bSetGet ) ) )
    endif

   oWnd:AddControl( Self )
   
return Self

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, bSetGet, lUpdate,bChanged) CLASS TTextBox

   local cText := Space( 20 )

   DEFAULT oWnd := GetWndDefault(), bSetGet := bSETGET( cText ),;
           lUpdate := .F.  
    
   ::nId     = nId
   ::oWnd    = oWnd
   ::bSetGet = bSetGet
   ::lUpdate = lUpdate 
   ::bChanged =bChanged
   
   oWnd:DefControl( Self ) 

return Self

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TTextBox

   super:Initiate()
   ::SetText( cValToChar( Eval( ::bSetGet ) ) )
   
return nil   

//----------------------------------------------------------------------------//
METHOD tabbusca(bChanged,ownd,bSetGet,bValid) CLASS TTextBox

   local cText := Space( 20 )
   
   DEFAULT oWnd := GetWndDefault(),bSetGet := bSETGET( cText ), bChanged := {|| .t. }

	
   ::hWnd = TBRSEARCHCREATE(ownd:hWnd)
   ::bSetGet = bSetGet
   ::bChanged  = bChanged
   ::oWnd      = oWnd   
   ::bValid    = bValid
   
   oWnd:AddControl( Self )
   
return Self
