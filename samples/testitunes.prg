// ----sample itunes control 
// --- @mastintin

#include "FiveMac.ch"

function Main()

   local oDlg   
   local cImgPath := UserPath() + "/fivemac/bitmaps/" 
   local cFile
   local oItunes
   local osay3, csay:=""
   local osay,oSlide
   local osay1,csay1
   local hImage
   local oImg
   
   DEFINE DIALOG oDlg TITLE "Testing itunes" ;
      FROM 70, 50 TO 500, 740
      
             
     cfile:= cImgPath+"fivetech.gif"
     
                     
   DEFINE ITUNES oItunes VOLUME 80 
   
    csay1:="Volumen :"+ str( oItunes:getvol() ) 
      
    @ 200,50 SAY osay PROMPT "Ahora suena ... " OF oDlg SIZE 250, 20    
    @ 200,150 SAY osay3 PROMPT csay OF oDlg SIZE 250, 20    
      
    osay3:setColor(CLR_BLUE ,CLR_BLACK )
    osay3:setBezeled(.t.,.t.)  
    osay3:SetSizeFont(14) 
    
  @ 140 , 20 SLIDER oSlide SIZE 460,20 OF oDlg AUTORESIZE 10
    oSlide:SetValue(oItunes:getvol() )
    oSlide:bChange := {||oItunes:setVol(oSlide:GetValue()),osay1:setText( "Volumen :"+ str(oSlide:GetValue()) ) }  
    
  @ 100,150 SAY osay1 PROMPT csay1 OF oDlg SIZE 250, 20      
    
                                                         
   oItunes:GetTracks("Movies")        
   
  @ 230, 50 IMAGE oImg OF oDlg SIZE 180, 180 
  
  oImg:setImage( oItunes:getArtWork() )
    
   
                                                                                                                                                                                                                                                                                                                 
                                                                                                                    
   @ 22, 20 BUTTON "play" OF oDlg ACTION ( if( !oItunes:isRun(), oItunes:run(),) , oItunes:play() ,osay3:setText(oItunes:SongName() ) )
   
   @ 22, 120 BUTTON "pause" OF oDlg ACTION ( if( oItunes:isRun(),  oItunes:playpause() , ), osay3:setText("" ) )
       
   @ 22, 220 BUTTON "stop" OF oDlg ACTION ( if( oItunes:isRun(),  oItunes:stop() , ), osay3:setText("" ) )
   
   @ 22, 320 BUTTON "<<" OF oDlg SIZE 50,30 ACTION ( if( oItunes:isRun(),  oItunes:PreviousTrack() , ), osay3:setText(oItunes:SongName() ),oImg:setImage( oItunes:getArtWork() ) )
         
   @ 22, 370 BUTTON ">>" OF oDlg SIZE 50,30 ACTION ( if( oItunes:isRun(),  oItunes:NextTrack() , ), osay3:setText(oItunes:SongName() ),oImg:setImage( oItunes:getArtWork() ) )  
        
   @ 22, 420 BUTTON "Cancel" OF oDlg ACTION oDlg:End()
   
     
   ACTIVATE DIALOG oDlg CENTERED
   
   
   
return nil   
 