#include <fivemac.h>

static PHB_SYMB symFMH = NULL;

@interface ViewFlipped : NSView
{
}
- ( BOOL ) isFlipped; 
@end

@implementation ViewFlipped

- ( BOOL ) isFlipped 
{
   if( symFMH == NULL )
       symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
    
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_FLIPPED );
   hb_vmPushLong( ( HB_LONG ) [ self superview ] );
   hb_vmDo( 3 );
       
   return hb_parl( -1 );
}

@end

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
   @interface tvDelegate : NSObject <NSTabViewDelegate>
#else   	
   @interface tvDelegate : NSObject
#endif
- ( void ) tabView: ( NSTabView * ) tabView didSelectTabViewItem: ( NSTabViewItem * ) tabViewItem;

@end

@implementation tvDelegate

- ( void ) tabView: ( NSTabView * ) tabView didSelectTabViewItem: ( NSTabViewItem * ) tabViewItem
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ tabView window ] );
   hb_vmPushLong( WM_TABITEMSEL );
   hb_vmPushLong( ( HB_LONG ) tabView );
   hb_vmPushLong( [ [ tabViewItem identifier ] intValue ] + 1 );
   hb_vmDo( 4 );
}		

@end		

HB_FUNC( TABVIEWCREATE ) 
{
   NSTabView * tabview = [ [ NSTabView alloc ] 
                           initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), 
                           	                          hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
   tvDelegate * tvd = [ [ tvDelegate alloc ] init ];  
   
   [ GetView( window ) addSubview: tabview ];
   [ tabview setDelegate: tvd ];
	    
   hb_retnl( ( HB_LONG ) tabview );
} 

HB_FUNC( TABVIEWITEMADD ) 
{
   NSTabView * tabview = ( NSTabView * ) hb_parnl( 1 );
   NSString * string =hb_NSSTRING_par( 2 ) ;
  
   NSTabViewItem * tabitem =  [[ NSTabViewItem alloc ] init  ] ;
   NSNumber * myNum = [ [ NSNumber alloc ] initWithInt: [ tabview numberOfTabViewItems ] ];
   NSRect defaultFrame = [tabview frame ]; 
   ViewFlipped * myview = [ [ ViewFlipped alloc ] initWithFrame: defaultFrame ];   
    
   [ tabitem setView: myview ];
   [ tabitem setLabel: string ]; 
   [ tabitem setIdentifier: myNum ]; 
   [ tabview addTabViewItem: tabitem ];
   
   hb_retnl( ( HB_LONG ) tabitem );
} 

HB_FUNC( TABVIEWSETTYPE ) 
{
    NSTabView * tabview = ( NSTabView * ) hb_parnl( 1 );
   
   [ tabview setTabViewType: hb_parnl( 2 ) ];    
}

HB_FUNC( TABVIEWGETNUMITEMS ) 
{
   NSTabView * tabview = ( NSTabView * ) hb_parnl( 1 );
   
   hb_retni( [ tabview numberOfTabViewItems ] );    
}


HB_FUNC( TABVIEWSETSELECTEDITEM ) 
{
    NSTabView * tabview = ( NSTabView * ) hb_parnl( 1 );
    [ tabview selectTabViewItemAtIndex: hb_parni( 2 ) ];    
}

HB_FUNC( TABVIEWGETITEM ) 
{
   NSTabView * tabview = ( NSTabView * ) hb_parnl( 1 );
   NSTabViewItem * item = [ tabview tabViewItemAtIndex: hb_parni( 2 ) ];
   
   hb_retnl( ( HB_LONG ) item );    
}

HB_FUNC( TABVIEWITEMSETLABEL ) 
{
    NSTabViewItem * item = ( NSTabViewItem * ) hb_parnl( 1 );
    NSString * string = hb_NSSTRING_par( 2 );    
    [item setLabel: string ] ;  
}




