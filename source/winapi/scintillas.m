#include <scintilla.h>
#include <fivemac.h>

enum IBDisplay 
{
  IBShowZoom          = 0x01,
  IBShowCaretPosition = 0x02,
  IBShowStatusText    = 0x04,
  IBShowAll           = 0xFF
};

typedef enum  
{
  IBNZoomChanged,    // The user selected another zoom value.
  IBNCaretChanged,   // The caret in the editor changed.
  IBNStatusChanged,  // The application set a new status message.
} NotificationType;

@interface ScintillaView : NSView
{
}

- ( void ) rightMouseDown : ( NSEvent * ) theEvent;

- (void) setGeneralProperty: (int) property 
	                parameter: (long) parameter 
	                	  value: (long) value;

- (void) setColorProperty: (int) property
                  parameter: (long) parameter
                    value: (NSColor*) value ;

- (void) setLexerProperty: (NSString*) property value: (NSString*) value ;


- (long) getGeneralProperty: (int) property 
	                parameter: (long) parameter 
	                	  extra: (long) extra;

- (long) getGeneralProperty: (int) property 
	                parameter: (long) parameter;

- (long) getGeneralProperty: (int) property ;

- (void) setString: (NSString*) aString;
	
- (void) setFontName: (NSString*) font
                size: (int) size
                bold: (BOOL) bold
              italic: (BOOL) italic;


typedef void ( * SciNotifyFunc ) ( id window, unsigned int iMessage, unsigned long wParam, unsigned long lParam );          	

- (void) registerNotifyCallback: ( id ) window value: ( SciNotifyFunc ) callback;          	
	             	
@end



struct Sci_CharacterRange
{
   long cpMin;
   long cpMax;
};

struct Sci_TextRange
{
   struct Sci_CharacterRange chrg;
   char * lpstrText;
};

typedef struct 
{
   struct Sci_CharacterRange chrg;
   char * lpstrText;
   struct Sci_CharacterRange chrgText;
} TEXTTOFIND;

static PHB_SYMB symFMH = NULL;

void NotifyFunc( id sv, unsigned int iMessage, unsigned long wParam, unsigned long lParam )
{
   // WM_COMMAND: HIWORD (wParam) = notification code, LOWORD (wParam) = 0 (no control ID), lParam = ScintillaCocoa*

   // WM_NOTIFY: wParam = 0 (no control ID), lParam = ptr to SCNotification structure, with hwndFrom set to ScintillaCocoa*

   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FSCI" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ sv window ] );
   hb_vmPushLong( WM_SCINOTIFY );
   hb_vmPushLong( ( HB_LONG ) sv );
   hb_vmPushLong( ( HB_LONG ) wParam );
   hb_vmPushLong( ( HB_LONG ) lParam );
   hb_vmDo( 5 );
}	          	






HB_FUNC( SCICREATE ) 
{
  
    NSRect newFrame = NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) )  ;
    NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
    ScintillaView * sv = [[[ScintillaView alloc] initWithFrame: newFrame] autorelease];
    [ GetView( window ) addSubview : sv  ];
    
    [ sv registerNotifyCallback: ( id ) sv value: NotifyFunc ];
   	
   hb_retnl( ( HB_LONG ) sv );
}     




HB_FUNC( SCIFINDTEXT )
{
    bool lresult ;
    
   ScintillaView * sv = ( ScintillaView * ) hb_parnl( 1 );
   
   [ sv setGeneralProperty: SCI_SEARCHANCHOR parameter: 0 value: 0 ];
    
    long matchStart = [sv getGeneralProperty: SCI_GETSELECTIONSTART parameter: 0];
    long matchEnd   = [sv getGeneralProperty: SCI_GETSELECTIONEND   parameter: 0];
    
    [sv setGeneralProperty: SCI_FINDINDICATORFLASH parameter: matchStart value:matchEnd ];
   // [sv setGeneralProperty: SCI_FINDINDICATORSHOW parameter: matchStart value:matchEnd ];
    
    lresult = ( [ sv getGeneralProperty: SCI_SEARCHNEXT parameter: 0 extra: ( long ) hb_parc( 2 ) ] != -1 );
    
    
    hb_retl( lresult) ;
    
}      	   	

HB_FUNC( SCISETTEXT )
{
   ScintillaView * sv = ( ScintillaView * ) hb_parnl( 1 );
	
   [ sv setString : hb_NSSTRING_par( 2 ) ];
}   	

HB_FUNC( SCISETFONT )
{
   ScintillaView * sv = ( ScintillaView * ) hb_parnl( 1 );

   [ sv setFontName: hb_NSSTRING_par( 2 ) size: hb_parnl( 3 ) bold: hb_parl( 4 ) italic: hb_parl( 5 ) ];
}   	    	

HB_FUNC( SCIGETKEYWORDS )
{
   ScintillaView * sv = ( ScintillaView * ) hb_parnl( 1 );
   const char * keyWords = [ hb_NSSTRING_par( 2 ) UTF8String ];

   hb_retnl( [ sv getGeneralProperty: SCI_SETKEYWORDS parameter: hb_parnl( 3 ) extra: ( long ) keyWords ] );
}    		   	                          

HB_FUNC( SCISEND )
{
   ScintillaView * sv = ( ScintillaView * ) hb_parnl( 1 );
	 
   [ sv setGeneralProperty: hb_parnl( 2 ) parameter: hb_parnl( 3 ) 
   	                 value: HB_ISCHAR( 4 ) ? ( long ) hb_parc( 4 ) : hb_parnl( 4 ) ];
}    	

HB_FUNC( SCISETCOLORPROP )
{
    ScintillaView * sv = ( ScintillaView * ) hb_parnl( 1 );
    int fBlue = hb_parni( 4 );
    int fGreen =  hb_parni(5) ;
    int fRed = hb_parni( 6 );
    float falpha = hb_parni( 7 );
    
    NSColor * color = [ NSColor colorWithDeviceRed : fRed / 255.0
                                             green : fGreen / 255.0
                                              blue : fBlue / 255.0
                                              alpha: falpha/100.0 ];
    
    
    [ sv setColorProperty: hb_parnl( 2 ) parameter: hb_parnl( 3 )
                    value: color ];

}



HB_FUNC( SCISETLEXERPROP )
{
    NSString *cProp = hb_NSSTRING_par( 2 ) ;
    NSString *cValue = hb_NSSTRING_par( 3 ) ;
    
    ScintillaView * sv = ( ScintillaView * ) hb_parnl( 1 );
    [ sv setLexerProperty: cProp value: cValue ];
    
}

HB_FUNC( SCIGETONEPROP )
{
    ScintillaView * sv = ( ScintillaView * ) hb_parnl( 1 );
     hb_retnl( [ sv getGeneralProperty: hb_parnl( 2 )  ] );
}


HB_FUNC( SCIGETPROP )
{
   ScintillaView * sv = ( ScintillaView * ) hb_parnl( 1 );
	 
   hb_retnl( [ sv getGeneralProperty: hb_parnl( 2 ) parameter: hb_parnl( 3 ) 
   	                 extra: HB_ISCHAR( 4 ) ? ( long ) hb_parc( 4 ) : hb_parnl( 4 ) ] );
}    	

HB_FUNC( SCISEARCHBACKWARD ) 
{
   ScintillaView * sv = ( ScintillaView * ) hb_parnl( 1 );
   char * szText = ( char * ) hb_parc( 2 );
    unsigned long dwSearchFlags = hb_parnl( 3 );
   long ulMinSel;
   long lPos;
   TEXTTOFIND tf;
   
   tf.lpstrText = szText;
   ulMinSel = [ sv getGeneralProperty: SCI_GETSELECTIONSTART parameter: 0 ];
   	
   if( ulMinSel >= 0 )	
      tf.chrg.cpMin = ulMinSel - 1;
   else   	
      tf.chrg.cpMin = [ sv getGeneralProperty: SCI_GETCURRENTPOS parameter: 0 ] - 1;

   tf.chrg.cpMax = 0;
   lPos = [ sv getGeneralProperty: SCI_FINDTEXT parameter: dwSearchFlags extra: ( long ) &tf ];
   
   if( lPos >= 0 )
   {
      [ sv setGeneralProperty: SCI_GOTOPOS parameter: lPos value: 0 ];
      [ sv setGeneralProperty: SCI_SETSEL parameter: tf.chrgText.cpMin value: tf.chrgText.cpMax ];
      [ sv getGeneralProperty: SCI_FINDTEXT parameter: dwSearchFlags extra: ( long ) &tf ];
       
       long matchStart = [sv getGeneralProperty: SCI_GETSELECTIONSTART parameter: 0];
       long matchEnd   = [sv getGeneralProperty: SCI_GETSELECTIONEND   parameter: 0];
       
       [sv setGeneralProperty: SCI_FINDINDICATORFLASH parameter: matchStart value:matchEnd ];
 
      hb_retl( TRUE );
      return;
   }

   hb_retl( FALSE );
}	   	  

HB_FUNC( SCISEARCHFORWARD ) 
{
   ScintillaView * sv = ( ScintillaView * ) hb_parnl( 1 );
   char * szText = ( char * ) hb_parc( 2 );
   unsigned long dwSearchFlags = hb_parnl( 3 );
   long lPos;
   TEXTTOFIND tf;
   
   tf.lpstrText  = szText;
   tf.chrg.cpMin = [ sv getGeneralProperty: SCI_GETCURRENTPOS parameter: 0 extra: 0 ] + 1;
   tf.chrg.cpMax = [ sv getGeneralProperty: SCI_GETLENGTH parameter: 0 extra: 0 ];
   lPos = [ sv getGeneralProperty: SCI_FINDTEXT parameter: dwSearchFlags extra: ( long ) &tf ];
   
   if( lPos >= 0 )
   {
      [ sv setGeneralProperty: SCI_GOTOPOS parameter: lPos value: 0 ];
      [ sv setGeneralProperty: SCI_SETSEL parameter: tf.chrgText.cpMin value: tf.chrgText.cpMax ];
       
       long matchStart = [sv getGeneralProperty: SCI_GETSELECTIONSTART parameter: 0];
       long matchEnd   = [sv getGeneralProperty: SCI_GETSELECTIONEND   parameter: 0];
       
       [sv setGeneralProperty: SCI_FINDINDICATORFLASH parameter: matchStart value:matchEnd ];
       
       
      hb_retl( TRUE );
      return;
   }

   hb_retl( FALSE );
}	   	  

HB_FUNC( SCIGETSELTEXT )
{
   ScintillaView * sv = ( ScintillaView * ) hb_parnl( 1 );
   unsigned long dwLen = [ sv getGeneralProperty: SCI_GETSELECTIONEND parameter: 0 extra: 0 ] - 
   	             [ sv getGeneralProperty: SCI_GETSELECTIONSTART parameter: 0 extra: 0 ];
   char * buffer = ( char * ) hb_xgrab( dwLen + 1 );

   [ sv setGeneralProperty: SCI_GETSELTEXT parameter: 0 value: ( long ) buffer ];

   hb_retclen( buffer, dwLen );
   hb_xfree( buffer );
}	         

HB_FUNC( SCIGETTEXT )
{
   ScintillaView * sv = ( ScintillaView * ) hb_parnl( 1 );
   unsigned long dwLen = [ sv getGeneralProperty: SCI_GETLENGTH parameter: 0 extra: 0 ];
   char * buffer = ( char * ) hb_xgrab( dwLen + 1 );

   [ sv setGeneralProperty: SCI_GETTEXT parameter: dwLen + 1 value: ( long ) buffer ];

   hb_retclen( buffer, dwLen );
   hb_xfree( buffer );
}	         

HB_FUNC( SCIGETLINE )
{
   ScintillaView * sv = ( ScintillaView * ) hb_parnl( 1 );
   unsigned long ulLine = hb_parnl( 2 ) - 1;
   unsigned long dwLen = [ sv getGeneralProperty: SCI_LINELENGTH parameter: ulLine extra: 0 ];
   char * buffer = ( char * ) hb_xgrab( dwLen + 1 );

   [ sv setGeneralProperty: SCI_GETLINE parameter: ulLine value: ( long ) buffer ];

   hb_retclen( buffer, dwLen );
   hb_xfree( buffer );
}	         

HB_FUNC( SCICOPY )
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060
      NSPasteboard * pasteboard = [ NSPasteboard generalPasteboard ];
      NSArray * objects = [ [ NSArray alloc ] initWithObjects: hb_NSSTRING_par( 1 ), nil ]; 
  
      [ pasteboard clearContents ];
   
      hb_retl( [ pasteboard writeObjects: objects ] );
   #endif
}  

HB_FUNC( SCIPASTE )
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060
   NSPasteboard * pasteboard = [ NSPasteboard generalPasteboard ];
   NSArray * objects = [ [ NSArray alloc ] initWithObjects: [ NSString class ], nil ]; 
   NSDictionary * options = [ NSDictionary dictionary ];
   NSArray * copiedItems = [ pasteboard readObjectsForClasses: objects options: options ];
   	
   if( copiedItems != nil )
   {
      NSString * string = [ copiedItems objectAtIndex: 0 ]; 
      
      hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] ); 		
   }
   else
      hb_ret();
   #endif
}   	  

struct NotifyHeader      // This matches the Win32 NMHDR structure
{
   void * hwndFrom;      // environment specific window handle/pointer
   unsigned long idFrom; // CtrlID of the window issuing the notification
   unsigned int code;    // The SCN_* notification code
};

typedef struct 
{
   struct NotifyHeader nmhdr;
   int position;
   /* SCN_STYLENEEDED, SCN_DOUBLECLICK, SCN_MODIFIED, SCN_MARGINCLICK, */
   /* SCN_NEEDSHOWN, SCN_DWELLSTART, SCN_DWELLEND, SCN_CALLTIPCLICK, */
   /* SCN_HOTSPOTCLICK, SCN_HOTSPOTDOUBLECLICK, SCN_HOTSPOTRELEASECLICK, */
   /* SCN_INDICATORCLICK, SCN_INDICATORRELEASE, */
   /* SCN_USERLISTSELECTION, SCN_AUTOCSELECTION */

   int ch;		/* SCN_CHARADDED, SCN_KEY */
   int modifiers;
   /* SCN_KEY, SCN_DOUBLECLICK, SCN_HOTSPOTCLICK, SCN_HOTSPOTDOUBLECLICK, */
   /* SCN_HOTSPOTRELEASECLICK, SCN_INDICATORCLICK, SCN_INDICATORRELEASE, */

   int modificationType;	/* SCN_MODIFIED */
   const char *text;
   /* SCN_MODIFIED, SCN_USERLISTSELECTION, SCN_AUTOCSELECTION, SCN_URIDROPPED */

   int length;		/* SCN_MODIFIED */
   int linesAdded;	/* SCN_MODIFIED */
   int message;	/* SCN_MACRORECORD */
   unsigned long wParam;	/* SCN_MACRORECORD */
   unsigned long lParam;	/* SCN_MACRORECORD */
   int line;		/* SCN_MODIFIED */
   int foldLevelNow;	/* SCN_MODIFIED */
   int foldLevelPrev;	/* SCN_MODIFIED */
   int margin;		/* SCN_MARGINCLICK */
   int listType;	/* SCN_USERLISTSELECTION */
   int x;			/* SCN_DWELLSTART, SCN_DWELLEND */
   int y;		/* SCN_DWELLSTART, SCN_DWELLEND */
   int token;		/* SCN_MODIFIED with SC_MOD_CONTAINER */
   int annotationLinesAdded;	/* SCN_MODIFIED with SC_MOD_CHANGEANNOTATION */
   int updated;	/* SCN_UPDATEUI */
} SCNotification;

HB_FUNC( SCNCODE )
{
   SCNotification * notification = ( SCNotification * ) hb_parnl( 1 );

   hb_retnl( notification->nmhdr.code );
}


HB_FUNC( SCNCH )
{
   SCNotification * notification = ( SCNotification * ) hb_parnl( 1 );

   hb_retnl( notification->ch );
}

HB_FUNC( SCNMARGIN )
{
   SCNotification * notification = ( SCNotification * ) hb_parnl( 1 );

   hb_retnl( notification->margin );
}

HB_FUNC( SCNPOS )
{
   SCNotification * notification = ( SCNotification * ) hb_parnl( 1 );

   hb_retnl( notification->position );
}