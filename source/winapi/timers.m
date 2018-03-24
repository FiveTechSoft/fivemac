#include <fivemac.h>

// - ( void ) OnTimerEvent : ( NSTimer * ) timer

HB_FUNC( TIMERCREATE ) // hTimer
{
   NSTimer * timer= [ [ NSTimer scheduledTimerWithTimeInterval : hb_parnl( 1 ) target : GetView( ( NSWindow * ) hb_parnl( 2 ) ) selector : @selector ( OnTimerEvent: ) userInfo : NULL repeats : hb_parl( 3 ) ] retain ];

   hb_retnl( ( HB_LONG ) timer );
}

HB_FUNC( TIMEREND )
{
   NSTimer * timer = ( NSTimer * ) hb_parnl( 1 );
    
   [ timer invalidate ];
   [ timer release ];
}


HB_FUNC( TIMERFIRE )
{
    NSTimer * timer = ( NSTimer * ) hb_parnl( 1 );
      
    [ timer fire ];
 
}

HB_FUNC( TIMERISVALID )
{
    NSTimer * timer = ( NSTimer * ) hb_parnl( 1 );
    
    hb_retl( [ timer isValid ] ) ;
    
}

/*
HB_FUNC( TIMERDATECREATE ) // hTimer
{
    NSString * string =hb_NSSTRING_par( 1 ) ;
    NSDateFormatter * formatter = [ [ [ NSDateFormatter alloc ] init ] autorelease ];
    
    [ formatter setDateStyle : NSDateFormatterShortStyle ];
    
    
    NSTimer * timer= [ [ NSTimer initWithFireDate: [formatter dateFromString : string ]  interval : hb_parnl( 2 ) target : GetView( ( NSWindow * ) hb_parnl( 3 ) ) selector : @selector ( OnTimerEvent: ) userInfo : NULL repeats : hb_parl( 4 ) ] retain ];
    
    hb_retnl( ( HB_LONG ) timer );
}
*/
