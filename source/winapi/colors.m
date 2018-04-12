#include <fivemac.h>

static PHB_SYMB symFMH = NULL;


@interface colorPick : NSColorWell
    {
    }

    - (BOOL)   acceptsFirstResponder;
    - ( IBAction ) changeColor : ( id ) sender ;
 
@end

@implementation colorPick
    
- ( BOOL ) acceptsFirstResponder
    {
        if( symFMH == NULL )
        symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
        
        hb_vmPushSymbol( symFMH );
        hb_vmPushNil();
        hb_vmPushLong( ( HB_LONG ) [ self window ] );
        hb_vmPushLong( WM_WHEN );
        hb_vmPushLong( ( HB_LONG ) self );
        hb_vmDo( 3 );
        
        if( HB_ISLOG( -1 ) )
        return hb_parl( -1 );
        else
        return TRUE;
    }
    
    
- ( IBAction ) changeColor : ( id ) sender
    {
        if( symFMH == NULL )
        symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
        
        hb_vmPushSymbol( symFMH );
        hb_vmPushNil();
        hb_vmPushLong( ( HB_LONG ) [ self window ] );
        hb_vmPushLong( WM_CLRCHANGE );
        hb_vmPushLong( ( HB_LONG ) self );
        hb_vmDo( 3 );
    }

    
@end



HB_FUNC( CREATECOLORWELL )
{
   colorPick * clrWell = [ [ colorPick alloc ]
                             initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), 
                             hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
   
   [ GetView( window ) addSubview : clrWell ];
   	
   [ clrWell setAction: @selector( changeColor: ) ];		
   	
   hb_retnl( ( HB_LONG ) clrWell );
}

HB_FUNC( CLOSECOLORWELL )
{
   colorPick * clrWell = ( colorPick * ) hb_parnl( 1 );
   [[NSColorPanel sharedColorPanel] close];
   [ clrWell deactivate ];
    
}

HB_FUNC( CLRWSETCOLOR )
{
   colorPick * clrWell = ( colorPick * ) hb_parnl( 1 );
   float fBlue = hb_parnl( 2 ) / 65536;
   float fGreen = ( hb_parnl( 2 ) - ( ( ( HB_LONG ) fBlue ) * 65536 ) ) / 256;
   float fRed = hb_parnl( 2 ) - ( ( ( HB_LONG ) fBlue ) * 65536 ) - ( ( ( HB_LONG ) fGreen ) * 256 );
   NSColor * color = [ NSColor colorWithCalibratedRed : fRed / 255.0
                       green : fGreen / 255.0
					             blue : fBlue / 255.0
                       alpha: 1.0 ];   

    clrWell.color = color ;
}
	
HB_FUNC( CLRWGETCOLOR )
{
   colorPick * clrWell = ( colorPick * ) hb_parnl( 1 );
   NSColor * color = [ clrWell color ];
   int iRed   = ( int ) ( color.redComponent * 255 ) ;
   int iGreen = ( int ) ( color.greenComponent * 255 ) ;
   int iBlue  = ( int ) ( color.blueComponent * 255 ) ;
   
   hb_retnl( ( HB_LONG ) RGB( iRed, iGreen, iBlue ) );
} 	   	


HB_FUNC( CLRWGETNSCOLOR )
{
   colorPick * clrWell = ( colorPick * ) hb_parnl( 1 );
   hb_retnl( ( HB_LONG ) [ clrWell color ]  );
}

HB_FUNC( GETCOLORRGB )
{
    NSColor * color =  (NSColor *) hb_parnl(1);
    int iRed   = ( int ) ( color.redComponent * 255 ) ;
    int iGreen = ( int ) ( color.greenComponent * 255 ) ;
    int iBlue  = ( int ) ( color.blueComponent * 255 ) ;
    
    hb_retnl( ( HB_LONG ) RGB( iRed, iGreen, iBlue ) );
}


HB_FUNC( GETBLUENSCOLOR )
{
    NSColor * color =  (NSColor *) hb_parnl(1);
    hb_retni( ( int ) ( color.blueComponent * 255 ) )  ;
}

HB_FUNC( GETGREENNSCOLOR )
{
    NSColor * color =  (NSColor *) hb_parnl(1);
    hb_retni( ( int ) ( color.greenComponent * 255 ) )  ;
}

HB_FUNC( GETREDNSCOLOR )
{
    NSColor * color =  (NSColor *) hb_parnl(1);
    hb_retni( ( int ) ( color.redComponent * 255 ) )  ;
}



HB_FUNC( COLORFROMNRGB )
{
   
    float fBlue = hb_parnl( 1 ) / 65536;
    float fGreen = ( hb_parnl( 1 ) - ( ( ( HB_LONG ) fBlue ) * 65536 ) ) / 256;
    float fRed = hb_parnl( 1 ) - ( ( ( HB_LONG ) fBlue ) * 65536 ) - ( ( ( HB_LONG ) fGreen ) * 256 );
    NSColor * color = [ NSColor colorWithCalibratedRed : fRed / 255.0 
                                                    green : fGreen / 255.0
                                                     blue : fBlue / 255.0
                                                      alpha: 1.0 ];  

  hb_retnl( ( HB_LONG ) color ) ;	
}    

HB_FUNC( GRADSETCOLORS )
{
    
    float fBlue = hb_parnl( 1 ) / 65536;
    float fGreen = ( hb_parnl( 1 ) - ( ( ( HB_LONG ) fBlue ) * 65536 ) ) / 256;
    float fRed = hb_parnl( 1 ) - ( ( ( HB_LONG ) fBlue ) * 65536 ) - ( ( ( HB_LONG ) fGreen ) * 256 );
    NSColor * colorini = [ NSColor colorWithCalibratedRed : fRed / 255.0 
                                             green : fGreen / 255.0
                                              blue : fBlue / 255.0
                                              alpha: 1.0 ];   
 
     fBlue = hb_parnl( 2 ) / 65536;
     fGreen = ( hb_parnl( 2 ) - ( ( ( HB_LONG ) fBlue ) * 65536 ) ) / 256;
     fRed = hb_parnl( 2 ) - ( ( ( HB_LONG ) fBlue ) * 65536 ) - ( ( ( HB_LONG ) fGreen ) * 256 );
    
    NSColor * colorend = [ NSColor colorWithCalibratedRed : fRed / 255.0 
                                                    green : fGreen / 255.0
                                                     blue : fBlue / 255.0
                                                     alpha: 1.0 ];   
    
       
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor: colorini endingColor: colorend ];
    
    hb_retnl( ( HB_LONG ) gradient );	
    
}

HB_FUNC( GRADSETNSCOLORS )
{
    
    NSColor * colorini =  (NSColor *) hb_parnl(1);
    NSColor * colorend =  (NSColor *) hb_parnl(2);   
        
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor: colorini endingColor: colorend ];
    
    hb_retnl( ( HB_LONG ) gradient );	
    
}

HB_FUNC( GRADSETNRBGCOLORS )
{
    float fBlue =  hb_parnl( 3 ) / 255.0 ;
    float fGreen = hb_parnl( 2 ) / 255.0 ;
    float fRed =   hb_parnl( 1 ) / 255.0 ;
    
    NSColor * colorini = [ NSColor colorWithCalibratedRed : fRed / 255.0 
                                                    green : fGreen / 255.0
                                                     blue : fBlue / 255.0
                                                     alpha: 1.0 ];   
      
     fBlue =  hb_parnl( 6 ) / 255.0 ;
     fGreen = hb_parnl( 5 ) / 255.0 ;
     fRed =   hb_parnl( 4 ) / 255.0 ;   
    
    NSColor * colorend = [ NSColor colorWithCalibratedRed : fRed / 255.0 
                                                    green : fGreen / 255.0
                                                     blue : fBlue / 255.0
                                                     alpha: 1.0 ];   
    
    
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor: colorini endingColor: colorend ];
    
    hb_retnl( ( HB_LONG ) gradient );	
    
}

HB_FUNC( COLORFROMNRGB2 )
{
   float fBlue =  hb_parnl( 3 ) / 255.0 ;
   float fGreen = hb_parnl( 2 ) / 255.0 ;
   float fRed =   hb_parnl( 1 ) / 255.0 ;
   NSColor * color = [ NSColor colorWithCalibratedRed : fRed
                                                        green : fGreen
                                                        blue : fBlue
                                                        alpha: 1.0 ];   
   hb_retnl( ( HB_LONG ) color );
}   

HB_FUNC( ETIQUETGRADCOLORS )
{
  NSString * string =  hb_NSSTRING_par( 1 );
    
  NSGradient *gradient = nil;
    
    if ( [ string isEqualToString : @"orange" ] ) {
		
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.972549 green:0.811765 blue:0.584314 alpha:1.0] endingColor:[NSColor colorWithCalibratedRed:0.952941 green:0.662745 blue:0.286275 alpha:1.0]]; 
    }
    
    if ([ string isEqualToString:  @"red" ]) {       
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.976471 green:0.639216 blue:0.623529 alpha:1.0] endingColor:[NSColor colorWithCalibratedRed:0.964706 green:0.368627 blue:0.360784 alpha:1.0]] ;        
        
	}    
    
    if ([ string isEqualToString:  @"yellow"]) {    
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.972549 green:0.956863 blue:0.619608 alpha:1.0] endingColor:[NSColor colorWithCalibratedRed:0.925490 green:0.862745 blue:0.305882 alpha:1.0]];
        
    } 
    
    if ([ string isEqualToString:  @"green" ]) {     
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.835294 green:0.925490 blue:0.619608 alpha:1.0] endingColor:[NSColor colorWithCalibratedRed:0.698039 green:0.850980 blue:0.301961 alpha:1.0]];
        
    }  
    
    if ( [ string isEqualToString: @"blue" ]) { 
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.678431 green:0.819608 blue:0.996078 alpha:1.0] endingColor:[NSColor colorWithCalibratedRed:0.368627 green:0.627451 blue:0.988235 alpha:1.0]];     } 
    
    
    if ( [ string isEqualToString :  @"purple" ]) {    
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.862745 green:0.749020 blue:0.917647 alpha:1.0] endingColor:[NSColor colorWithCalibratedRed:0.749020 green:0.537255 blue:0.839216 alpha:1.0]];   
    } 
    
    
    if ( [ string isEqualToString : @"gray" ])
    {
        
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.811765 green:0.811765 blue:0.811765 alpha:1.0] endingColor:[NSColor colorWithCalibratedRed:0.658824 green:0.658824 blue:0.658824 alpha:1.0]];
    }
  
     hb_retnl( ( HB_LONG ) gradient );	 
    
}

//---------------------- standar colors ---------------

HB_FUNC( GETBLACKCOLOR )
{
      hb_retnl( ( HB_LONG ) [ NSColor blackColor ] );
}

HB_FUNC( GETBLUECOLOR )
{
   hb_retnl( ( HB_LONG ) [ NSColor blueColor  ] );
}

HB_FUNC( GETBROWNCOLOR )
{
   hb_retnl( ( HB_LONG ) [ NSColor brownColor ] );
}
 
HB_FUNC( GETCLEARCOLOR )
{
   hb_retnl( ( HB_LONG ) [ NSColor clearColor  ] );
}

HB_FUNC( GETCYANCOLOR )
{
   hb_retnl( ( HB_LONG ) [ NSColor cyanColor ] );
}
 
HB_FUNC( GETDARKGRAYCOLOR )
{
   hb_retnl( ( HB_LONG ) [ NSColor darkGrayColor ] );
}
 
HB_FUNC( GETGRAYCOLOR )
{
   hb_retnl( ( HB_LONG ) [ NSColor grayColor ] );
}

HB_FUNC( GETGREENCOLOR )
{
   hb_retnl( ( HB_LONG ) [ NSColor greenColor ] );
}

HB_FUNC( GETLIGHTGRAYCOLOR )
{
   hb_retnl( ( HB_LONG ) [ NSColor lightGrayColor ] );
}

HB_FUNC( GETMAGENTACOLOR )
{
   hb_retnl( ( HB_LONG ) [ NSColor magentaColor ] );
}

HB_FUNC( GETORANGECOLOR )
{
   hb_retnl( ( HB_LONG ) [ NSColor orangeColor ] );
}

HB_FUNC( GETPURPLECOLOR )
{
   hb_retnl( ( HB_LONG ) [ NSColor purpleColor ] );
}

HB_FUNC( GETREDCOLOR )
{
   hb_retnl( ( HB_LONG ) [ NSColor redColor ] );
}

HB_FUNC( GETWHITECOLOR )
{
   hb_retnl( ( HB_LONG ) [ NSColor whiteColor ] );
}

HB_FUNC( GETYELLOWCOLOR )
{
   hb_retnl( ( HB_LONG ) [ NSColor yellowColor ] );
}
