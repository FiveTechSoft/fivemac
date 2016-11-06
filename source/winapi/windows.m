#include <fivemac.h>

static PHB_SYMB symFMH = NULL;
static NSWindow * wndMain = NULL;

@interface PrnView : NSView
{
   @public NSWindow * hWnd;	
}
- ( void ) drawRect : ( NSRect ) needsDisplayInRect;
@end

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
   @interface View : NSView <NSWindowDelegate>
#else
   @interface View : NSView
#endif
{
   @public BOOL bDesign;	
}
- ( BOOL ) windowShouldClose : ( NSNotification * ) notification;
- ( void ) windowWillClose : ( NSNotification * ) notification;
- ( BOOL ) acceptsFirstResponder ;
- ( void ) windowDidUpdate : ( NSNotification * ) notification;
- ( void ) mouseDown : ( NSEvent * ) theEvent;
- ( void ) mouseUp : ( NSEvent * ) theEvent;
- ( void ) rightMouseDown : ( NSEvent * ) theEvent;
- ( void ) mouseMoved : ( NSEvent * ) theEvent;
- ( void ) mouseDragged : ( NSEvent * ) theEvent;
- ( void ) keyDown : ( NSEvent * ) theEvent;
- ( void ) flagsChanged : ( NSEvent * ) theEvent;
- ( void ) windowDidResize: ( NSNotification * ) notification;	
- ( void ) MenuItem : ( id ) sender;
- ( void ) BtnClick : ( id ) sender;
- ( void ) CbxChange : ( id ) sender;
- ( void ) ChkClick : ( id ) sender;
- ( void ) BrwDblClick : ( id ) sender;
- ( void ) TbrClick : ( id ) sender;
- ( void ) OnTimerEvent : ( NSTimer * ) timer;
- ( void ) SliderChanged : ( id ) sender;
- ( IBAction ) changeColor : ( id ) sender; 	
- ( NSView * ) hitTest: ( NSPoint ) aPoint;	
//- ( BOOL ) isFlipped ;
@end

@implementation View

- ( BOOL ) windowShouldClose : ( NSNotification * ) notification  // VALID clause !
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_WNDVALID );
   hb_vmDo( 2 );
   
   if( HB_ISLOG( -1 ) )
      return hb_parl( -1 );
   else
      return TRUE;
} 

- ( void ) windowWillClose : ( NSNotification * ) notification
{
   if( [ self window ] == wndMain )
      [ NSApp terminate : self ];
   else
      [ NSApp stopModal ]; // modal dialogs	   
}

- (BOOL)acceptsFirstResponder
{
    if( symFMH == NULL )
        symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
    
    hb_vmPushSymbol( symFMH );
    hb_vmPushNil();
    hb_vmPushLong( ( HB_LONG ) [ self window ] );
    hb_vmPushLong( WM_WHEN );
    hb_vmDo( 2 );
    
    if( HB_ISLOG( -1 ) )
        return hb_parl( -1 );
    else
        return TRUE;

}


- ( void ) windowDidUpdate : ( NSNotification * ) notification
{
    if( symFMH == NULL )
        symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
    
    hb_vmPushSymbol( symFMH );
    hb_vmPushNil();
    hb_vmPushLong( ( HB_LONG ) [ self window ] );
    hb_vmPushLong( WM_PAINT );
    hb_vmDo( 2 );
}

- ( void ) mouseDown : ( NSEvent * ) theEvent
{
   NSPoint point = [ theEvent locationInWindow ]; 

   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_LBUTTONDOWN );
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( point.y );
   hb_vmPushLong( point.x );
   hb_vmDo( 5 );
}

/*
- ( BOOL ) isFlipped 
{
   if( symFMH == NULL )
       symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
    
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_FLIPPED );
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmDo( 3 );
       
   return hb_parl( -1 );
}
*/

- ( void ) mouseUp : ( NSEvent * ) theEvent
{
   NSPoint point = [ theEvent locationInWindow ]; 

   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_LBUTTONUP );
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( point.y );
   hb_vmPushLong( point.x );
   hb_vmDo( 5 );
}

- ( void ) rightMouseDown : ( NSEvent * ) theEvent
{
    NSPoint point = [ theEvent locationInWindow ]; 
    
    if( symFMH == NULL )
        symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
    
    hb_vmPushSymbol( symFMH );
    hb_vmPushNil();
    hb_vmPushLong( ( HB_LONG ) [ self window ] );
    hb_vmPushLong( WM_RBUTTONDOWN );
    hb_vmPushLong( ( HB_LONG ) [ self window ] );
    hb_vmPushLong( point.y );
    hb_vmPushLong( point.x );
    hb_vmDo( 5 );
}	

- ( void ) mouseMoved : ( NSEvent * ) theEvent
{
   NSPoint point = [ theEvent locationInWindow ]; 
   NSPoint absPos = [ self convertPoint : [ theEvent locationInWindow ] fromView : nil ];
   BOOL isInside = [ self mouse : absPos inRect : [ self bounds ] ];
     
   if( ! isInside )
      return;
   
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_MOUSEMOVED );
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( point.y );
   hb_vmPushLong( point.x );
   hb_vmDo( 5 );
}	

- ( void ) mouseDragged : ( NSEvent * ) theEvent
{
   NSPoint point = [ theEvent locationInWindow ]; 
   NSPoint absPos = [ self convertPoint : [ theEvent locationInWindow ] fromView : nil ];
   BOOL isInside = [ self mouse : absPos inRect : [ self bounds ] ];
     
   if( ! isInside )
      return;
   
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_MOUSEMOVED );
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( point.y );
   hb_vmPushLong( point.x );
   hb_vmDo( 5 );
}	

- ( void ) keyDown : ( NSEvent * ) theEvent
{
   // unsigned int flags = [ theEvent modifierFlags ]; 
   NSString * key = [ theEvent characters ]; 
   int unichar = [ key characterAtIndex: 0 ];
   
   // if ( flags & NSAlternateKeyMask) 
   //    NSLog(@"Option key on");   
    
   // NSRunAlertPanel( @"Attention", @"key pressed", @"Ok", NULL, NULL, NULL );

   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
    
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ]  );
   hb_vmPushLong( WM_KEYDOWN );
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( unichar );
   hb_vmDo( 4 );
   
   if( hb_parnl( -1 ) != 1 )
      [ super keyDown: theEvent ];
}	

- ( void ) flagsChanged : ( NSEvent * ) theEvent
{
   /*
   unsigned flags = [ theEvent modifierFlags ];

   if( [ theEvent keyCode ] == 0x39 ) // 57 = key code for caps lock
   {
      if( flags & NSAlphaShiftKeyMask )
         NSLog( @"capsLock on" );
      else
         NSLog( @"capsLock off" );
   }
   */
    
   /*
    if ( flags & NSAlternateKeyMask) NSLog(@"Option key on"); 
    if ( flags & NSShiftKeyMask) NSLog(@"shift key has been  presseed"); 
    if ( flags &  NSControlKeyMask ) NSLog(@"Control key has been presseed"); 
    if ( flags &  NSCommandKeyMask ) NSLog(@"Command key has been presseed"); 
   */     
   
   [ super flagsChanged : theEvent ];
}

- ( void ) windowDidResize: ( NSNotification * ) notification
{	
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_RESIZE );
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmDo( 3 );
}   

- ( void ) MenuItem : ( id ) sender
{
      if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_MENUITEM );
   hb_vmPushLong( ( HB_LONG ) sender );
   hb_vmDo( 3 );
}   

- ( void ) BtnClick : ( id ) sender;
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_BTNCLICK );
   hb_vmPushLong( ( HB_LONG ) sender );
   hb_vmDo( 3 );
}   

- ( void ) BrwDblClick : ( id ) sender;
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
	
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_BRWDBLCLICK );
   hb_vmPushLong( ( HB_LONG ) sender );
   hb_vmDo( 3 );
   
} 

- ( void ) CbxChange : ( id ) sender
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_CBXCHANGE );
   hb_vmPushLong( ( HB_LONG ) sender );
   hb_vmDo( 3 );
}

- ( void ) ChkClick : ( id ) sender;
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_CHKCLICK );
   hb_vmPushLong( ( HB_LONG ) sender );
   hb_vmDo( 3 );
}   

- ( IBAction ) changeColor : ( id ) sender
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_CLRCHANGE );
   hb_vmPushLong( ( HB_LONG ) sender );
   hb_vmDo( 3 );
}	

- ( void ) TbrClick : ( id ) sender;
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_TBRCLICK );
   hb_vmPushLong( ( HB_LONG ) sender );
   hb_vmDo( 3 );
}   

- ( void ) OnTimerEvent : ( NSTimer * ) timer
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_TIMER );
   hb_vmPushLong( ( HB_LONG ) timer );
   hb_vmDo( 3 );
}

- ( void ) SliderChanged : ( id ) sender;      
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
      
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_SLIDERCHANGE );
   hb_vmPushLong( ( HB_LONG ) sender );
   hb_vmDo( 3 );
}

- ( NSView * ) hitTest: ( NSPoint ) aPoint	
{
   if( bDesign )
      return self;
   else	
      return [ super hitTest: aPoint ];	
}	

@end

HB_FUNC( WNDCREATE )
{
   NSPanel * window = [ [ NSPanel alloc ] 
	       initWithContentRect : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) )
               styleMask :	hb_parnl( 5 )
	       backing : NSBackingStoreBuffered
	       defer :  NO ];
   View * view = [ [ View alloc ] init ];
   view->bDesign = FALSE;

   [ window setContentView : view ];
   [ window setDelegate : view ];
    
   if( wndMain == NULL )
      wndMain = window;	

   [ window makeFirstResponder : view ]; 
   [ window setAcceptsMouseMovedEvents : YES ];
       
   hb_retnl( ( HB_LONG ) window );	       
}    

HB_FUNC( WNDRUN )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
	
   [ window makeKeyAndOrderFront : nil ];

   if( window == wndMain )
      [ NSApp run ];							
}   

HB_FUNC( WNDSAY )
{
   NSString * string = hb_NSSTRING_par( 3 );
   NSMutableDictionary * attr = [ [ NSMutableDictionary alloc ] init ];

   [ attr setObject : [ NSFont boldSystemFontOfSize: 14 ] forKey: NSFontAttributeName ];
   [ attr setObject : [ NSColor blackColor ] forKey: NSForegroundColorAttributeName ];

   [ string drawAtPoint: NSMakePoint( hb_parnl( 1 ), hb_parnl( 2 ) ) withAttributes: attr ];
}

HB_FUNC( WNDSETFOCUS )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
	
   [ window makeKeyAndOrderFront: nil ];
}   

HB_FUNC( GETFOCUS )
{
   hb_retnl( ( HB_LONG ) [ NSView focusView ] );
}   	

HB_FUNC( WNDSETFONT )
{
   NSControl * view = ( NSControl * ) hb_parnl( 1 );
   NSString * name = hb_NSSTRING_par( 2 );
   
   [ view setFont : [ [ NSFont fontWithName : name 
                        size : hb_parnl( 3 ) ] autorelease ] ];
}   

HB_FUNC( WNDCLOSE )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
	
   [ window performClose : nil ];
}   

HB_FUNC( WNDDESIGN )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   View * view = [ window contentView ];

   hb_retl( view->bDesign );
   
   if( ! HB_ISNIL( 2 ) )   
      view->bDesign = hb_parl( 2 );
}   

HB_FUNC( WNDHITTEST )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   View * view = [ window contentView ];
   NSPoint aPoint;
   BOOL bDesign = view->bDesign;
   NSView * ctrl;
   
   aPoint.y = ( float ) hb_parnl( 2 );
   aPoint.x = ( float ) hb_parnl( 3 );	
   
   view->bDesign = FALSE;
   ctrl = [ view hitTest: aPoint ];

   if( [ [ ctrl class ] isSubclassOfClass: [ NSScrollView class ] ] )
      ctrl = [ ( ( NSScrollView * ) ctrl ) documentView ];
   	
   hb_retnl( ( long ) ctrl );
   view->bDesign = bDesign;	
}   			

HB_FUNC( WNDICONIZE )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
	
   [ window performMiniaturize : nil ];
}   

HB_FUNC( WNDMAXIMIZE )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
	
   [ window performZoom : nil ];
}   

HB_FUNC( WNDREFRESH )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
	
   [ window update ];
}   

HB_FUNC( WNDSETTEXT )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 );
   
   [ window setTitle : string ];
}   

HB_FUNC( WNDGETTEXT )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   NSString * string = [ window title ];
   
   hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}   		

HB_FUNC( WNDTOP )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   NSRect frame = [ window frame ];   
   
   if( [ [ window class ] isSubclassOfClass: [ NSTableView class ] ] )
   {
      window = ( NSWindow * ) [ ( ( NSTableView * ) window ) enclosingScrollView ];
      
      frame = [ window frame ];
   }
   
   if( HB_ISNUM( 2 ) )
   {
      frame.origin.y = hb_parnl( 2 );
      
      if( [ [ window className ] isEqual : @"NSPanel" ] )
         [ window setFrame : frame display : YES ];
      else
      {	      
         [ ( ( NSControl * ) window ) setFrame : frame ];
         [ [ ( ( NSControl * ) window ) window ] display ];
      } 
   }

   hb_retnl( frame.origin.y );
}	

HB_FUNC( WNDLEFT )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   NSRect frame = [ window frame ];   

   if( [ [ window class ] isSubclassOfClass: [ NSTableView class ] ] )
   {
      window = ( NSWindow * ) [ ( ( NSTableView * ) window ) enclosingScrollView ];
      
      frame = [ window frame ];
   }

   if( HB_ISNUM( 2 ) )
   {
      frame.origin.x = hb_parnl( 2 );
      if( [ [ window className ] isEqual : @"NSPanel" ] )
         [ window setFrame : frame display : YES ];
      else
      {	      
         [ ( ( NSControl * ) window ) setFrame : frame ];
         [ [ ( ( NSControl * ) window ) window ] display ];
      } 
   }
   
   hb_retnl( frame.origin.x );
}	

HB_FUNC( WNDWIDTH )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   NSRect frame = [ window frame ];   

   if( [ [ window class ] isSubclassOfClass: [ NSTableView class ] ] )
   {
      window = ( NSWindow * ) [ ( ( NSTableView * ) window ) enclosingScrollView ];
      
      frame = [ window frame ];
   }

   if( HB_ISNUM( 2 ) )
   {
      frame.size.width = hb_parnl( 2 );
      if( [ [ window className ] isEqual : @"NSPanel" ] )
         [ window setFrame : frame display : YES ];
      else
      {	      
         [ ( ( NSControl * ) window ) setFrame : frame ];
         [ [ ( ( NSControl * ) window ) window ] display ];
      } 
   }
   
   hb_retnl( frame.size.width );
}	

HB_FUNC( WNDHEIGHT )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   NSRect frame = [ window frame ];   

   if( [ [ window class ] isSubclassOfClass: [ NSTableView class ] ] )
   {
      window = ( NSWindow * ) [ ( ( NSTableView * ) window ) enclosingScrollView ];
      
      frame = [ window frame ];
   }
   
   if( HB_ISNUM( 2 ) )
   {
      frame.size.height = hb_parnl( 2 );
      if( [ [ window className ] isEqual : @"NSPanel" ] )
         [ window setFrame : frame display : YES ];
      else
      {	      
         [ ( ( NSControl * ) window ) setFrame : frame ];
         [ [ ( ( NSControl * ) window ) window ] display ];
      } 
   }

   hb_retnl( frame.size.height );
}	

HB_FUNC( WNDCENTER )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );

   [ window center ];
}

HB_FUNC( WNDFULLSCREEN )
{
   // Check for Lion, Mountain Lion 
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1070
      NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
      [ window setCollectionBehavior: NSWindowCollectionBehaviorFullScreenPrimary ];
   #endif
}

HB_FUNC( WNDSETSPLASH )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );

   [ window setOpaque : NO ];
   [ window setBackgroundColor : [ NSColor colorWithDeviceWhite : 1.0 alpha : 0.0 ] ];
   [ window setHasShadow : NO ];
   
   // [window setLevel:NSFloatingWindowLevel];
}

HB_FUNC( WNDSETTRANS ) 
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   
   [ window setAlphaValue : hb_parnd( 2 ) ];
   [ window center ]; 
}

HB_FUNC( WNDSETSHADOW )
{
    NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
    window.hasShadow = hb_parl( 2 ) ;
 //  [ window setHasShadow : hb_parl( 2 ) ];
    
}



HB_FUNC( WNDDESTROY )                             
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   
   [ window close ];
}   

HB_FUNC( WNDFADEOUT )
{
    NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
    float alpha = 1.0;
    int x ;
    [window setAlphaValue:alpha];
    [window makeKeyAndOrderFront:window];
    for ( x = 0; x < 10; x++) 
    {
        alpha -= 0.1;
        [window setAlphaValue:alpha];
        [NSThread sleepForTimeInterval:0.020];
    }
}


HB_FUNC( WNDFADEIN )
{
    NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
    float alpha = 0.0;
    int x;
    [window setAlphaValue:alpha];
    [window makeKeyAndOrderFront:window ];
    for (x = 0; x < 10; x++)
    {
        alpha += 0.1;
        [window setAlphaValue:alpha];
        [NSThread sleepForTimeInterval:0.020];
    }
}

HB_FUNC( WNDHIDE )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
    
   [ window orderOut: window ];     
}     

HB_FUNC( WNDSHOW ) // hWnd
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
    
   [ window makeKeyAndOrderFront: window ];
   [ NSApp activateIgnoringOtherApps: YES ];         
} 
    
HB_FUNC( WNDENABLE ) // hWnd [, lOnOff ] --> lOnOff
{
   /*	
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );

   if( ISLOG( 2 ) )
      [ window setEnabled : hb_parl( 2 ) ];
   
   hb_retl( [ window enabled ] );
   */
}   

HB_FUNC( WNDSETMSGBAR )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   
   [ window setAutorecalculatesContentBorderThickness: YES forEdge: NSMinYEdge ];
   [ window setContentBorderThickness : ( hb_parnl( 2 ) / 1.0 ) forEdge: NSMinYEdge ];
}   		

NSView * GetTopView( NSWindow * window )
{
   NSView * view = [ window contentView ];
   
   while( [ window contentView ] != nil )
      view = [ window contentView ];
      
   return view;
}      

NSView * GetView( NSWindow * window )
{
   if( [ [ window className ] isEqual : @"ToolBar" ] )
   { 
      return ( ( View * ) window );
   }

   if( [ [ window className ] isEqual : @"NSBox" ] )
   { 
      return [ window contentView ];
   }
   
   else if( [ [ window className ] isEqual : @"NSView" ] )
   {
      return ( ( NSView * ) window )  ;
   }
   
   else if( [ [ window className ] isEqual : @"View" ] )
   {
      return ( ( View * ) window )  ;
   }
    
   else if( [ [ window className ] isEqual : @"PrnView" ] )
   {	
       return (( PrnView * ) window ) ; 
   }

    
   else if( [ [ window className ] isEqual : @"NSPanel" ] )
   {	
      return [ window contentView ]; 
   }
   
   else
      return [ ( ( NSTabViewItem * ) window ) view ];
}   

HB_FUNC( FLDCREATE ) 
{
   NSTabView * folder = [ [ NSTabView alloc ] 
	           initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );

   [ GetView( window ) addSubview : folder ];
   
   hb_retnl( ( HB_LONG ) folder );
} 

HB_FUNC( FLDADDITEM )
{
   NSTabView * folder = ( NSTabView * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 );
   NSTabViewItem * item = [ [ NSTabViewItem alloc ] initWithIdentifier : string ];
   View * view = [ [ View alloc ] initWithFrame : [ folder contentRect ] ];
   
   [ item setLabel : string ];
   [ folder addTabViewItem : item ];
   [ item setView : view ];
   
   hb_retnl( ( HB_LONG ) item );
}   

HB_FUNC( CTLSETNEXTKEYVIEW ) // hControl1, hControl2
{
   NSControl * control1 = ( NSControl * ) hb_parnl( 1 );	
   NSControl * control2 = ( NSControl * ) hb_parnl( 2 );
   
   [ control1 setNextKeyView : control2 ];
}

HB_FUNC( WINSIZECHANGE )  //HControl ,nHeight,nWidth
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   NSRect frame = [window frame];
    
    CGFloat sizeyChange = hb_parnl( 2 );
	CGFloat sizexChange = hb_parnl( 3 );
    frame.size.height += sizeyChange;
    // Move the origin.
    frame.origin.y -= sizeyChange;
    frame.size.width += sizexChange;  
    
    [window setFrame:frame display:YES animate:YES];    
}

HB_FUNC( WNDSETPOS )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   NSRect frame = [ window frame ];

   if( [ [ window class ] isSubclassOfClass: [ NSTableView class ] ] )
   {
      window = ( NSWindow * ) [ ( ( NSTableView * ) window ) enclosingScrollView ];
      
      frame = [ window frame ];
   }
    
   frame.origin.y = hb_parnl( 2 );
   frame.origin.x = hb_parnl( 3 );

   if( [ [ window class ] isSubclassOfClass: [ NSControl class ] ] ||
   	   [ [ window class ] isSubclassOfClass: [ NSView class ] ] ||
   	   [ [ window class ] isSubclassOfClass: [ NSScrollView class ] ] )
   {
      NSControl * ctrl = ( NSControl * ) window;	
   
      [ ctrl setFrame: frame ];
      [ [ ctrl window ] display ];
   }
   else
      [ window setFrame: frame display: YES animate: NO ];
}	

HB_FUNC( WINSETSIZE )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   NSRect frame = [ window frame ];
   CGFloat nWidth = hb_parnl( 2 );
   CGFloat nHeight = hb_parnl( 3 );
    
   frame.origin.y   -= nHeight - frame.size.height;
   frame.size.height = nHeight;
   frame.size.width  = nWidth;  

   [ window setFrame: frame display: YES animate: YES ];    
}	

HB_FUNC( WINSETSIZECHANGE )  //HControl ,nHeight,nWidth
{
    NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
    NSRect frame = [window frame];
    
    CGFloat sizeyChange = hb_parnl( 2 );
	CGFloat sizexChange = hb_parnl( 3 );
    
    frame.origin.y -=  sizeyChange - frame.size.height;
    
     // Move the origin.
        
    frame.size.height = sizeyChange;
    frame.size.width = sizexChange;  
    
    [window setFrame:frame display:YES animate:YES];    
}

HB_FUNC( WINHEIGHTCHANGE )
{
	 NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
	 NSRect frame = [window frame];
	
   // The extra +14 accounts for the space between the box and its neighboring views
   CGFloat sizeChange = hb_parnl(2) ;
	
    
   // Make the window bigger.
   frame.size.height += sizeChange;
   // Move the origin.
   frame.origin.y -= sizeChange ; 
	
   [ window setFrame:frame display:YES animate:YES];
}

HB_FUNC( WINWIDTHCHANGE )
{
	NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
	NSRect frame = [window frame];
	
    // The extra +14 accounts for the space between the box and its neighboring views
    CGFloat sizeChange = hb_parnl(2) ;
	
	
    // Make the window bigger.
	frame.size.width += sizeChange;
    // Move the origin.
	//frame.origin.x += sizeChange;
	
	
    [window setFrame:frame display:YES animate:YES];
	
}

HB_FUNC( CONTROLSETFOCUS )
{
    NSControl * control = ( NSControl * ) hb_parnl( 1 );
    [ [ control window] makeFirstResponder:control];
}


HB_FUNC( WNDSETRESIZEINDICATOR )
{
    NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
    if( HB_ISLOG( 2 ) )
        [window setShowsResizeIndicator:hb_parl(2)];
    
    hb_retl( [window showsResizeIndicator] ) ;
    
}

HB_FUNC( GOTONEXTCONTROL )
{
    NSControl * control = ( NSControl * ) hb_parnl( 1 );
    
    if( [ [ control window] firstResponder ] == control ) 
    {
       [ [ control window ] selectNextKeyView: control ];
    }
}

HB_FUNC( SETAUTORESIZESSUBVIEWS )
{
   NSView * view = ( NSView * ) hb_parnl( 1 );
    
 [ view setAutoresizesSubviews: hb_parl( 2 ) ];
} 

HB_FUNC( WNDSETSUBVIEW )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
   NSView * view = [ [ NSView alloc ] initWithFrame: NSMakeRect( hb_parnl( 2 ), 
                       hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ] ;	
   
   [ GetView( window ) addSubview : view ];	
      
   hb_retnl( ( HB_LONG ) view );	
}
 
HB_FUNC( WINDOWISFLIPPED )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
    
   hb_retl( [ [ window contentView ] isFlipped ] );        
}

HB_FUNC( WINDOWPRINT )
{
    NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   [ [ window contentView ] print: window ] ;
    
} 
