#include "FiveMac.ch"

function Main()

   local oDlg
   local oGroup
   local obtn1
   local obtn2,obtn3
   local obtn4
   local obtn5,obtn6
   local obtnfin
   local nAncla:= 0
   
   DEFINE DIALOG oDlg TITLE "Testing Anclas" ;
      FROM 270, 350 TO 510, 740
   
   @ 60, 70 GROUP oGroup PROMPT "" SIZE 250, 120 OF oDlg

   oGroup:setStyle(4) 
          
   
   @ 4, 180 BTNBMP obtn1 FILENAME ( UserPath() + "/fivemac/bitmaps/VertOrigin.png") OF oDlg ACTION (.t. ) SIZE 20,55
   
   oBtn1:setType(6)
  // oBtn1:SetBezelStyle(8)
   
   
  @ 182, 180 BTNBMP obtn4 FILENAME ( UserPath() + "/fivemac/bitmaps/VertOrigin.png") OF oDlg ACTION (.t. ) SIZE 20,55
   
    oBtn4:setType(6)
         
  @ 114, 4 BTNBMP obtn2 FILENAME ( UserPath() + "/fivemac/bitmaps/HorzOrigin.png") OF oDlg ACTION ( .t. ) SIZE 65,20
  
   oBtn2:setType(6)
      
  @ 114, 322 BTNBMP obtn3 FILENAME ( UserPath() + "/fivemac/bitmaps/HorzOrigin.png") OF oDlg ACTION (.t. ) SIZE 65,20 
  
   oBtn3:setType(6)
   
   
    @ 82, 76 BTNBMP obtn6 FILENAME ( UserPath() + "/fivemac/bitmaps/VertSize.png") OF oDlg ACTION (.t.) SIZE 20,96
   
    oBtn6:setType(6)
   
    @ 64, 74 BTNBMP obtn5 FILENAME ( UserPath() + "/fivemac/bitmaps/HorzSize.png") OF oDlg ACTION ( .t. ) SIZE 242,20
  
   oBtn5:setType(6)
   
   
      
@ 4, 340 BUTTON obtnfin PROMPT "ok" OF oDlg ACTION ( msginfo(Sumaanclas(obtn1,obtn2,obtn3,obtn4,obtn5,obtn6)) ) SIZE 45,40 

       
   ACTIVATE DIALOG oDlg CENTERED
   
   
   
return nil   
 
Function SumaAnclas(obtn1,obtn2,obtn3,obtn4,obtn5,obtn6)
 local nAncla:= 0 
 local nState1:=BTNGETSTATE(obtn1:hWnd)
 local nState3:=BTNGETSTATE(obtn3:hWnd)
 local nState2:=BTNGETSTATE(obtn2:hWnd)
 local nState4:=BTNGETSTATE(obtn4:hWnd)
 local nState5:=BTNGETSTATE(obtn5:hWnd)
 local nState6:=BTNGETSTATE(obtn6:hWnd)
 
  if  nState1== 1
      nAncla=nancla+8
 endif
 if  nState3== 1
      nAncla=nancla+1
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