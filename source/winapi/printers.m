#include <fivemac.h>

void CocoaInit( void );

@interface PrnView : NSView
{
   @public NSWindow * hWnd;	
}
- ( void ) drawRect : ( NSRect ) needsDisplayInRect;
@end

@implementation PrnView

- ( void ) drawRect : ( NSRect ) needsDisplayInRect
{
   PHB_SYMB symPrinterPaint = hb_dynsymSymbol( hb_dynsymFindName( "PrinterPaint" ) );
   
   hb_vmPushSymbol( symPrinterPaint );
   hb_vmPushNil();
   hb_vmDo( 0 );
}

- (BOOL)isFlipped
{
    return YES;
}

@end

HB_FUNC( PRINTERSELECT )
{
   PrnView * view;
   
   CocoaInit();
      
   view = [ [ PrnView alloc ] initWithFrame : NSMakeRect( 0, 0, 300, 300 ) ];
   
   [ [ NSPrintOperation printOperationWithView : view ] runOperation ];
   
   [ view release ];
}

HB_FUNC( NRGBCOLOR )
{
   NSColor * color = [ NSColor colorWithCalibratedRed : ( CGFloat) hb_parnl( 1 ) green : ( CGFloat ) hb_parnl( 2 ) 
                     blue : ( CGFloat ) hb_parnl( 3 ) alpha : ( CGFloat ) 100 ];
   hb_retnl( ( HB_LONG ) color );
}                     

HB_FUNC( CLRRED )
{
   hb_retnl( ( HB_LONG ) [ NSColor redColor ] );
}   

HB_FUNC( CLRGREEN )
{
   hb_retnl( ( HB_LONG ) [ NSColor greenColor ] );
}   

HB_FUNC( CLRBLUE )
{
   hb_retnl( ( HB_LONG ) [ NSColor blueColor ] );
}   

HB_FUNC( COLOR_SET )
{
   [ ( ( NSColor * ) hb_parnl( 1 ) ) set ];
}  


HB_FUNC( PRNJOBCREATE ) 
{
  NSPrintOperation * printjob ;
  PrnView * view = ( PrnView * ) hb_parnl( 1 );
  printjob = [ NSPrintOperation printOperationWithView : view ] ;
   hb_retnl( ( HB_LONG ) printjob );
}   

HB_FUNC( PRNVIEWCREATE ) 
{
  PrnView * view = [ [ PrnView alloc ] 
  			initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ] ;
  			
  hb_retnl( ( HB_LONG ) view );
}   

HB_FUNC( PRNJOBRUN ) 
{
  NSPrintOperation * printjob = ( NSPrintOperation *  ) hb_parnl( 1 );
  [ printjob runOperation ];
}

HB_FUNC( PRNJOBCURRENT ) 
{
  NSPrintOperation * printjob = [NSPrintOperation currentOperation] ;
  hb_retnl( ( HB_LONG ) printjob );
}

HB_FUNC( PRNINFOCREATE ) 
{
 NSPrintOperation * printjob = ( NSPrintOperation *  ) hb_parnl( 1 );
 NSPrintInfo *pi = [ printjob printInfo] ;
  hb_retnl( ( HB_LONG ) pi );
}

HB_FUNC( PRNSETPAPERNAME ) 
{
 NSString * string = hb_NSSTRING_par( 2 );
 NSPrintInfo * pi = ( NSPrintInfo *  ) hb_parnl( 1 );
 [ pi setPaperName : string ] ;
}

HB_FUNC( PRNSHOWPANEL ) 
{
 NSPrintOperation * printjob = ( NSPrintOperation *  ) hb_parnl( 1 );
 [printjob setShowsPrintPanel: hb_parl(2) ];
}

HB_FUNC( PRNINFOSHARED ) 
{
NSPrintInfo  *sharedPrintInfo = [NSPrintInfo sharedPrintInfo];
 hb_retnl( ( HB_LONG ) sharedPrintInfo  );
}

HB_FUNC( PRNINFOSCALE ) 
{
 NSPrintInfo * pi = ( NSPrintInfo *   ) hb_parnl( 1 );
 float scale = [[[pi dictionary] objectForKey:NSPrintScalingFactor] floatValue];
 hb_retnl( scale );
}

HB_FUNC( PRNINFOPAGEWIDTH) // in points
{
 NSPrintInfo * pi = ( NSPrintInfo * ) hb_parnl( 1 );
 NSSize paperSize = [ pi paperSize];
 float pageWidth = paperSize.width ;
 hb_retnl( pageWidth );
}

HB_FUNC( PRNINFOPAGEHEIGHT) // in points
{
 NSPrintInfo * pi = ( NSPrintInfo *   ) hb_parnl( 1 );
 NSSize paperSize = [ pi paperSize];
 float pageHeight = paperSize.height ;
 hb_retnl( pageHeight );
}

HB_FUNC( PRNINFOPAGLEFTMARGIN) // in points
{
 NSPrintInfo * pi = ( NSPrintInfo *   ) hb_parnl( 1 );
 hb_retnl( [ pi leftMargin]  );
}

HB_FUNC( PRNINFOPAGTOPMARGIN) // in points
{
 NSPrintInfo * pi = ( NSPrintInfo *  ) hb_parnl( 1 );
 hb_retnl( [ pi topMargin ]  );
}

HB_FUNC( PRNINFOPAGBOTTOMMARGIN) // in points
{
 NSPrintInfo * pi = ( NSPrintInfo *   ) hb_parnl( 1 );
 hb_retnl( [ pi bottomMargin ]  );
}

HB_FUNC( PRNINFOPAGRIGHTMARGIN) // in points
{
 NSPrintInfo * pi = ( NSPrintInfo *   ) hb_parnl( 1 );
 hb_retnl( [ pi rightMargin]  );
}

HB_FUNC( PRNINFOPAGSETRIGHTMARGIN) // in points
{
 NSPrintInfo * pi = ( NSPrintInfo *   ) hb_parnl( 1 );
 [ pi setRightMargin : hb_parnl( 2 ) ] ;
}

HB_FUNC( PRNINFOPAGSETLEFTMARGIN) // in points
{
 NSPrintInfo * pi = ( NSPrintInfo *  ) hb_parnl( 1 );
 [ pi setLeftMargin : hb_parnl( 2 ) ] ;
}

HB_FUNC( PRNINFOPAGSETBUTTOMMARGIN) // in points
{
 NSPrintInfo * pi = ( NSPrintInfo *   ) hb_parnl( 1 );
 [ pi setBottomMargin : hb_parnl( 2 ) ] ;
}

HB_FUNC( PRNINFOPAGSETTOPMARGIN) // in points
{
 NSPrintInfo * pi = ( NSPrintInfo *   ) hb_parnl( 1 );
 [ pi setTopMargin : hb_parnl( 2 ) ] ;
}

HB_FUNC( PRNINFOPAGSETBOTTOMMARGIN) // in points
{
 NSPrintInfo * pi = ( NSPrintInfo *   ) hb_parnl( 1 );
 [ pi setBottomMargin : hb_parnl( 2 ) ] ;
}

HB_FUNC( PRNINFOPAGSETORIENTATION) 
{
 NSPrintInfo * pi = ( NSPrintInfo *   ) hb_parnl( 1 );
 [ pi setOrientation: hb_parni( 2 ) ] ;
}

HB_FUNC( PRNINFOAUTOPAGE) 
{
 NSPrintInfo * pi = ( NSPrintInfo *   ) hb_parnl( 1 );

 [ pi setHorizontalPagination:NSPrintingPaginationModeAutomatic];
 [ pi setVerticalPagination:NSPrintingPaginationModeAutomatic];
 [ pi setVerticallyCentered:NO];
}

HB_FUNC( PRNSAY ) // in points
{
   NSTextField * say = [ [ NSTextField alloc ] 
 			                   initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), 
 			                   	                           hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   PrnView * window = ( PrnView * ) hb_parnl( 5 );
   NSString * string = hb_NSSTRING_par( 6 );
   NSString * cFontName = hb_NSSTRING_par( 7 );
   
   [ say setFont: [ NSFont fontWithName: cFontName size: hb_parnl( 8 ) ] ];
   
   [ say setTextColor: ( NSColor * ) hb_parnl( 9 ) ];
   [ say setBackgroundColor: ( NSColor * ) hb_parnl( 10 )];
   [ say setEditable : FALSE ]; 
   [ say setSelectable : FALSE ]; 
   [ say setBordered : FALSE ]; 
   [ say setDrawsBackground : FALSE ];
   [ say setStringValue : string ];
   [ say setAlignment : hb_parnl( 11 ) ];
   [ window addSubview : say ];
   
   hb_retnl( ( HB_LONG ) say );
}


HB_FUNC( PRNSETSIZE )
{
    PrnView * window = ( PrnView * ) hb_parnl( 1 );
    NSRect frame = [ window frame ];
    CGFloat nWidth = hb_parnl( 2 );
    CGFloat nHeight = hb_parnl( 3 );
    
    frame.origin.y   -= nHeight - frame.size.height;
    frame.size.height = nHeight;
    frame.size.width  = nWidth;  
    
    [ window setFrame: frame ];    
}	

HB_FUNC( PRNINFOIMAGEABLEBOUNDS )
{
    NSPrintInfo * pi = ( NSPrintInfo *   ) hb_parnl( 1 );
    NSRect boundRect  = [ pi imageablePageBounds ] ;
    
    hb_reta(2);
    hb_storvnl( ( long ) boundRect.size.width, -1, 1);
    hb_storvnl( ( long ) boundRect.size.height,-1, 2);
}

