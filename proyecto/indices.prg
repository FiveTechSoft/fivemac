

#include "Fivemac.ch"

extern dbfcdx, DBCloseArea, DbUseArea, DbGoTo

//----------------------------------------------------------------//


Function indices(nOpcion)

local indice:=tindices():new():MsgSelect() 

     return nil

//----------------------------------------------------------------------------//

CLASS Tindices

   DATA nIndice
   DATA bItems
   DATA ODlg, oSayind,obrw
   DATA cAlias,osaytime,oMeter
   DATA nrecord
   DATA cDbfPath
   
   METHOD New() CONSTRUCTOR
   METHOD Proceso()
   METHOD CreaIndices()
   METHOD MsgSelect( cTitle )
   METHOD ponproceso(opcion,aDatos)
   
//   METHOD refresca()  INLINE   dbselectar(::calias),dbgoto(::oBrw:nArrayAt)




ENDCLASS

//----------------------------------------------------------------------------//

METHOD New(nIndice) CLASS Tindices
  ::cDbfpath := cDbfPath
  ::cAlias := SoloAbre("indices")
   if Empty(::cAlias)
       Return .f.
   endif
  ::nIndice=nIndice
  sele (::calias)
  
return Self

//----------------------------------------------------------------------------//

METHOD CreaIndices() CLASS Tindices
local indi,aj,t_var,camp
local aux,lunico
local cadavez
local contador:=1
local nindi,cBase,cVia
local cCampo,ctag
local i
local at,att,atblock
local nalias
local n:=1
LOCAL DBNUM,cfor,bfor

sele (::calias)
nalias:=select()
DBNUM := (::calias)->numero
nindi:=(::calias)->num_ind

cBase:=::cDbfpath+alltrim((::cAlias)->base)
CVia:=trim((::calias)->via)
if upper(alltrim((::cAlias)->base)) == "CAMINO"
   RETURN NIL
endif

 ::oSayind:SetText("Organizando Archivo de "+ alltrim((::cAlias)->base))
 
 Ferase(cBase+".cdx")
   dbusearea(.t.,,cbase)
   if netErr()
      pausa("error en bloqueo"+cbase)
      Return .f.
   endif
   PACK
   dbclosearea()

cadavez:=reccount()/100*(nindi)

::oMeter:setRange(0,Indi)
n:= 0
::oMeter:Update( n )

::oSayind:setText("Creando indices de "+ alltrim((::cAlias)->base))
  dbusearea(.T.,cVia,cBase)
 // nunico:=eval(fieldwblock("unico",nalias))
  for i=1 to nindi
      cCampo:="campo"+str(i,1,0)
      at:=trim(eval(fieldwblock(cCampo,nalias)) )
      ctag:="tag"+str(i,1,0)
      att:=trim(eval(fieldwblock(ctag,nalias) ) )
      atblock:= compila(at)
      lunico:= .f.

      // For condition string format
      cFor := '!deleted()'
      // Actual for condition
      bFor := {|| !deleted() }

       ordCondSet(cFor,bFor,,,,, RECNO(),,,, )
       ordCreate(cbase, att, at, atblock,lunico )

      ::oMeter:Update( n++ )
      next
	  
  ::nrecord:=reccount()
   dbclosearea()
 ::oSayind:setText(  "Finalizado creación indices ")
 
 
return NIL

/*----------------------------------------------------------------------------*/

METHOD MsgSelect( cTitle ) CLASS Tindices
local cValue
local ofont,oFontHeader,oFontSele
local obmp
local nval:= 0
local auxn
local osay1
local aDatos:={}
local oHeaderDlg, oViaBitmap1
local obtn,oprog
local respath:=respath()+"/"
local obox,oColor1, oColor2,oGrad
::bItems:={}

sele (::calias)
(::calias)->(dbgotop())

DBEVAL({|| aadd(::bItems,(::calias)->tiempo ) } )
DBEVAL({|| aadd(aDatos,{.f. , substr( (::calias)->nombre,1,18)  })} )

cValue:= aDatos[1,2]
//close(::cAlias)



DEFINE DIALOG ::oDlg TITLE "Creación de indices" ;
FROM 470, 650 TO 880, 1280

  
   
   @ 110, 270 SAY ::osayind PROMPT "Escoja un archivo" OF ::oDlg SIZE 320, 50 TEXTCENTER
   
   @  85, 270 SAY ::osaytime PROMPT " " OF ::oDlg SIZE 320, 50 TEXTCENTER   
  
   
   @ 180, 330 IMAGE oImg OF ::oDlg SIZE 200, 200 FILENAME respath+"PrefApp.tiff"
   
   @ -16,0 BROWSE ::oBrw FIELDS "","" HEADERS "P", "Archivos" OF ::oDlg SIZE 240 , (::oDlg:nHeight-6) 
      

     ::oBrw:setArray( aDatos )
     ::oBrw:bLine = { | nRow | { If( aDatos[ nRow ][ 1 ], respath+"online.tiff", respath+"offline.tiff" ), aDatos[ nRow ][ 2 ] , } }
	 
   WITH OBJECT ::oBrw    
    
	 :SetColEditable( 2, .f. ) 
	 
	 :SetNoHead()
      
     :SetColWidth( 1,20 )
     :SetColWidth( 2,170 )
     :SetRowHeight( 20 )
     :bAction := {|| ::ponproceso( ::obrw:nRowPos,aDatos) }
     :SetGridLines( 1 )
     :SetSelectorStyle( 1 )	  	
       
     :SetHeadTooltip( 2, "Hola" )	
     :SetColBmp( 1 )  
     :bChange := {|obrw| ::oMeter:Update(0)  }
          
   END
    
	
   ::oSaytime:setText("Tiempo del proceso : "+str(::bItems[::obrw:nRowPos],6,3)+" segundos" )
     
   @ 74 , 280 PROGRESS ::oMeter OF ::oDlg SIZE 300, 30 POSITION 0     
                          
                                                    	   			   
   @ 20, 450 BUTTON "Cancel" OF ::oDlg ACTION ((::calias)->(dbclosearea()) , ::oDlg:End())                                               	   
   @ 20, 320 BUTTON obtn PROMPT "OK" OF ::oDlg ACTION  ( ::ponproceso( ::obrw:nRowPos,aDatos)   )
  
   
   ACTIVATE DIALOG ::oDlg CENTERED 


return cValue

//------------------------------------------------------------------------------

METHOD ponproceso(opcion,aDatos) CLASS Tindices
   local n
   local aa, bb

if opcion !=0
     if opcion=len(aDatos)

        ::oBrw:gotop()
        aa:=seconds()
        FOR n=1 TO ( len(aDatos) -1 )
            ::nIndice:=n
            ::proceso()
             aDatos[n,1]:= .t.
             ::oBrw:GoDown()	
        NEXT
        bb:=seconds()
        SELE (::calias)
       (::calias)->(dbgoto( len(aDatos)) )
        IF (::calias)->(Rlock())
            REPLACE (::calias)->TIEMPO WITH BB-AA
            (::calias)->(dbunlock())
         ENDIF
             ::oSayTime:setText("Proceso : "+alltrim(Str(len(aDatos)-1,5,0))+" Archivos en " +str(::bItems[::obrw:nRowPos],6,3)+" segundos." )
         else
	    
	    ::nIndice:=opcion
        ::proceso()
        
        aDatos[opcion,1]:= .t.
		::oBrw:GoDown()
		
    		
   endif
 
   endif
   
RETURN NIL


//----------------------------------------------------------------------------//

METHOD Proceso() CLASS Tindices

local aa,bb
(::calias)->(dbgoto(::nIndice))
AA:=seconds()
::Creaindices()
bb:=seconds()
SELE (::calias)
(::calias)->(dbgoto(::nIndice))
IF (::cAlias)->(RLOCK())
   REPLACE (::calias)->TIEMPO WITH BB-AA
   (::calias)->(dbunlock())
ENDIF
::oSayTime:SetText("Proceso : "+ alltrim(Str(::nrecord,10,0))+" Registros en " +str(::bItems[::obrw:nRowPos],6,3)+" segundos." )

return NIL

