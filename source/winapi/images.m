#include <fivemac.h>

static PHB_SYMB symFMH = NULL;

@interface ImageView : NSImageView
{
}
- ( void ) mouseDown : ( NSEvent * ) theEvent;
- ( void ) mouseUp : ( NSEvent * ) theEvent;
@end 

@implementation ImageView

- ( void ) mouseDown : ( NSEvent * ) theEvent
{
   NSPoint point = [ theEvent locationInWindow ]; 

   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_LBUTTONDOWN );
   hb_vmPushLong( ( HB_LONG ) self );
   hb_vmPushLong( point.y );
   hb_vmPushLong( point.x );
   hb_vmDo( 5 );
} 

- ( void ) mouseUp : ( NSEvent * ) theEvent
{
   NSPoint point = [ theEvent locationInWindow ]; 

   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_LBUTTONUP );
   hb_vmPushLong( ( HB_LONG ) self );
   hb_vmPushLong( point.y );
   hb_vmPushLong( point.x );
   hb_vmDo( 5 );
}

@end

HB_FUNC( IMGCREATE ) // hWnd
{
   ImageView * image = [ [ ImageView alloc ] 
                           initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );

   [ GetView( window ) addSubview : image ];
    
   hb_retnl( ( HB_LONG ) image );
}

HB_FUNC( IMGSETFILE )
{
   NSImageView * image = ( NSImageView * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 );
   
   [ image setImage : [ [ NSImage alloc ] initWithContentsOfFile : string ] ];
   [ [ image image ] setName: string ]; 
}   

HB_FUNC( IMGSETNSIMAGE )
{
    NSImageView * image = ( NSImageView * ) hb_parnl( 1 );
    NSImage * hImg =  ( NSImage * ) hb_parnl( 2 );
    
    [ image setImage : hImg ];
 }  

HB_FUNC( NSIMAGEFROMNAME )
{
  NSString * string = hb_NSSTRING_par( 1 );
  NSImage * image ;
    
  NSFileManager * filemgr = [ NSFileManager defaultManager ];
    
  if( [ filemgr fileExistsAtPath: string ] ) 
        image = [ [ NSImage alloc ] initWithContentsOfFile : string ]  ; 
    else
        image = ImgTemplate( string ) ;
        
  hb_retnl( ( HB_LONG ) image );    
} 


HB_FUNC( IMGGETFILE )
{
   NSImageView * image = ( NSImageView * ) hb_parnl( 1 );
   NSString * string = [ [ image image ] name ];
   
   hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( IMGGETWIDTH )
{
   NSImageView * image = ( NSImageView * ) hb_parnl( 1 );
   NSImageRep * rep = [ [ [ image image ] representations ] objectAtIndex:0 ];

   hb_retnl( rep.pixelsWide );
}

HB_FUNC( IMGGETHEIGHT )
{
   NSImageView * image = ( NSImageView * ) hb_parnl( 1 );
   NSImageRep * rep = [ [ [ image image ] representations ] objectAtIndex:0 ];

   hb_retnl( rep.pixelsHigh );
}

HB_FUNC( IMGSETFRAME )
{
   NSImageView * image = ( NSImageView * ) hb_parnl( 1 );
 
   [ [ image animator ] setImageFrameStyle: hb_parni( 2 ) ];
    
   // [ image setImageFrameStyle : NSImageFrameGrayBezel ];
}   

HB_FUNC( IMGSETSCALING )
{
   NSImageView * image = ( NSImageView * ) hb_parnl( 1 );
 
   [  image  setImageScaling: hb_parni( 2 ) ];
} 

HB_FUNC( IMGSETRESFILE ) // Read image from the app resources folder
{
   NSImageView * image = ( NSImageView * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 );
   NSString * myImagePath = [ [ [ NSBundle mainBundle ] resourcePath ] stringByAppendingString: string ];
  
   [ image setImage : [ [ NSImage alloc ] initWithContentsOfFile : myImagePath ] ];
}

HB_FUNC( CHOOSESHEETIMAGE )
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
      NSImageView * vista = ( NSImageView * ) hb_parnl( 1 );
      NSOpenPanel * panel = [ NSOpenPanel openPanel ];
    
      [ panel setMessage: @"Import the file" ];
    	
      [ panel beginSheetModalForWindow: [vista window ] completionHandler:^(NSInteger result)
      {
         if (result == NSFileHandlingPanelOKButton)
         {
            [ vista setHidden: NO ];
            [ vista setImage  : [ [ NSImage alloc ] initWithContentsOfURL : [[panel URLs] objectAtIndex:0] ] ];
            NSString *source =  [[[[panel URLs] objectAtIndex:0]  path]
                                stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [ [ vista image ] setName: source ]  ;
         } 
      } ];
   #endif    
}

/*
HB_FUNC( IMGMASREFLEXSETFILE ) 
{
 NSImageView * imageView = ( NSImageView * ) hb_parnl( 1 );
 NSString * string =  hb_NSSTRING_par( 2 ) ;
 NSImage * image = [ [ NSImage alloc ] initWithContentsOfFile : string ] ;
 
 (CGFloat)percentage = ( hb_parnl( 3 )/100.0 ) ;
 
 CGRect offscreenFrame = CGRectMake(0, 0, image.size.width, image.size.height*(1.0+percentage));
 NSBitmapImageRep * offscreen = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
  		 pixelsWide:offscreenFrame.size.width
  		 pixelsHigh:offscreenFrame.size.height
  		 bitsPerSample:8
  		 samplesPerPixel:4
  		 hasAlpha:YES
  		 isPlanar:NO
  		 colorSpaceName:NSDeviceRGBColorSpace
  		 bitmapFormat:0
  		 bytesPerRow:offscreenFrame.size.width * 4
   		 bitsPerPixel:32];
  
  [NSGraphicsContext saveGraphicsState];
  [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:offscreen]];
  [[NSColor clearColor] set];
  
  NSRectFill(offscreenFrame);
 
  NSGradient * fade = [[NSGradient alloc] initWithStartingColor:
                      [NSColor colorWithCalibratedWhite:1.0 alpha:0.2] endingColor:[NSColor clearColor]];
 
  CGRect fadeFrame = CGRectMake(0, 0, image.size.width, offscreen.size.height - image.size.height);
  [fade drawInRect:fadeFrame angle:270.0]; 
 
  NSAffineTransform* transform = [NSAffineTransform transform];
  [transform translateXBy:0.0 yBy:fadeFrame.size.height];
  [transform scaleXBy:1.0 yBy:-1.0];
  [transform concat];
  
  [self drawAtPoint:NSMakePoint(0, 0) fromRect:CGRectMake(0, 0, self.size.width, self.size.height)
  									 operation:NSCompositeSourceIn fraction:1.0];
  
  [transform invert];
  [transform concat];
  
  [image drawAtPoint:CGPointMake(0, offscreenFrame.size.height - self.size.height)
                fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];

   [NSGraphicsContext restoreGraphicsState];
  
   NSImage * imageWithReflection = [[NSImage alloc] initWithSize:offscreenFrame.size];
   [imageWithReflection addRepresentation:offscreen];
   
  [ imageView setImage : imageWithReflection ];
  
}

HB_FUNC( IMAGESETROTATE ) 
{
NSImageView * imageView = ( NSImageView * ) hb_parnl( 1 );
NSImage * image = [imageView image ] ;

(CGFloat)degrees = ( hb_parnl( 2 )/100.0 ) ;

 NSRect imageBounds = {NSZeroPoint, [image size]};
 NSBezierPath* boundsPath = [NSBezierPath bezierPathWithRect:imageBounds];
 NSAffineTransform* transform = [NSAffineTransform transform];
[transform rotateByDegrees:degrees];
[boundsPath transformUsingAffineTransform:transform];
 
 NSRect rotatedBounds = {NSZeroPoint, [boundsPath bounds].size};

 NSImage* rotatedImage = [[NSImage alloc] initWithSize:rotatedBounds.size];
 imageBounds.origin.x = NSMidX(rotatedBounds) - (NSWidth (imageBounds) / 2);
 imageBounds.origin.y = NSMidY(rotatedBounds) - (NSHeight (imageBounds) / 2);
 
 transform = [NSAffineTransform transform];

 [transform translateXBy:+(NSWidth(rotatedBounds) / 2) yBy:+ (NSHeight(rotatedBounds) / 2)];
 
 [transform rotateByDegrees:degrees];
 [transform translateXBy:-(NSWidth(rotatedBounds) / 2) yBy:- (NSHeight(rotatedBounds) / 2)];
 
 [rotatedImage lockFocus];
 [transform concat];
 
 [image drawInRect:imageBounds fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0] ;
 
 [rotatedImage unlockFocus];
 [ imageView setImage : rotatedImage ];
 
 // [rotatedImage autorelease];

}
*/
 
HB_FUNC( IMAGETODESKTOPWALLPAPER ) 
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060
      NSString * path = hb_NSSTRING_par( 1 );
      NSURL * imageURL = [ [ NSURL alloc ] initFileURLWithPath: path ];
      NSError * error;
      NSDictionary * options = [ NSDictionary dictionaryWithObjectsAndKeys: [ NSNumber numberWithBool:NO], NSWorkspaceDesktopImageAllowClippingKey, [NSNumber numberWithInteger:NSImageScaleProportionallyUpOrDown], NSWorkspaceDesktopImageScalingKey, nil ];
      BOOL result = [ [ NSWorkspace sharedWorkspace ] setDesktopImageURL: imageURL 
      	            forScreen: [ [ NSScreen screens ] lastObject ] options: options 
      	            error: &error ];
    
      if( ! result ) 
      {
         [ NSApp presentError: error ];
      }
   #endif	
}