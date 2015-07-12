#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TPlist

  DATA   cName

  METHOD New( cName ) CONSTRUCTOR
  
  METHOD GetItemByName( cKey ) INLINE GetPlistValue( ::cName, cKey )
  METHOD SetItemByName( cKey, cValue, lpost ) 
  
  METHOD SetArrayByName( cKey, aArray, lpost )
  METHOD GetArrayByName( cKey )
  
  METHOD IsKeyByName(cKey) INLINE IsKeyPlist( ::cName, cKey )
                        
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cName ) CLASS TPlist

   ::cName = cName 

return self

//----------------------------------------------------------------------------//

METHOD SetItemByName( cKey, cValue, lpost ) CLASS TPlist
   local oArray
   DEFAULT lpost := .t.
   
   if Valtype( cValue ) == "N"
      cValue = AllTrim( Str( cValue ) )
   endif 
 
   SetPlistValue( ::cName, cKey, cValue, lpost )

return nil 

//----------------------------------------------------------------------------//

METHOD SetArrayByName( cKey, aArray, lpost ) CLASS TPlist
   local oArray, n
    DEFAULT lpost := .t.
        
    if ! Empty( aArray )
      if ValType( aArray ) == "A" .and. Len( aArray ) > 0
      
         oArray:=  ArrayCreateEmpty() 
                        
         for n = 1 to Len( aArray )
            ArrayAddString(oArray, aArray[ n ]  )     
                  
         next 
          SetPlistArrayValue( ::cName, cKey, oArray, lpost ) 
      endif
   endif 

return nil 

//----------------------------------------------------------------------------//

METHOD GetArrayByName( cKey ) CLASS TPlist

local oArray := GetPlistArrayValue(::cName,Ckey) 
local i
local n:= Arraylen(oArray)
local aArray:= {}
loca cValue
   
   for i=1 to n
      cValue:= ArrayGetStringIndex(oArray,i-1)
      aadd(aArray,cValue)
   next      
 
return aArray

//----------------------------------------------------------------------------//
Function CreateInfoFile(cProg,cPath,cIcon)
local lpost:= .f.
local cFile:= cPath+cProg+".app"+"/Contents/"+"Info.plist" 
 

oInfo:=TPlist():new(cfile)

 WITH OBJECT oInfo  
   :SetItemByName ( "CFBundleExecutable" , cProg , lpost ) 
   :SetItemByName ( "CFBundleName" , cProg,lpost ) 
   :SetItemByName ( "CFBundleIdentifier" , "com.fivetech."+cProg , lpost  ) 
   :SetItemByName ( "CFBundlePackageType" , "APPL" , lpost  ) 
   :SetItemByName ( "CFBundleInfoDictionaryVersion" , "6.0" , lpost  ) 
   :SetItemByName ( "CFBundleIconFile" , cIcon , lpost  ) 
 END

Return nil

