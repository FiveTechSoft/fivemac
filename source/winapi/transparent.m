#include <fivemac.h>

HB_FUNC( SETTRANS ) // hWnd
{ 
   NSView * view = [ [ NSView alloc ] init ];
   NSWindow * window = ( NSWindow * ) hb_parnl(1 );

   [ GetView( window ) addSubview : view ];
   [ window setAlphaValue:hb_parnd( 2 ) ];
   
   hb_retnl( ( HB_LONG ) view ); 
}

HB_FUNC( SPLASHCREATE ) // hWnd
{ 
   NSRect screenRect = [[NSScreen mainScreen] frame];
   NSRect content = NSMakeRect(screenRect.size.width/2 - 350, screenRect.size.height/2 - 225, 700, 450);
   NSWindow *w = [[NSWindow alloc] initWithContentRect:content styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO ];

   hb_retnl( ( HB_LONG ) w );    
}

HB_FUNC( SPLASHSETFILE ) // hWnd
{  
   NSWindow * window = ( NSWindow * ) hb_parnl(1 ); 
   NSString * string = hb_NSSTRING_par( 2 ); 	
   
   [ window setBackgroundColor: [ NSColor colorWithPatternImage:[ [NSImage alloc ] initByReferencingFile : string ]]];
   [ window setOpaque: NO ];
}

HB_FUNC( SPLASHRUN ) // hWnd
{ 
   NSWindow * window = ( NSWindow * ) hb_parnl(1 );
 
  [ window makeKeyAndOrderFront: nil ];
  usleep( 5 * 1000000 );
  [ window close ];
}

/*
id) initWithContentRect: (NSRect) contentRect
styleMask: (unsigned int) aStyle
backing: (NSBackingStoreType) bufferingType
defer: (BOOL) flag
{
    if (![super initWithContentRect: contentRect 
                          styleMask: NSBorderlessWindowMask 
                            backing: bufferingType 
                              defer: flag]) return nil;
    [self setBackgroundColor: [NSColor clearColor]];
    [self setOpaque:NO];
    
    return self;*/
