#include <fivemac.h>

static PHB_SYMB symFMH = NULL;

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
   @interface SearchGet : NSSearchField <NSTextFieldDelegate>
#else
   @interface SearchGet : NSSearchField
#endif
{
   @public NSWindow * hWnd;	
}
- ( BOOL ) textShouldEndEditing : ( NSText * ) text;
- ( void ) controlTextDidChange : ( NSNotification * ) aNotification;	
@end

@implementation SearchGet
- ( BOOL ) textShouldEndEditing : ( NSText * ) text
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName(  "_FMO" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) hWnd );
   hb_vmPushLong( WM_GETVALID );
   hb_vmPushLong( ( HB_LONG ) self );
   hb_vmDo( 3 );

   return hb_parl( -1 );	
}

- ( void ) controlTextDidChange : ( NSNotification * ) aNotification
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName(  "_FMO" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) hWnd );
   hb_vmPushLong( WM_GETCHANGED );
   hb_vmPushLong( ( HB_LONG ) self );
   hb_vmDo( 3 );
   
   // NSLog( @"The contents of the text field changed" );
}

@end

HB_FUNC( SEARCHGETCREATE ) 
{
   SearchGet * edit = [ [ SearchGet alloc ] 
 			  initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );

   [ GetView( window ) addSubview : edit ];
   edit->hWnd = window;
   [ edit setDelegate : edit ];
   
   hb_retnl( ( HB_LONG ) edit );
}   

HB_FUNC( SEARCHGETRESCREATE ) 
{
    NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
    SearchGet * edit =  (SearchGet *) [  GetView( window ) viewWithTag: hb_parnl( 2 ) ];
    edit->hWnd = window;
    [ edit setDelegate : edit ];
    
 	hb_retnl( ( HB_LONG ) edit );	 			
    
}  

HB_FUNC( SEARCHGETSETAUTOSAVE ) 
{
	SearchGet * get = ( SearchGet * ) hb_parnl( 1 );
    NSString * string = hb_NSSTRING_par( 2 ) ;
	[get setRecentsAutosaveName: string ] ;
}  

HB_FUNC( SEARCHGETGETAUTOSAVE ) // hGet --> cText
{
	SearchGet * get = ( SearchGet * ) hb_parnl( 1 );
	NSString * string = [ get recentsAutosaveName ];
	
	hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}   

HB_FUNC( TBRSEARCHCREATE )
{
	NSWindow * window = ( NSWindow * ) hb_parnl( 1 );   
	SearchGet * edit =[ [ SearchGet alloc ] 
					   initWithFrame : NSMakeRect( 1,1,40,20 ) ];
	
	edit->hWnd = window;	
	[ edit setDelegate : edit ];
	hb_retnl( ( HB_LONG ) edit );
} 

HB_FUNC( SEARCHGETSETCURRENT ) 
{
	SearchGet * get = ( SearchGet * ) hb_parnl( 1 );
	NSNumberFormatter * formato = [ [ NSNumberFormatter alloc ] init] ;
	[formato setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[ formato setNumberStyle : NSNumberFormatterCurrencyStyle ] ; 
	[ get setFormatter : formato ] ;
}  

