#include "FiveMac.ch"


     
//----------------------------------------------------------------------------//

CLASS TiTunes 

   DATA hWnd

   METHOD New(nVolume)
   METHOD SetVol(nVol) INLINE iTunesSetVol(::hWnd,nVol)
   METHOD GetVol() INLINE iTunesGetVol(::hWnd)
   METHOD isRun() INLINE iTunesIsRun(::hWnd)
   METHOD Run()   INLINE iTunesRun(::hWnd)
   METHOD Quit()  INLINE iTunesQuit(::hWnd)
   METHOD Stop()  INLINE iTunesStop(::hWnd)
   METHOD Play()  INLINE itunesPlay(::hWnd) 
   METHOD SongName()  INLINE iTunesSongName(::hWnd)
   METHOD PlayPause() INLINE iTunesPlayPause(::hWnd)
   METHOD NextTrack() INLINE iTunesNextTrack(::hWnd)
   METHOD PreviousTrack() INLINE iTunesPreviousTrack(::hWnd)
   METHOD backTrack() INLINE iTunesbackTrack(::hwnd)
   METHOD GetTracks(cLibrary) 
   METHOD GetArtWork() INLINE iTunesGetArtWork(::hWnd )    
   
 ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New(nVolume) CLASS TiTunes
   
   ::hWnd = iTunesCreate()
   if !Empty(nVolume)
       ::setVol(nVolume)
   endif
      
return Self

//----------------------------------------------------------------------------//

METHOD GetTracks(cLibrary) CLASS TiTunes
local hNSArray
local nLen, i 
local aMovies:= {}
  
   if UPPER (cLibrary) == "MOVIES"
       cLibrary :=  "Movies"
   endif
   
   hNSArray:= iTunesGetTracks(::hWnd,"Movies")
   nLen:= ArrayLen( hNSArray  )  
      
   for i=1 to nLen
      aadd(aMovies, arrayGetStringIndex( hNSArray,i-1 ) )  
   Next 
   

Return nil 