#include <fivemac.h>

static NSWindow * wndMain = NULL;

@interface NSString (Size)

- (NSSize) sizeWithWidth:(float)width andFont:(NSFont *)font;

@end

@implementation NSString (Size)

- (NSSize) sizeWithWidth:(float)width andFont:(NSFont *)font {
    
    NSSize size = NSMakeSize(width, FLT_MAX);
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:self];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:size];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage addAttribute:NSFontAttributeName value:font
                        range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    
    [layoutManager glyphRangeForTextContainer:textContainer];
    
    size.height = [layoutManager usedRectForTextContainer:textContainer].size.height;
    
    return size;
}

@end

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
   @interface RoundedView : NSView <NSWindowDelegate>
#else
   @interface RoundedView : NSView
#endif
{
   @public NSWindow * hWnd;
}

@end

@implementation RoundedView

- (void)drawRect:(NSRect)frame
{
    NSColor *bgColor = [NSColor colorWithCalibratedWhite:0.0 alpha:0.65];
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:frame
                                                         xRadius:15.0 yRadius:15.0];
    [bgColor set];
    [path fill];
}

@end

HB_FUNC( MSGROUNDCREATE )
{
    NSString * string = hb_NSSTRING_par( 1 );
   
    float padding = 5;
     NSSize size = [string sizeWithWidth:350.0 andFont:[NSFont labelFontOfSize: 22.0 ]];
    
    NSSize popoverSize = NSMakeSize(size.width + (padding * 2), size.height + (padding * 2));
    NSRect popoverRect = NSMakeRect(0, 0, popoverSize.width, popoverSize.height);

    NSTextField *label = [[NSTextField alloc] initWithFrame:NSMakeRect(padding, padding, size.width, size.height)];
      
    [label setBezeled:NO];
    [label setDrawsBackground:NO];
    [label setEditable:NO];
    [label setSelectable:NO];
    [ label setFont : [NSFont labelFontOfSize: 22.0  ]];
       
    [ label setTextColor : [ NSColor whiteColor ] ] ;
    [ label setStringValue:string];
    
    [[label cell] setLineBreakMode:NSLineBreakByWordWrapping];
    
        
    NSPanel * window = [ [ NSPanel alloc ] 
						initWithContentRect : popoverRect
						styleMask :NSWindowStyleMaskBorderless
						backing : NSBackingStoreBuffered
						defer :  NO ];
    
    RoundedView * view = [ [ RoundedView alloc ] init ];
	
    view->hWnd = window;
    [ window setContentView : view ];
    [ window setDelegate : view ];
    
    [view addSubview:label];
    [label setBounds:NSMakeRect(padding, padding, size.width, size.height)];
    [label setAlignment : 2 ];
    
    if( wndMain == NULL )
		wndMain = window;	
	
	[ window makeFirstResponder : view ]; 
	[ window setAcceptsMouseMovedEvents : YES ];

     #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
	   [ window setStyleMask: NSWindowStyleMaskBorderless ];
	#endif

	[window center];
	[window setLevel: NSStatusWindowLevel];
	[ window setBackgroundColor : [ NSColor colorWithDeviceWhite : 1.0 alpha : 0.0 ] ];
	[window  setAlphaValue:0.90];
	[window setOpaque:NO];
	[window setHasShadow:NO];	
    
	[ window makeKeyAndOrderFront : nil ];
	 hb_retnl( ( HB_LONG ) window );	 
     
}    

HB_FUNC( MSGROUNDCLOSE )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 ); 
     
    [window close ]; 
}

HB_FUNC( RDWNDCREATE )
{
     NSPanel * window = [ [ NSPanel alloc ] 
						initWithContentRect : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) )
						styleMask :NSWindowStyleMaskBorderless
						backing : NSBackingStoreBuffered
						defer :  NO ];
    RoundedView * view = [ [ RoundedView alloc ] init ];
	
    view->hWnd = window;
    [ window setContentView : view ];
    [ window setDelegate : view ];
    
    if( wndMain == NULL )
		wndMain = window;	
	
	[ window makeFirstResponder : view ]; 
	[ window setAcceptsMouseMovedEvents : YES ];

     #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 101000
	   [window setStyleMask: NSWindowStyleMaskBorderless ];
     #endif
 
	[window center];
	[window setLevel: NSStatusWindowLevel];
	[ window setBackgroundColor : [ NSColor colorWithDeviceWhite : 1.0 alpha : 0.0 ] ];
	[window  setAlphaValue:0.90];
	[window setOpaque:NO];
	[window setHasShadow:NO];	
	
	hb_retnl( ( HB_LONG ) window );	       
}    

HB_FUNC(WNDSETROUNDED)
{
  NSWindow * window = ( NSWindow * ) hb_parnl( 1 ); 
  RoundedView * view = [ [ RoundedView alloc ] init ];
  view->hWnd = window;
  [ window setContentView : view ];
  [ window setDelegate : view ];
  [ window makeFirstResponder : view ];  

   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 101000
     [ window setStyleMask: NSWindowStyleMaskBorderless ];
   #endif
	
  [window center];
  [window setLevel: NSStatusWindowLevel];
  [ window setBackgroundColor : [ NSColor colorWithDeviceWhite : 1.0 alpha : 0.0 ] ];
  [window  setAlphaValue: 0.90 ];
  [window setOpaque:NO];
  [window setHasShadow:NO];	    
}
   
