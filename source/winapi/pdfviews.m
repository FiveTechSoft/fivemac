#include <fivemac.h>
#import "Quartz/Quartz.h"

HB_FUNC( PDFVIEWCREATE ) 
{
   NSScrollView * sv = [ [ NSScrollView alloc ] 
 		    	          initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   PDFView * Wview ;
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
   
   [ sv setAutoresizingMask : NSViewWidthSizable | NSViewHeightSizable ];
   [ sv setHasVerticalScroller : YES ];
   [ sv setHasHorizontalScroller : YES ];
   [ sv setBorderType : NSBezelBorder ];

   Wview = [ [ PDFView alloc ] 
 		   initWithFrame : [ [ sv contentView ] frame ] ];
        
   [ sv setDocumentView : Wview ];		   
   [ GetView( window ) addSubview : sv ];
     
   hb_retnl( ( HB_LONG ) Wview );
}  

HB_FUNC( PDFSETDOCUMENT )
{
    PDFView * Pdfview = ( PDFView * ) hb_parnl( 1 );
    NSString * string = hb_NSSTRING_par( 2 ) ;
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:string ];
    PDFDocument *pdfDoc = [[[PDFDocument alloc] initWithURL: fileURL ] autorelease ];
    [ Pdfview setDocument : pdfDoc ];
    
} 


HB_FUNC( PDFSETSCALE )
{
    PDFView * Pdfview = ( PDFView * ) hb_parnl( 1 );
    [ Pdfview setScaleFactor : ( hb_parnl( 2 )/100.0 ) ] ;
 } 

HB_FUNC( PDFZOOMIN )
{
    PDFView * Pdfview = ( PDFView * ) hb_parnl( 1 );
    [ Pdfview zoomIn : Pdfview ] ;
} 

HB_FUNC( PDFZOOMOUT )
{
    PDFView * Pdfview = ( PDFView * ) hb_parnl( 1 );
    [ Pdfview zoomOut : Pdfview ] ;
} 

HB_FUNC( PDFGOBACK )
{
    PDFView * Pdfview = ( PDFView * ) hb_parnl( 1 );
    [ Pdfview goBack : Pdfview ] ;
}

HB_FUNC( PDFGOFORWARD )
{
    PDFView * Pdfview = ( PDFView * ) hb_parnl( 1 );
    [ Pdfview goForward : Pdfview ] ;
} 

HB_FUNC( PDFGOTOP )
{
    PDFView * Pdfview = ( PDFView * ) hb_parnl( 1 );
    [ Pdfview goToFirstPage : Pdfview ] ;
} 

HB_FUNC( PDFGOBOTTOM )
{
    PDFView * Pdfview = ( PDFView * ) hb_parnl( 1 );
    [ Pdfview goToLastPage : Pdfview ] ;
} 

HB_FUNC( PDFGOPREVIOUS )
{
    PDFView * Pdfview = ( PDFView * ) hb_parnl( 1 );
    [ Pdfview goToPreviousPage : Pdfview ] ;
} 

HB_FUNC( PDFGONEXT )
{
    PDFView * Pdfview = ( PDFView * ) hb_parnl( 1 );
    [ Pdfview goToNextPage : Pdfview ] ;
} 

HB_FUNC( PDFAUTOSCALE )
{
    PDFView * Pdfview = ( PDFView * ) hb_parnl( 1 );
    [ Pdfview setAutoScales : hb_parl( 2 ) ] ;
} 


