#include <fivemac.h>

@interface FontPanelController : NSWindowController <NSWindowDelegate>
{
   @public NSFont * font;
   @public NSFont * newFont;
}
-( void ) changeFont: ( id ) sender;
-( void ) windowWillClose: ( id ) sender;
@end

@implementation FontPanelController
-( void ) changeFont: ( id ) sender
{
   newFont = [ sender convertFont: font ];
}

- ( void ) windowWillClose: ( id ) sender
{
   [ NSApp abortModal ];

   hb_retc( [ [ ( newFont ? newFont: font ) displayName ] cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}
@end

HB_FUNC( CHOOSEFONT )
{
   NSFontManager * fontManager = [ NSFontManager sharedFontManager ];
   NSFontPanel * fontPanel = [ fontManager fontPanel:YES ];
   FontPanelController * fontPanelController = [ [ FontPanelController alloc ] init ];

   [ fontPanel setDelegate: fontPanelController ];
   fontPanelController->font = [ NSFont systemFontOfSize : 10 ];
   [ fontPanel makeKeyAndOrderFront: fontPanel ];
   [ NSApp runModalForWindow: fontPanel ];
}

