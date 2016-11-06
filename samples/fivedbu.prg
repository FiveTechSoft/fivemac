#include "FiveMac.ch"
#include "../../harbour/contrib/xhb/hbcompat.ch"

#define GENBLOCK(x)  &( "{ || " + x + " }" )

request DbfCdx, Descend

static oWnd, oMruFiles, cPrefFile

//----------------------------------------------------------------------------//


function Main()

   cPrefFile = Path() + "/fivedbu.plist"

   BuildMenu()
   
   DEFINE WINDOW oWnd TITLE "FiveDBU for FiveMac" ;
    FROM  0,0  TO 0 , ScreenWidth()

   BuildBar()
   
   oWnd:setPos( ScreenHeight(), 0 )

   ACTIVATE WINDOW oWnd ;
      ON INIT ( LoadUsedFileNames(), FWSetLanguage( LoadLanguageUsed() ) ) ;
      VALID ( SaveUsedFileNames(), MsgYesNo( FWString("Want to end ?"), FWString( "Select an option" ) ) )
  
return nil

//----------------------------------------------------------------------------//

function BuildBar()

   local oBar

   DEFINE TOOLBAR oBar OF oWnd

   DEFINE BUTTON OF oBar PROMPT "New" IMAGE ImgPath() + "new.png" ;
      ACTION New()
   
   DEFINE BUTTON OF oBar PROMPT "Open" IMAGE ImgPath() + "open.png" ;
      ACTION Open()
      
   DEFINE BUTTON OF oBar PROMPT "Exit" IMAGE ImgPath() + "exit2.png" ;
      ACTION oWnd:End()

return nil


//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

Function LoadLanguageUsed()

local oPList := TPList():New( cPrefFile )
local nLanguage := val( oPList:GetItemByName( "language" ) )
  if Empty(nLanguage)
     nLanguage := FWSetDefaultLanguage()
  endif

Return nLanguage

//----------------------------------------------------------------------------//

function SaveUsedFileNames()

   local oPList := TPList():New( cPrefFile )
   local n, aFileNames := {}
   
   for n = 1 to Len( oMruFiles:bAction:aItems )
      AAdd( aFileNames, oMruFiles:bAction:aItems[ n ]:cPrompt )
   next   
   
   oPList:SetArrayByName( "files", aFileNames, .T. )

   oPList:SetItemByName( "language", FWSetLanguage() , .T. )

return nil



//----------------------------------------------------------------------------//


function LoadUsedFileNames()

   local oPList := TPList():New( cPrefFile )
   local aFileNames := oPList:GetArrayByName( "files" ) , n
   
   for n = 1 to Len( aFileNames )
      Open( aFileNames[ n ] )
   next
   
return nil   

//----------------------------------------------------------------------------//

function GetFileName( aFileNames, n )

return aFileNames[ n ]

//----------------------------------------------------------------------------//
 
function BuildMenu()
 
   local oMenu
 
   MENU oMenu
      MENUITEM "Files"
      MENU
         MENUITEM FWString( "New" )+"..."  ACTION New()
         MENUITEM FWString( "Open" ) + "..."  ACTION Open()
         SEPARATOR
         MENUITEM oMruFiles PROMPT "Recent files"
         MENU
         ENDMENU
         SEPARATOR
         MENUITEM FWString( "Exit" ) ACTION oWnd:End()
      ENDMENU
    MENUITEM "Indexs"
      MENU
        MENUITEM "Indexes..."  ACTION  Indexes()
        MENUITEM "structuras..."  ACTION  New(alias())
      ENDMENU

    MENUITEM "Help"
      MENU
         MENUITEM "Wiki..."
         MENUITEM "About..." ACTION MsgAbout( "(C) FiveTech Software 2012", "FiveMac" )
      ENDMENU
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

function New(cAlias)

   local oDlg, oBrw, cFieldName := "", cType, nLength := 10, nDec := 0
   local cFileName := "", cRDD 
   local aFields := { }
   local oGet,oGetDeci ,oGetName,oGetLen,oCbx
   local oBtnCreate,oBtnEdit
   local aStruct
   local cTitle 
   
    if ! Empty( cAlias )
        aFields = ( cAlias )->( DbStruct() )
        cTitle = "Modify DBF struct"
    else
        cTitle = "DBF builder"
    endif

   DEFINE DIALOG oDlg TITLE cTitle ;
      FROM 207, 274 TO 590, 790

   @ 351, 20 SAY "FieldName:" OF oDlg SIZE 78, 17   

   @ 326, 20 GET oGet VAR cFieldName OF oDlg SIZE 125, 22   

   @ 351, 153 SAY "Type:" OF oDlg SIZE 51, 17   

   @ 326, 153 COMBOBOX oCbx VAR cType OF oDlg ;
      SIZE 124, 25 ITEMS { "Character", "Numeric", "Logical", "Date", "Memo" } ;
      ON CHANGE ( Iif(cType== "Numeric",oGetDeci:enabled() ,oGetDeci:disabled() ) )

   @ 351, 285 SAY "Length:" OF oDlg SIZE 50, 17 
   
   @ 326, 285 GET oGetLen VAR nLength OF oDlg SIZE 43, 22 
   oGetLen:setnumeric()   
   
   @ 351, 336 SAY "Dec:" OF oDlg SIZE 31, 17   

   @ 326, 336 GET oGetDeci VAR nDec OF oDlg SIZE 43, 22   
   
   oGetDeci:disabled() 
   
   @ 73, 20 LISTBOX oBrw FIELDS "", "", "", "" ;
      HEADERS "FieldName", "Type", "Length", "Decimals" ;
      OF oDlg SIZE 379, 245 ;
      AUTORESIZE 18 ;
       ON CHANGE ( cFieldName:= aFields[oBrw:nrowPos,1],oGet:refresh(),;
                  cType:= aFields[oBrw:nrowPos,2], oCbx:refresh(),;
                  nLength:=  aFields[oBrw:nrowPos,3],oGetLen:refresh() ,;
                  nDec   :=  aFields[oBrw:nrowPos,4],oGetDeci:refresh()  )
   
   oBrw:SetArray( aFields )
   oBrw:bLine = { | nRow | { aFields[ nRow ][ 1 ], aFields[ nRow ][ 2 ], alltrim(str(aFields[ nRow ][ 3 ])),;
                                        alltrim(str(aFields[ nRow ][ 4 ] ))} }
   oBrw:SetSelectorStyle( 1 )	
   oBrw:SetAlternateColor( .t. )  	 
       
   @ 324, 407 BUTTON "Add" OF oDlg ;
        ACTION ( btnAddField(@aFields,{ cFieldName,cType,nLength,nDec },oBrw:nRowPos),;
        				cFieldName :="" ,oBrw:refresh(), oGet:refresh()  )
    
   @ 274, 407 BUTTON oBtnedit PROMPT "Edit" OF oDlg ;
      ACTION ( aFields[oBrw:nRowPos]:= { cFieldName,cType,nLength,nDec } , ;
               cFieldName :="" ,oBrw:refresh(), oGet:refresh()  )
               
   oBtnEdit:disable()
      
   @ 242, 407 BUTTON "Up" OF oDlg ACTION SetFieldUp(@aFields,obrw:nRowPos ) 
   @ 210, 407 BUTTON "Down" OF oDlg ACTION SetFieldDown(@aFields,obrw:nRowPos )  
   @ 178, 407 BUTTON "Del" OF oDlg ACTION ( aDel( aFields, obrw:nRowPos ),ASize(aFields,Len(aFields)-1),oBrw:Refresh() )   


   @ 48, 20 SAY "DBF filename:" OF oDlg SIZE 92, 17   

   @ 46, 110 GET oGetName VAR cFileName OF oDlg SIZE 275, 22 ;
    VALID ( IF( !Empty(cFileName) .and. len(afields)>0 , oBtnCreate:Enable(),oBtnCreate:disable() ) , .t.   )

   @ 20, 73 SAY "RDD:" OF oDlg SIZE 108, 17   

   @ 16, 110 COMBOBOX cRDD OF oDlg ;
      SIZE 94, 25 ITEMS { "DBFNTX", "DBFCDX" }
      
      
   @ 101, 407 BUTTON "Code Gen." OF oDlg ACTION (msginfo(DbfGen( aFields )))
   

   @ 71, 407 BUTTON "Import" OF oDlg ACTION ( aStruct:= importDbf(), if ( !Empty(aStruct), ( afields:= aStruct,oBrw:SetArray( aFields ) ) ,),oBrw:refresh() )

   @ 41, 407 BUTTON oBtnCreate PROMPT "Create" OF oDlg ;   
             ACTION (  DBCREATE( cFileName, aFields ,cRdd )    )
   
   oBtnCreate:disable()
      
   ACTIVATE DIALOG oDlg
   
return nil

//----------------------------------------------------------------------------//

function DelField( aFields, cFieldName, oGet, oBrw )
    
    if Len( aFields ) >= 1
        ADel( aFields, oBrw:nRowPos, .T. )
        ASize( aFields, Len( aFields ) - 1 )
        oBrw:SetArray( aFields )
    endif
    
    oGet:VarPut( cFieldName := Space( 10 ) )
    oGet:SetPos( 0 )
    oGet:SetFocus()
    oBrw:GoBottom()
    
return nil


//----------------------------------------------------------------------------//

function SetFieldUp( aFields, nIndex )

   local BakaField

   if nIndex > 1
      BakaField = aFields[ nIndex - 1 ]
      aFields[ nIndex - 1 ] = aFields[ nIndex ]
      aFields[ nIndex ] = BakaField
   endif   

return nil

//----------------------------------------------------------------------------//

function SetFieldDown( aFields, nIndex )

   local BakaField

   if nIndex < Len( aFields )
      BakaField = aFields[ nIndex + 1 ]
      aFields[ nIndex + 1 ] = aFields[ nIndex ]
      aFields[ nIndex ] = BakaField
   endif   

return nil

//----------------------------------------------------------------------------//

function importDbf()

   local cFile := ChooseFile( fwstring( "Please select a DBF" ) , "Dbf" )
   local calias, aStruct

   if Upper( SubStr( cFile, Len( cFile ) - 3, 4 ) ) == ".DBF"
      USE ( cFile ) NEW  
      cAlias = Alias()
      aStruct = ( cAlias )->( DbStruct() )
      close( cAlias )
      MsgInfo( Len( aStruct ) )
   else
      MsgInfo( Upper( SubStr( cFile, Len( cFile ) - 3, 4 ) ) )  
      MsgInfo( "Invalid file type" )
   endif

return aStruct

//----------------------------------------------------------------------------//

function btnAddField( aFields, aField, nAt )

   DEFAULT nAt := Len( aFields )
 
   if Valtype( aField[ 3 ] ) == "C"
      aField[ 3 ] = Val( aField[ 3 ] )
   endif
 
   if Valtype( aField[ 4 ] ) == "C"
      aField[ 4 ] = Val( aField[ 4 ] )
   endif
 
   if Len( aFields ) == 0
      nAt = Len( aFields )
   endif   
 
   if nAt == Len( aFields)
      AAdd( aFields, aField )
   else    
      ASize( aFields, Len( aFields ) + 1 )
      AIns( aFields, nAt + 1 )
      aFields[ nAt + 1 ] = aField   
   endif
      
return nil

//----------------------------------------------------------------------------//

static function DbfGen( aFields )

   local cPrg  := "local aFields := "
   local aInfo := aFields
   local n, cTempName

   for n = 1 to Len( aInfo )
      cPrg +=  If( n == 1, "{ ", space(18) ) + '{ "' + ;
              aInfo[ n ][ 1 ] + '", "' + ;
              aInfo[ n ][ 2 ] + '", ' + ;
              AllTrim( Str( aInfo[ n ][ 3 ] ) ) + ", " + ;
              AllTrim( Str( aInfo[ n ][ 4 ] ) ) + "}" + ;
              If( n < Len( aInfo ), ",;", " } " ) + CRLF
   next
   
return cPrg

//----------------------------------------------------------------------------//

function Open( cDbfName, lAddMru )

   local oWnd, oBar, oBrw, oSay, aFiles, cTagName := "", oCbx
   local aTags := {}, n
   local nTags
   local calias 
   local oPopupZap 
  
   DEFAULT cDbfName := ChooseFile( FWString("Please select a DBF"), "dbf" ),;
           lAddMru := .T.
   
   if Empty( cDbfName )
       MsgInfo( "No file selected" )
      return nil
   endif
   
   if ! "." $ cDbfName
      cDbfName += ".dbf"
   endif
      
   if ! File( cDbfName )
      MsgInfo( FwString("File not found ") + cDbfName )
      return nil
   endif
  
   
   if lAddMru   
      oMruFiles:bAction:AddItem( cDbfName, { | oMenuItem | Open( oMenuItem:cPrompt ) } )   
   endif
      
   aFiles = Directory( cFilePath( cDbfName ) + "*.*" )   

      
   if AScan( aFiles, { | aFile | Upper( aFile[ 1 ] ) == ;
      Upper( cFileNoExt( cDbfName ) + ".ntx" ) } ) != 0
        USE ( cDbfName ) VIA "DBFNTX" NEW SHARED ;
        ALIAS ( cGetNewAlias( cFileName( cFileNoExt( cDbfName ) ) ) )
      
      for n = 1 to 15
         if ! Empty( OrdName( n ) )
            AAdd( aTags, OrdName( n ) )
         endif
      next  
       calias:=Alias()
else   
        USE ( cDbfName ) VIA "DBFCDX" NEW SHARED ;
        ALIAS ( cGetNewAlias( cFileName( cFileNoExt( cdbfName ) ) ) )
      
       calias:=Alias()

      aTags:= (cAlias )->( GetOrdNames() )
      nTags := len(aTags)
      if ntags > 0
        cTagName:=aTags[1]
        (calias)->(ordsetfocus(0))
      endif
   
 endif


   DEFINE WINDOW oWnd TITLE cDbfName ;
      FROM ScreenHeight() - 650, 50 TO ScreenHeight() - 150, 950

   DEFINE TOOLBAR oBar OF oWnd

   DEFINE BUTTON OF oBar PROMPT "Add" IMAGE ImgPath() + "add.png" ;
      ACTION ( oBrw:GoBottom(), ( oBrw:cAlias )->( DbAppend() ) )

   DEFINE BUTTON OF oBar PROMPT "Edit" IMAGE ImgPath() + "edit.png" ;
      ACTION RecEdit( oBrw )

   DEFINE BUTTON OF oBar PROMPT "Del" IMAGE ImgPath() + "minus.png" ;
      ACTION DeleteRecord(oBrw)

   DEFINE BUTTON OF oBar PROMPT "First" IMAGE ImgPath() + "first.png" ;
      ACTION oBrw:GoTop()

   DEFINE BUTTON OF oBar PROMPT "Last" IMAGE ImgPath() + "last.png" ;
      ACTION oBrw:GoBottom()
   
   DEFINE BUTTON OF oBar PROMPT "Structure" IMAGE ImgPath() + "preferences.png" ;
      ACTION ShowStruct( oBrw:cAlias )

   DEFINE BUTTON OF oBar PROMPT "Indexs" IMAGE ImgPath() + "Sort.tif" ;
    ACTION Indexes()

   @ 20, 1200 COMBOBOX oCbx VAR cTagName ITEMS aTags OF oWnd ;
    ON CHANGE  (( oBrw:cAlias )->( DbSetOrder( AScan( oCbx:aItems, { | cTagName | oCbx:GetText() == cTagName } ) ) ),;
                    oBrw:Refresh() )  

   oBar:AddControl( oCbx, "Index", "ordered by" )
    
   DEFINE BUTTON OF oBar PROMPT "Filters" IMAGE ImgPath() + "filter.tiff" ;
   ACTION  ( cAlias )->( Filter( oBrw ) )

   DEFINE BUTTON OF oBar PROMPT FwString("Recall") IMAGE ImgPath() + "undo.png" ;
   ACTION ( cAlias )->( Recall( oBrw, cDbfName ) )

   DEFINE BUTTON OF oBar PROMPT "Pack" IMAGE ImgPath() + "build.tiff" ;
   ACTION   Pack( oBrw , cDbfName )

   DEFINE BUTTON OF oBar PROMPT "Zap" IMAGE ImgPath() + "Behaviors.tiff" ;
   ACTION   Zap ( oBrw, cDbfName )

   DEFINE BUTTON OF oBar PROMPT "Exit" IMAGE ImgPath() + "exit2.png" ;
      ACTION oWnd:End()
   
   sele (calias)

   @ 25, 4 BROWSE oBrw OF oWnd SIZE 894, 472 ALIAS calias AUTORESIZE 18 ;
   


   // oBrw:bHeadClick:= { | obj , nindex| if(nindex== 1, msginfo("clickada cabecera"+str(nindex)),)  } 
   
   oBrw:SetColor( CLR_BLACK, CLR_GRAY )
   
   oBrw:GoTop()
   
    oBrw:bChange = { || oSay:SetText( "Alias: " + oBrw:cAlias + ; 
                       "   Record: " + AllTrim( Str( oBrw:nRowPos ) ) + " / " + ;
                       AllTrim( Str( ( oBrw:cAlias )->( RecCount() ) ) ) + ;
                       "   RDD: " + ( oBrw:cAlias )->( RddName() ) ) }

   oBrw:SetSelectorStyle( 1 )
   oBrw:SetAlternateColor( .T. )


   DEFINE MSGBAR OF oWnd

   @ 0, 10 SAY oSay PROMPT "Alias: " + oBrw:cAlias + ;
               "   Record: 1 / " + AllTrim( Str( ( oBrw:cAlias )->( RecCount() ) ) ) + ;
               "   RDD: " + ( oBrw:cAlias )->( RddName() ) ;
      OF oWnd SIZE 400, 20 RAISED

   ACTIVATE WINDOW oWnd ;
      VALID ( ( oBrw:cAlias )->( DbCloseArea() ), .T. )

return nil


//----------------------------------------------------------------------------//

Function DeleteRecord(oBrw)
 ( oBrw:cAlias )->( DbGoTo( oBrw:nRowPos ) )

 if (oBrw:cAlias)->(deleted() )
    Msginfo("ese registro ya está borrado")
    return .f.
 endif

 If MsgYesNo( fwstring("Want to delete this record ?") )
   
   if ( oBrw:cAlias )->( rlock() )
        ( oBrw:cAlias )->( DbDelete() )
        ( oBrw:cAlias )->( Dbunlock() )
        oBrw:Refresh()
   else
        msginfo("no bloqueado")
   endif
 endif


Return nil

//----------------------------------------------------------------------------//

function OrdTagsCount()

local n, nCount := 0

for n = 1 to 100
if ! Empty( OrdKey( n ) )
nCount++
endif   
next

return nCount   

//----------------------------------------------------------------------------//  

//----------------------------------------------------------------------------//

function ShowStruct( cAlias )

   local oDlg, oBrw, aInfo := ( cAlias )->( DbStruct() )
   
   DEFINE DIALOG oDlg TITLE "Dbf " + cAlias + " fields"
   
   oDlg:SetSize( 430, 395 )

   @ 33, 10 BROWSE oBrw ;
      FIELDS "", "", "", "" ;
      HEADERS "Name", "Type", "Len", "Dec" ;
      AUTORESIZE 18 ;
      OF oDlg SIZE 410, 327
   
   oBrw:SetArray( aInfo )
   oBrw:bLine = { | nRow | { aInfo[ nRow ][ 1 ], aInfo[ nRow ][ 2 ],;
                             Str( aInfo[ nRow ][ 3 ] ), Str( aInfo[ nRow ][ 4 ] ) } }

 //  oBrw:SetColor( CLR_BLACK, CLR_GRAY )

   oBrw:SetSelectorStyle( 1 )
   oBrw:SetAlternateColor( .T. )

   DEFINE MSGBAR OF oDlg

   @ 0, 10 SAY "Total fields: " + AllTrim( Str( ( cAlias )->( FCount() ) ) ) ;
      OF oDlg SIZE 300, 20 RAISED
   
   ACTIVATE DIALOG oDlg CENTERED 

return nil

//----------------------------------------------------------------------------//

function RecEdit( oBrw )

   local oWnd, oBar, oBtnSave, oSayRec, nRecNo
   local aRecord, cAlias := oBrw:cAlias
   
   ( cAlias )->( DbGoto( oBrw:nRowPos ) ) 
   
   nRecNo = ( cAlias )->( RecNo() )
   aRecord = ( cAlias )->( LoadRecord() )
   
   DEFINE WINDOW oWnd TITLE "Edit: " + oBrw:cAlias SIZE 600, 500
   
   DEFINE TOOLBAR oBar OF oWnd

   DEFINE BUTTON oBtnSave OF oBar PROMPT "Save" IMAGE ImgPath() + "save2.png" ;
      ACTION ( ( cAlias )->( SaveRecord( nRecNo, aRecord ) ), oBtnSave:Disable() )

   oBtnSave:Disable()

   DEFINE BUTTON OF oBar PROMPT "Prev" IMAGE ImgPath() + "first.png" ;
      ACTION ( If( nRecNo > 1, ( cAlias )->( DbGoTo( --nRecNo ) ),),;
               aRecord := ( cAlias )->( LoadRecord() ), oBtnSave:Disable(), oBrw:Refresh(),;
               oSayRec:SetText( ( cAlias )->( GetRecNo() ) ) )

   DEFINE BUTTON OF oBar PROMPT "Next" IMAGE ImgPath() + "last.png" ;
      ACTION ( If( nRecNo < ( cAlias )->( RecCount() ), ( cAlias )->( DbGoTo( ++nRecNo ) ),),;
               aRecord := ( cAlias )->( LoadRecord() ), oBtnSave:Disable(), oBrw:Refresh(),;
               oSayRec:SetText( ( cAlias )->( GetRecNo() ) ) )
      
   DEFINE BUTTON OF oBar PROMPT "Exit" IMAGE ImgPath() + "exit2.png" ;
      ACTION oWnd:End()
         
   @ 33, 10 BROWSE oBrw ;
      FIELDS "", "" ;
      HEADERS "Field", "Value" ;
      AUTORESIZE 18;
      OF oWnd SIZE 579, 436
   
   oBrw:SetColEditable( 1, .F. )
   oBrw:SetColWidth( 2, 454 )
   oBrw:SetArray( aRecord )
   oBrw:bLine = { | nRow | { aRecord[ nRow ][ 1 ], aRecord[ nRow ][ 2 ] } }
   oBrw:bSetValue = { | nRow, nCol, cValue | aRecord[ nRow ][ 2 ] := cValue, oBtnSave:Enable(), oBrw:Refresh() }
   oBrw:SetColor( CLR_BLACK, CLR_GRAY )
   oBrw:GoTop()
    
   DEFINE MSGBAR OF oWnd PROMPT ( cAlias )->( GetRecNo() ) SIZE 20
  
   ACTIVATE WINDOW oWnd CENTERED

return nil

//----------------------------------------------------------------------------//

function GetRecNo()

return "Record: " + AllTrim( Str( RecNo() ) ) + " / " + ;
                    AllTrim( Str( RecCount() ) )

//----------------------------------------------------------------------------//

function LoadRecord()

   local aRecord := {}, n

   for n = 1 to ( Alias() )->( FCount() )
      AAdd( aRecord, { ( Alias() )->( FieldName( n ) ),;
                       cValToChar( ( Alias() )->( FieldGet( n ) ) ) } )
   next                   

return aRecord

//----------------------------------------------------------------------------//

function SaveRecord( nRecNo, aRecord )

   local n, cType
   
   ( Alias() )->( DbGoTo( nRecNo ) )

    if ( Alias() )->( DbRLock( nRecNo ) )

        for n = 1 to Len( aRecord )
            cType = ( Alias() )->( FieldType( n ) )
            do case
                case cType == "C"
                    ( Alias() )->( FieldPut( n, aRecord[ n ][ 2 ] ) )
              
                case cType == "N"
                    ( Alias() )->( FieldPut( n, Val( aRecord[ n ][ 2 ] ) ) )
              
                case cType == "D"
                    ( Alias() )->( FieldPut( n, CToD( aRecord[ n ][ 2 ] ) ) )
              
                case cType == "L"
                    ( Alias() )->( FieldPut( n, Upper( aRecord[ n ][ 2 ] ) == ".T." ) )
            endcase
        next
        ( Alias() )->( DbUnLock() )
        MsgInfo( "Record updated" )
    else
        MsgAlert( "Record in use, please try it again" )
   endif

return nil              

//----------------------------------------------------------------------------//

function IndexBuilder()

   local oDlg, cExp := Space( 80 ), cTo := Space( 80 ), cTag := Space( 20 )
   local cFor := Space( 80 ), cWhile := Space( 80 ), lUnique := .F.
   local lDescend := .F., lMemory := .F., cScope := "All", nRecNo
   local oPgr, nMeter := 0, nStep := 10, lTag := .T. 

   DEFINE DIALOG oDlg TITLE "Index builder" 

   oDlg:SetSize( 530, 380 )

   @ 317, 14 SAY "Expression:" OF oDlg SIZE 80, 20

   @ 317, 100 GET cExp OF oDlg SIZE 380, 20 ;
      VALID ! Empty( cExp )

   @ 317, 488 BUTTON "..." SIZE 20, 20 ACTION .t. ;// ExpBuilder( @cExp )
      STYLE 10
   
   @ 287, 60 SAY FWString( "To " )+":" OF oDlg SIZE 80, 20

   @ 287, 100 GET cTo OF oDlg SIZE 380, 20

   @ 257, 54 SAY "Tag:" OF oDlg SIZE 80, 20

   @ 257, 100 GET cTag OF oDlg SIZE 260, 20 
   
   @ 227, 54 SAY "For:" OF oDlg SIZE 80, 20

   @ 227, 100 GET cFor OF oDlg SIZE 380, 20  

   @ 227, 488 BUTTON "..." SIZE 20, 20 ACTION .t. ;// ExpBuilder( @cExp )
   STYLE 10

   @ 197, 46 SAY "While:" OF oDlg SIZE 80, 20

   @ 197, 100 GET cWhile OF oDlg SIZE 380, 20

   @ 197, 488 BUTTON "..." SIZE 20, 20 ACTION .t. ;// ExpBuilder( @cExp )
     STYLE 10
   
   @ 167, 100 CHECKBOX lUnique PROMPT "Unique" OF oDlg SIZE 100, 20

   @ 167, 230 CHECKBOX lDescend PROMPT "Descending" OF oDlg SIZE 100, 20

   @ 167, 360 CHECKBOX lMemory PROMPT "Memory" OF oDlg SIZE 100, 20

   @ 136, 100 SAY "Scope:" OF oDlg SIZE 80, 20
   
   @ 107, 100 COMBOBOX cScope ITEMS { "All", "Next", "Record", "Rest" } OF oDlg

   @ 136, 200 SAY "Record:" OF oDlg SIZE 80, 20

   @ 111, 200 GET nRecNo OF oDlg SIZE 180, 22

   @ 83 , 100 SAY "Progress:" OF oDlg SIZE 100, 20
   
   @ 62 , 100 PROGRESS oPgr OF oDlg SIZE 380, 20
   
   @ 14, 280 BUTTON "Create" OF oDlg SIZE 100 , 24;
      ACTION ( OrdCondSet( If( ! Empty( cFor ), cFor,),;
               If( ! Empty( cFor ), GENBLOCK( cFor ),),;
               If( cScope == "All", .T.,),;
               If( ! Empty( cWhile ), GENBLOCK( cWhile ),),;
                   { || nMeter += nStep, oPgr:SetPos( nMeter ), .t. },;
                        nStep, Recno(),;
               If( cScope == "Next", nRecNo,),;
               If( cScope == "Record", nRecNo,),;
               If( cScope == "Rest", .T.,),;
               If( lDescend, .T.,),;
                   lTag,, .F., .F., .F., .T., .F., .F. ),;
               OrdCreate( OrdBagName(), If( lTag, cTag,), cExp, GENBLOCK( cExp ),;
               If( lUnique, .T.,) ), oDlg:End() ) 

   @ 14, 400 BUTTON FWString( "&Cancel" ) OF oDlg SIZE 100, 24 ACTION oDlg:End()
   
   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//

function Indexes()

   local oWnd, oBar, oBrw, oMsgBar
   local cAlias := Alias(), aIndexes := {}, n 

   for n = 1 to 15
      if ! Empty( OrdName( n ) )
         AAdd( aIndexes, { n,;
               OrdName( n ),;
               OrdKey( n ),;
               OrdFor( n ),;
               OrdBagName( n ),;
               OrdBagExt( n ) } )
      endif   
   next    

   DEFINE WINDOW oWnd TITLE "Indexes of " + Alias() 

   oWnd:SetSize( 950, 550 )

   DEFINE BUTTONBAR oBar OF oWnd 

   DEFINE BUTTON OF oBar PROMPT "Add" IMAGE ImgPath() + "add.png" ;
      ACTION ( IndexBuilder(), oBrw:Refresh(), oBrw:SetFocus() )

   DEFINE BUTTON OF oBar PROMPT "Edit" IMAGE ImgPath() + "edit.png" ;
      ACTION ( MsgInfo( "Edit" ) )

   DEFINE BUTTON OF oBar PROMPT "Del" IMAGE "TrashFull" ;
      ACTION If( MsgYesNo( "Want to delete this tag ?" ),;
             ( ( cAlias )->( OrdBagClear( oBrw:nRowPos() ) ), oBrw:Refresh() ),)

   //DEFINE BUTTON OF oBar PROMPT "Report" RESOURCE "report" ;
   //   ACTION oBrw:Report() GROUP

   DEFINE BUTTON OF oBar PROMPT "Exit" IMAGE ImgPath() + "exit2.png" ;
      ACTION oWnd:End() 

   @ 25, 4 BROWSE oBrw FIELDS "", "", "", "","" ,"" ;
      HEADERS "Order", "TagName", "Expression", "For","BagName","BagExt" ;
      AUTORESIZE 18;
      OF oWnd SIZE 942, 489 

   oBrw:SetArray( aIndexes )
   oBrw:bLine = { | nRow | { AllTrim( Str( aIndexes[ nRow ][ 1 ] ) ), aIndexes[ nRow ][ 2 ], aIndexes[ nRow ][ 3 ],;
                                      aIndexes[ nRow ][ 4 ], aIndexes[ nRow ][ 5 ], aIndexes[ nRow ][ 6 ]} }
 
   oBrw:SetSelectorStyle( 1 )	
   oBrw:SetAlternateColor( .T. )  	 
 
   oBrw:SetFocus()

   DEFINE MSGBAR oMsgBar OF oWnd SIZE 20

   ACTIVATE WINDOW oWnd 

return nil

//----------------------------------------------------------------------------//

function Filter( oBrw )

   local oDlg, cFilter := PadR( DbFilter(), 200 )
   local obtn

   DEFINE DIALOG oDlg TITLE "Filter " + Alias() SIZE 600, 200

   @ 110, 30 SAY "Expression:" OF oDlg SIZE 80, 22

   @ 80, 30 GET cFilter OF oDlg SIZE 540,22 ; //ACTION ExpBuilder( @cFilter ) ;
      VALID If( ! Empty( cFilter ), CheckExpression( cFilter ), .T. )

   @ 10, 480 BUTTON obtn PROMPT "Ok" OF oDlg SIZE 100, 24 ;
      ACTION ( cFilter := AllTrim( cFilter ),;
             If( Empty( cFilter ), DbClearFilter(), DbSetFilter( GENBLOCK( cFilter ), cFilter ) ),;
             oBrw:GoTop(), oBrw:Refresh(), oDlg:End() )

   oBtn:SetFocus()

   @ 10, 360 BUTTON "Cancel" OF oDlg SIZE 100,24 ACTION oDlg:End() 

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//

function CheckExpression( cExpression ) 

   local bCode := GENBLOCK( cExpression ), lResult := .F., oError

   TRY
      Eval( bCode )
      lResult = .T.
   CATCH oError
      MsgAlert( oError:Description + If( ! Empty( oError:Operation ),;
                CRLF + oError:Operation, "" ) + CRLF + ArgsList( oError ),;
                "Expression error" )
   END

return lResult

//----------------------------------------------------------------------------//

static function ArgsList( oError )

local cArgs := "", n

if ValType( oError:Args ) == "A"
cArgs += "Args:" + CRLF
for n = 1 to Len( oError:Args )
cArgs += "   [" + Str( n, 4 ) + "] = " + ValType( oError:Args[ n ] ) + ;
"   " + cValToChar( oError:Args[ n ] ) + CRLF
next
elseif ValType( oError:Args ) == "C"
cArgs += "Args:" + oError:Args + CRLF
endif

return cArgs    

function GetTokenPlus()

return ""

function ChrKeep()

return ""

function Soundex

return ""

//----------------------------------------------------------------------------//

function Pack( oBrw, cFileName )

   if MsgYesNo( FWString( "Do you want to completely remove the deleted records ?" ) )
      TRY
         ( oBrw:cAlias )->( __dbPack() )
         oBrw:Refresh()
      CATCH
         MsgStop( FWString( "Please change shared mode in preferences and " + ;
                  "open the file again in exclusive mode" ) )
      END
   endif

return nil

//----------------------------------------------------------------------------//

function Zap( oBrw, cFileName )

   if MsgYesNo( FWString( "WARNING: This will remove all records from the DBF. Are you sure ?" ) )
      TRY
         ( oBrw:cAlias )->( __dbZap() )
         oBrw:Refresh()
      CATCH
         MsgStop( FWString( "Please change shared mode in preferences and " + ;
                  "open the file again in exclusive mode" ) )
      END
   endif

return nil

//----------------------------------------------------------------------------//

function Recall( oBrw, cFileName )

   local nRecNo := RecNo()

   if ! FLock()
      MsgStop( cFileName + " " + FWString( "can not be locked" ),;
               FWString( "Recall records of" ) + " " + Alias() )
      return nil
   endif

   RECALL ALL
   DbUnLock()

   DbGoTo( nRecNo )
   oBrw:Refresh()
   oBrw:SetFocus()
   
return nil   

//----------------------------------------------------------------------------//
/*
function FWString( cString )
return cString
*/
