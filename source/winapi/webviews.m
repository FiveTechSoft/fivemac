#include <fivemac.h>
#import <WebKit/WebKit.h>

HB_FUNC( WEBVIEWCREATE ) 
{
   NSScrollView * sv = [ [ NSScrollView alloc ] 
 		    	          initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   WebView * Wview ;
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
   
   [ sv setAutoresizingMask : NSViewWidthSizable | NSViewHeightSizable ];
   [ sv setHasVerticalScroller : YES ];
   [ sv setHasHorizontalScroller : YES ];
   [ sv setBorderType : NSBezelBorder ];

   Wview = [ [ WebView alloc ] 
 		   initWithFrame : [ [ sv contentView ] frame ] ];
        
   [ sv setDocumentView : Wview ];		   
   [ GetView( window ) addSubview : sv ];
     
   hb_retnl( ( HB_LONG ) Wview );
}  

HB_FUNC( WEBVIEWLOADREQUEST ) 
{
    NSString * string = hb_NSSTRING_par( 2 ) ;
   
	 WebView * Wview = ( WebView * ) hb_parnl( 1 );
   
   [ [ Wview mainFrame ] loadRequest : [ NSURLRequest requestWithURL : [ NSURL URLWithString : string ] ] ];	
} 

HB_FUNC( WEBVIEWGOBACK ) 
{
   WebView * Wview = ( WebView * ) hb_parnl( 1 );
   
   [ Wview goBack ];	
} 

HB_FUNC( WEBVIEWGOFORWARD ) 
{
   WebView * Wview = ( WebView * ) hb_parnl( 1 );
   
   [ Wview goForward ];	
} 

HB_FUNC( WEBVIEWRELOAD )
{
   WebView * Wview = ( WebView * ) hb_parnl( 1 );
	
	 [ Wview reload : Wview ];   
}

HB_FUNC( WEBVIEWISLOADING )
{
    WebView * Wview = ( WebView * ) hb_parnl( 1 );
	
  hb_retl(  [ Wview isLoading  ] );
}

HB_FUNC( WEBVIEWPROGRESS )
{
   WebView * Wview = ( WebView * ) hb_parnl( 1 );
	
	 hb_retnl( [ Wview estimatedProgress ] * 100 );   
}

HB_FUNC( WEBVIEWSTOPLOADING )
{
   WebView * Wview = ( WebView * ) hb_parnl( 1 );
   
   [ Wview stopLoading : Wview ];   
}
 
HB_FUNC( WEBVIEWSETTEXTSIZEMULTIPLIER )
{
   WebView * Wview = ( WebView * ) hb_parnl( 1 );	
	 [ Wview setTextSizeMultiplier : ( hb_parnl( 2 ) / 100.0 ) ];   
}

HB_FUNC( JUMPTOANCHOR )
{
    WebView * Wview = ( WebView * ) hb_parnl( 1 );
	NSString * anchor =  hb_NSSTRING_par( 2 ) ;
   [Wview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var anchor = document.anchors[\"%@\"];window.scrollTo(anchor.offsetLeft, anchor.offsetTop);", anchor]]; 
 }
      
HB_FUNC( WEBSCRIPCALLMETHOD )
{
    WebView * Wview = ( WebView * ) hb_parnl( 1 );
    NSString * string =hb_NSSTRING_par( 2 ) ;
    [[ Wview windowScriptObject] callWebScriptMethod: string withArguments:nil];
}

HB_FUNC( WEBSCRIPCALLMETHODARG )
{
    WebView * Wview = ( WebView * ) hb_parnl( 1 );
    NSString * string =hb_NSSTRING_par( 2 ) ;
    NSString * arg =hb_NSSTRING_par( 3 ) ;
    NSArray  * args = [NSArray arrayWithObjects: arg , nil ];
    [[ Wview windowScriptObject] callWebScriptMethod: string withArguments:args];
}

HB_FUNC( WEBVIEWSTARTSPEAKING )
{
   WebView * Wview = ( WebView * ) hb_parnl( 1 );
	 [ Wview startSpeaking : Wview ];   
}

HB_FUNC( WEBVIEWSTOPSPEAKING )
{
   WebView * Wview = ( WebView * ) hb_parnl( 1 );
	 [ Wview stopSpeaking : Wview ];   
}