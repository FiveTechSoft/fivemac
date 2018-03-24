#include <fivemac.h>

HB_FUNC( SEGMENTCREATE ) 
{
    NSSegmentedControl * segment = [ [ NSSegmentedControl alloc ] 
                                    initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
    
	NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
    
    [ GetView( window ) addSubview : segment ];
	
	[ segment setAction : @selector( BtnClick: ) ];
    
    hb_retnl( ( HB_LONG ) segment );
} 

HB_FUNC( SEGMENTRESCREATE ) 
{
    NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
    NSSegmentedControl * segment  = (NSSegmentedControl *) [  GetView( window ) viewWithTag: hb_parnl( 2 ) ];
    
    [ GetView( window ) addSubview : segment ];
	[ segment setAction : @selector( BtnClick: ) ];
    
    hb_retnl( ( HB_LONG ) segment );
} 


HB_FUNC( SEGMENTSETSTYLE )
{
    
	NSSegmentedControl * segment = (NSSegmentedControl *) hb_parnl( 1 );
    
    [ segment setSegmentStyle : hb_parnl( 2 ) ];
}   


HB_FUNC( SEGMENTSETTRACK )
{
	NSSegmentedControl * segment = (NSSegmentedControl *) hb_parnl( 1 );
    [ [segment cell ] setTrackingMode : hb_parnl( 2 ) ];
}   



HB_FUNC( SEGMENTSETCOUNT )
{
	NSSegmentedControl * segment = (NSSegmentedControl *) hb_parnl( 1 );
    [segment setSegmentCount: hb_parnl( 2 ) ];
}   


HB_FUNC( SEGMENTSETLABEL )
{
	
	NSSegmentedControl * segment = (NSSegmentedControl *) hb_parnl( 1 );
    NSString * string = hb_NSSTRING_par( 3 ) ;
    [ segment setLabel: string forSegment: hb_parnl( 2 ) ];
}   

HB_FUNC( SEGMENTSETSELECT )
{
	NSSegmentedControl * segment = (NSSegmentedControl *) hb_parnl( 1 );
	[ segment setSelectedSegment: hb_parnl( 2 ) ];
} 

HB_FUNC( SEGMENTSELECT )
{
	NSSegmentedControl * segment = (NSSegmentedControl *) hb_parnl( 1 );
	int numitem =[ segment selectedSegment ] ;
    hb_retni(numitem);
} 


HB_FUNC( SEGMENTSETENABLED )
{
	NSSegmentedControl * segment = (NSSegmentedControl *) hb_parnl( 1 );
    [ segment setEnabled: hb_parl( 2 ) forSegment: hb_parnl( 3 ) ];    
} 

HB_FUNC( SEGMENTSETWIDTH )
{
	NSSegmentedControl * segment = (NSSegmentedControl *) hb_parnl( 1 );
    [ segment setWidth: hb_parnl( 2 ) forSegment: hb_parnl( 3 ) ];
}

HB_FUNC( SEGMENTSETIMAGE )
{
	NSSegmentedControl * segment = (NSSegmentedControl *) hb_parnl( 1 );
    NSString * string = hb_NSSTRING_par( 2 ) ;
    
    [ segment setImage:[ [ NSImage alloc ] initWithContentsOfFile : string ] forSegment: hb_parnl( 3 ) ];
    
    
} 

HB_FUNC( SEGMENTSETIMAGESCALING )
{
	NSSegmentedControl * segment = (NSSegmentedControl *) hb_parnl( 1 );
    [ segment setImageScaling: NSImageScaleProportionallyDown forSegment: hb_parnl( 2 ) ];
  } 


HB_FUNC( SEGMENTSETMENU )
{
	NSSegmentedControl * segment = (NSSegmentedControl *) hb_parnl( 1 );
    NSMenu * menu = (NSMenu *) hb_parnl( 2 );
    [ segment setMenu: menu forSegment: hb_parnl( 3 ) ];
} 





