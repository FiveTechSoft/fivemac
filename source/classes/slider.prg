#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TSlider FROM TControl

   DATA   bChange
   
   DATA   nValue
   
   DATA   aEvents INIT { { { "OnClick", "nValue", "Self" }, nil } } 

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, Bchange, nValue,;
               nAutoResize, cVarName, cOnclick )
   
   METHOD SetCircular() INLINE CircularSlider( ::hWnd )   
   
   METHOD SetMinMaxValue( nMin, nMax )
   
   METHOD SetTickMarks( nTick )
   
   METHOD Change() 
   
   METHOD GetValue() INLINE ::nValue := GetSliderValue( ::hWnd ), ::nValue
   
   METHOD SetValue( nValue ) INLINE ::nValue := nValue,;
                                    SliderSetValue( ::hWnd, ::nValue )
  
   METHOD Redefine( nId, oWnd, bChange ,nValue ) 

   METHOD Initiate()
   
   METHOD cGenPrg()

ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, bChange, nValue, nAutoResize,;
            cVarName , cOnclick ) CLASS TSlider 

   DEFAULT nWidth := 100, nHeight := 100, nValue := 0
     
   ::hWnd    = SliderCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
   ::nValue  = nValue
   ::oWnd    = oWnd
   ::bChange = bChange
   
   ::nAutoResize = nAutoResize
   
    if !Empty(cOnClick)
       ::aEvents[1 ][ 2] :=  cOnclick
   endif
     
   oWnd:AddControl( Self )
   
   DEFAULT cVarName := "oSld" + ::GetCtrlIndex()
   
   ::cVarName = cVarName
   
return Self   

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, bChange ,nValue ) CLASS TSlider 

   DEFAULT oWnd := GetWndDefault(), nValue:= 0

   ::nId     = nId
   ::oWnd    = oWnd
   ::nValue  = nValue
   ::bChange = bChange

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS  TSlider

   local hWnd := SliderResCreate( ::oWnd:hWnd, ::nId )   

   if hWnd != 0
	    ::hWnd = hWnd
   else
	    MsgAlert( "Non defined SLIDER ID " + AllTrim( Str( ::nId ) ) + ;
			    			" in resource " + ::oWnd:cNibName )
   endif

   ::SetValue( ::nValue )

return nil

//----------------------------------------------------------------------------//

METHOD SetTickMarks( nTick ) CLASS TSlider

   DEFAULT nTick := 25

   SliderSetTickMarks( ::hWnd, nTick )
   
return nil  

//----------------------------------------------------------------------------//

METHOD SetMinMaxValue( nMin, nMax ) CLASS TSlider

   DEFAULT nMin := 1, nMax := 100 

   SliderMinMaxValue( ::hWnd, nMin, nMax )
   
return nil  

//----------------------------------------------------------------------------//

METHOD Change() CLASS TSlider

 //  if ! Empty( ::GetEventCode( "OnClick" ) )
 //     Eval( ::GetEventBlock( "OnClick" ), ::nValue, Self )
 //  else
      if ! Empty( ::bChange )
         Eval( ::bChange, ::nValue, Self )
      endif      
 //  endif   
   
return nil  

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TSlider

   local cCode := CRLF + CRLF + "   @ " + ;
                  AllTrim( Str( ::nTop ) ) + ", " + ;
                  AllTrim( Str( ::nLeft ) ) + " SLIDER " + ::cVarName + ;
                  ' VALUE ' + alltrim(str(::GetValue())) + ' OF ' + ::oWnd:cVarName + ;
                  " ;" + CRLF + "      SIZE " + ;
                  AllTrim( Str( ::nWidth ) ) + ", " + ;
                  AllTrim( Str( ::nHeight ) ) 
                     
   local cEventCode := ::GetEventCode( "OnClick" )    
       
   if ! Empty( cEventCode )
      cCode += " ON CLICK " + cEventCode
   endif   
                     
   if ::nAutoResize != 0                  
      cCode += " AUTORESIZE " + AllTrim( Str( ::nAutoResize ) )               
   endif            
                              
return cCode  

//----------------------------------------------------------------------------//
