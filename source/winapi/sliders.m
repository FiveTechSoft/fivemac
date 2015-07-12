#include <fivemac.h>

HB_FUNC( SLIDERCREATE ) // hWnd
{
   NSSlider * slider = [ [ NSSlider alloc ] 
 			           initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );

   [ GetView( window ) addSubview : slider ]; 
   [slider setMinValue: 0 ];      
   [slider setMaxValue:100];
   [ slider setAction : @selector( SliderChanged: ) ];
   hb_retnl( ( HB_LONG ) slider);
}

HB_FUNC( SLIDERRESCREATE ) 
{
    NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
    NSSlider  * slider  = (NSSlider *) [  GetView( window ) viewWithTag: hb_parnl( 2 ) ];
    
   //  [ GetView( window ) addSubview : slider ]; 
   
   [ slider setAction : @selector( SliderChanged: ) ];
    
 	hb_retnl( ( HB_LONG ) slider );	 			
}


HB_FUNC( SLIDERMINMAXVALUE ) 
{ 
  NSSlider * slider = ( NSSlider * ) hb_parnl( 1 );
  
  [slider setMinValue:hb_parni( 2 )];      
  [slider setMaxValue:hb_parni( 3 )];

}



HB_FUNC( SLIDERSETTICKMARKS ) 
{ 
  NSSlider * slider = ( NSSlider * ) hb_parnl( 1 );
  
  [slider setNumberOfTickMarks:hb_parni( 2 )];      
  
}



HB_FUNC( CIRCULARSLIDER ) 
{ 
  NSSlider * slider = ( NSSlider * ) hb_parnl( 1 );
  
  [[slider cell] setSliderType:NSCircularSlider];

}

HB_FUNC( SLIDERSETVALUE ) 
{ 
    NSSlider * slider = ( NSSlider * ) hb_parnl( 1 );
    [slider setIntValue:  hb_parni( 2 )];     
}

HB_FUNC( GETSLIDERVALUE ) 
{ 
  NSSlider * slider = ( NSSlider * ) hb_parnl( 1 );
      
   int   sliderValue = [ slider intValue ];
   
    
  //NSLog( @"slider value = %i", sliderValue );
  
  hb_retni(sliderValue);
   
}

 