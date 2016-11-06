// Objects inspector

#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TInspector FROM TWindow

   DATA   oCtrl         // Inspected control
   DATA   oCbxControls
   DATA   oTabs
   DATA   oBrwProps
   DATA   oBrwEvents

   METHOD New()

   METHOD AddItem( oCtrl )

   METHOD BuildPanels()

   METHOD DelControl( oCtrl )

   METHOD SelControl() // A control is selected from the inspector's combobox

   METHOD SetProp( nRow, nCol, cData )

   METHOD GetProp( nRow, nCol )
   
   METHOD InspectEvent()
 
   METHOD InspectProperty()

   METHOD GetEvent( nRow, nCol )

   METHOD SetControl( oCtrl )

   METHOD SetEvent( nRow, nCol, cData )

   METHOD Refresh() INLINE ::oBrwProps:Refresh(), ::oBrwEvents:Refresh()

   METHOD SetForm( oForm )
   
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS TInspector

   local nControl, oThis := Self

   ::Super:New()

   ::cText = "Inspector"
   ::SetPos( ScreenHeight() - 600, 32 )
   ::SetSize( 317, 460 )

   @ 400, 10 COMBOBOX ::oCbxControls VAR nControl ITEMS {} OF Self ;
      SIZE 295, 25 AUTORESIZE 10 // ON CHANGE oThis:SelControl()

   @ 6, 8 TABS ::oTabs PROMPTS { "Properties", "Methods" } OF Self ;
      SIZE 300, 390 AUTORESIZE 18

   ::BuildPanels()

return Self

//----------------------------------------------------------------------------//

METHOD BuildPanels() CLASS TInspector

   @ 2, 2 BROWSE ::oBrwProps FIELDS "", "" HEADERS "Name", "Value" ;
      OF ::oTabs:aControls[ 1 ] ;
      SIZE 276, 340 COLSIZES 115, 138 ;
      AUTORESIZE 18

   WITH OBJECT ::oBrwProps
      :SetColor( CLR_BLACK, CLR_PANE )
      :bSetValue = { | nRow, nCol, cData | ::SetProp( nRow, nCol, cData ) }
      :bGetValue = { | nRow, nCol | ::GetProp( nRow, nCol ) }
      :bLogicLen = { || If( ::oCtrl != nil, Len( ::oCtrl:aProps ), 0 ) }
      :cAlias = "_INSPECT"
      :SetColEditable( 1, .F. )
      :SetRowHeight( 20 )
      :bAction = { || ::InspectProperty(), ::Refresh() }
   END

   @ 2, 2 BROWSE ::oBrwEvents FIELDS "", "" HEADERS "Event", "Code" ;
      OF ::oTabs:aControls[ 2 ] ;
      SIZE 296, 386 COLSIZES 115, 138 ;
      AUTORESIZE 18

   WITH OBJECT ::oBrwEvents
      :SetColor( CLR_BLACK, CLR_PANE )
      :bSetValue = { | nRow, nCol, cData | ::SetEvent( nRow, nCol, cData ) }
      :bGetValue = { | nRow, nCol | ::GetEvent( nRow, nCol ) }
      :bLogicLen = { || If( ::oCtrl != nil, Len( ::oCtrl:aEvents ), 0 ) }
      :cAlias = "_INSPECT"
      :SetColEditable( 1, .F. )
      :SetRowHeight( 20 )
      :bAction = { || ::InspectEvent() , ::Refresh() }   
   END 
return nil

//----------------------------------------------------------------------------//

METHOD AddItem( oCtrl ) CLASS TInspector

   ::oCbxControls:Add( oCtrl:cVarName + " AS " + oCtrl:ClassName() )
   ::oCtrl = oCtrl
   ::oBrwProps:Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD DelControl( oCtrl ) CLASS TInspector

   local nAt := AScan( ::oCbxControls:aItems,;
      { | cItem | SubStr( cItem, 1, Len( oCtrl:cVarName ) ) == oCtrl:cVarName } )
   local oWnd := oCtrl:oWnd, aItems

   if nAt != 0
      aItems = ::oCbxControls:aItems
      aItems = ADel( aItems, nAt )
      aItems = ASize( aItems, Len( aItems ) - 1 )
      ::oCbxControls:SetItems( aItems )
      ::SetControl( oWnd )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GetEvent( nRow, nCol ) CLASS TInspector

   if nCol == 0
      return ::oCtrl:aEvents[ nRow + 1 ][ 1 ][ 1 ]
   else
      return If( ! Empty( ::oCtrl:aEvents[ nRow + 1 ][ 2 ] ),;
                 ::oCtrl:aEvents[ nRow + 1 ][ 2 ], "" )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GetProp( nRow, nCol ) CLASS TInspector

   if nCol == 0
      return ::oCtrl:aProps[ nRow + 1 ]
   else
      do case
         case ::oCtrl:aProps[ nRow + 1 ] == "cFileName"
              ::oBrwProps:SetColEditable( 2, .F. )
              return __ObjSendMsg( ::oCtrl, ::oCtrl:aProps[ nRow + 1 ] )

         case ValType( __ObjSendMsg( ::oCtrl, ::oCtrl:aProps[ nRow + 1 ] ) ) == "A"
              ::oBrwProps:SetColEditable( 2, .F. )
              return "{ ... }"

         otherwise
            ::oBrwProps:SetColEditable( 2, .T. )
            return cValToChar( __ObjSendMsg( ::oCtrl, ::oCtrl:aProps[ nRow + 1 ] ) )
      endcase
   endif

return nil

//----------------------------------------------------------------------------//

METHOD InspectProperty() CLASS TInspector

   local oCtrl  := ::oCtrl
   local uValue := __ObjSendMsg( oCtrl, oCtrl:aProps[ ::oBrwProps:nArrayAt ] )

   do case

      case oCtrl:aProps[ ::oBrwProps:nArrayAt ] == "nAutoResize"
           uValue = SetAutoResize( oCtrl:nAutoResize )
           oCtrl:nAutoResize = uValue

      case oCtrl:aProps[ ::oBrwProps:nArrayAt ] == "cFileName"
           uValue = ChooseFile( "Please select a file", "png" )
           oCtrl:cFileName = uValue

      case ValType( uValue ) == "A"
        if oCtrl:IsKindOf( "TTABS" ) 
             uValue:= oCtrl:TabsToArray()
             if ArrayEdit( @uValue, oCtrl:aProps[ ::oBrwProps:nArrayAt ] )
                oCtrl:ArrayToTabs(uValue)
             endif
        else
              
          if ArrayEdit( @uValue, oCtrl:aProps[ ::oBrwProps:nArrayAt ] )
              do case
                 case oCtrl:IsKindOf( "TCOMBOBOX" )
                      oCtrl:SetItems( uValue )

                 otherwise
                    __ObjSendMsg( oCtrl, "_" + oCtrl:aProps[ ::oBrwProps:nArrayAt ], uValue )
              endcase
           endif
        endif
      case ValType( uValue ) == "L"
           __ObjSendMsg( oCtrl, "_" + oCtrl:aProps[ ::oBrwProps:nArrayAt ], ! uValue )

      otherwise
          //  MsgInfo( uValue )
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD InspectEvent() CLASS TInspector

   local cCode := ::oCtrl:aEvents[ ::oBrwEvents:nArrayAt ][ 2 ]
                             
   if ! Empty( cCode )
      ::oCtrl:SetEventCode( ::oCtrl:aEvents[ ::oBrwEvents:nArrayAt ][ 1 ], cCode )
   endif                                                 

return nil

//----------------------------------------------------------------------------//

METHOD SetControl( oCtrl ) CLASS TInspector

   local nAt := AScan( ::oCbxControls:aItems,;
      { | cItem | SubStr( cItem, 1, Len( oCtrl:cVarName ) ) == oCtrl:cVarName } )

   if nAt != 0
      if ::oCbxControls:GetText() != ::oCbxControls:aItems[ nAt ]
         ::oCbxControls:Select( nAt )
      endif
   endif

   ::oCtrl = oCtrl
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD SetEvent( nRow, nCol, cData ) CLASS TInspector

   ::oCtrl:aEvents[ nRow + 1 ][ 2 ] = cData

   // oWndCode:EditMethod( cData, "TForm1", oCtrl:aEvents[ nRow + 1 ][ 1 ] )

return nil

//----------------------------------------------------------------------------//

METHOD SetForm( oForm ) CLASS TInspector

   if ::oCtrl == oForm
      return nil
   endif

   ::oCbxControls:Reset()

   ::AddItem( oForm )

   AEval( oForm:aControls, { | oCtrl | ::AddItem( oCtrl ) } )

   ::SetControl( oForm )
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD SelControl() CLASS TInspector

   local cVarName := StrToken( ::oCbxControls:GetText(), 1 )
   local oWnd, nAt

   if ::oCtrl:IsKindOf( "TCONTROL" )
      oWnd = ::oCtrl:oWnd
   else
      oWnd = ::oCtrl
   endif

   if oWnd:cVarName == cVarName
      ::oCtrl = oWnd
   else
      if ( nAt := AScan( oWnd:aControls,;
         { | o | o:cVarName == cVarName } ) ) != 0
         ::oCtrl = oWnd:aControls[ nAt ]
      endif
   endif

   ::Refresh()

   if ::oCtrl:IsKindOf( "TCONTROL" )
      ::oCtrl:oWnd:SetFocus()
   endif

   ::oCtrl:SetFocus()

return nil

//----------------------------------------------------------------------------//

METHOD SetProp( nRow, nCol, cData ) CLASS TInspector

   local cProp, cType, oCtrl := ::oCtrl

   if oCtrl != nil
      cProp = oCtrl:aProps[ nRow + 1 ]
      cType = ValType( __ObjSendMsg( oCtrl, cProp ) )
          
      do case
         case cType == "C"
              __ObjSendMsg( oCtrl, "_" + cProp, cData )

         case cType == "N"
            if  cProp == "nAutoResize"
               // msginfo("si")
               oCtrl:Anclaje( val(cData) )
            elseif cProp == "nTab" 
                   oCtrl:SetItemSelected( val(cData) )
            else
              __ObjSendMsg( oCtrl, "_" + cProp, Val( cData ) )
            endif
         case cType == "L"
              __ObjSendMsg( oCtrl, "_" + cProp, Lower( cData ) == ".t." )
      endcase
   endif

return nil

//----------------------------------------------------------------------------//

function SetAutoResize( nState )

   local oDlg
   local oGroup
   local obtn1
   local obtn2,obtn3
   local obtn4
   local obtn5,obtn6
   local obtnfin
   local nAncla:= 0

   DEFINE DIALOG oDlg TITLE "nAutoResize" ;
      FROM 270, 350 TO 510, 740

   @ 60, 70 GROUP oGroup PROMPT "" SIZE 250, 120 OF oDlg

   oGroup:setStyle( 4 )

   @   4, 180 BTNBMP obtn1 FILENAME ( UserPath() + "/fivemac/bitmaps/VertOrigin.png") OF oDlg ACTION (.t. ) SIZE 20,55

   @ 182, 180 BTNBMP obtn4 FILENAME ( UserPath() + "/fivemac/bitmaps/VertOrigin.png") OF oDlg ACTION (.t. ) SIZE 20,55

   @ 114,   4 BTNBMP obtn2 FILENAME ( UserPath() + "/fivemac/bitmaps/HorzOrigin.png") OF oDlg ACTION ( .t. ) SIZE 65,20

   @ 114, 322 BTNBMP obtn3 FILENAME ( UserPath() + "/fivemac/bitmaps/HorzOrigin.png") OF oDlg ACTION (.t. ) SIZE 65,20

   @  82,  76 BTNBMP obtn6 FILENAME ( UserPath() + "/fivemac/bitmaps/VertSize.png") OF oDlg ACTION (.t.) SIZE 20,96

   @  64,  74 BTNBMP obtn5 FILENAME ( UserPath() + "/fivemac/bitmaps/HorzSize.png") OF oDlg ACTION ( .t. ) SIZE 242,20

   AEval( oDlg:aControls,;
          { | oCtrl | If( oCtrl:ClassName() == "TBTNBMP", oCtrl:nType := 6,) } )

   AssignAutoResize( nState, obtn1, obtn2, obtn3, obtn4, obtn5, obtn6 )

   @ 4, 340 BUTTON obtnfin PROMPT "ok" OF oDlg ;
      ACTION ( nAncla:=Sumaanclas(obtn1,obtn2,obtn3,obtn4,obtn5,obtn6),oDlg:end() ) ;
      SIZE 45, 40

   ACTIVATE DIALOG oDlg CENTERED

return nAncla

//----------------------------------------------------------------------------//

Function AssignAutoResize( nState, obtn1, obtn2, obtn3, obtn4, obtn5, obtn6 )

   if nState = 8
      BTNSETSTATE(obtn1:hWnd,1)
   endif

   if nState = 1
      BTNSETSTATE(obtn3:hWnd,1)
   endif

   if nState = 2
      BTNSETSTATE(obtn5:hWnd,1)
   endif

   if nState = 9
      BTNSETSTATE(obtn1:hWnd,1)
      BTNSETSTATE(obtn3:hWnd,1)
   endif

   if nState = 10
      BTNSETSTATE(obtn1:hWnd,1)
      BTNSETSTATE(obtn5:hWnd,1)
   endif

   if nState = 16
      BTNSETSTATE(obtn6:hWnd,1)
   endif

   if nState = 17
      BTNSETSTATE(obtn6:hWnd,1)
      BTNSETSTATE(obtn3:hWnd,1)
   endif

   if nState = 18
      BTNSETSTATE(obtn5:hWnd,1)
      BTNSETSTATE(obtn6:hWnd,1)
   endif

   if nState = 2
      BTNSETSTATE(obtn5:hWnd,1)
   endif

return nil

//----------------------------------------------------------------------------//

Function SumaAnclas(obtn1,obtn2,obtn3,obtn4,obtn5,obtn6)

  local nAncla:= 0
  local nState1:=BTNGETSTATE(obtn1:hWnd)
  local nState3:=BTNGETSTATE(obtn3:hWnd)
  local nState2:=BTNGETSTATE(obtn2:hWnd)
  local nState4:=BTNGETSTATE(obtn4:hWnd)
  local nState5:=BTNGETSTATE(obtn5:hWnd)
  local nState6:=BTNGETSTATE(obtn6:hWnd)

  if  nState1== 1
      nAncla = nancla + 8
  endif

  if  nState3 == 1
      nAncla = nancla+1
 endif
   if  nState2== 1
      nAncla=nancla+4
 endif
 if  nState4== 1
      nAncla=nancla+32
 endif
  if  nState5== 1
      nAncla=nancla+2
 endif
 if  nState6== 1
      nAncla=nancla+16
 endif


Return nAncla




