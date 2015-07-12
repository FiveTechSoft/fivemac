#include <fivemac.h>

HB_FUNC( SPLITCREATE )
{
   NSSplitView * vista = [ [  NSSplitView alloc ] initWithFrame :
                                     NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
							
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
			
   [ GetView( window ) addSubview : vista ];
 	
   [ vista setDividerStyle:  3  ];
   [ vista setAutoresizingMask : NSViewWidthSizable | NSViewHeightSizable ];	
 	
    hb_retnl( ( HB_LONG ) vista );
}

HB_FUNC( SPLITGETSUBVIEW )
{
   NSSplitView * vista = ( NSSplitView * ) hb_parnl( 1 );	
   NSView * subview = [ [ vista subviews ] objectAtIndex: ( hb_parnl( 2 ) - 1 ) ];

   hb_retnl( ( HB_LONG ) subview );
}

HB_FUNC( SPLITSETSTYLE )
{
   NSSplitView * vista = ( NSSplitView * ) hb_parnl( 1 );	
 
   [ vista setDividerStyle : hb_parnl( 2 ) ];
}

HB_FUNC( SPLITSETPOSITION )
{
   NSSplitView * vista = ( NSSplitView * ) hb_parnl( 1 );	
  
   #if __MAC_OS_X_VERSION_MAX_ALLOWED < 1050    
      [ vista setPosition : ( float ) hb_parnl( 3 )  ofDividerAtIndex: hb_parni( 2 ) ];
   #else
      [ vista setPosition : ( CGFloat ) hb_parnl( 3 )  ofDividerAtIndex: hb_parni( 2 ) ];
   #endif
}

HB_FUNC( SPLITSETVERTICAL )
{
   NSSplitView * vista = ( NSSplitView * ) hb_parnl( 1 );	
 
   [ vista setVertical: hb_parl( 2 ) ];
}

HB_FUNC( SPLITSETSUBVIEW )
{
   NSSplitView * vista = ( NSSplitView * ) hb_parnl( 1 );	
   NSView * vista1 = [[ NSView alloc ] initWithFrame: [ vista frame ] ] ;	

   [ vista addSubview :  vista1 ];	
   [ vista1 setAutoresizesSubviews: YES ];
    
   hb_retnl( ( HB_LONG ) vista1 );	
}
