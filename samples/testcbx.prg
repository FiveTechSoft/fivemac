#include "FiveMac.ch"

function Main()

   local oDlg, oBrw, cFieldName := "", cType, nLength := 10, nDec := 0
   local cFileName := "", cRDD 
   local aFields := {  }
   local oGet,oGetDeci ,oGetName,oGetLen,oCbx
   local oBtnCreate,oBtnEdit
   local aStruct
   
   DEFINE DIALOG oDlg TITLE "DBF Builder" ;
      FROM 207, 274 TO 590, 790

   @ 351, 20 SAY "FieldName:" OF oDlg SIZE 78, 17   

   @ 326, 20 GET oGet VAR cFieldName OF oDlg SIZE 125, 22   

   @ 351, 153 SAY "Type:" OF oDlg SIZE 51, 17   

   @ 326, 153 COMBOBOX oCbx VAR cType OF oDlg ;
      SIZE 124, 25 ITEMS { "Character", "Numeric", "Logical", "Date", "Memo" } ;
      ON CHANGE ( Iif(cType== "Numeric",oGetDeci:enabled() ,oGetDeci:disabled() ) )
      
      oCbx:DisableItem(2)

   @ 351, 285 SAY "Length:" OF oDlg SIZE 50, 17 
   
   @ 326, 285 GET oGetLen VAR nLength OF oDlg SIZE 43, 22  

   
   @ 351, 336 SAY "Dec:" OF oDlg SIZE 31, 17   

   @ 326, 336 GET oGetDeci VAR nDec OF oDlg SIZE 43, 22   
   
   oGetDeci:disabled() 
   
 @ 73, 20 LISTBOX oBrw FIELDS "", "", "", "" ;
      HEADERS "FieldName", "Type", "Length", "Decimals" ;
      OF oDlg SIZE 379, 245 ;
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
             ACTION ( msginfo("crea dbf") , DBCREATE( cFileName, aFields ,cRdd )    )
   
   oBtnCreate:disable()
      
   ACTIVATE DIALOG oDlg
   
return nil

//----------------------------------------------------------------------------//

Function SetFieldUp(aFields,nIndex)
local BakaField
if nIndex > 1
   BakaField:= aFields[nIndex-1]
   aFields[nIndex-1]:= aFields[nIndex]
   aFields[nIndex]:= BakaField
endif   

Return nil

//----------------------------------------------------------------------------//

Function SetFieldDown(aFields,nIndex)
local BakaField
if nIndex < len(aFields)
   BakaField:= aFields[nIndex+1]
   aFields[nIndex+1]:= aFields[nIndex]
   aFields[nIndex]:= BakaField
endif   

Return nil

//----------------------------------------------------------------------------//

Function importDbf()
local cFile:=CHOOSEFILE("Select dbf file :","Dbf" )
local calias
local aStruct
if Upper(substr(cFile,len(cfile)-3,4)) == ".DBF"
   USE (cfile) NEW  
   calias:=Alias()
   aStruct:= (calias)->(dbstruct())
   close(calias)
   msginfo(len(aStruct))
else
   msginfo( Upper(substr(cFile,len(cfile)-3,4))    )  
   msginfo("tipo de archivo incorrecto")
endif
Return aStruct

//----------------------------------------------------------------------------//

Function btnAddField(aFields,aField,nAt)
local aItem

 DEFAULT nAt := Len( aFields )
 
 if Valtype(aField[3]) == "C"
    aField[3]:= val(aField[3])
 endif
 
  if Valtype(aField[4]) == "C"
    aField[4]:= val(aField[4])
 endif
 
 if len(afields) =  0
    nAt:=len(afields)
 endif   
 if nAt == Len( aFields)
      AAdd( aFields, aField )
 else    
      ASize( aFields, Len( aFields ) + 1 )
      AIns( aFields, nAt + 1 )
      aFields[ nAt + 1 ] = aField   
 endif
      
Return nil

//----------------------------------------------------------------------------//
static function DbfGen( aFields )

   local cPrg  := "local aFields:= "
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


