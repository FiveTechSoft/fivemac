#include <fivemac.h>

HB_FUNC( BTNCREATE ) 
{
   NSButton * button = [ [ NSButton alloc ] 
 			           initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSString * string = hb_NSSTRING_par( 5 );
   NSWindow * window = ( NSWindow * ) hb_parnl( 6 );

   [ button setBezelStyle : NSRoundedBezelStyle ];
   [ button setTitle : string ];
   
   [ GetView( window ) addSubview : button ];

   [ button setAction : @selector( BtnClick: ) ];
   
   hb_retnl( ( HB_LONG ) button );
}   

HB_FUNC( RADCREATE ) 
{
   NSButton * radio = [ [ NSButton alloc ] 
                        initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSString * string = hb_NSSTRING_par( 5 );
   NSWindow * window = ( NSWindow * ) hb_parnl( 6 );
    
   [ radio setButtonType: NSRadioButton ];
   [ radio setTitle : string ];
   [ GetView( window ) addSubview : radio ];
   [ radio setAction : @selector( BtnClick: ) ];
   
   hb_retnl( ( HB_LONG ) radio );
} 

HB_FUNC( BTNSETENABLED ) 
{
   NSButton * button = ( NSButton * ) hb_parnl( 1 );
	
	 [ button setEnabled: hb_parl( 2 ) ];
}  

HB_FUNC( BTNSETBORDERED )
{
    NSButton * button = ( NSButton * ) hb_parnl( 1 );
    button.bordered = hb_parl( 2 ) ;
}  

HB_FUNC( BTNSETTRANSPARENT )
{
    NSButton * button = ( NSButton * ) hb_parnl( 1 );
    button.transparent = hb_parl( 2 ) ;
}

HB_FUNC( BTNSETHIGHLIGHT )
{
    NSButton * button = ( NSButton * ) hb_parnl( 1 );
    [button highlight : hb_parl( 2 ) ] ;
}

HB_FUNC( BTNRESCREATE )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   NSButton * button = ( NSButton * ) [ GetView( window ) viewWithTag: hb_parnl( 2 ) ];
    
   [ GetView( window ) addSubview : button ];
   [ button setAction : @selector( BtnClick: ) ];
    
   hb_retnl( ( HB_LONG ) button );
}


HB_FUNC( BTNBMPCREATE ) 
{
   NSButton * button = [ [ NSButton alloc ] 
 			           initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );

   [ button setBezelStyle : NSThickSquareBezelStyle ];
   [ button setTitle : @"" ];
   
   [ GetView( window ) addSubview : button ];
   [ button setAction : @selector( BtnClick: ) ];
   
   hb_retnl( ( HB_LONG ) button );
}   

HB_FUNC( BTNSETTEXT )
{
   NSButton * button = ( NSButton * ) hb_parnl( 1 );
   
   [ button setTitle : hb_NSSTRING_par( 2 ) ];
}   

HB_FUNC( BTNGETTEXT ) // hButton --> cText
{
   NSButton * button = ( NSButton * ) hb_parnl( 1 );
   NSString * string = [ button title ];
   
   hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}   

HB_FUNC( BTNBMPFILE )
{
   NSButton * button = ( NSButton * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 );
   NSFileManager * filemgr = [ NSFileManager defaultManager ];
    
    if( [ filemgr fileExistsAtPath: string ] )
        [ button setImage : [ [ NSImage alloc ] initWithContentsOfFile : string ] ];
    else 
        [ button setImage : ImgTemplate( string ) ]; 
    
}   

HB_FUNC( BTNSETIMAGE )
{
   NSButton * button = ( NSButton * ) hb_parnl( 1 );
   NSImage * image = ( NSImage * ) hb_parnl( 2 );
   
   [ button setImage : image ];
}

HB_FUNC( BTNSETIMAGENPOSITION )
{
    NSButton * button = ( NSButton * ) hb_parnl( 1 );
    button.imagePosition = hb_parnl( 2 ) ;
 }

HB_FUNC( BTNSETBEZEL )
{
   NSButton * button = ( NSButton * ) hb_parnl( 1 );
   
   [ button setBezelStyle: hb_parnl( 2 ) ];
} 


HB_FUNC( BTNSETSOUND )
{
   NSButton * button = ( NSButton * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 ); 
   NSSound * sound  = [ [ [ NSSound alloc ] initWithContentsOfFile: string byReference: NO ] autorelease ];
   
   [ button setSound :sound ];
} 

HB_FUNC( BTNSETTYPE )
{
   NSButton * button = ( NSButton * ) hb_parnl( 1 );
   
   [ button setButtonType: hb_parnl( 2 ) ];
} 

HB_FUNC( BTNGETSTATE )
{
   NSButton * button = ( NSButton * ) hb_parnl( 1 );
 
   hb_retnl(  [ button state ] );
}

HB_FUNC( BTNSETSTATE )
{
   NSButton * button = ( NSButton * ) hb_parnl( 1 );
 
   [ button setState: hb_parnl( 2 ) ];
}

HB_FUNC( BTNALIGNTEXT )
{
   NSButton * button = ( NSButton * ) hb_parnl( 1 );
	 
	 [ button setAlignment: hb_parnl( 2 ) ];
}  

HB_FUNC( BTNAUTOAJUST )
{
   NSButton * button = ( NSButton * ) hb_parnl( 1 );
	 
	 [ button setAutoresizingMask : hb_parnl( 2 ) ];	
} 

HB_FUNC( BTNSETTOOLTIP )
{
   NSButton * button = ( NSButton * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 ); 
   
   [ button setToolTip: string ] ;
}



