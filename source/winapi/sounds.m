#include <fivemac.h>

HB_FUNC( SOUNDOPEN )
{
   NSString * string = hb_NSSTRING_par( 1 );
   
   NSSound * sound =[[ [ NSSound alloc ] initWithContentsOfFile: string byReference:NO] autorelease ];

   hb_retnl( ( HB_LONG ) sound );  
}

HB_FUNC( SOUNDPLAY )
{
   NSSound * sound =  ( NSSound * ) hb_parnl( 1 );  

   [ sound play ];
}  
 
HB_FUNC( SOUNDISPLAY )
{
   NSSound * sound =  ( NSSound * ) hb_parnl( 1 );  
   
   hb_retl( ( HB_BOOL )  [sound isPlaying] ) ;
}  

HB_FUNC( SOUNDSTOP )
{
   NSSound * sound =  ( NSSound * ) hb_parnl( 1 );  
   
   [ sound stop ];
}  

HB_FUNC( SOUNDPAUSE )
{
   NSSound * sound =  ( NSSound * ) hb_parnl( 1 );  
   
   [ sound pause ];
} 

HB_FUNC( SOUNDRESUME )
{
   NSSound * sound =  ( NSSound * ) hb_parnl( 1 );  
   
   [ sound resume ];
} 

HB_FUNC( SOUNDSETVOL )
{
   NSSound * sound =  ( NSSound * ) hb_parnl( 1 );  
   
   [ sound setVolume: ( hb_parnl( 2 ) / 100.0 ) ] ;
}

HB_FUNC( SOUNDGETVOL )
{
   NSSound * sound =  ( NSSound * ) hb_parnl( 1 );
	 int iVol = [ sound volume ];
	    
   hb_retni( ( iVol * 100 ) );
}

HB_FUNC( SOUNDSETLOOP )
{
   NSSound * sound =  ( NSSound * ) hb_parnl( 1 );  

   [ sound setLoops: hb_parl( 2 ) ] ;
}
