#import <Cocoa/Cocoa.h>
#define HB_DONT_DEFINE_BOOL
#include <hbapi.h>
#include <hbvm.h>
#include <hbapifs.h>
#include <fmsgs.h>

#define RGB( nRed, nGreen, nBlue ) ( nRed + ( nGreen * 256 ) + ( nBlue * 65536 ) )

NSString * hb_NSSTRING_par( int iParam );

NSAttributedString * hb_NSASTRING_par( int iParam );

#if __MAC_OS_X_VERSION_MAX_ALLOWED < 1050
   #define NSInteger int
   #define NSUInteger int
   #define CGFloat float
#endif

NSString * NumToStr( NSInteger myInt );

NSView * GetView( NSWindow * window );

void ValToChar( PHB_ITEM item );
void ImgResize( NSImage * image , int nWidth, int nHeight  ) ;

NSImage * ImgTemplate( NSString * );

void MsgAlert( NSString *, NSString * messageText );

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
   @interface View : NSView <NSWindowDelegate>
#else
   @interface View : NSView
#endif
{
   @public BOOL bDesign;	
   @public NSWindow * hWnd;
   @public BOOL isFlipped;
}
- ( BOOL ) windowShouldClose: ( NSNotification * ) notification;
- ( void ) windowWillClose: ( NSNotification * ) notification;
- ( BOOL ) acceptsFirstResponder;

- (void) windowDidResignKey:(NSNotification *)notification;
- (void) windowDidBecomeKey:(NSNotification *)notification;

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

#if __MAC_OS_X_VERSION_MAX_ALLOWED < 1060	
   @interface Get : NSTextField
#else
   @interface Get : NSTextField <NSTextFieldDelegate>
#endif
{
   @public NSWindow * hWnd;
}
- ( BOOL ) textShouldEndEditing : ( NSText * ) text;
- ( void ) controlTextDidChange : ( NSNotification * ) aNotification;
- ( void ) controlTextDidEndEditing:(NSNotification *) aNotification;
- ( BOOL ) acceptsFirstResponder;
- ( void ) keyUp : ( NSEvent * ) theEvent;
- (BOOL) performKeyEquivalent: (NSEvent*) theEvent ;
@end
