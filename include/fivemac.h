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

NSImage * ImgTemplate( NSString * );

