#include <fivemac.h>

HB_FUNC( CREATEFONT )
{
   NSString * name = hb_NSSTRING_par( 1 );
   NSFont * font = [ NSFont fontWithName : name size : hb_parnl( 2 ) ];
   
   hb_retnl( ( HB_LONG ) font );
}

HB_FUNC( FONTGETSYSTEM )
{
   NSFont * font = [ NSFont systemFontOfSize: hb_parnl( 1 ) ];

   hb_retnl( ( HB_LONG ) font );
} 

HB_FUNC( FONTGETNAME )
{
   NSFont * font = [ NSFont systemFontOfSize: hb_parnl( 1 ) ];

   hb_retc( [ [font displayName ] cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );   
}

HB_FUNC( FONTISVERTICAL )
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1070	
   NSFont * font = [ NSFont systemFontOfSize: hb_parnl( 1 ) ];

   hb_retl( [ font isVertical ] );   
   #else
   hb_retl( 0 );
   #endif
}

HB_FUNC( FONTSETVERTICAL )
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1070	
   NSFont * font = [ NSFont systemFontOfSize: hb_parnl( 1 ) ];
   NSFont * fontVertical = [ font verticalFont ] ;
   hb_retnl( ( HB_LONG ) fontVertical );
   #endif	
}

HB_FUNC( DRAWTEXT ) // nRow, nCol, cText, hFont
{
   
   NSString * text =   hb_NSSTRING_par( 3 ); 
   NSMutableDictionary * attr = [ NSMutableDictionary dictionaryWithObject : ( NSFont * ) hb_parnl( 4 ) forKey : NSFontAttributeName ];
   
   if( hb_pcount() > 4 )
      [ attr setObject: ( NSColor * ) hb_parnl( 5 ) forKey : NSForegroundColorAttributeName ];
   
   [ text drawAtPoint: NSMakePoint( hb_parnl( 1 ), hb_parnl( 2 ) ) withAttributes: attr ];
}   	
   