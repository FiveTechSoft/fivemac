#include <fivemac.h>
#import "Quartz/Quartz.h"

NSAutoreleasePool * pool;

void CocoaInit( void )
{
   static BOOL bInit = FALSE;
   
   if( ! bInit )
   {
      pool = [ [ NSAutoreleasePool alloc ] init ];
      NSApp = [ NSApplication sharedApplication ];
      bInit = TRUE;
      
    }
}   
      
HB_FUNC( COCOAINIT )
{
   CocoaInit();
}   

void CocoaExit( void )
{
   static BOOL bExit = FALSE;
   
   if( ! bExit )
   {		
      [ NSApp release ];
      [ pool release ];
      bExit = TRUE;
   }   	
}	

void MsgAlert( NSString * detailedInformation , NSString * messageText )
{
    NSAlert *alert = [[NSAlert alloc] init];
    
    alert.messageText = messageText ;
    alert.informativeText = detailedInformation ;
    alert.alertStyle = NSAlertStyleWarning ;
    
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}

HB_FUNC( COCOAEXIT )
{
   CocoaExit();
}   	

HB_FUNC( MSGBADGE )
{
   ValToChar( hb_param( 1, HB_IT_ANY ) );

   [ [ NSApp dockTile ] setBadgeLabel: hb_NSSTRING_par( -1 ) ];
}
    
HB_FUNC( MSGINFO )
{
   NSString * msg, * title;
   
   CocoaInit();
   
   ValToChar( hb_param( 1, HB_IT_ANY ) );
   msg = hb_NSSTRING_par( -1 );
   if( [ msg length ] == 0 )
      msg = @" " ;
   
if( hb_pcount() > 1 )
   {	   
      ValToChar( hb_param( 2, HB_IT_ANY ) );
      title = hb_NSSTRING_par( -1 );
      if( [ title length ] == 0 )
         title = @"Attention" ;
   }
   else
      title = @"Attention";
    
    NSAlert * alert = [ [ NSAlert alloc ] init ];
    
    alert.alertStyle = NSAlertStyleInformational ;
    alert.informativeText = msg ;
    alert.messageText = title  ;
    
    [ alert addButtonWithTitle:@"OK"];
    [ alert runModal ];
    [ alert release ];
    
   hb_ret();
}
@interface Alert : NSAlert
{
}
- ( void ) killWindow: ( NSAlert * ) alert;
@end

@implementation Alert

-(void) killWindow: ( NSAlert * ) alert;
{
    [ NSApp abortModal ];
}

@end

HB_FUNC( MSGWAIT )
{
    NSString * msg, * title;
    NSTimer * myTimer;
    
    CocoaInit();
    
    ValToChar( hb_param( 1, HB_IT_ANY ) );
    msg = hb_NSSTRING_par( -1 );
    if( [ msg length ] == 0 )
        msg = @" " ;
    
    if( hb_pcount() > 1 )
    {
        ValToChar( hb_param( 2, HB_IT_ANY ) );
        title = hb_NSSTRING_par( -1 );
        if( [ title length ] == 0 )
            title = @"Attention" ;
    }
    else
        title = @"Attention";
    
    Alert * alert = [ [ Alert alloc ] init ];
    
    alert.alertStyle = NSAlertStyleInformational;
    alert.informativeText = msg;
    alert.messageText = title;
    
    myTimer = [ NSTimer timerWithTimeInterval: hb_parnl( 3 )
                                       target: alert
                                     selector: @selector( killWindow: )
                                     userInfo: nil
                                      repeats: NO ];
    
    [[ NSRunLoop currentRunLoop ] addTimer:myTimer forMode:NSModalPanelRunLoopMode ];
    
    [ alert addButtonWithTitle: @"" ];
    [ alert runModal ];
    [ alert release ];
    
    hb_ret();
}
HB_FUNC( MSGSTOP )
{
    CocoaInit();
    
    NSAlert * dlg = [ [ NSAlert alloc ] init ];
    
    ValToChar( hb_param( 1, HB_IT_ANY ) );
    dlg.informativeText =  hb_NSSTRING_par( -1 ) ;
    dlg.messageText = @"Stop" ;
    dlg.alertStyle = NSAlertStyleWarning ;
    
    [ dlg addButtonWithTitle:@"OK"];
    [ dlg runModal ];
    
     hb_ret();
  }

HB_FUNC( MSGALERT )
{    
   CocoaInit();
    
   NSAlert * dlg = [ [ NSAlert alloc ] init ];
    
   ValToChar( hb_param( 1, HB_IT_ANY ) );
   dlg.informativeText =  hb_NSSTRING_par( -1 ) ;
   dlg.messageText = @"Alert" ;
   dlg.alertStyle = NSAlertStyleWarning ;
    
   [ dlg addButtonWithTitle:@"OK"];
   [ dlg runModal ];
    
   hb_ret();
}

HB_FUNC( MSGALERTSHEET )
{
    
 //  CocoaInit();
    
   ValToChar( hb_param( 1, HB_IT_ANY ) );
   NSAlert * alert = [ [ NSAlert alloc ] init ];
   alert.messageText = @"Alert" ;
   alert.informativeText = hb_NSSTRING_par( -1 ) ;

   [alert addButtonWithTitle : @"OK" ] ;
       
   [alert runModal ] ;
    
   // hb_ret();    
}
 
HB_FUNC( MSGYESNO ) // cMsg --> lYesNo
{
   NSString * text;
   NSAlert * alert = [ [ NSAlert alloc ] init ];
    
   CocoaInit();

   ValToChar( hb_param( 2, HB_IT_ANY ) );
   text = hb_NSSTRING_par( -1 ) ;
   if( [ text isEqualToString : @"" ] )
      text = @"Please select" ;
    
   alert.messageText = text;
   
   ValToChar( hb_param( 1, HB_IT_ANY ) );
   text = hb_NSSTRING_par( -1 ) ;
   if( [ text isEqualToString : @"" ] )
      text = @"make a choice" ;
    
   alert.informativeText = text;

   [alert addButtonWithTitle : @"Yes" ] ;
   [alert addButtonWithTitle : @"No" ] ;
    
   hb_retl( [ alert runModal ] == NSAlertFirstButtonReturn );
        
   [ alert release ];
}

HB_FUNC( MSGNOYES ) // cMsg --> lYesNo
{
   NSString * text;
   NSAlert * alert = [ [ NSAlert alloc ] init ];
    
   CocoaInit();
    
   ValToChar( hb_param( 2, HB_IT_ANY ) );
   text = hb_NSSTRING_par( -1 ) ;
   if( [ text isEqualToString : @"" ] )
      text = @"Please select" ;
    
   alert.messageText = text;
    
   ValToChar( hb_param( 1, HB_IT_ANY ) );
   text = hb_NSSTRING_par( -1 ) ;
   if( [ text isEqualToString : @"" ] )
      text = @"make a choice" ;
    
   alert.informativeText = text;
    
   [ alert addButtonWithTitle : @"No" ] ;
   [ alert addButtonWithTitle : @"Yes" ] ;
    
   hb_retl( [ alert runModal ] != NSAlertFirstButtonReturn );
    
   [ alert release ];    
}

HB_FUNC( MSGBEEP )
{
   NSBeep();
}   

HB_FUNC( CHOOSEFILE )
{
   NSString * types = hb_NSSTRING_par( 2 );     
   NSOpenPanel * op =  [NSOpenPanel openPanel];  //[ [ NSOpenPanel alloc ] init ];

   [ op setPrompt: @"Ok" ];

   if( ! HB_ISCHAR( 1 ) )	
      [ op setTitle: @"Please select a filename" ];
   else
      [ op setTitle: hb_NSSTRING_par( 1 ) ];

   if( ! [ types isEqualToString : @"" ] )
   {
      NSMutableArray * fileTypes;

      if( [ types containsString: @"," ] )
      {
         fileTypes = [ [ NSMutableArray alloc ] init ]; 
         [ fileTypes addObjectsFromArray: [ types componentsSeparatedByString: @"," ] ];
         [ fileTypes addObjectsFromArray: [ [ types uppercaseString ] componentsSeparatedByString: @"," ] ];
      }   
      else
         fileTypes = [ [ NSMutableArray alloc ] initWithObjects: types, [ types uppercaseString ], nil ];

      [ op setAllowedFileTypes: fileTypes ];
   }

    if( [ op runModal ] == NSModalResponseOK  )
    {
       NSString * source = [ [ [ [ op URLs ] objectAtIndex: 0 ] path ] stringByRemovingPercentEncoding ];

       hb_retc( [ source cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
    }  
    else
        hb_retc( "" );	   
} 

HB_FUNC( CHOOSEFOLDER )
{
   NSString * types = hb_NSSTRING_par( 2 );     
   NSOpenPanel * op = [ NSOpenPanel openPanel ];  //[ [ NSOpenPanel alloc ] init ];

   [ op setCanChooseFiles: NO ];
   [ op setCanChooseDirectories: YES ];
   [ op setPrompt: @"Ok" ];

   if( ! HB_ISCHAR( 1 ) )	
      [ op setTitle: @"Please select a folder" ];
   else
      [ op setTitle: hb_NSSTRING_par( 1 ) ];
    
   if( ! [ types isEqualToString : @"" ] )
   {
      NSMutableArray * fileTypes;

      if( [ types containsString: @"," ] )
      {
         fileTypes = [ [ NSMutableArray alloc ] init ]; 
         [ fileTypes addObjectsFromArray: [ types componentsSeparatedByString: @"," ] ];
         [ fileTypes addObjectsFromArray: [ [ types uppercaseString ] componentsSeparatedByString: @"," ] ];
      }   
      else
         fileTypes = [ [ NSMutableArray alloc ] initWithObjects: types, [ types uppercaseString ], nil ];
     
      // [ op setAllowedFileTypes: fileTypes ];
      op.allowedContentTypes = fileTypes;
   }
        
    if( [ op runModal ] == NSModalResponseOK  )
    {
       NSString * source = [ [ [ [ op URLs ] objectAtIndex: 0 ] path ] stringByRemovingPercentEncoding ];
    
       hb_retc( [ source cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
    }  
    else
        hb_retc( "" );	   
} 

HB_FUNC( CHOOSEFILEURL )
{
   NSOpenPanel * op = [ [ NSOpenPanel alloc ] init ];
   NSURL * source ;
    
   [ op setPrompt: @"Ok" ];
   [ op setMessage: @"Please select a file" ];
   
   if( [ op runModal ] == NSModalResponseOK )
   {
      source = [ [ op URLs ] objectAtIndex: 0 ];
      hb_retnl( ( HB_LONG ) source );    
   }
   else
      hb_ret();
} 

HB_FUNC( SAVEFILE )
{
   NSSavePanel * op = [ [ NSSavePanel alloc ] init ];
        
   [ op setPrompt: @"Ok" ];
   
   if( ! HB_ISCHAR( 1 ) )	
      [ op setTitle: @"Please select a filename" ];
   else
      [ op setTitle: hb_NSSTRING_par( 1 ) ];

   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
   if( HB_ISCHAR( 2 ) )	
      [ op setNameFieldStringValue: hb_NSSTRING_par( 2 ) ];
   #endif
        
   if( [ op runModal ] == NSModalResponseOK  )
   {
       
      NSString * source = [ [  [ op URL ]  path ]
                             stringByRemovingPercentEncoding ];
      hb_retc( [ source cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
   }
   else
      hb_retc( "" );     
} 
                 
HB_FUNC( CHOOSEIMAGEFILE )
{
   NSOpenPanel * op = [ [ NSOpenPanel alloc ] init ];
   NSArray * imageTypes = [ NSImage imageTypes ];
        
   [ op setPrompt: @"Ok" ];
   [ op setMessage: @"Please select a file" ];
   // [ op setAllowedFileTypes:imageTypes];
   op.allowedContentTypes = imageTypes;
        
   if( [ op runModal ] == NSModalResponseOK )
   {
      NSString * source = [ [ [ [ op URLs ] objectAtIndex: 0 ] path ]
                                  stringByRemovingPercentEncoding ];
        
      hb_retc( [ source cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
   }
   else
      hb_retc( "" );	   
} 

HB_FUNC( CHOOSESHEETTXTIMG )
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
   NSTextField * texto = ( NSTextField * ) hb_parnl( 1 );    
   NSImageView * vista = ( NSImageView *) hb_parnl( 2 );
   NSOpenPanel* panel = [ NSOpenPanel openPanel ];

   [ panel setDirectoryURL: [NSURL fileURLWithPath: [ texto stringValue ] ] ];
   [ panel setMessage: @"Import the file" ];
    	
   [ panel beginSheetModalForWindow: [ vista window ] 
     completionHandler: ^( NSInteger result ) 
   {
      if( result == NSModalResponseOK )
      {
         [ vista setHidden: NO ];
         [ vista setImage  : [ [ NSImage alloc ] initWithContentsOfURL : [[panel URLs] objectAtIndex:0] ] ];
            
         NSString * source = [ [ [ [ panel URLs ] objectAtIndex: 0 ] path ]
                                 stringByRemovingPercentEncoding ];
            
         [ texto setStringValue: source ];
         [ [ vista image ] setName: source ];
      } 
   } ];
   #endif    
}

//----------------------------------------------------------------------------//

HB_FUNC( CLIPBOARDNEW )
{
   NSPasteboard * pasteBoard = [ NSPasteboard generalPasteboard ];
   hb_retptr( pasteBoard  );
}

HB_FUNC( SETCLIPBOARDDATA )
{
    NSPasteboard * pasteBoard = hb_parptr( 1 );
    int iType = hb_parnl( 2 );
    
    [ pasteBoard clearContents ] ;
    
    switch( iType )
    {
        case 1:
        [pasteBoard declareTypes:[ NSArray arrayWithObject:NSPasteboardTypeString ] owner:nil ];
        break;
        
        case 2:
        [pasteBoard declareTypes:[ NSArray arrayWithObject:NSPasteboardTypePNG ] owner:nil ];
        break;
        
        case 12:
       [pasteBoard declareTypes:[ NSArray arrayWithObject:NSPasteboardTypeSound ] owner:nil ];
        break;
        
        default:
       [pasteBoard declareTypes:[ NSArray arrayWithObject:NSPasteboardTypeString ] owner:nil ];
        break;
    }
    
}


HB_FUNC( CLIPBOARDCOPYPNG )
{
    NSPasteboard * pasteBoard = hb_parptr( 1 );
    NSImage * image =  ( NSImage * ) hb_parnl( 2 );
    CGImageRef CGImage = [image CGImageForProposedRect:nil context:nil hints:nil];
    NSBitmapImageRep *rep = [[[NSBitmapImageRep alloc] initWithCGImage:CGImage] autorelease];
    NSDictionary * dict = [NSDictionary dictionaryWithObject: [NSNumber numberWithFloat:0.5] forKey:NSImageCompressionFactor];
    NSData *data = [rep representationUsingType: NSBitmapImageFileTypePNG properties: dict];
    bool lResult =  [pasteBoard setData:data forType:NSPasteboardTypePNG];
    
      hb_retl( lResult );
}

HB_FUNC( CLIPBOARDCOPYSTRING )
{
    NSPasteboard * pasteBoard = hb_parptr( 1 );
    NSString * string = hb_NSSTRING_par( 2 );
    
    [pasteBoard declareTypes:[ NSArray arrayWithObject:NSPasteboardTypeString ] owner:nil ];
    bool lResult =  [pasteBoard setString:string forType:NSPasteboardTypeString];
    hb_retl( lResult );
}

HB_FUNC( CLIPBOARDPASTESTRING )
{
    NSPasteboard * pasteBoard = hb_parptr( 1 );
    NSString * string;
    
    string = [ pasteBoard stringForType: NSPasteboardTypeString ];
    hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
 }

HB_FUNC( CLIPBOARDCLEAR )
{
     NSPasteboard * pasteBoard = hb_parptr( 1 );
    [ pasteBoard clearContents ] ;
    
}

HB_FUNC( CLIPBOARDGETNAME )
{
    NSPasteboard * pasteBoard = hb_parptr( 1 );
    NSString * string = pasteBoard.name ;
    hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}

//----------------------------------------------------------------------------//

HB_FUNC( COPYPASTEBOARDSTRING )
{
    NSString * string = hb_NSSTRING_par( 1 );
    NSPasteboard * pasteBoard = [ NSPasteboard generalPasteboard ];
    
   [pasteBoard declareTypes:[ NSArray arrayWithObject:NSPasteboardTypeString ] owner:nil ];
   [pasteBoard setString:string forType:NSPasteboardTypeString];
    
  }
 
HB_FUNC( PASTEPASTEBOARDSTRING )
{
   NSPasteboard * pasteBoard = [ NSPasteboard generalPasteboard ];
   NSString * string;

   [ pasteBoard declareTypes: [  NSArray arrayWithObjects:
                                NSPasteboardTypeString, nil ] owner: nil ];
   string = [ pasteBoard stringForType: NSPasteboardTypeString ];
   hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] ); 
}

HB_FUNC( SCREENTOPASTEBOARD )
{
#if __MAC_OS_X_VERSION_MAX_ALLOWED < 150000
   NSPasteboard * pasteBoard = hb_parptr( 1 );
   NSRect screenRect = [[NSScreen mainScreen] frame];
   CGImageRef cgImage = CGWindowListCreateImage(screenRect, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);

   NSBitmapImageRep *rep = [[[NSBitmapImageRep alloc] initWithCGImage: cgImage] autorelease];
   NSDictionary * dict = [NSDictionary dictionaryWithObject: [NSNumber numberWithFloat:0.5] forKey:NSImageCompressionFactor];
   NSData *data = [rep representationUsingType: NSBitmapImageFileTypePNG properties: dict];
   bool lResult =  [pasteBoard setData:data forType:NSPasteboardTypePNG];

   hb_retl( lResult );
#else
   hb_retl( HB_FALSE );
#endif
}
