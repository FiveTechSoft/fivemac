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
    alert.alertStyle = NSWarningAlertStyle ;
    
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

   if( hb_pcount() > 1 )
   {	   
      ValToChar( hb_param( 2, HB_IT_ANY ) );
      title = hb_NSSTRING_par( -1 );
   }
   else
      title = @"Attention";
    
    NSAlert * alert = [ [ NSAlert alloc ] init ];
    
    alert.alertStyle = NSInformationalAlertStyle ;
    alert.informativeText =  msg ;
    alert.messageText = title  ;
    
    [ alert addButtonWithTitle:@"OK"];
    [ alert runModal ];
    [ alert release ];
    
   hb_ret();
}

HB_FUNC( MSGSTOP )
{
    CocoaInit();
    ValToChar( hb_param( 1, HB_IT_ANY ) );
    NSAlert * dlg = [ [ NSAlert alloc ] init ];
    dlg.alertStyle = NSWarningAlertStyle ;
    dlg.informativeText =  hb_NSSTRING_par( -1 ) ;
    dlg.messageText = @"Stop" ;
    [ dlg addButtonWithTitle:@"OK"];
    [ dlg runModal ];
    hb_ret();
  }


HB_FUNC( MSGALERT )
{
    CocoaInit();
    ValToChar( hb_param( 1, HB_IT_ANY ) );
    NSAlert * dlg = [ [ NSAlert alloc ] init ];
    dlg.alertStyle = NSWarningAlertStyle ;
    dlg.informativeText =  hb_NSSTRING_par( -1 ) ;
    dlg.messageText = @"Alert" ;
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
    
   CocoaInit();
   ValToChar( hb_param( 2, HB_IT_ANY ) );
   NSString * texto= hb_NSSTRING_par( -1 ) ;
    
   if( ! [ texto isEqualToString : @"" ] )
         texto = @"Please select" ;
    
   ValToChar( hb_param( 1, HB_IT_ANY ) );
    
    NSAlert * alert = [ [ NSAlert alloc ] init ];
    alert.messageText = texto;
    alert.informativeText = hb_NSSTRING_par( -1 ) ;
    
    [alert addButtonWithTitle : @"YES" ] ;
    [alert addButtonWithTitle : @"NO" ] ;
    
    hb_retl( [alert runModal] == NSAlertFirstButtonReturn  ) ;
        
    [alert release];

}


HB_FUNC( MSGNOYES ) // cMsg --> lYesNo
{
    CocoaInit();
    ValToChar( hb_param( 2, HB_IT_ANY ) );
    NSString * texto= hb_NSSTRING_par( -1 ) ;
    
    if( ! [ texto isEqualToString : @"" ] )
        texto = @"Please select" ;
    
    ValToChar( hb_param( 1, HB_IT_ANY ) );
    
    NSAlert * alert = [ [ NSAlert alloc ] init ];
    
    alert.messageText = texto;
    alert.informativeText = hb_NSSTRING_par( -1 ) ;
    
    [alert addButtonWithTitle : @"NO" ] ;
    [alert addButtonWithTitle : @"YES" ] ;
    
    hb_retl( [alert runModal] != NSAlertFirstButtonReturn  ) ;
    
    [alert release];
    
}

HB_FUNC( MSGBEEP )
{
   NSBeep();
}   

HB_FUNC( CHOOSEFILE )
{
   NSString * type = hb_NSSTRING_par( 2 );     
   NSOpenPanel * op =  [NSOpenPanel openPanel];  //[ [ NSOpenPanel alloc ] init ];
    
   [ op setPrompt: @"Ok" ];

   if( ! HB_ISCHAR( 1 ) )	
      [ op setTitle: @"Please select a filename" ];
   else
      [ op setTitle: hb_NSSTRING_par( 1 ) ];

    
   if( ! [ type isEqualToString : @"" ] )
   {
      NSArray * fileTypes = [ [ NSArray alloc ] initWithObjects: type, [ type uppercaseString ], nil ];
      [ op setAllowedFileTypes:fileTypes ];
   }
        
    if( [ op runModal ] == NSFileHandlingPanelOKButton )
    {
       NSString * source = [ [ [ [ op URLs ] objectAtIndex: 0 ] path ]
                            stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding ];
    
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
   
   if( [ op runModal ] == NSFileHandlingPanelOKButton )
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
        
   if( [ op runModal ] == NSFileHandlingPanelOKButton  )
   {
      NSString * source = [ [  [ op URL ]  path ]
                             stringByReplacingPercentEscapesUsingEncoding:
                             NSUTF8StringEncoding ];
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
   [ op setAllowedFileTypes:imageTypes];
        
   if( [ op runModal ] == NSFileHandlingPanelOKButton )
   {
      NSString * source = [ [ [ [ op URLs ] objectAtIndex: 0 ] path ]
                                  stringByReplacingPercentEscapesUsingEncoding:
                                  NSUTF8StringEncoding ];
        
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
      if( result == NSFileHandlingPanelOKButton )
      {
         [ vista setHidden: NO ];
         [ vista setImage  : [ [ NSImage alloc ] initWithContentsOfURL : [[panel URLs] objectAtIndex:0] ] ];
            
         NSString * source = [ [ [ [ panel URLs ] objectAtIndex: 0 ] path ]
                                 stringByReplacingPercentEscapesUsingEncoding:
                                 NSUTF8StringEncoding];
            
         [ texto setStringValue: source ];
         [ [ vista image ] setName: source ];
      } 
   } ];
   #endif    
}

HB_FUNC( COPYPASTEBOARDSTRING )
{
    NSString * string = hb_NSSTRING_par( 1 );
    NSPasteboard * pasteBoard = [ NSPasteboard generalPasteboard ];
    
   [pasteBoard declareTypes:[ NSArray arrayWithObject:NSStringPboardType ] owner:nil ];
   [pasteBoard setString:string forType:NSStringPboardType];
    
  }
 
HB_FUNC( PASTEPASTEBOARDSTRING )
{
   NSPasteboard * pasteBoard = [ NSPasteboard generalPasteboard ];
   NSString * string;

   [ pasteBoard declareTypes: [  NSArray arrayWithObjects:
                                NSStringPboardType, nil ] owner: nil ];
   string = [ pasteBoard stringForType: NSStringPboardType ];  
   hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] ); 
}