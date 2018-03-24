//
//  Tsheet.prg
//  fivemac
//
//  Created by Manuel Sanchez on 14/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#include "FiveMac.ch"

//----------------------------------------------------------------------------//

Function cGetfile(cMsg)
Return CHOOSEFILE(cMsg)

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

CLASS TSheet FROM TControl

   DATA   bAction
   DATA   oURL
   DATA   hWnd
   DATA   oWnd 
   DATA   lsave
    
   METHOD New( cTitle, bAction, oWnd ) CONSTRUCTOR

   METHOD open() INLINE if(!::lsave,;
            Sheetopenrun(::hWnd, ::ownd:hwnd ), )
    
   
   METHOD Save(cfile) INLINE if(::lsave,;
       SheetSaverun(::hWnd, ::ownd:hwnd,cfile), )
       
   
   METHOD SetTitle(cTitle) INLINE SheetSetTitle(::hWnd,cTitle )   
    
   METHOD Click(oUrl) 
   
 ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cTitle , bAction, oWnd ,lsave) CLASS TSheet

   DEFAULT bAction := { || nil }
   DEFAULT cTitle := "seleccione el archivo"
   DEFAULT lsave:= .f.
   
   ::lsave:=lsave
   if ::lsave
      ::hWnd := SheetsaveCreate()
   else
      ::hWnd := SheetopenCreate()
   endif
   ::oWnd := oWnd   
   ::bAction  := bAction
   ::SetTitle(cTitle ) 
    
   oWnd:AddControl( Self )
          
return Self

//----------------------------------------------------------------------------//

METHOD Click(oURL) CLASS TSheet
      
    eval(::bAction,URLPATH(oURL)) 
  
return nil

//----------------------------------------------------------------------------//

