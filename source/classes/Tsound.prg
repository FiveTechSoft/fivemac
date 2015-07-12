//
//  TSound.prg
//  fivemac
//
//  Created by Manuel Sanchez on 14/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TSound

   DATA  hWnd
   DATA  cFile
  
   METHOD New(cFile) CONSTRUCTOR

   METHOD Play() INLINE ( soundPlay(::hWnd) )
   METHOD Stop() INLINE soundStop(::hWnd) 
   METHOD Pause() INLINE soundPause(::hWnd) 
   METHOD Resume() INLINE soundResume(::hWnd) 
   METHOD SetLoop(lLoop) INLINE soundSetLoop(::hWnd,lLoop) 
   METHOD Volumen(nVol) INLINE soundSetVol(::hWnd,nVol )        // volumen de 0 a 100   
   METHOD GetVolumen() INLINE  SoundGetVol(::hWnd)
     
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New(cFile) CLASS TSound
    if !Empty(cFile)
        ::cFile:= cFile 
    else
        ::cFile:= CHOOSEFILE()
    endif
   ::hWnd:= soundOpen(::cFile )         
return Self

//----------------------------------------------------------------------------//
