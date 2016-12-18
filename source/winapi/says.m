#include <fivemac.h>

HB_FUNC( SAYCREATE ) 
{
   NSTextField * say = [ [ NSTextField alloc ] 
 			          initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
   NSString * string =hb_NSSTRING_par( 6 ) ;
   
   [ say setEditable : FALSE ]; 
   [ say setSelectable : FALSE ]; 
   [ say setBordered : FALSE ]; 
   [ say setDrawsBackground : FALSE ];
   [ say setStringValue : string ];

   [ GetView( window ) addSubview : say ];
   
   hb_retnl( ( HB_LONG ) say );
}   

// ------------- tipos BackgroudStyle
//enum {
//    NSBackgroundStyleLight = 0,
//    NSBackgroundStyleDark,
//    NSBackgroundStyleRaised,
//    NSBackgroundStyleLowered };

#if __MAC_OS_X_VERSION_MAX_ALLOWED < 1050
   #define NSBackgroundStyleRaised 2
#endif    

HB_FUNC( SAYSETRAISED )
{
   NSTextField * say = ( NSTextField * ) hb_parnl( 1 );
   
   [ [ say cell ] setBackgroundStyle: NSBackgroundStyleRaised ];
}   	  

HB_FUNC( SAYSETTEXT )
{
   NSTextField * label = ( NSTextField * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 );
      
   [ label setStringValue: string ];
}   

HB_FUNC( SETTEXTCOLOR )
{
    NSTextField * say = ( NSTextField * ) hb_parnl( 1 );
    NSColor * color =  [ NSColor colorWithCalibratedRed  : ( hb_parnl( 2 ) / 255.0 ) 
                                 green: ( hb_parnl( 3 ) / 255.0 ) 
                                 blue:  ( hb_parnl( 4 ) / 255.0 ) alpha : ( hb_parnl( 5 ) / 100.0 ) ];    
    
    [  say  setTextColor : color ] ;
}  

HB_FUNC( SETBKCOLOR )
{
    NSTextField * say = ( NSTextField * ) hb_parnl( 1 );
    NSColor * color =  [ NSColor colorWithCalibratedRed  : ( hb_parnl( 2 ) / 255.0 ) 
                                 green: ( hb_parnl( 3 ) / 255.0 ) 
                                 blue:  ( hb_parnl( 4 ) / 255.0 ) alpha : ( hb_parnl( 5 ) / 100.0 ) ];    
    
    [  say  setBackgroundColor : color ] ;
}   


//----------- tipos bezel
//enum {
//    NSTextFieldSquareBezel  = 0,
//    NSTextFieldRoundedBezel = 1
//};
//typedef NSUInteger NSTextFieldBezelStyle;

HB_FUNC( SAYSETBEZELED )
{
    NSTextField * say = ( NSTextField * ) hb_parnl( 1 );
    [ [ say cell ] setBezeled  : hb_parl( 2 ) ];
    
     if ( hb_parl( 2 ) ) 
    {
        if ( hb_parl( 3 ) ) 
          [ [ say cell ] setBezelStyle: NSRoundedBezelStyle ];
        else
          [ [ say cell ] setBezelStyle: NSRegularSquareBezelStyle  ];
     }
}


HB_FUNC( SAYSETBEZELSQUARE )
{
    NSTextField * say = ( NSTextField * ) hb_parnl( 1 );
    [ [ say cell ] setBezelStyle: NSRegularSquareBezelStyle  ];
}

HB_FUNC( SAYSETBEZELROUNDED )
{
    NSTextField * say = ( NSTextField * ) hb_parnl( 1 );
    [ [ say cell ] setBezelStyle: NSRoundedBezelStyle ];
}


HB_FUNC( SAYSETSIZEFONT )
{
	NSTextField * say = ( NSTextField * ) hb_parnl( 1 );
	[ say setFont : [NSFont labelFontOfSize: hb_parnl( 2 ) ]];
} 


HB_FUNC( SAYSETFONT )
{
   NSTextField * say = ( NSTextField * ) hb_parnl( 1 );
   NSString * name =hb_NSSTRING_par( 2 ) ;
   [ say setFont:[NSFont fontWithName: name size:  hb_parnl( 3 ) ]];
} 


HB_FUNC( SETTEXTALIGN )
{
	NSTextField * say = ( NSTextField * ) hb_parnl( 1 );
	[ say setAlignment : hb_parnl( 2 ) ];
} 


HB_FUNC( TXTSETENABLED ) // hGet --> cText
{
	NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
	[get setEnabled: YES  ];
	[get setTextColor: [NSColor controlTextColor]];
}  

HB_FUNC( TXTSETNOSELECT ) // hGet --> cText
{
	NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
	[get setEnabled: NO  ];
}


HB_FUNC( TXTSETDISABLED ) // hGet --> cText
{
	NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
	[get setEnabled: NO  ];
    [get setTextColor: [NSColor secondarySelectedControlColor]];
} 


HB_FUNC( TXTISENABLED ) // hGet --> cText
{
	NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
	hb_retl( ( BOOL ) [ get isEnabled ] );
}

HB_FUNC( TXTGETWIDTH )
{
   NSString * text = hb_NSSTRING_par( 1 );
   NSString * name = hb_NSSTRING_par( 2 );
   NSFont * font = [ NSFont fontWithName: name size:  hb_parnl( 3 ) ];
   CGSize frameSize = CGSizeMake( 300, 50 );

   CGRect idealFrame = [ text boundingRectWithSize: frameSize
                         options: NSStringDrawingUsesLineFragmentOrigin
                         attributes: @{ NSFontAttributeName: font }
                         context: nil ];

   hb_retnl( idealFrame.size.width );
}

HB_FUNC( SAYHIPERLINKCREATE )
{
    NSTextField * say = [ [ NSTextField alloc ]
                         initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
    NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
    
    NSString * string = hb_NSSTRING_par( 6 ) ;
    
    NSString * cUrl   = hb_NSSTRING_par( 7 ) ;
    
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: string];
    NSRange range = NSMakeRange(0, [attrString length]);
    [attrString beginEditing];
    
    NSURL * aURL = [ [ [ NSURL alloc ] initWithString : cUrl ]autorelease ];
    
    [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];

    // make the text appear in blue
    [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];

    // next make the text appear with an underline
    [attrString addAttribute:
     NSUnderlineStyleAttributeName value:[ NSNumber numberWithInt:NSUnderlineStyleSingle ] range:range];

    [attrString endEditing];

    [say setAllowsEditingTextAttributes: YES];
    
    [ say setEditable : FALSE ];
    [ say setSelectable : YES ];
    [ say setBordered : FALSE ];
    [ say setDrawsBackground : FALSE ];
    [ say setAttributedStringValue : attrString ];
    
    [ GetView( window ) addSubview : say ];
    
    hb_retnl( ( HB_LONG ) say );
}



