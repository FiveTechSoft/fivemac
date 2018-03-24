#include <fivemac.h>

NSView * GetView( NSWindow * window );

HB_FUNC( CBXCREATE ) 
{
   NSPopUpButton * combo = [ [ NSPopUpButton alloc ] 
 			  initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );

   [ GetView( window ) addSubview : combo ];
   [ combo setAction : @selector( CbxChange: ) ];
   
   hb_retnl( ( HB_LONG ) combo );
}   

HB_FUNC( CBXRESCREATE ) 
{
    NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
    NSPopUpButton * combo  = (NSPopUpButton *) [  GetView( window ) viewWithTag: hb_parnl( 2 ) ];
    
    [ GetView( window ) addSubview : combo ];
    [ combo setAction : @selector( CbxChange: ) ];
    
    hb_retnl( ( HB_LONG ) combo );
}   

HB_FUNC( CBXADDITEM ) 
{
   NSPopUpButton * combo = ( NSPopUpButton * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 );
   
   [ combo addItemWithTitle: string ];
}   

HB_FUNC( CBXINSERTITEM ) 
{
   NSPopUpButton * combo = ( NSPopUpButton * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 );
   
   [ combo insertItemWithTitle: string atIndex:  hb_parni( 3 ) ];
} 

HB_FUNC( CBXDELITEMINDEX ) 
{
   NSPopUpButton * combo = ( NSPopUpButton * ) hb_parnl( 1 );
  [ combo removeItemAtIndex:  hb_parni( 2 ) ];
}  

HB_FUNC( CBXDELITEM ) 
{
   NSPopUpButton * combo = ( NSPopUpButton * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 );
   
   [ combo removeItemWithTitle: string ];
}  


HB_FUNC( CBXRESET )
{
   NSPopUpButton * combo = ( NSPopUpButton * ) hb_parnl( 1 );
   
   [ combo removeAllItems ];
}   

HB_FUNC( CBXSETPULLSDOWN ) 
{
   NSPopUpButton * combo = ( NSPopUpButton * ) hb_parnl( 1 );
   
   [ combo setPullsDown: hb_parl( 2 ) ];
}   

HB_FUNC( CBXSETTITLE ) 
{
   NSPopUpButton * combo = ( NSPopUpButton * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 );

   [ combo setTitle: string ];
}

HB_FUNC( CBXSETITEMDISABLED ) 
{
   NSPopUpButton * combo = ( NSPopUpButton * ) hb_parnl( 1 );
  
   [ combo setAutoenablesItems: NO ];  
   [ [ combo itemAtIndex: hb_parni( 2 ) ] setEnabled: NO ];
}

HB_FUNC( CBXSETITEMENABLED ) 
{
   NSPopUpButton * combo = ( NSPopUpButton * ) hb_parnl( 1 );
   
   [ combo setAutoenablesItems: NO ]; 
   [ [ combo itemAtIndex: hb_parni( 2 ) ] setEnabled: YES ];
}

HB_FUNC( CBXSETITEMSELECTED ) 
{
   NSPopUpButton * combo = ( NSPopUpButton * ) hb_parnl( 1 );
   [ combo selectItemAtIndex: hb_parni( 2 ) ];
}

HB_FUNC( CBXGETITEMSELECTED )
{
  NSPopUpButton * combo = ( NSPopUpButton * ) hb_parnl( 1 );
  hb_retni(  [ combo indexOfSelectedItem ] ) ;
}

HB_FUNC( CBXGETTITLEITEMSELECTED )
{
  NSPopUpButton * combo = ( NSPopUpButton * ) hb_parnl( 1 );
  NSString * string =  [ combo titleOfSelectedItem ]  ;
  hb_retc( [ string cStringUsingEncoding: NSWindowsCP1252StringEncoding ] );
}

 