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
				 

//-----------------------------------------------------------------//

REQUEST HB_LANG_ES
REQUEST HB_CODEPAGE_ESWIN

function Main()

   local oBar
   PUBLIC respath:=respath()+"/"
   PUBLIC cDbfpath:= apppath()+"/dbf/"

SET EPOCH TO 1990
SET CENTURY ON
SET DATE ITALIAN
SET( _SET_CODEPAGE, "ESWIN" )

//setencoding(1)


   BuildMenu() // Build the main menu
  
   DEFINE WINDOW oWnd TITLE "Applicatión login test"
   
   ownd:fullscreen()


   if Logon()

      DEFINE TOOLBAR oBar OF oWnd

      DEFINE BUTTON OF oBar PROMPT "Indices" ;
         ACTION indices() ;
         TOOLTIP "Crear nuevos indices" ;
	       IMAGE respath+"PrefApp.tiff"
	
	   DEFINE BUTTON OF oBar PROMPT "Familias" ;
	       ACTION Familias() ;
         TOOLTIP "Open a file" ;
	       IMAGE "Folder"
		   
       DEFINE BUTTON OF oBar PROMPT "Provincias" ;
	       ACTION provincias() ;
         TOOLTIP "Open a file" ;
	       IMAGE "Folder"

      oBar:AddSeparator()	
       		

      DEFINE BUTTON OF oBar PROMPT "Exit" ;
         ACTION oWnd:End() ;
         TOOLTIP "Exit from the application" ;
         IMAGE respath+"exit.png"
		 	
	   
	   DEFINE MSGBAR OF oWnd
   
      oWnd:Maximize()

    
      ACTIVATE WINDOW oWnd ;
         VALID MsgYesNo( "Want to end ?" )
   else
      MsgInfo( "non authorized user" )
   endif

return nil

//-----------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM "MyAppName"     // This becomes the name of your prg
      MENU
         MENUITEM "About" ACTION MsgInfo( "Application developed with FiveMac", "Your application name" )
		 SEPARATOR
	      MENUITEM "Exit" ACTION oWnd:End() ACCELERATOR "e"
		 
      ENDMENU

      MENUITEM "Maestros"
         MENU
            MENUITEM "Crear indices" ACTION Indices()
			SEPARATOR
	          MENUITEM "Familias" ACTION Familias()
			  MENUITEM "Provincias" ACTION provincias()
	    ENDMENU

      MENUITEM "Reports"
      MENU
         MENUITEM "Search"
	       MENUITEM "Replace"
      ENDMENU

      MENUITEM "Utilities"
      MENU
         MENUITEM "Editor" ACTION Editor()
         MENUITEM "Help" ACTION MsgInfo( "Help" )
	     MENUITEM "Topic Help"
         SEPARATOR
         MENUITEM "Calculator" ACTION MacExec( "calculator" )
         MENUITEM "TextEdit" ACTION MacExec( "textedit" )
      ENDMENU

ENDMENU

return nil

//-----------------------------------------------------------------------//

function Logon()

   local oDlg, lSuccess := .T.
   local cLogin := UserName(), cPassw := ""
   local respath:= respath()+"/"
   local oimg 
   local oget1
   local oget2
   
   DEFINE DIALOG oDlg TITLE "Please Logon" ;
      FROM 0, 0 TO 200, 450

   @ 76, 30 IMAGE oImg OF oDlg SIZE 107, 91 FILENAME respath+"Pass.png"
   
   @ 130, 190 SAY "Login:" OF oDlg SIZE 80, 20

   @ 130, 240 GET oget1 VAR  cLogin OF oDlg SIZE 160, 20 ROUNDED VALID ( MsgInfo("sale") ,.t. )

   @ 90, 170 SAY "Password:" OF oDlg SIZE 100, 20

   @ 90, 240 GET oGet2 VAR cPassw OF oDlg SIZE 160, 20 PASSWORD ROUNDED
    
   @ 20, 200 BUTTON "OK" OF oDlg ACTION oDlg:End()

   @ 20, 320 BUTTON "Cancel" OF oDlg ACTION ( lSuccess := .F., oDlg:End() )
	
   ACTIVATE DIALOG oDlg CENTERED

   if lSuccess
      if CPassw != "000"
	      MsgInfo( "Acceso no permitido" )
		  lSuccess := .f.
	  endif
   endif

return lSuccess

//-----------------------------------------------------------------------//

function Familias()

   local oWnd 
   local oGet, cText := "Hello world", oBtn
   local oChk, lTest := .T.
   local obtn3,obtn2,obtn4
   local osplit,obrw,oDlg
   local respath:=respath()+"/"
   local cAlias:=Abrimos("Familias")
    local oget1, oget2,oget3,oget4
	local ctext2:= "yo"
	local orden
	local csay,osay1
	
   local bchanged:= {|oGet| Busqueda(oGet,oBrw,calias ) } 
	
   sele (calias)
   orden:=(calias)->(ordsetfocus(2))
   (cAlias)->(dbgotop())
     
			     
 DEFINE WINDOW oDlg TITLE "Gestion de Familias" ;
      FROM 470, 650 TO 880, 1280
 
 odlg:fullscreen()
 
// @ 3,34 GET oget VAR cText OF oDlg SIZE 200, 26 SEARCH
 
//  oget:bchanged:= {||   (calias)->(dbseek(UPPER(oget:assign() ))) ,  BRWSETROWPOS(obrw:hwnd, (calias)->(ORDKEYNO())) } 
 
 DEFINE TOOLBAR oBar OF oDlg

      DEFINE BUTTON OF oBar PROMPT "Indices" ;
         ACTION indices() ;
         TOOLTIP "Crear nuevos indices" ;
	       IMAGE respath+"PrefApp.tiff"
	
	   DEFINE BUTTON OF oBar PROMPT "Familias" ;
	       ACTION Familias() ;
         TOOLTIP "Open a file" ;
	       IMAGE "Folder"

      oBar:AddSeparator()	


      DEFINE BUTTON OF oBar PROMPT "Exit" ;
         ACTION oDlg:End() ;
         TOOLTIP "Salir de Familias" ;
         IMAGE respath+"exit.png"
		
		     	   	
	   oBar:AddSpaceFlex()
	   obar:Addsearch( "busca", "Buscar",bchanged ) 			
      
       
  DEFINE MSGBAR OF oDlg SIZE 32  

  

 @ 33,0 BROWSE oBrw FIELDS str((calias)->familia,3,0) ,(calias)->descripcio ; 
HEADERS "Codigo", "Archivos" OF oDlg SIZE 280 , (oDlg:nHeight-110) ALIAS cAlias ;
AUTORESIZE 16  COLSIZES 40,200 
    
	  WITH OBJECT oBrw  

         :SetColEditable( 1, .f. ) 	 
         :SetColEditable( 2, .f. ) 	
         :SetRowHeight( 20 )
         :SetSelectorStyle( 1 )	 
         :SetGridLines( 1 )
         :bAction := {|| ( FamEdit((calias)->(Recno())) ) }
         :bHeadclick:={|o, nhead| orden(nHead,obrw) }

      END

     obrw:SetIndicatorDescent(2)
	  	 
  
	  obrw:bchange:= {|| (calias)->(ORDKEYGOTO(obrw:nrowPos())),  oget2:setText((calias)->descripcio) ,oget1:setText(str((calias)->familia,3,0)) } 
	 
		
 
   @ 324, 340 SAY oget3 PROMPT "Codigo:" OF oDlg 

    oGet3:SetTextColor(50,50,50)  
   
	   
   @ 300, 340 SAY oget1 PROMPT cText OF oDlg SIZE 200 , 26 RAISED

   oGet1:setText(str((calias)->familia,3,0)) 

   oGet1:SetSizeFont(16) 
   oGet1:Enabled()
	
   @ 274, 340 SAY oget4 PROMPT "Descripcion:" OF oDlg  

   oGet4:SetTextColor(50,50,50)  
   

   @ 250, 340 SAY oget2 PROMPT cText2 OF oDlg SIZE 200 , 26 RAISED   

     oget2:setText((calias)->descripcio) 

     oGet2:SetSizeFont(16) 

	
   @ 4 , 4 BUTTON obtn3 PROMPT "+" OF oDlg ACTION ( oGet1:Disabled(), Msginfo("alta")   ) ;
          SIZE 24,24 STYLE 11 

   @ 4 , 250 BUTTON obtn4 PROMPT "Editar" OF oDlg ACTION ( FamEdit((calias)->(Recno())) ) ;
          SIZE 60,24 STYLE 11 AUTORESIZE 1   
    
    
   @ 4 , 350 BUTTON obtn PROMPT "1" OF oDlg ACTION (orden(1,obrw)) ;
          SIZE 24,24 STYLE 11 AUTORESIZE 1  

       	  
   @ 4 , 380 BUTTON obtn2 PROMPT "2" OF oDlg ACTION (orden(2,obrw)) ;
          SIZE 24,24 STYLE 11 AUTORESIZE 1 	
	
			 
   @ 2 , 420 SAY osay1 PROMPT ( str((calias)->(Reccount()),5,0)+ " Registros" ) OF oDlg ;
          RAISED SIZE 100,20 AUTORESIZE 1		
		

      oDlg:bValid:={|| (calias)->(dbclosearea()),.t. }
	  
   ACTIVATE WINDOW oDlg 
   
   
   
             
return nil   

//-----------------------------------------------------------------------

function orden(norden,obrw)
local bakorden:= (obrw:calias)->(ordNumber())
 (obrw:cAlias)->(ordsetfocus(norden))
 if bakorden != nOrden
  oBrw:SetIndicatorDescent( nOrden )
	oBrw:DelIndicator( bakorden )
	obrw:refresh() 
endif 
Return nil

//-----------------------------------------------------------------------

Function Busqueda(oGet,oBrw,calias )
local nOrden := (obrw:calias)->(ordNumber())
if nOrden == 2
(calias)->(dbseek(UPPER(oGet:assign() )))
   oBrw:SetRowPos((obrw:calias)->(ORDKEYNO())) 
else
  (calias)->(dbseek(Val(oGet:assign() ))) 
   obrw:Gotop()
   oBrw:SetRowPos((obrw:calias)->(ORDKEYNO()))    
endif

Return nil

//-----------------------------------------------------------------------//

function FamEdit(nrec)


   local oWnd 
   local oGet, cText := "Hello world", oBtn
   local oChk, lTest := .T.
   local oCbx, cVar  := "One"
   local osplit,obrw
   local ncod,cDescrip
   local oget1, oget2
   local oBtn1,oBtn2
   local cAlias:=Abrimos("Familias")   
  local  oSay1, oSay2
   

     sele (calias)
   (calias)->(dbgotop())
   (calias)->(ordsetfocus(1))
   (cAlias)->(dbgotop())
   (calias)->(dbgoto(nrec))
   nCod:=str((calias)->familia,3,0)
   cDescrip := (calias)->descripcio 



DEFINE WINDOW oWnd ;
TITLE "Familias" ;
SIZE 430, 213 FLIPPED



@ 27, 26 SAY oSay1 PROMPT "código" OF oWnd ;
SIZE 90, 20 ;
AUTORESIZE 0 // UTF8

@ 86, 29 SAY oSay2 PROMPT "Familia" OF oWnd ;
SIZE 90, 20 ;
AUTORESIZE 0


@ 49, 27 GET oGet1 VAR nCod OF oWnd ;
SIZE 120, 20

@ 108, 27 GET oGet2 VAR cDescrip OF oWnd ;
SIZE 369, 20


@ 153, 331 BUTTON oBtn1 PROMPT "Salir" OF oWnd ;
SIZE 90, 30 ACTION (oWnd:end() )

@ 153, 240 BUTTON oBtn2 PROMPT "Grabar" OF oWnd ;
SIZE 90, 30 ACTION grabafam(cAlias,oGet1,oGet2)

 oWnd:bValid:={|| (calias)->(dbclosearea()),.t. }  

ACTIVATE WINDOW oWnd CENTERED 

oWnd:setfocus()

oGet1:SetFocus()
/*
   DEFINE WINDOW oWnd RESOURCE "Familias"
   
      
   REDEFINE GET oGet1 VAR ncod ID 10 OF oWnd
   
    REDEFINE GET oGet2 VAR cDescrip ID 12 OF oWnd
   
     
   REDEFINE BUTTON oBtn1 ID 40 OF oWnd ACTION grabafam(cAlias,oGet1,oGet2)  
   REDEFINE BUTTON oBtn2 ID 42 OF oWnd ACTION (oWnd:end() )
   
   
   oWnd:bValid:={|| (calias)->(dbclosearea()),.t. }   
   
   ACTIVATE WINDOW oWnd 

    oWnd:setfocus()
   
   oGet1:SetFocus()
  */
			      
return nil   

//-----------------------------------------------------------------------//

Function  grabafam(cAlias,oGet1,oGet2)
if (calias)->(rlock())
      
(cAlias)->descripcio := Upper(oGet2:Assign() )
	(cAlias)->familia  := val(oGet1:Assign())
  (cAlias)->(dbunlock())
	oget1:settext(str((calias)->familia,3,0))
	oGet2:settext((cAlias)->descripcio, .t.)
else
   msginfo( "no se ha podido grabar el registro")
   
endif


Return nil



//-----------------------------------------------------------------------


Function Busquedapobla(oGet,oBrw,calias,nCod )
local nOrden := (obrw:calias)->(ordNumber())

(calias)->(dbseek(ncod+UPPER(oGet:assign() )))
 BRWSETROWPOS(obrw:hwnd, (obrw:calias)->(ORDKEYNO())) 


Return nil



/*
function calles(nCod)

   local oWnd 
   local oGet, cText := "Hello world", oBtn
   local oChk, lTest := .T.
   local obtn3,obtn2,obtn4
   local osplit,obrw,oDlg
   local respath:=respath()+"/"
   local cAlias:=Abrimos("calles")
    local oget1, oget2,oget3,oget4
	local ctext2:= "yo"
	local orden
	local csay,osay1
	
   local bchanged:= {|oGet| Busquedapobla(oGet,oBrw,calias,ncod ) } 
	
	pausa(nCod)
	
   sele (calias)
   orden:=(calias)->(ordsetfocus(1))
   if !Empty(ncod)
       (calias)->(ordscope(0,nCod+space(55)))
	   (calias)->(ordscope(1,ncod+Replicate("Z",55)))
      endif
   
   (cAlias)->(dbgotop())
     
			     
 DEFINE WINDOW oDlg TITLE "Gestion de Poblaciones" ;
      FROM 570, 750 TO 980, 1380
 
 

 
 DEFINE TOOLBAR oBar OF oDlg

      DEFINE BUTTON OF oBar PROMPT "Indices" ;
         ACTION indices() ;
         TOOLTIP "Crear nuevos indices" ;
	       IMAGE respath+"PrefApp.tiff"
	
	   DEFINE BUTTON OF oBar PROMPT "Provincia" ;
	       ACTION provincias() ;
         TOOLTIP "Open a file" ;
	       IMAGE "./../bitmaps/folder.png"

      oBar:AddSeparator()	


      DEFINE BUTTON OF oBar PROMPT "Exit" ;
         ACTION oDlg:End() ;
         TOOLTIP "Salir de poblaciones" ;
         IMAGE respath+"exit.png"
		
		     	   	
	   oBar:AddSpaceFlex()
	   obar:Addsearch( "busca", "Buscar",bchanged ) 			
      
       SETMSGBARHEIGHT(oDlg:hwnd,32)
	  	   
	   
  
   

 @ 33,0 BROWSE oBrw FIELDS (calias)->calle ,"Desde :"+str((calias)->desdepar,5,0)+" A " +str((cAlias)->hastapar,5,0) ,(cAlias)->Codpostal ; 
      HEADERS "Calle", "Pares","Codigo Postal"  OF oDlg SIZE 350 , (oDlg:nHeight-110) ALIAS cAlias 
    
		 
	 oBrw:SetColEditable( 1, .f. ) 	 
	 oBrw:SetColEditable( 2, .f. ) 	
	  oBrw:SetColEditable( 3, .f. ) 
	  		   
	 BRWSETCOLWIDTH(oBrw:hWnd,1,200 )
	 BRWSETCOLWIDTH(oBrw:hWnd,2,200 )	
	  BRWSETCOLWIDTH(oBrw:hWnd,3,200 )	
	  
	    
	 BRWSETROWHEIGHT(oBrw:hWnd,20)
     BRWSETSELECTORSTYLE(oBrw:hWnd,1)
	 BRWSETGRIDLINES(oBrw:hWnd,1)
	 BRWSETINDICATORDESCENT(oBrw:hWnd,2)
	  	 
 
	 
	//  obrw:bchanged:= {|| (calias)->(ORDKEYGOTO(obrw:nrowPos())),  oget2:setText((calias)->provincia) ,oget1:setText((calias)->poblacion) } 
	 
	//  obrw:bHeadclick:={|o, nhead| orden(nHead,obrw) }
	  
	
	
 
   @ 324, 440 SAY oget3 PROMPT "Calle:" OF oDlg 
   
	   
   @ 300, 440 SAY oget1 PROMPT cText OF oDlg SIZE 200 , 26 RAISED
    oget1:setText((calias)->calle) 
    SAYSETSIZEFONT(oget1:hWnd,16) 	
	
	  TXTsetEnabled(oget1:hWnd)
	   
    SAYSETCOLOR(oget3:hWnd,50,50,50)  
  
   @ 274, 440 SAY oget4 PROMPT "cpostal:" OF oDlg  
   
   @ 250, 440 SAY oget2 PROMPT cText2 OF oDlg SIZE 200 , 26 RAISED   
     oget2:setText((calias)->codpostal) 
    SAYSETSIZEFONT(oget2:hWnd,16) 
		   
    SAYSETCOLOR(oget4:hWnd,50,50,50)  
	
	@ 4 , 4 BUTTON obtn3 PROMPT "+" OF oDlg ACTION ( TXTsetDisabled(oget1:hWnd ) , Msginfo("alta") ) SIZE 24,24
   
   BTNSETBEZEL(obtn3:hwnd,11)

  
    @ 4 , 250 BUTTON obtn4 PROMPT "Editar" OF oDlg ACTION ( Another((calias)->(Recno())) ) SIZE 60,24    
    BTNSETBEZEL(obtn4:hwnd,11)    
	
     BTNAUTOAJUST(obtn4:hwnd,1) 
  	 
   @ 4 , 350 BUTTON obtn PROMPT "1" OF oDlg ACTION (orden(1,obrw)) SIZE 24,24    
    BTNSETBEZEL(obtn:hwnd,11)    

     BTNAUTOAJUST(obtn:hwnd,1) 
	  
    @ 4 , 380 BUTTON obtn2 PROMPT "2" OF oDlg ACTION (orden(2,obrw))  SIZE 24,24	
	   BTNSETBEZEL(obtn2:hwnd,11)
			 BTNAUTOAJUST(obtn2:hwnd,1) 
		 
		@ 1 , 420 SAY osay1 PROMPT ( str((calias)->(Reccount()),5,0)+ " Registros" ) OF oDlg RAISED SIZE 100,20		
	
		
 //  BRWSETDBLACTION(obrw:hWnd) 
	// obrw:baction:= {|| Another((calias)->(Recno())) }

				
						
     TXTAUTOAJUST(osay1:hwnd,1)
							  	      
  	oDlg:bValid:={|| (calias)->(dbclosearea()) }
	  
   ACTIVATE WINDOW oDlg 
   
   
   
             
return nil  

*/ 
