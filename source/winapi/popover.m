#include <fivemac.h>

@interface NSString (Size)
   - (NSSize) sizeWithWidth:(float)width andFont:(NSFont *)font;
@end

#if __MAC_OS_X_VERSION_MAX_ALLOWED < 1070
   #define NSPopoverBehaviorTransient 1
   @interface NSPopover : NSObject 
#else
   @interface NSPopover ( Message ) 
#endif

- (void) showRelativeToRect:(NSRect)rect
                     ofView:(NSView *)view
              preferredEdge:(NSRectEdge)edge
                     string:(NSString *)string   
                   maxWidth:(float)width;

- (void) showWinRelativeToRect:(NSRect)rect
                     ofView:(NSView *)view
              preferredEdge:(NSRectEdge)edge
                     window:(NSWindow *)window   
                   maxWidth:(float)width;

#if __MAC_OS_X_VERSION_MAX_ALLOWED < 1070

- (void) setContentSize: ( NSSize ) size;
	
- (void) setContentViewController: ( NSViewController * ) controller;	

- (void) setAnimates: ( BOOL ) bYesNo;

- (void) setBehavior: ( int ) iBehavior;

#endif

@end

//----------------------------------------------------------//

#if __MAC_OS_X_VERSION_MAX_ALLOWED < 1070
   @implementation NSPopover
#else
   @implementation NSPopover ( Message )
#endif

- (void) showRelativeToRect:(NSRect)rect
                     ofView:(NSView *)view
              preferredEdge:(NSRectEdge)edge
                     string:(NSString *)string   
                   maxWidth:(float)width 
{
    float padding = 5;
    
    NSSize size = [string sizeWithWidth:250.0 andFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSRegularControlSize]]];
    
    NSSize popoverSize = NSMakeSize(size.width + (padding * 2), size.height + (padding * 2));
    NSRect popoverRect = NSMakeRect(0, 0, popoverSize.width, popoverSize.height);
    
    NSTextField *label = [[NSTextField alloc] initWithFrame:NSMakeRect(padding, padding, size.width, size.height)];
    
    [label setBezeled:NO];
    [label setDrawsBackground:NO];
    [label setEditable:NO];
    [label setSelectable:NO];
    [label setStringValue:string];
    [[label cell] setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSView *container = [[NSView alloc] initWithFrame:popoverRect];
    [container addSubview:label];
    [label setBounds:NSMakeRect(padding, padding, size.width, size.height)];
    [container awakeFromNib];
    
    NSViewController *controller = [[NSViewController alloc] init];
    [controller setView:container];
    
  //  NSPopover *popover = [[NSPopover alloc] init];
    
    [self setContentSize: popoverSize];
    [self setContentViewController:controller];
    [self setAnimates:YES];
    [self setBehavior: NSPopoverBehaviorTransient ];
    
    [self showRelativeToRect:rect
                         ofView:view
                  preferredEdge:edge];
    return  ;
}


- (void) showWinRelativeToRect:(NSRect)rect
                     ofView:(NSView *)view
              preferredEdge:(NSRectEdge)edge
                     window :(NSWindow *)window   
                   maxWidth:(float)width 
{    
    float padding = 5;
    
    NSRect frame = [window frame];
        
    NSSize popoverSize = NSMakeSize(frame.size.width + (padding * 2), frame.size.height + (padding * 2));
    NSRect popoverRect = NSMakeRect(0, 0, popoverSize.width, popoverSize.height);
    
    NSView *container = [[NSView alloc] initWithFrame:popoverRect];
    [container addSubview: GetView( window ) ];
    [GetView( window ) setBounds:NSMakeRect(padding, padding, frame.size.width, frame.size.height)];
    [container awakeFromNib];
    
    NSViewController *controller = [[NSViewController alloc] init];
    [controller setView:container];
    
   // NSPopover *popover = [[NSPopover alloc] init];
    
    [self setContentSize:popoverSize];
    [self setContentViewController:controller];
    [self setAnimates:YES];
    [self setBehavior:NSPopoverBehaviorTransient];
    
    [self showRelativeToRect:rect
                         ofView:view
                  preferredEdge:edge];
    return  ;
}

@end

//----------------------------------------------------------//

HB_FUNC( SHOWPOPOVER ) 
{
    NSControl * theInput = ( NSControl * ) hb_parnl( 1 );
    NSString * mystring = hb_NSSTRING_par( 2 ) ;
    NSPopover * popover = [[NSPopover alloc] init]; 
    [ popover showRelativeToRect:[theInput frame]
                          ofView:[theInput superview]
                     preferredEdge:NSMaxXEdge  // Show the popover on the right edge
                     string: mystring 
                     maxWidth:250.0];
    
     hb_retnl( ( HB_LONG ) popover );
}   

HB_FUNC( SHOWWINPOPOVER ) 
{
   NSControl * theInput = ( NSControl * ) hb_parnl( 1 ); 
   NSWindow * window = ( NSWindow * ) hb_parnl( 2 ); 
   NSPopover * popover = [[NSPopover alloc] init];
  
   [ popover showWinRelativeToRect:[theInput frame]
                            ofView:[theInput superview]
                     preferredEdge:NSMaxXEdge  // Show the popover on the right edge
                            window: window 
                          maxWidth:250.0];
    
   hb_retnl( ( HB_LONG ) popover );
}   

HB_FUNC( CLOSEPOPOVER ) 
{
   NSPopover * popover = ( NSPopover * ) hb_parnl( 1 );  
  
   [ popover close ];      
}    

HB_FUNC( SETPOPOVERAPPERANCE ) 
{
   NSPopover * popover = ( NSPopover * ) hb_parnl( 1 );  
    popover.appearance =   hb_parni( 2 )   ; 
} 

