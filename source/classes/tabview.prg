#include "FiveMac.ch"
                                          
//----------------------------------------------------------------------------//

CLASS TTabs FROM TControl
   
   DATA   nTab INIT 1
   DATA   bChange
   DATA   aDialogs INIT {}
   
   DATA  aEvents INIT { { { "OnChange", "nRow", "nCol" }, nil } }   
   
   CLASSDATA aProps INIT { "nTop", "nLeft", "nWidth", "nHeight", "cVarName",;
                           "aControls", "nAutoResize", "lFlipped","nTab" }
                           
   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, aTabs, bChange, nAutoResize,;
               cVarName, lFlipped )

   METHOD Redefine( nId, oWnd, bChange ) 
   
   METHOD Initiate() 
   
   METHOD AddTab( cText ) INLINE aAdd( ::aDialogs , TTabItem():New( self, cText ) )
   
   METHOD Type( nType ) INLINE TabViewSettype( ::hwnd, nType ) 

   METHOD cGenPrg()
   
   METHOD Change( nTabSelected ) 

   METHOD ArrayToTabs( aPrompts )
   METHOD TabsToArray() 
   METHOD TabsToText()
   
   METHOD GetItem( nItem ) INLINE ::aControls[ nItem ]
      
   METHOD SetItemText( nItem, cText ) INLINE  ::aControls[ nItem ]:SetText( cText )   
   
   METHOD SetItemSelected( nItem ) INLINE ( ::Change( nItem ),;
                                   TabViewSetSelectedItem( ::hWnd, nItem - 1 ) )

   METHOD SetVarName( cVarName )

ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, aTabs, bChange, nAutoResize,;
            cVarName, lFlipped , cOnChange ) CLASS TTabs

   DEFAULT nWidth := 90, nHeight := 20, oWnd := GetWndDefault()
   DEFAULT aTabs := {}, lFlipped := .F.
            
   ::hWnd     = TabViewCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )
   ::oWnd     = oWnd
   ::bChange  = bChange
   ::lFlipped = lFlipped
    
   oWnd:AddControl( Self )

   DEFAULT cVarName := "oTabs" + ::GetCtrlIndex()
   
   ::cVarName = cVarName

   if Len( aTabs ) > 0
      AEval( aTabs, { | cTab | ::AddTab( cTab ) } )       
   endif 
   
    if ! Empty( cOnChange )
      ::SetEventCode( "OnChange", cOnChange )
   endif
 
   ::nAutoResize = nAutoResize 
      
return Self

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, bChange ) CLASS TTabs

   DEFAULT oWnd := GetWndDefault()

   ::nId     = nId
   ::oWnd    = oWnd
   ::bChange = bChange
      
   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TTabs

   local n, hWnd := WndGetIdentFromNib( ::oWnd:hWnd, AllTrim( Str( ::nId ) ) )   
   
   if hWnd = -1
      MsgAlert( "Non found TABS cID " + ;
                AllTrim( Str( ::nId ) ) + ;
                " in resource " + ::oWnd:cNibName )
      return nil
   endif 
   
   if hWnd != 0 
      ::hWnd = hWnd
   else
      MsgAlert( "Non defined TABS cID " + ;
                AllTrim( Str( ::nId ) ) + ;
                " in resource " + ::oWnd:cNibName )
   endif
    
   for n = 1 to TabViewGetNumItems( ::hWnd )
      AAdd( ::aControls, TTabItem():Redefine( self , n )  )     
      AAdd( ::aDialogs ,::aControls[ len( ::aControls ) ] )
   next
  
return nil

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TTabs

   local n, cCode := CRLF + CRLF + "   @ " + ;
                     AllTrim( Str( ::nTop ) ) + ", " + ;
                     AllTrim( Str( ::nLeft ) ) + " TABS " + ::cVarName + ;
                     " PROMPTS { " + ::TabsToText() + " } OF " + ::oWnd:cVarName + ;
                     " ;" + CRLF + "      SIZE " + ;
                     AllTrim( Str( ::nWidth ) ) + ", " + ;
                     AllTrim( Str( ::nHeight ) )
     
    local cEventCode := ::GetEventCode( "OnChange" )    
       
   if ! Empty( cEventCode )
      cCode += " ON CHANGE " + cEventCode
   endif      
                        
   if ::nAutoResize != 0                  
      cCode += " AUTORESIZE " + AllTrim( Str( ::nAutoResize ) )               
   endif            
                        
   if ::lFlipped
      cCode += " FLIPPED"
   endif                          
                              
   for n = 1 to Len( ::aControls )
      AEval( ::aControls[ n ]:aControls, { | oCtrl | cCode += oCtrl:cGenPrg() } )
   next                              
                              
return cCode                                

//----------------------------------------------------------------------------//

METHOD SetVarName( cVarName ) CLASS TTabs

   local n

   ::cVarName = cVarName

   for n = 1 to Len( ::aControls )
      ::aControls[ n ]:cVarName = cVarName + ":aControls[ " + AllTrim( Str( n ) ) + " ]"
   next
   
return nil      

//----------------------------------------------------------------------------//

METHOD TabsToText() CLASS TTabs

   local cText := "", n
   
   for n = 1 to Len( ::aControls )
      cText += '"' + ::aControls[ n ]:cPrompt + '", '
   next
   
return SubStr( cText, 1, Len( cText ) - 2 )

//----------------------------------------------------------------------------//

METHOD TabsToArray() CLASS TTabs

   local aPrompts := {}, n
   
   for n = 1 to Len( ::aControls )
      aadd(aPrompts, ::aControls[ n ]:cPrompt )
   next
   
return aPrompts

//----------------------------------------------------------------------------//

METHOD ArrayToTabs(aPrompts) CLASS TTabs

   local  n
   
   for n = 1 to Len( ::aControls )
     ::aControls[ n ]:setText( aPrompts[n] )
   next
   
return nil

//----------------------------------------------------------------------------//

METHOD Change( nTabSelected ) CLASS TTabs

   ::nTab := nTabSelected
   
  // if ! Empty( ::GetEventCode( "OnChange" ) )
  //    Eval( ::GetEventBlock( "OnChange" ), ::nTab, Self )
  // else
      if ::bChange != nil
         if ValType( ::bChange ) == "C"
            Eval( &( "{ | sender | " + ::bChange + " }" ), Self )
         else
            Eval( ::bChange, Self )
         endif
      endif
 //  endif
          
return nil  