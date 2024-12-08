#include <fivemac.h>

HB_FUNC( PROGRESSCREATE ) // hWnd
{
   NSProgressIndicator * progressIndicator = [ [ NSProgressIndicator alloc ] 
 			           initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );

   [ GetView( window ) addSubview: progressIndicator ];
   
   [ progressIndicator setUsesThreadedAnimation: NO ];
   	
   [ progressIndicator setDoubleValue: hb_parnl( 6 ) ];

   [ progressIndicator setIndeterminate: NO ];
   
   hb_retnl( ( HB_LONG ) progressIndicator );
}

HB_FUNC( PROGRESSUPDATE ) 
{ 
   NSProgressIndicator * progressIndicator = ( NSProgressIndicator * ) hb_parnl( 1 );
  
  [ progressIndicator setDoubleValue: hb_parnl( 2 ) ];
}

HB_FUNC( PROGRESSSETMAX )
{
	NSProgressIndicator * progressIndicator = ( NSProgressIndicator * ) hb_parnl( 1 );
	
	[ progressIndicator setMaxValue: hb_parnl( 2 ) ];
}

HB_FUNC( PROGRESSSETMIN )
{
	NSProgressIndicator * progressIndicator = ( NSProgressIndicator * ) hb_parnl( 1 );
	
	[ progressIndicator setMinValue: hb_parnl( 2 ) ];
}

HB_FUNC( PROGRESSINCREMEN )
{
	NSProgressIndicator * progressIndicator = ( NSProgressIndicator * ) hb_parnl( 1 );
	
	[ progressIndicator incrementBy: hb_parnl( 2 ) ];
}

HB_FUNC( PROGRESSSETSPIN )
{
   NSProgressIndicator * progressIndicator = ( NSProgressIndicator * ) hb_parnl( 1 );
	
   [ progressIndicator setStyle: NSProgressIndicatorStyleSpinning ];
}

HB_FUNC( PROGRESSSETBAR )
{
	 NSProgressIndicator * progressIndicator = ( NSProgressIndicator * ) hb_parnl( 1 );
	
   [ progressIndicator setStyle:  NSProgressIndicatorStyleBar ];
}

HB_FUNC( PROGRESSSETINDETERMINATE )
{
	 NSProgressIndicator * progressIndicator = ( NSProgressIndicator * ) hb_parnl( 1 );
	
	 [ progressIndicator setIndeterminate: hb_parl( 2 ) ];
}

HB_FUNC( PROGRESSINDETERMINATE )
{
	 NSProgressIndicator * progressIndicator = ( NSProgressIndicator * ) hb_parnl( 1 );
	
	 hb_retl( ( BOOL ) [ progressIndicator isIndeterminate ] );
}

HB_FUNC( PROGRESSSTARTANIME )
{
	NSProgressIndicator * progressIndicator = ( NSProgressIndicator * ) hb_parnl( 1 );
	
	[ progressIndicator startAnimation: nil ];   //falta el sender
}

HB_FUNC( PROGRESSSTOPANIME )
{
	NSProgressIndicator * progressIndicator = ( NSProgressIndicator * ) hb_parnl( 1 );
	
	[ progressIndicator stopAnimation: nil  ];  //falta el sender
}

HB_FUNC( PROGRESSSETBEZELED )
{
	NSProgressIndicator * progressIndicator = ( NSProgressIndicator * ) hb_parnl( 1 );
	
	[ progressIndicator setBezeled: hb_parl( 2 ) ];
}
    
HB_FUNC( PROGRESSTINTDEFAULT )
{
	NSProgressIndicator * progressIndicator = ( NSProgressIndicator * ) hb_parnl( 1 );
    [ progressIndicator setControlTint: NSDefaultControlTint  ];
}

HB_FUNC( PROGRESSTINTBLUE )
{
	NSProgressIndicator * progressIndicator = ( NSProgressIndicator * ) hb_parnl( 1 );
    [ progressIndicator setControlTint: NSBlueControlTint ];
}

HB_FUNC( PROGRESSTINTGRAFITE )
{
	NSProgressIndicator * progressIndicator = ( NSProgressIndicator * ) hb_parnl( 1 );
    [ progressIndicator setControlTint: NSGraphiteControlTint ];
}

HB_FUNC( PROGRESSTINTCLEAR )
{
	NSProgressIndicator * progressIndicator = ( NSProgressIndicator * ) hb_parnl( 1 );
    [ progressIndicator setControlTint: NSClearControlTint ];
}


