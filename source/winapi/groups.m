#include <fivemac.h>

HB_FUNC( BOXCREATE )
{
   NSBox * box = [ [ NSBox alloc ] initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), 
   	             hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
   NSString * string = hb_NSSTRING_par( 6 ) ;

   [ GetView( window ) addSubview : box ];   
   [ box setTitle : string ];
   [ box setBoxType : hb_parnl( 7 ) ];
    
   hb_retnl( ( HB_LONG ) box );
}

HB_FUNC( BOXTITLE )
{
   NSBox * box = ( NSBox * ) hb_parnl( 1 );
   NSString * title = [ box title ]; 
    
   hb_retc( [ title cStringUsingEncoding: NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( BOXSETTITLE )
{
   NSBox * box = ( NSBox * ) hb_parnl( 1 );
   NSString * title = hb_NSSTRING_par( 2 ); 
   
   [ box setTitle: title ];  
}

HB_FUNC( BOXSETSTYLE )
{
   NSBox * box = ( NSBox * ) hb_parnl( 1 );
    
   [ box setBoxType : hb_parnl( 2 ) ];
}

HB_FUNC( BOXGETSTYLE )
{
   NSBox * box = ( NSBox * ) hb_parnl( 1 );
    
   hb_retnl( [ box boxType ] );
}

HB_FUNC( BOXSETBORDERWIDTH )
{
   NSBox * box = ( NSBox * ) hb_parnl( 1 );

   [ box setBorderWidth: hb_parnd( 1 ) ];
}

HB_FUNC( BOXSETTITLEPOS )
{
   NSBox * box = ( NSBox * ) hb_parnl( 1 );
   
   [ box setTitlePosition: hb_parnl( 2 ) ];
}

HB_FUNC( BOXSETBORDERTYPE )
{
   NSBox * box = ( NSBox * ) hb_parnl( 1 );
   [ box setBorderType: hb_parnl( 2 ) ];
}

HB_FUNC( BOXISLINEBORDER )
{
    NSBox * box = ( NSBox * ) hb_parnl( 1 );
    hb_retl( ( [box borderType]  == NSLineBorder ) );
}

HB_FUNC( BOXSETFILLCOLOR )
{
    NSBox * box = ( NSBox * ) hb_parnl( 1 );
    NSColor * color =  [ NSColor colorWithCalibratedRed  : ( hb_parnl( 2 ) / 255.0 )
                                                    green: ( hb_parnl( 3 ) / 255.0 )
                                                     blue:  ( hb_parnl( 4 ) / 255.0 ) alpha : ( hb_parnl( 5 ) / 100.0 ) ];
    [box setFillColor: color ] ;
}

HB_FUNC( BOXSETBORDERCOLOR )
{
    NSBox * box = ( NSBox * ) hb_parnl( 1 );
    NSColor * color =  [ NSColor colorWithCalibratedRed  : ( hb_parnl( 2 ) / 255.0 )
                                                    green: ( hb_parnl( 3 ) / 255.0 )
                                                     blue:  ( hb_parnl( 4 ) / 255.0 ) alpha : ( hb_parnl( 5 ) / 100.0 ) ];
    [box setBorderColor: color   ]  ;
}

HB_FUNC( BOXSETTRASPARENT )
{
    NSBox * box = ( NSBox * ) hb_parnl( 1 );
   [ box setTransparent: hb_parl( 2 ) ];
}

HB_FUNC( BOXISTRASPARENT )
{
    NSBox * box = ( NSBox * ) hb_parnl( 1 );
    hb_retl( ( BOOL )[ box isTransparent ] );
}
HB_FUNC( BOXHIDE )
{
	 NSBox * box = ( NSBox * ) hb_parnl( 1 );
   
   [ box setHidden: YES ];
}

HB_FUNC( BOXSHOW )
{
	 NSBox * box = ( NSBox * ) hb_parnl( 1 );
	 
	 [ box setHidden: NO ];
}

HB_FUNC( BOXAUTOAJUST )
{
   NSBox * box = ( NSBox * ) hb_parnl( 1 );
   
   [ box setAutoresizingMask: hb_parnl( 2 )  ];	
}  

HB_FUNC( BOXSETCUSTOM )
{
    NSBox * box = ( NSBox * ) hb_parnl( 1 );
	[ box setBoxType: NSBoxCustom ];
}

HB_FUNC( BOXISCUSTOM )
{
    NSBox * box = ( NSBox * ) hb_parnl( 1 );
    hb_retl( ( [box boxType]  == NSBoxCustom ) );
}

HB_FUNC( SEPARATORH )
{
  NSBox * box = [ [ NSBox alloc ] initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), 
                                                               hb_parnl(3 ), 1.0 ) ];
  NSWindow * window = ( NSWindow * ) hb_parnl( 4 );   
  [ GetView( window ) addSubview: box ];   
  [ box setBoxType: NSBoxSeparator ];
    
  hb_retnl( ( HB_LONG ) box );  
}    

HB_FUNC( SEPARATORV )
{
   NSBox * box = [ [ NSBox alloc ] initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), 
                                                               1.0, hb_parnl( 3 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 4 );   
   
   [ GetView( window ) addSubview: box ];   
   [ box setBoxType: NSBoxSeparator ];
    
   hb_retnl( ( HB_LONG ) box );  
}    

HB_FUNC( MATRIXCREATE )
{
   NSMatrix * matrix = [ [ NSMatrix alloc ] initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), 
                                                               hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
       
   [ GetView( window ) addSubview: matrix ];   
   [ matrix setMode:  NSRadioModeMatrix ];
      
   hb_retnl( ( HB_LONG ) matrix );
}

HB_FUNC( MATRIXSETCELLCLASSIMAGE )
{
   NSMatrix * matrix = ( NSMatrix * ) hb_parnl( 1 ); 
      
   [ matrix setCellClass: [NSImageCell class] ];
}

HB_FUNC( MATRIXSETCELLSIZE )
{
   NSMatrix * matrix = ( NSMatrix * ) hb_parnl( 1 ); 
    
   [ matrix setCellSize: NSMakeSize( hb_parnl( 2 ), hb_parnl( 3 ) ) ];
}

HB_FUNC( MATRIXADDCOLUMN )
{
   NSMatrix * matrix = ( NSMatrix * ) hb_parnl( 1 ); 
   
   [ matrix addColumn ];
}

HB_FUNC( MATRIXADDROW )
{
   NSMatrix * matrix = ( NSMatrix * ) hb_parnl( 1 ); 
   
   [ matrix addRow ];
}
