#include "FiveMac.ch"

static oWnd

extern dbfcdx, DBCloseArea, DbUseArea, DbGoTo , ordsetfocus

#define NoMovil          0
#define AnclaRight       1
#define AnchoMovil       2
#define AnclaLeft        4
#define AnclaTop         8
#define AltoMovil       16
#define AnclaBottom     32
				 
//-----------------------------------------------------------------------//
function provincias()

   local oWnd 
   local oGet, cText := "Hello world", oBtn
   local oChk, lTest := .T.
   local obtn3,obtn2,obtn4
   local osplit,obrw,oDlg
   local respath:=respath()+"/"
   local cAlias:=Abrimos("Provinci")
    local oget1, oget2,oget3,oget4
	local ctext2:= "yo"
	local orden
	local csay,osay1
	local cpobla,cCalles
	local lvista:= .f.
	local obrw2
	local ncod
	
	   local bchanged:= {|oGet| Busquedaprov(oGet,oBrw,calias ) } 
	
   sele (calias)
   orden:=(calias)->(ordsetfocus(2))
   (cAlias)->(dbgotop())
 
    
   cCalles:=Abrimos("calles")
   
   cpobla:=Abrimos("Poblacio")
   orden:=(cpobla)->(ordsetfocus(1))
     
   sele (calias)
				 
 DEFINE WINDOW oDlg TITLE "Gestion de Provincias" ;
      FROM 470, 650 TO 880, 960
  

 
 DEFINE TOOLBAR oBar OF oDlg

       oBar:Addsearch( "buscar provincia", "Buscar provincias ",bchanged ) 	
     		     	   	
	   oBar:AddSpaceFlex()
	  		
        DEFINE BUTTON OF oBar PROMPT "Exit" ;
         ACTION oDlg:End() ;
         TOOLTIP "Salir de Familias" ;
         IMAGE respath+"exit.png"

     DEFINE MSGBAR OF oDlg SIZE 32      	  	   
	     
 


 @ 33,0 BROWSE oBrw FIELDS (calias)->codprov ,(calias)->provincia ; 
HEADERS "Codigo", "Provincia" OF oDlg SIZE 310 , (oDlg:nHeight-110) ;
ALIAS cAlias  COLSIZES 60,210 AUTORESIZE nor(4,16)
    WITH OBJECT oBrw  

        :SetColEditable( 1, .f. ) 	 
        :SetColEditable( 2, .f. ) 	
        :SetRowHeight( 20 )
        :SetSelectorStyle( 1 )	 
        :SetGridLines( 1 )
        :bHeadclick:={|o, nhead| orden(nHead,obrw) }
        :SetIndicatorDescent(2)


    END
	 	 
	 
	obrw:bHeadclick:={|o, nhead| orden(nHead,o) }


   oBrw:setDblClick()
   oBrw:baction:= {|| poblacion((calias)->codprov,oDlg,cpobla,@lvista,@obrw2,cCalles) }

   oDlg:bValid:={|| (calias)->(dbclosearea()),(cpobla)->(dbclosearea()), (cCalles)->(dbclosearea()),.t. }

  ACTIVATE WINDOW oDlg 
   
  
             
return nil   

//-----------------------------------------------------------------------


Function Busquedaprov(oGet,oBrw,calias )
local nOrden := (obrw:calias)->(ordNumber())

(calias)->(dbseek(UPPER(oGet:assign() )))
oBrw:SetRowPos((obrw:calias)->(ORDKEYNO()))  


Return nil

//-----------------------------------------------------------------------//


function poblacion(nCod,odlg,cpobla,lvista,obrw2,cCalles)

local oWnd 
local oGet, cText := "Hello world", oBtn
local oChk, lTest := .T.
local obtn3,obtn2,obtn4
local osplit
local respath:=respath()+"/"

local oget1, oget2,oget3,oget4
local ctext2:= "yo"
local orden
local csay,osay1
local oseach	  
local lvista2:= .f.
local obrw3

local bchanged:= {|oGet| Busquedapobla(oGet,oBrw2,cpobla,ncod ) } 




sele (cpobla)
orden:=(cpobla)->(ordsetfocus(1))
if !Empty(ncod)
(cpobla)->(ordscope(0,nCod+space(60)))
(cpobla)->(ordscope(1,ncod+Replicate("z",60)))
endif

(cpobla)->(dbgotop())


oDlg:obar:aButtons[2]:disable()

oSearch:=oDlg:obar:aButtons[1]
oSearch:osearch:bchanged:= bChanged
oSearch:oSearch:setText("")	
osearch:ChangeLabel("buscar poblacion")

if !lvista	  

    lvista:= .t.

    oDlg:ChangeWidth(330)  


    @ 33,310 BROWSE oBrw2 FIELDS (cpobla)->poblacion,if((cpobla)->detalle == 9 , (cpobla)->Codpostal,"-->"  ) ; 
            HEADERS "Población","Codigo Postal"  OF oDlg ;
            SIZE 330 , (oDlg:nHeight-110) ALIAS cpobla  ;
            COLSIZES 210,900 AUTORESIZE nor(4,16)

endif   

WITH OBJECT oBrw2  


  :bLogicLen = { || ( cpobla )->( Ordkeycount() ) }

  :Refresh()

  :SetColEditable( 1, .f. ) 	 
  :SetColEditable( 2, .f. ) 	
  :SetRowHeight( 20 )
  :SetSelectorStyle( 1 )	 
  :SetGridLines( 1 )
  :SetIndicatorDescent(2)
  :bHeadclick:={|o, nhead| orden(nHead,o ) }

END

oBrw2:setDblClick()
oBrw2:baction:= {||if(detalle!=9,calles(ncod+str(detalle,5,0) ,oDlg,@lvista2,@obrw3,cCalles),) }
oBrw2:setfocus()

oBrw2:bWhen:= { || msginfo("hola"),.f. }


return nil   

//-----------------------------------------------------------------------//

function calles(nCod,oDlg,lvista2,obrw,cAlias)

local oWnd 
local oGet, cText := "Hello world", oBtn
local oChk, lTest := .T.
local obtn3,obtn2,obtn4
local osplit
local respath:=respath()+"/"

local oget1, oget2,oget3,oget4
local ctext2:= "yo"
local orden
local csay,osay1

local bchanged:= {|oGet| Busquedapobla(oGet,oBrw,calias,ncod ) } 


sele (calias)
orden:=(calias)->(ordsetfocus(1))
if !Empty(ncod)
(calias)->(ordscope(0,nCod+space(55)))
(calias)->(ordscope(1,ncod+Replicate("Z",55)))
endif

(cAlias)->(dbgotop())

if (calias)->(Ordkeycount()) == 0
Return nil
endif   

oSearch:=oDlg:obar:aButtons[1]
oSearch:osearch:bchanged:= bChanged
oSearch:oSearch:setText("")	
osearch:ChangeLabel("buscar calle")

if !lvista2

   oDlg:ChangeWidth(370)  

   lvista2:= .t.   

   @ 33,640 BROWSE oBrw FIELDS (calias)->calle ,"Desde :"+str((calias)->desdepar,5,0)+" A " +str((cAlias)->hastapar,5,0) ,(cAlias)->Codpostal ; 
            HEADERS "Calle", "Pares","Codigo Postal"  OF oDlg ;
            SIZE 370 , (oDlg:nHeight-110) ALIAS cAlias ;
            COLSIZES 200,200,200

endif


obrw:bLogicLen = { || ( obrw:cAlias )->( Ordkeycount() ) }

oBrw:SetColEditable( 1, .f. ) 	 
oBrw:SetColEditable( 2, .f. ) 	
oBrw:SetColEditable( 3, .f. ) 


oBrw:SetRowHeight( 20 )

oBrw:SetSelectorStyle(1)

oBrw:SetGridLines(1)

oBrw:SetIndicatorDescent(2)
oBrw:setfocus()



return nil   



