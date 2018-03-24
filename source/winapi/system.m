#include <fivemac.h>
#import <iTunes.h>

HB_FUNC( APPNAME )
{
	NSString * path = [ [ NSBundle mainBundle ] bundlePath ];

	hb_retc( [ path cStringUsingEncoding: NSWindowsCP1252StringEncoding ] );
} 

HB_FUNC( APPPATH )
{
   NSString * path = [ [ NSBundle mainBundle ] bundlePath ];

   hb_retc( [ path cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );  	
}

HB_FUNC( RESPATH )
{
   NSString * bundlePath = [ [ NSBundle mainBundle ] resourcePath ];

   hb_retc( [ bundlePath cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( CURRENTPATH )
{
   NSString * currentpath = [[NSFileManager defaultManager] currentDirectoryPath];
   
   hb_retc( [ currentpath cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( PATH )
{
   NSString * buPath = [ [ NSBundle mainBundle ] bundlePath ];
   NSString * secondParentPath = [ buPath stringByDeletingLastPathComponent ];

   hb_retc( [ secondParentPath cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( PARENTPATH )
{
    NSString * string = [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( 1 ) ? hb_parc( 1 ) : "" encoding : NSWindowsCP1252StringEncoding ] autorelease ];
   NSString * secondParentPath = [ string stringByDeletingLastPathComponent ];
    
   hb_retc( [ secondParentPath cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}


HB_FUNC( FILENOPATH )
{
   NSString * string = [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( 1 ) ? hb_parc( 1 ) : "" encoding : NSWindowsCP1252StringEncoding  ] autorelease ];
   NSString * file   = [string lastPathComponent] ;
   
   hb_retc( [ file cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( LIBRARYPATH )
{
    NSString * Userpath = [ @"~/Library" stringByExpandingTildeInPath ];
    
    hb_retc( [ Userpath cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( USERPATH )
{
   NSString * Userpath = [ @"~" stringByExpandingTildeInPath ];
   
   hb_retc( [ Userpath cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( ISFILE )
{
   NSString * string = [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( 1 ) ? hb_parc( 1 ) : "" encoding : NSWindowsCP1252StringEncoding ] autorelease ];
   NSFileManager * filemgr = [ NSFileManager defaultManager ];
   
   hb_retl( ( [ filemgr fileExistsAtPath: string ] == YES ) ); 
} 


HB_FUNC( COPYFILETO )
{
   NSString * fileini = [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( 1 ) ? hb_parc( 1 ) : "" encoding : NSWindowsCP1252StringEncoding ] autorelease ];
   NSString * filefin = [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( 2 ) ? hb_parc( 2 ) : "" encoding : NSWindowsCP1252StringEncoding ] autorelease ];
   NSFileManager *filemgr = [NSFileManager defaultManager]; 
    
   hb_retl( ([filemgr copyItemAtPath: fileini toPath: filefin error: NULL]  == YES) );
}    

HB_FUNC( DELETEFILE )
{
    bool lresult = false ;
    
    NSString * string = [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( 1 ) ? hb_parc( 1 ) : "" encoding : NSWindowsCP1252StringEncoding ] autorelease ];
    
    NSFileManager * filemgr = NSFileManager.defaultManager ;
    
    if( [ filemgr isDeletableFileAtPath: string ] )
        lresult =  [filemgr removeItemAtPath:string error: nil ] ;
    
    hb_retl( lresult ) ;
    
}

HB_FUNC( DELETEDIR )
{
   NSString * string = [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( 1 ) ? hb_parc( 1 ) : "" encoding : NSWindowsCP1252StringEncoding ] autorelease ];
   NSFileManager *fManager = NSFileManager.defaultManager ;
   BOOL isDir;
   NSString * strfile = [ string stringByAppendingString:  @"/" ];
    
   if( [ fManager fileExistsAtPath: strfile isDirectory: &isDir ] )
   {
      [ fManager removeItemAtPath: strfile error: NULL ];
      //  NSLog(@"removed: %@",strfile);
   }  
}

HB_FUNC( CREATEDIR )
{
   NSString * cDirName = hb_NSSTRING_par( 1 );
   NSFileManager *fileManager= NSFileManager.defaultManager ;
   BOOL isDir;
  
   if( ! [ fileManager fileExistsAtPath: cDirName isDirectory: &isDir ] )
      if( ! [ fileManager createDirectoryAtPath: cDirName withIntermediateDirectories: YES attributes: nil 
     	       error: NULL ] )
      NSLog( @"Error: Create folder failed %@", cDirName );
}

/*
HB_FUNC( MACEXEC )
{
   NSString * appName  = hb_NSSTRING_par( 1 );
   NSString * fileName = hb_NSSTRING_par( 2 );
   NSWorkspace * theProcess;

   if( hb_pcount() > 1 )
      hb_retl( [ [ NSWorkspace sharedWorkspace ] openFile: fileName withApplication: appName ] );
   else   	
   {
      theProcess = [ [ [ NSWorkspace alloc ] init ] autorelease ];
      	 
      hb_retl( [ theProcess launchApplication: appName ] );
   }
}
*/

HB_FUNC( MACEXEC )
{
    NSWorkspace * workspace;
    
    if( hb_pcount() > 1 )
    {
        workspace = [ [ [ NSWorkspace alloc ] init ] autorelease ];
        
        if( hb_pcount() == 1 )
            hb_retl( [ workspace launchApplication: hb_NSSTRING_par( 1 ) ] );
        
        if( hb_pcount() == 2 )
        {
             NSURL * url = [ NSURL fileURLWithPath: [ workspace fullPathForApplication: hb_NSSTRING_par( 1 ) ] ];
            NSArray * arguments = [ NSArray arrayWithObjects: hb_NSSTRING_par( 2 ), nil ];
            NSError * error = nil;
            [ workspace launchApplicationAtURL: url options:NSWorkspaceLaunchDefault
                                                configuration:[NSDictionary dictionaryWithObject:arguments forKey:NSWorkspaceLaunchConfigurationArguments]
                                                    error:&error ] ;
            hb_retl( ( error == nil )  ) ;
            
        }
    }
}

HB_FUNC( SCREENWIDTH )
{
   NSScreen * screen = [ NSScreen mainScreen ];
   NSRect rect = [ screen frame ];

   hb_retnl( rect.size.width );
}

HB_FUNC( SCREENHEIGHT )
{
   NSScreen * screen = [ NSScreen mainScreen ];
   NSRect rect = [ screen frame ];

   hb_retnl( rect.size.height );
}

HB_FUNC( GETCLASSNAME ) // hCtrl
{
   NSObject * control = ( NSObject * ) hb_parnl( 1 );
   
   hb_retc( [ [ control className ] cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( APPTOFROM )
{
[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

HB_FUNC( HIDEAPPS )
{
   NSWorkspace * theProcess = [ [ [ NSWorkspace alloc ] init ] autorelease ]; 
   
   [ theProcess hideOtherApplications ];   
} 

HB_FUNC( MSGABOUT )
{
   NSString * cVersion    = hb_NSSTRING_par( 1 );
   NSString * cAppName    = hb_NSSTRING_par( 2 );
   NSString * cCopyright  = hb_NSSTRING_par( 3 );
   NSDictionary * options = [ NSDictionary dictionaryWithObjectsAndKeys: 
                                cVersion, @"Version",
	 	                      cAppName, @"ApplicationName",
			                 cCopyright, @"Copyright",
                                nil ];
   [ [ NSApplication sharedApplication ] orderFrontStandardAboutPanelWithOptions: options ];    
}

HB_FUNC( SPOTLITE )
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
      NSString * string = hb_NSSTRING_par( 1 );    
      NSWorkspace * theProcess = [ [ [ NSWorkspace alloc ] init ] autorelease ];
     
      hb_retl( [ theProcess showSearchResultsForQueryString : string ] );
   #endif     
} 

HB_FUNC( SYSTEM )
{
   hb_retnl( system( hb_parc( 1 ) ) );
}   	

HB_FUNC( OPENFILE )
{
   NSString * string = hb_NSSTRING_par( 1 ) ;
   NSWorkspace * theProcess = [ [ [ NSWorkspace alloc ] init ] autorelease ];
     
   hb_retl( [ theProcess openFile : string ] );    
} 


HB_FUNC( MOVETOTRASH2 )
{
   NSFileManager * filemgr = NSFileManager.defaultManager ;
   bool lresult = false ;
    
   NSString * string = hb_NSSTRING_par( 1 ) ;
    
   if( [ filemgr isDeletableFileAtPath: string ] )
    {
       NSURL * originalURL = [ [ NSURL alloc ] initFileURLWithPath: string ];
       
       lresult =  [filemgr trashItemAtURL:originalURL resultingItemURL: nil error: nil ] ;
        
    }
  
   hb_retl( lresult) ;
 
}


HB_FUNC( MOVETOTRASH )
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
   NSString * path = [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( 1 ) ? hb_parc( 1 ) : "" encoding : NSWindowsCP1252StringEncoding ] autorelease ];  
   NSURL * originalURL = [ [ NSURL alloc ] initFileURLWithPath: path ]; 
   NSArray * urls = [NSArray arrayWithObject:originalURL];

   [ [ NSWorkspace sharedWorkspace ] recycleURLs: urls
   completionHandler:^(NSDictionary * newURLs, NSError * error ) 
   {
      if( error != nil ) 
      {
         [ NSApp presentError: error ];
         // NSLog( @"error: %@", error );
      } 
      // else 
      // {
      // NSLog(@"newURLs: %@", newURLs);
      // }
   } ];
   #endif	
} 

HB_FUNC( TASKEXEC )
{
	NSString * comando = hb_NSSTRING_par( 1 );
	NSString * arg1 = hb_NSSTRING_par( 2 );
	NSString * arg2 = hb_NSSTRING_par( 3 );
	NSString * arg3 = hb_NSSTRING_par( 4 );
    NSString * arg4 = hb_NSSTRING_par( 5 );
	NSTask * task = [ [ NSTask alloc ] init ];
	
  [ task setLaunchPath: comando ];
	
  NSArray *arguments = [ NSArray arrayWithObjects: arg1, arg2, arg3,arg4, nil ];
  [ task setArguments: arguments ];
	
  NSPipe * pipe = [ NSPipe pipe ];
  [ task setStandardOutput: pipe ];
  [ task setStandardError: pipe ];	
	
  NSFileHandle * file = [ pipe fileHandleForReading ];
  [ task launch ];
	
  NSData * data = [ file readDataToEndOfFile ];
	NSString * string = [ [ NSString alloc ] initWithData: data encoding: NSUTF8StringEncoding ];
 // NSLog( @"woop! got\n%@", string );
   hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );  
}


HB_FUNC( TASKEXECARRAY )
{
	NSString * comando = hb_NSSTRING_par( 1 );
    
	NSTask * task = [ [ NSTask alloc ] init ];
	
    [ task setLaunchPath: comando ];
	
    NSArray *arguments = ( NSArray * ) hb_parnl(2) ;
    [ task setArguments: arguments ];
	
    NSPipe * pipe = [ NSPipe pipe ];
    [ task setStandardOutput: pipe ];
    [ task setStandardError: pipe ];	
	
    NSFileHandle * file = [ pipe fileHandleForReading ];
    [ task launch ];
	
    NSData * data = [ file readDataToEndOfFile ];
	NSString * string = [ [ NSString alloc ] initWithData: data encoding: NSUTF8StringEncoding ];
    // NSLog( @"woop! got\n%@", string );
    hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );  
}


HB_FUNC( BUILD )
{
   NSString * cFileName = hb_NSSTRING_par( 1 );
   NSTask * build = [ [ NSTask alloc ] init ];
	 
	 NSString * buPath = [ [ NSBundle mainBundle ] bundlePath ]; 
   NSString * secondParentPath = [ buPath stringByDeletingLastPathComponent ]; 
 
   secondParentPath  = [secondParentPath  stringByAppendingString: @"/build.sh"] ;
	 
	[ build setLaunchPath: @"/bin/sh" ];
	[ build setArguments: [ NSArray arrayWithObjects: secondParentPath , cFileName, nil ] ];	
	 
	NSPipe *pipe = [ NSPipe pipe ];
  [ build setStandardOutput: pipe ];
	
  NSFileHandle * file = [ pipe fileHandleForReading ];
	 
	[ build launch ];
	
	NSData * data = [ file readDataToEndOfFile ];
	NSString * string = [ [ NSString alloc ] initWithData: data encoding: NSUTF8StringEncoding ];
      
  hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );  
		
}


HB_FUNC( MAKEEXEC )
{  
   NSString * cShFile = hb_NSSTRING_par( 1 ); 
   NSString * cFileName = hb_NSSTRING_par( 2 );
   NSString * SdkPath = hb_NSSTRING_par( 3 ); 
   NSString * Frameworks = hb_NSSTRING_par( 4 );
   NSString * HarbLibs = hb_NSSTRING_par( 5 ); 
   NSString * HarbPath = hb_NSSTRING_par( 6 );  
   NSString * FivePath = hb_NSSTRING_par( 7 ); 
   NSString * ExtraFrameworks = hb_NSSTRING_par( 8 );
    
   
   NSTask * build = [ [ NSTask alloc ] init ];
   
     
   //------------- ajuste de enviroment ------------------
   
   // NSDictionary *environmentDict = [[NSProcessInfo processInfo] environment];
   
    
   NSMutableDictionary *env = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                         @"dumb", @"TERM",      
						 SdkPath, @"SDKPATH",
						 Frameworks,@"FRAMEWORKS",
						 HarbLibs,@"HRBLIBS",
                         HarbPath,@"HARBPATH",
                         FivePath,@"FIVEPATH",
                         ExtraFrameworks,@"EXTRAFRAMEWORKS",
						 nil];
						 
    [build setEnvironment:env] ;
  
  //------------------------------------------------------
     
	NSString * buPath = [ [ NSBundle mainBundle ] bundlePath ]; 
  NSString * secondParentPath = [ buPath stringByDeletingLastPathComponent ]; 
  secondParentPath  = [secondParentPath  stringByAppendingString: cShFile  ] ;
	[ build setLaunchPath: @"/bin/sh" ];
	
	[ build setArguments: [ NSArray arrayWithObjects: secondParentPath , cFileName, nil ] ];	
	 
	NSPipe *pipe = [ NSPipe pipe ];
   [ build setStandardOutput: pipe ];
   [ build setStandardError: pipe ];	
 
   NSFileHandle * file = [ pipe fileHandleForReading ];
   [ build launch ];
	
   NSData * data = [ file readDataToEndOfFile ];
   NSString * string = [ [ NSString alloc ] initWithData: data encoding: NSUTF8StringEncoding ];

   hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );  
}

HB_FUNC( USERNAME )
{
   NSString * userName = NSUserName();
   
   hb_retc( [ userName cStringUsingEncoding : NSWindowsCP1252StringEncoding ] ); 
}

HB_FUNC( WINEXEC )
{
   HB_FUN_MACEXEC();
}   	

HB_FUNC( WAITRUN )
{
   HB_FUN_SYSTEM();
}   	

HB_FUNC( SETEXECUTABLE )
{
  NSString * script = hb_NSSTRING_par( 1 );

  NSFileManager * fileManager = [ NSFileManager defaultManager ];
    
   if( ! [ fileManager isExecutableFileAtPath: script ] ) 
   {
      NSArray * chmodArguments = [ NSArray arrayWithObjects: @"+x", script, nil ];
      NSTask * chmod = [ NSTask launchedTaskWithLaunchPath: @"/bin/chmod" arguments: chmodArguments ];
      [ chmod waitUntilExit ];
   }
}    

HB_FUNC( SHFILEFROMSTRING )
{
   NSString * script = hb_NSSTRING_par( 1 );
   NSString * FileName = hb_NSSTRING_par( 2 ); 
   NSString * attachmentsString = @"#!/bin/sh\n";
   
   attachmentsString = [ attachmentsString stringByAppendingString: script ];
   attachmentsString = [ attachmentsString stringByAppendingString: @"\n" ];
   attachmentsString = [ attachmentsString stringByAppendingString: @"\n" ];
   attachmentsString = [ attachmentsString stringByAppendingString: @"echo done!\n" ];
    
    [ attachmentsString writeToFile: FileName atomically: YES encoding: NSASCIIStringEncoding error: nil ] ;
}    

HB_FUNC( RUNSCRIPTSFROMFILE )
{
NSString * script = hb_NSSTRING_par( 1 );
NSAppleScript * theScript = [[NSAppleScript alloc] initWithContentsOfURL: [NSURL fileURLWithPath: script ] error: nil];
 [theScript executeAndReturnError:nil];
}

HB_FUNC( GETCURRENTLANGUAGE )
{ 
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
NSString *currentLanguage = [languages objectAtIndex:0];
 hb_retc( [currentLanguage cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( GETAPPICON )
{   
  NSImage *image =  [ NSApp applicationIconImage ];
  hb_retnl( ( HB_LONG ) image );
}

 HB_FUNC( SETAPPICON )
{   
  NSImage * image = ( NSImage * ) hb_parnl( 1 );
    [ NSApp setApplicationIconImage: image ] ;
} 

HB_FUNC( DOCKGET )
{ 
  NSDockTile * docTile = [ NSApp dockTile];
  hb_retnl( ( HB_LONG ) docTile );
}

HB_FUNC(APPISACTIVE )
{
  hb_retl( [ NSApp isActive ]  );
}

HB_FUNC(APPISHIDE )
{
    hb_retl( [ NSApp isHidden ]  );
}

HB_FUNC(SYSREFRESH )
{
   [ NSApp setWindowsNeedUpdate: YES ] ;
}

HB_FUNC( DOCKDISPLAY )
{ 
  [[ NSApp dockTile ] display ]; 
}

HB_FUNC( DOCKSETIMAGE )
{ 
  NSDockTile * docTile = [ NSApp dockTile ] ;
  NSImage * image = ( NSImage * ) hb_parnl( 1 );
  NSImageView *iv = [[NSImageView alloc] init];
  [iv setImage:image ];
  [docTile setContentView:iv];
}

HB_FUNC( DOCKADDPROGRESS )
{ 
  NSDockTile * docTile =  [ NSApp dockTile ] ;
  NSImageView * iv = ( NSImageView * ) [ docTile contentView ];
  NSProgressIndicator * progressIndicator = [[NSProgressIndicator alloc]
             initWithFrame:NSMakeRect(0.0f, 0.0f , docTile.size.width, 10. ) ];
             
  [progressIndicator setStyle:NSProgressIndicatorBarStyle];
  [progressIndicator setIndeterminate:NO];
  [iv addSubview:progressIndicator];
  [progressIndicator setBezeled:YES];
  [docTile display];
  hb_retnl( ( HB_LONG ) progressIndicator );
}


HB_FUNC( DELIVERNOTIFICATION )
{
  NSString * title = hb_NSSTRING_par( 1 );
  NSString * info = hb_NSSTRING_par( 2 );
  NSUserNotification * notice = [[NSUserNotification alloc] init];
  notice.title = title ;
  notice.informativeText =info  ;
  // notice.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:listObject.internalObjectID, @"internalObjectID", nil];
  
  NSUserNotificationCenter * center = [NSUserNotificationCenter defaultUserNotificationCenter];
    
  [center setDelegate: nil ];
  [center deliverNotification:notice];

}

HB_FUNC( GETMACADDRESS )
{
   NSPipe *outPipe = [NSPipe pipe];
   NSTask* theTask = [[NSTask alloc] init];
   NSString *string;
   NSString *s;
   //Built-in ethernet
   [theTask setStandardOutput:outPipe];
   [theTask setStandardError:outPipe];
   [theTask setLaunchPath:@"/sbin/ifconfig"];
   [theTask setCurrentDirectoryPath:@"~/"];
   [theTask setArguments:[NSArray arrayWithObjects:@"en0", nil]];
   [theTask launch];
   [theTask waitUntilExit];

   string = [[NSString alloc] initWithData:[[outPipe fileHandleForReading] readDataToEndOfFile] encoding:NSUTF8StringEncoding];

   if (![string isEqualToString:@"ifconfig: interface en0 does not exist"]) 
   {
      s = string;
      NSRange f;
      f = [s rangeOfString:@"ether "];
      if( f.location != NSNotFound) 
      {
        s = [s substringFromIndex:f.location + f.length];
        
        string = [s substringWithRange:NSMakeRange(0, 17)];
      }
   }

   hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] ); 
}
