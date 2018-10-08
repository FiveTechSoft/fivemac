#include <fivemac.h>

HB_FUNC( VIEWSETAUTORESIZE )
{
   NSView * view = ( NSView * ) hb_parnl( 1 );

   if( [ [ view class ] isSubclassOfClass: [ NSTableView class ] ] )
      view = [ view enclosingScrollView ];
   
	 [ view setAutoresizingMask: hb_parnl( 2 ) ];	
}

HB_FUNC( VIEWAUTORESIZE )
{
   NSView * view = ( NSView * ) hb_parnl( 1 );

   if( [ [ view class ] isSubclassOfClass: [ NSTableView class ] ] )
      view = [ view enclosingScrollView ];
   
	 hb_retnl( [ view autoresizingMask ] );	
}

HB_FUNC( VIEWSETBACKCOLOR )
{
    NSView * view = ( NSView * ) hb_parnl( 1 );
    NSColor * color = ( NSColor * ) hb_parnl( 2 );
    view.layer.backgroundColor = color.CGColor;
 //   [  view setBackgroundColor: color ];
}

HB_FUNC( VIEWSETSIZE )
{
   NSView * view = ( NSView * ) hb_parnl( 1 );
   
   [ view setFrameSize: NSMakeSize( hb_parnl( 2 ), hb_parnl( 3 ) ) ];  
}	

HB_FUNC( VIEWHIDE )
{
   NSView * window = ( NSView * ) hb_parnl( 1 );
    
   [ window setHidden: YES ];           
}     

HB_FUNC( VIEWSHOW )
{
   NSView * window = ( NSView * ) hb_parnl( 1 );
   
   [ window setHidden: NO ];         
} 

HB_FUNC( VIEWSETTOOLTIP )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 );
   
   [ ( NSView * ) window setToolTip: string ];
}

HB_FUNC( VIEWEND )
{
   NSView * view = ( NSView * ) hb_parnl( 1 );

   if( [ [ view class ] isSubclassOfClass: [ NSTableView class ] ] )
      view = [ view enclosingScrollView ];
   
   [ view removeFromSuperview ];
}   	
