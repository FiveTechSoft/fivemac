#include <fivemac.h>

static PHB_SYMB symFMH = NULL;

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060
   @interface TextView : NSTextView <NSTextViewDelegate>
#else
   @interface TextView : NSTextView
#endif
{
}
- ( void ) keyDown: ( NSEvent * ) theEvent;
- ( NSView * ) view; // workaround to avoid a "unrecognized selector sent" error
- ( void ) textDidChange: ( NSNotification * ) aNotification;	
@end

@implementation TextView

- ( void ) keyDown : ( NSEvent * ) theEvent
{
   NSString * key = [ theEvent characters ]; 
   int unichar = [ key characterAtIndex : 0 ];
    
   [ super keyDown : theEvent ];
   
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_KEYDOWN );
   hb_vmPushLong( ( HB_LONG ) self );
   hb_vmPushLong( unichar );
   hb_vmDo( 4 );
}	

- ( NSView * ) view
{
   return NULL;
}

- ( void ) textDidChange: ( NSNotification * ) aNotification
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_GETCHANGED );
   hb_vmPushLong( ( HB_LONG ) self );
   hb_vmDo( 3 );
}

@end

HB_FUNC( TXTCREATE ) // hWnd
{
   NSScrollView * sv = [ [ NSScrollView alloc ] 
 		    	          initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   TextView * memo;
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
   
   [ sv setHasVerticalScroller : YES ];
   [ sv setHasHorizontalScroller : YES ];
   [ sv setBorderType : NSBezelBorder ];
   [ sv setAutoresizingMask : NSViewWidthSizable | NSViewHeightSizable ];

   memo = [ [ TextView alloc ] 
 	 initWithFrame : [ [ sv contentView ] frame ] ];
   [ memo setDelegate: memo ];
   	   
   [ sv setDocumentView : memo ];		   
   [ GetView( window ) addSubview : sv ];
   
   hb_retnl( ( HB_LONG ) memo );
}

HB_FUNC( TXTRESCREATE )
{
    NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
    TextView * memo =  (TextView *) [  GetView( window ) viewWithTag: hb_parnl( 2 ) ];
    
  //  memo->hWnd = window;
  // [ memo setDelegate : memo ]; 
        
   hb_retnl( ( HB_LONG ) memo );
}

HB_FUNC( TXTSETTEXT )
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 ) ;
    
   [ memo setString : string ];
}  

HB_FUNC( TXTSETATTRIBUTEDSTRING )
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );
   NSAttributedString * string = hb_NSASTRING_par( 2 ) ;
    
   [ [ memo textStorage ] setAttributedString : string ];
}  

HB_FUNC( TXTGETTEXT )
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );
   
   hb_retc( [ [ memo string ] cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}  

HB_FUNC( TXTADDLINE ) // hWnd, cTxtLine
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 ) ;
   
   [ [ [ memo textStorage ] mutableString ] appendString : string ];   
}

HB_FUNC( TXTINSERTTEXT ) // hWnd, cTxtLine
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 ) ;

   [ memo insertText : string ];   
}

HB_FUNC( TXTSPELLCHECK ) // hWnd, cTxtLine
{
    TextView * memo = ( TextView * ) hb_parnl( 1 );
    [ memo setContinuousSpellCheckingEnabled :  hb_parl( 2 ) ];   
}


HB_FUNC( TXTUSEFINDBAR ) // hWnd, cTxtLine
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );
   [ memo setUsesFindBar :  hb_parl( 2 ) ];   
}

HB_FUNC( TXTSETINCREMENTALSEARCH ) // hWnd, cTxtLine
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );
   [ memo setIncrementalSearchingEnabled :  hb_parl( 2 ) ];   
}

HB_FUNC( TXTGOBOTTOM )
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );
   NSRange range = NSMakeRange( [ [ memo string ] length ], 0 );

   [ memo scrollRangeToVisible : range ];
}    

HB_FUNC( TXTGOTOP )
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );
   NSRange range = NSMakeRange( 0, 0 );

   [ memo scrollRangeToVisible : range ];
}    

HB_FUNC( TXTROW )
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );
   unsigned int uiAt = [ memo selectedRange ].location;
   unsigned int ui, uiRows = 1;
   
   for( ui = 0; ui < uiAt; ui++ )
      if( [ [ memo string ] characterAtIndex : ui ] == 10 ) // CRLF
         uiRows++;	      
  
   hb_retnl( uiRows );
}   

HB_FUNC( TXTCOL )
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );
    unsigned int uiAt = [ memo selectedRange ].location;
    unsigned int uiEnd = [ [ memo string ] lineRangeForRange : [ memo selectedRange ] ].location - 1;
   
    hb_retnl( uiAt - uiEnd );
}

HB_FUNC( TXTSETEDITABLE )
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );

   [ memo setEditable : hb_parl( 2 ) ];
}   

HB_FUNC( TXTSETBKCOLOR )
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );
   float fBlue = hb_parnl( 2 ) / 65536;
   float fGreen = ( hb_parnl( 2 ) - ( ( ( HB_LONG ) fBlue ) * 65536 ) ) / 256;
   float fRed = hb_parnl( 2 ) - ( ( ( HB_LONG ) fBlue ) * 65536 ) - ( ( ( HB_LONG ) fGreen ) * 256 );
   NSColor * color = [ NSColor colorWithDeviceRed : fRed / 255.0 
                       green : fGreen / 255.0
					   blue : fBlue / 255.0
                       alpha: 1.0 ];

   [ memo setBackgroundColor : color ];
}

HB_FUNC( TXTSETFONT )
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );
   NSString * name = hb_NSSTRING_par( 2 ) ;
   
   [ memo setFont : [ [ NSFont fontWithName : name 
                               size : hb_parnl( 3 ) ] autorelease ] ];
}   

HB_FUNC( TXTHIGHLIGHT )
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );

   [ [ memo textStorage ] addAttribute : NSForegroundColorAttributeName value : [ NSColor blueColor ] range : NSMakeRange( 1, 10 ) ];
}

HB_FUNC( TXTADDRULERVERT )
{
    TextView * memo = ( TextView * ) hb_parnl( 1 );

    NSScrollView * sv = [ memo enclosingScrollView ];
    
    [sv setRulersVisible:YES];
   // [sv setBorderType : 2 ] ;
   // NSLog(@"aqui") ;
   // [sv setHasHorizontalRuler:NO];
    
    [sv setHasVerticalRuler:YES ];
    
    NSRulerView *rulerV = [[NSRulerView alloc] initWithScrollView: sv orientation :  NSVerticalRuler ];    
    
    [sv setVerticalRulerView: rulerV ] ;
    
}   


HB_FUNC( TXTADDRULERHORI )
{
    TextView * memo = ( TextView * ) hb_parnl( 1 );
    
    NSScrollView * sv = [ memo enclosingScrollView ];
    
    [sv setRulersVisible:YES];
      
    [sv setHasHorizontalRuler:YES ];
    
    NSRulerView *rulerH = [[NSRulerView alloc] initWithScrollView: sv orientation :  NSHorizontalRuler ];    
    
    [sv setHorizontalRulerView: rulerH ] ;
    
}   

HB_FUNC( TXTSETRICHTEXT )
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );

   [ memo setRichText: hb_parl( 2 ) ];
}      

HB_FUNC( TXTSETIMPORTGRAF )
{
   TextView * memo = ( TextView * ) hb_parnl( 1 );

   [ memo setImportsGraphics: hb_parl( 2 ) ];
}  

HB_FUNC( TXTSElECTDEL )
{
    TextView * memo = ( TextView * ) hb_parnl( 1 );
    [memo delete: nil ] ;
}  

HB_FUNC( TXTMOVETOEND )
{
    TextView * memo = ( TextView * ) hb_parnl( 1 );
    NSRange range = { [[memo string] length], 0 };
    [memo setSelectedRange: range];
}
HB_FUNC( TXTSETUNDO )
{
    TextView * memo = ( TextView * ) hb_parnl( 1 );
    [memo setAllowsUndo: hb_parl(2) ] ;
}    


 

